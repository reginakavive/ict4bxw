# ===========================================================================
# ADMINISTRATIVE NAME CLEANING
# Paste immediately after: diagnosisdata <- bxw_diagnosis
# Requires objects rwad_shp and rwas_shp already read with sf::st_read().
# Does NOT assert that Cell/Village names are verified by the supplied files.
# ===========================================================================

# 1. Normalize formatting; retain canonical spellings from the shapefiles.
clean_admin_text <- function(x) {
  x <- stringr::str_replace_all(as.character(x), "\u00a0", " ")
  x <- stringr::str_squish(x)
  x[x %in% c("", "-", "NA", "N/A")] <- NA_character_
  x
}
admin_key <- function(x) {
  x <- stringr::str_to_lower(clean_admin_text(x))
  # Ignore apostrophes and other punctuation during matching only.
  # Example: R'ubavu / R’ubavu -> rubavu -> official "Rubavu".
  x <- stringr::str_replace_all(x, "\\p{P}", "")
  x
}

admin_before <- diagnosisdata[, c("id", "District", "Sector", "Cell", "Village")]
diagnosisdata[c("District", "Sector", "Cell", "Village")] <-
  lapply(diagnosisdata[c("District", "Sector", "Cell", "Village")], clean_admin_text)

# 2. Canonical administrative names, based on your actual SHP fields.
district_ref <- unique(clean_admin_text(sf::st_drop_geometry(rwad_shp)$NAME_2))
district_ref <- district_ref[!is.na(district_ref)]
district_dict <- stats::setNames(district_ref, admin_key(district_ref))

sector_ref <- sf::st_drop_geometry(rwas_shp) |>
  dplyr::transmute(
    District_ref = clean_admin_text(District),
    Sector_ref   = clean_admin_text(Name)
  ) |>
  dplyr::distinct() |>
  dplyr::mutate(
    dkey = admin_key(District_ref),
    skey = admin_key(Sector_ref)
  )
valid_pairs <- paste(sector_ref$dkey, sector_ref$skey, sep = "|")

# 3. Fix known, high-frequency district spelling errors.
district_alias <- c(
  "monyi" = "Kamonyi", "gicunbi" = "Gicumbi", "rurindo" = "Rulindo",
  "bgesera" = "Bugesera", "fgisagara" = "Gisagara",
  "giasagara" = "Gisagara", "gisagsara" = "Gisagara",
  "ruvavu" = "Rubavu", "risizi" = "Rusizi",
  "kkayonza" = "Kayonza", "layonza" = "Kayonza",
  # User-confirmed district names (do not rely on fuzzy similarity).
  "tonza" = "Kayonza", "yonza" = "Kayonza",
  "yo" = "Kayonza", "yomza" = "Kayonza","yinza" = "Kayonza","bura" = "Kayonza",
  "buga" = "Huye", "Goho"="Gatsibo",
  # Plain "Rubavu" and punctuation variants (R'ubavu) already match
  # the official SHP name via admin_key(). Includes observed encoding typo.
  "åubavu" = "Rubavu",   # "Å”ubavu" in survey export
  "bueta" = "Burera", "burembo" = "Burera",
  "burerab" = "Burera", "bureral" = "Burera", "rylindo" = "Rulindo"
)

dkey <- admin_key(diagnosisdata$District)
skey <- admin_key(diagnosisdata$Sector)
fixed_district <- dplyr::coalesce(
  unname(district_dict[dkey]),
  unname(district_alias[dkey])
)

# 4. If District and Sector were reversed, swap them ONLY when the
#    reversed pair is explicitly present in the sector shapefile.
swap_rows <- which(
  is.na(fixed_district) & paste(skey, dkey, sep = "|") %in% valid_pairs
)
if (length(swap_rows)) {
  fixed_district[swap_rows] <- unname(district_dict[skey[swap_rows]])
  diagnosisdata$Sector[swap_rows] <- diagnosisdata$District[swap_rows]
}

# 5. If a district is missing/invalid, infer it only when its exact
#    sector name occurs in ONE district in the shapefile.
unique_sector_district <- function(sector_name) {
  hits <- unique(sector_ref$District_ref[
    sector_ref$skey == admin_key(sector_name) & !is.na(sector_ref$skey)
  ])
  if (length(hits) == 1L) hits else NA_character_
}
missing_district <- which(is.na(fixed_district))
if (length(missing_district)) {
  fixed_district[missing_district] <- vapply(
    diagnosisdata$Sector[missing_district], unique_sector_district, character(1)
  )
}
diagnosisdata$District <- dplyr::coalesce(fixed_district, diagnosisdata$District)

# 6. Correct sector spelling ONLY against sectors in that district.
#    Exact matches first; a unique close match otherwise.
match_sector <- function(district, sector) {
  if (is.na(district) || is.na(sector)) return(NA_character_)
  candidates <- sector_ref$Sector_ref[sector_ref$District_ref == district]
  if (!length(candidates)) return(NA_character_)
  candidate_keys <- admin_key(candidates)
  sector_key <- admin_key(sector)

  exact <- match(sector_key, candidate_keys)
  if (!is.na(exact)) return(candidates[exact])

  # Explicit exception: 'Kage' in Gatsibo is not an official sector.
  if (district == "Gatsibo" && sector_key == "kage") return("Kageyo")

  distances <- as.integer(utils::adist(sector_key, candidate_keys))
  best <- which(distances == min(distances))
  # Conservative: one edit for 4-7 chars; two for 8+ chars.
  max_edits <- if (nchar(sector_key) >= 8L) 2L else
    if (nchar(sector_key) >= 4L) 1L else 0L
  if (length(best) == 1L && min(distances) <= max_edits) {
    return(candidates[best])
  }
  NA_character_  # do not guess when no unique, sufficiently close match
}

sector_corrections <- dplyr::distinct(diagnosisdata, District, Sector)
sector_corrections$Sector_corrected <- vapply(
  seq_len(nrow(sector_corrections)),
  function(i) match_sector(sector_corrections$District[i], sector_corrections$Sector[i]),
  character(1)
)
sector_corrections$sector_match_method <- ifelse(
  is.na(sector_corrections$Sector_corrected), "unmatched",
  ifelse(admin_key(sector_corrections$Sector) ==
         admin_key(sector_corrections$Sector_corrected), "exact", "review_correction")
)

diagnosisdata <- dplyr::left_join(
  diagnosisdata, sector_corrections, by = c("District", "Sector")
)
diagnosisdata$Sector <- dplyr::coalesce(
  diagnosisdata$Sector_corrected, diagnosisdata$Sector
)
diagnosisdata$Sector_corrected <- NULL

# 7. Validate the corrected district + sector combination and keep an audit.
diagnosisdata$valid_admin_pair <- paste(
  admin_key(diagnosisdata$District), admin_key(diagnosisdata$Sector), sep = "|"
) %in% valid_pairs

admin_name_audit <- data.frame(
  id = diagnosisdata$id,
  District_before = admin_before$District,
  District_after = diagnosisdata$District,
  Sector_before = admin_before$Sector,
  Sector_after = diagnosisdata$Sector,
  sector_match_method = diagnosisdata$sector_match_method,
  valid_admin_pair = diagnosisdata$valid_admin_pair
)

unmatched_admin_names <- diagnosisdata |>
  dplyr::filter(!valid_admin_pair) |>
  dplyr::count(District, Sector, sort = TRUE)

message("Valid district-sector records: ", sum(diagnosisdata$valid_admin_pair),
        "/", nrow(diagnosisdata))
# Local review only: avoid file writes on Shiny deployment startup.
# write.csv(admin_name_audit, "admin_name_audit.csv", row.names = FALSE)
# write.csv(unmatched_admin_names, "unmatched_admin_names.csv", row.names = FALSE)

diagnosisdata$sector_match_method <- NULL
diagnosisdata$valid_admin_pair <- NULL
# ===========================================================================
