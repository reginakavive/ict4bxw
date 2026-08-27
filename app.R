
# BXW REAL-TIME SURVEILLANCE DASHBOARD 
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
#if(!require(rgdal)) install.packages("rgdal", repos = "http://cran.us.r-project.org")
if(!require(mapview)) install.packages("mapview", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(lubridate)) install.packages("lubridate", repos = "http://cran.us.r-project.org")
if(!require(sp)) install.packages("sp", repos = "http://cran.us.r-project.org")
if(!require(gstat)) install.packages("gstat", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(tidyr)) install.packages("tidyr", repos = "http://cran.us.r-project.org")
if(!require(magrittr)) install.packages("magrittr", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(shinyjs)) install.packages("shinyjs", repos = "http://cran.us.r-project.org")
if(!require(zoo)) install.packages("zoo", repos = "http://cran.us.r-project.org")
#if(!require(rgeos)) install.packages("rgeos", repos = "http://cran.us.r-project.org")
#if(!require(Cairo)) install.packages("Cairo", repos = "http://cran.us.r-project.org")
if(!require(grDevices)) install.packages("grDevices", repos = "http://cran.us.r-project.org")
if(!require(latticeExtra)) install.packages("latticeExtra", repos = "http://cran.us.r-project.org")
#if(!require(maptools)) install.packages("maptools", repos = "http://cran.us.r-project.org")
if(!require(sf)) install.packages("sf", repos = "http://cran.us.r-project.org")
if(!require(png)) install.packages("png", repos = "http://cran.us.r-project.org")
if(!require(naniar)) install.packages("naniar", repos = "http://cran.us.r-project.org")
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(bslib)) install.packages("bslib", repos = "http://cran.us.r-project.org")
if(!require(pagedown)) install.packages("pagedown", repos = "http://cran.us.r-project.org")


# Keep your existing data preparation files unchanged.
source("dataprep.R")
source("part.R")

# ---- Data normalisation + spatial integrity ---------------------------------
# Make the date field predictable once, rather than repeatedly inside outputs.
bxw_data_e$Date.Created <- as.Date(bxw_data_e$Date.Created)
bxw_data_e$Has.BXW <- toupper(trimws(as.character(bxw_data_e$Has.BXW)))

APP_START_DATE <- as.Date("2019-10-01")

# Build one authoritative Rwanda boundary in WGS84 and use it to validate every
# observation before it can reach a KPI, chart, map, or PDF report.
country_boundary_sf <- tryCatch({
  boundary <- sf::st_as_sf(rwa_shp)
  
  if (is.na(sf::st_crs(boundary))) {
    stop("rwa_shp has no CRS; country-bound validation cannot be performed safely.")
  }
  
  boundary <- boundary %>%
    sf::st_make_valid() %>%
    sf::st_transform(4326)
  
  sf::st_sf(geometry = sf::st_union(sf::st_geometry(boundary)))
}, error = function(e) {
  stop(
    paste0(
      "Unable to prepare the Rwanda country boundary. ",
      "The dashboard will not run without spatial validation. Reason: ",
      conditionMessage(e)
    ),
    call. = FALSE
  )
})

# Keep only records with valid lon/lat values first.
coord_ok <- with(
  bxw_data_e,
  !is.na(Longitude) & !is.na(Latitude) &
    is.finite(Longitude) & is.finite(Latitude) &
    Longitude >= -180 & Longitude <= 180 &
    Latitude >= -90 & Latitude <= 90
)

coordinate_invalid_n <- sum(!coord_ok)
valid_coord_data <- bxw_data_e[coord_ok, , drop = FALSE]

# Polygon-level validation (not just a bounding-box test): observations on the
# national boundary are retained; observations outside Rwanda are excluded.
if (nrow(valid_coord_data) > 0) {
  observation_points_sf <- sf::st_as_sf(
    valid_coord_data,
    coords = c("Longitude", "Latitude"),
    crs = 4326,
    remove = FALSE
  )
  
  inside_country <- lengths(
    sf::st_intersects(observation_points_sf, country_boundary_sf)
  ) > 0
  
  outside_country_n <- sum(!inside_country)
  bxw_data_e <- observation_points_sf[inside_country, ] %>%
    sf::st_drop_geometry()
} else {
  outside_country_n <- 0L
  bxw_data_e <- valid_coord_data
}

country_excluded_n <- coordinate_invalid_n + outside_country_n

if (nrow(bxw_data_e) == 0) {
  stop("No valid BXW observations remain inside the Rwanda boundary.", call. = FALSE)
}

# Limit the default UI period to the latest available surveillance record.
latest_data_date <- max(bxw_data_e$Date.Created, na.rm = TRUE)
APP_END_DATE <- min(Sys.Date(), latest_data_date)
if (is.infinite(APP_END_DATE) || is.na(APP_END_DATE)) APP_END_DATE <- Sys.Date()

# Build choices from the spatially validated data only.
district_choices <- c(
  "All Districts",
  sort(unique(na.omit(as.character(bxw_data_e$District))))
)

# ---- Reusable UI helpers ----------------------------------------------------
plant_diagnosis_icon <- function() {
  div(
    class = "plant-diagnosis-icon",
    icon("seedling"),
    span(class = "diagnosis-lens", icon("magnifying-glass"))
  )
}

kpi_box <- function(title, output_id, subtitle, icon_name, bg) {
  showcase_ui <- if (identical(icon_name, "plant-diagnosis")) {
    plant_diagnosis_icon()
  } else {
    icon(icon_name)
  }
  
  value_box(
    title = title,
    value = textOutput(output_id, inline = TRUE),
    p(subtitle, class = "kpi-subtitle"),
    showcase = showcase_ui,
    showcase_layout = "top right",
    theme = value_box_theme(bg = bg, fg = "#ffffff")
  )
}

# ---- Theme ------------------------------------------------------------------
app_theme <- bs_theme(
  version = 5,
  bootswatch = "darkly",
  bg = "#101713",
  fg = "#F5F7F4",
  primary = "#38A84F",
  secondary = "#AAB5AA",
  success = "#38A84F",
  danger = "#D94343",
  warning = "#F5D547"
)

# ---- UI ---------------------------------------------------------------------
ui <- page_sidebar(
  title = div(
    class = "app-title-wrap",
    div(class = "app-eyebrow", ""),
    div(
      class = "app-title-row",
      span(""),
      span(class = "live-pill", span(class = "live-dot"), "LIVE")
    ),
    div(
      class = "app-title-row",
      span("REAL-TIME BXW SURVEILLANCE")
    ),
 
    div(class = "app-subtitle", "Interactive monitoring of Banana Xanthomonas Wilt observations")
  ),
  
  theme = app_theme,
  fillable = FALSE,
  
  sidebar = sidebar(
    width = 320,
    open = "desktop",
    
    div(class = "sidebar-heading", icon("sliders"), " Filters"),
    p("Explore the surveillance data by location and reporting period.", class = "sidebar-copy"),
    
    # div(
    #   class = "quality-badge",
    #   icon("shield-halved"),
    #   span("Country-validated coordinates")
    # ),
    
    selectInput(
      "districtfinder",
      "District",
      choices = district_choices,
      selected = "All Districts"
    ),
    
    uiOutput("sector_ui"),
    
    dateRangeInput(
      "dateRange",
      "Date range",
      start = APP_START_DATE,
      end = APP_END_DATE,
      min = APP_START_DATE,
      max = APP_END_DATE,
      format = "dd M yyyy"
    ),
    
    div(
      class = "filter-actions",
      actionButton(
        "reset_filters",
        "Reset filters",
        icon = icon("rotate-left"),
        class = "btn btn-outline-light w-100"
      )
    ),
    
    hr(),
    
    div(class = "sidebar-heading", icon("circle-info"), " Current view"),
    uiOutput("filter_summary"),
    uiOutput("data_quality_summary"),
    
    div(
      class = "report-button-wrap",
      downloadButton(
        "report",
        "Generate PDF report",
        icon = icon("file-pdf"),
        class = "btn btn-success w-100"
      )
    )
  ),
  
  # Custom visual polish while keeping Bootstrap responsive behaviour.
  tags$style(HTML("\n    :root {\n      --panel: #172019;\n      --panel-2: #121914;\n      --border: rgba(170, 181, 170, 0.18);\n      --muted: #AAB5AA;\n    }\n\n    body {\n      background:\n        radial-gradient(circle at 15% 0%, rgba(56,168,79,0.11), transparent 28rem),\n        radial-gradient(circle at 85% 8%, rgba(245,213,71,0.035), transparent 24rem),\n        #101713;\n    }\n\n    .app-title-wrap {\n      padding: 0.35rem 0;\n    }\n\n    .app-eyebrow {\n      color: #6FCF62;\n      font-size: 0.72rem;\n      font-weight: 800;\n      letter-spacing: 0.14em;\n      margin-bottom: 0.15rem;\n    }\n\n    .app-title-row {\n      display: flex;\n      align-items: center;\n      gap: 0.75rem;\n      font-size: 1.45rem;\n      font-weight: 750;\n    }\n\n    .app-subtitle {\n      color: #AAB5AA;\n      font-size: 0.85rem;\n      font-weight: 400;\n      margin-top: 0.15rem;\n    }\n\n    .live-pill {\n      display: inline-flex;\n      align-items: center;\n      gap: 0.35rem;\n      padding: 0.25rem 0.55rem;\n      border: 1px solid rgba(111, 207, 98, 0.35);\n      border-radius: 999px;\n      color: #8FDF7C;\n      background: rgba(56, 168, 79, 0.10);\n      font-size: 0.68rem;\n      font-weight: 800;\n      letter-spacing: 0.08em;\n    }\n\n    .live-dot {\n      width: 0.45rem;\n      height: 0.45rem;\n      border-radius: 50%;\n      background: #38A84F;\n      box-shadow: 0 0 0 0 rgba(56,168,79,0.65);\n      animation: pulse 1.8s infinite;\n    }\n\n    @keyframes pulse {\n      0% { box-shadow: 0 0 0 0 rgba(56,168,79,0.55); }\n      70% { box-shadow: 0 0 0 8px rgba(56,168,79,0); }\n      100% { box-shadow: 0 0 0 0 rgba(56,168,79,0); }\n    }\n\n    .sidebar-heading {\n      font-size: 0.8rem;\n      font-weight: 800;\n      letter-spacing: 0.05em;\n      text-transform: uppercase;\n      color: #E3EADF;\n      margin-bottom: 0.55rem;\n    }\n\n    .sidebar-copy, .filter-summary {\n      color: var(--muted);\n      font-size: 0.84rem;\n      line-height: 1.45;\n    }\n\n    .filter-actions {\n      margin-top: 0.5rem;\n    }\n\n    .report-button-wrap {\n      margin-top: 1rem;\n    }\n\n    .card {\n      background: linear-gradient(180deg, rgba(23,32,25,0.98), rgba(18,25,20,0.98));\n      border: 1px solid var(--border);\n      border-radius: 16px;\n      box-shadow: 0 12px 32px rgba(0,0,0,0.15);\n      overflow: hidden;\n    }\n\n    .card-header {\n      border-bottom: 1px solid var(--border);\n      background: transparent;\n      font-weight: 700;\n      padding: 0.9rem 1rem;\n    }\n\n    .bslib-value-box {\n      border: 1px solid rgba(170,181,170,0.12);\n      border-radius: 16px;\n      box-shadow: 0 10px 26px rgba(0,0,0,0.15);\n    }\n\n    .bslib-value-box .value-box-value {\n      font-size: 2rem;\n      font-weight: 800;\n      line-height: 1.05;\n    }\n\n    .kpi-subtitle {\n      opacity: 0.78;\n      font-size: 0.78rem;\n      margin-bottom: 0;\n    }\n\n    .map-meta {\n      color: var(--muted);\n      font-size: 0.8rem;\n      font-weight: 400;\n    }\n\n    .leaflet-container {\n      background: #101713 !important;\n    }\n\n    .form-control, .form-select {\n      border-radius: 10px;\n      border-color: rgba(170,181,170,0.28);\n    }\n\n    .btn {\n      border-radius: 10px;\n      font-weight: 650;\n    }\n\n    @media (max-width: 768px) {\n      .app-title-row { font-size: 1.15rem; }\n      .app-subtitle { display: none; }\n    }\n  ")),
  
  # KPI row
  layout_columns(
    col_widths = c(3, 3, 3, 3),
    kpi_box(
      "Total diagnoses", "totalText", "records in the current view",
      "plant-diagnosis", "#2F7D3D"
    ),
    kpi_box(
      "BXW occurrences", "bxwText", "positive diagnoses",
      "triangle-exclamation", "#B93A3A"
    ),
    kpi_box(
      "Users reached", "farmerT", "unique farmers/users",
      "users", "#B96D22"
    ),
    kpi_box(
      "Change in BXW", "change", "vs. previous equal period",
      "arrow-trend-up", "#9A7A18"
    )
  ),
  
  # Map
  card(
    full_screen = TRUE,
    card_header(
      div(
        class = "d-flex flex-wrap justify-content-between align-items-center gap-2",
        span(icon("location-dot"), " BXW occurrence map"),
        uiOutput("map_meta")
      )
    ),
    leafletOutput("map", height = "560px")
  ),
  
  # Primary trends
  layout_columns(
    col_widths = c(7, 5),
    card(
      full_screen = TRUE,
      card_header(icon("chart-line"), " Monthly positive BXW trend"),
      plotlyOutput("graph", height = "330px")
    ),
    card(
      full_screen = TRUE,
      card_header(icon("chart-pie"), " Diagnosis status"),
      plotlyOutput("status_chart", height = "330px")
    )
  ),
  
  # Secondary analytics
  layout_columns(
    col_widths = c(4, 4, 4),
    card(
      full_screen = TRUE,
      card_header(icon("calendar"), " Yearly diagnoses"),
      plotlyOutput("graph2", height = "300px")
    ),
    card(
      full_screen = TRUE,
      card_header(icon("user-group"), " Unique users by year"),
      plotlyOutput("graph3", height = "300px")
    ),
    card(
      full_screen = TRUE,
      card_header(icon("venus-mars"), " Gender distribution"),
      plotlyOutput("pie", height = "300px")
    )
  )
)

# ---- Server -----------------------------------------------------------------
server <- function(input, output, session) {
  options(shiny.usecairo = TRUE)
  
  # Country boundary was validated before the UI was built; use the same
  # authoritative geometry everywhere. Districts are transformed to WGS84 once.
  rwa_sf <- country_boundary_sf
  rwad_sf <- tryCatch({
    x <- sf::st_as_sf(rwad_shp)
    if (is.na(sf::st_crs(x))) stop("District layer has no CRS")
    x %>% sf::st_make_valid() %>% sf::st_transform(4326)
  }, error = function(e) NULL)
  
  is_all_districts <- reactive({
    identical(input$districtfinder, "All Districts")
  })
  
  # Dynamic sector selector: only shown after a district is selected.
  output$sector_ui <- renderUI({
    req(input$districtfinder)
    
    if (is_all_districts()) {
      return(NULL)
    }
    
    sector_choices <- bxw_data_e %>%
      filter(District == input$districtfinder) %>%
      pull(Sector) %>%
      as.character() %>%
      na.omit() %>%
      unique() %>%
      sort()
    
    selectInput(
      "sectorfinder",
      "Sector",
      choices = c("All Sectors", sector_choices),
      selected = "All Sectors"
    )
  })
  
  # Reset all filters in one click.
  observeEvent(input$reset_filters, {
    updateSelectInput(
      session, "districtfinder",
      choices = district_choices,
      selected = "All Districts"
    )
    updateDateRangeInput(
      session, "dateRange",
      start = APP_START_DATE,
      end = APP_END_DATE
    )
  })
  
  # Shared reactive dataset: every KPI, chart, and map uses this same view.
  filtered_data <- reactive({
    req(input$dateRange)
    
    d <- bxw_data_e %>%
      filter(
        Date.Created >= as.Date(input$dateRange[1]),
        Date.Created <= as.Date(input$dateRange[2])
      )
    
    if (!is_all_districts()) {
      d <- d %>% filter(District == input$districtfinder)
      
      if (!is.null(input$sectorfinder) && input$sectorfinder != "All Sectors") {
        d <- d %>% filter(Sector == input$sectorfinder)
      }
    }
    
    d
  })
  
  # Same geographic filter as the selected view, but for any supplied dates.
  geography_filtered_data <- function(start_date, end_date) {
    d <- bxw_data_e %>%
      filter(Date.Created >= start_date, Date.Created <= end_date)
    
    if (!is_all_districts()) {
      d <- d %>% filter(District == input$districtfinder)
      
      if (!is.null(input$sectorfinder) && input$sectorfinder != "All Sectors") {
        d <- d %>% filter(Sector == input$sectorfinder)
      }
    }
    
    d
  }
  
  previous_period_data <- reactive({
    req(input$dateRange)
    
    start_date <- as.Date(input$dateRange[1])
    end_date <- as.Date(input$dateRange[2])
    period_days <- as.integer(end_date - start_date) + 1L
    
    prev_end <- start_date - 1L
    prev_start <- prev_end - (period_days - 1L)
    
    geography_filtered_data(prev_start, prev_end)
  })
  
  # ---- Filter summary -------------------------------------------------------
  output$filter_summary <- renderUI({
    district_label <- if (is.null(input$districtfinder)) "All Districts" else input$districtfinder
    sector_label <- if (
      is_all_districts() || is.null(input$sectorfinder)
    ) "All Sectors" else input$sectorfinder
    
    div(
      class = "filter-summary",
      div(tags$b("District: "), district_label),
      div(tags$b("Sector: "), sector_label),
      div(
        tags$b("Period: "),
        format(as.Date(input$dateRange[1]), "%d %b %Y"),
        " – ",
        format(as.Date(input$dateRange[2]), "%d %b %Y")
      )
    )
  })
  
  output$data_quality_summary <- renderUI({
    div(
      class = "data-quality-note",
      div(tags$strong("Latest observation: "), format(latest_data_date, "%d %b %Y")),
      # div(
      #   tags$strong("Spatial QA: "),
      #   if (country_excluded_n == 0) {
      #     "All coordinate records fall within Rwanda."
      #   } else {
      #     paste0(
      #       format(country_excluded_n, big.mark = ","),
      #       " invalid/out-of-country record",
      #       ifelse(country_excluded_n == 1, " was", "s were"),
      #       " excluded from every dashboard output."
      #     )
      #   }
      # )
    )
  })
  
  output$map_meta <- renderUI({
    d <- filtered_data()
    positives <- sum(d$Has.BXW == "YES", na.rm = TRUE)
    valid_diagnoses <- sum(d$Has.BXW %in% c("YES", "NO"), na.rm = TRUE)
    rate <- if (valid_diagnoses > 0) positives / valid_diagnoses else 0
    
    span(
      class = "map-meta",
      paste0(
        format(nrow(d), big.mark = ","), " observations  •  ",
        scales::percent(rate, accuracy = 0.1), " positive  •  country-validated"
      )
    )
  })
  
  # ---- KPI outputs ----------------------------------------------------------
  output$totalText <- renderText({
    format(nrow(filtered_data()), big.mark = ",")
  })
  
  output$bxwText <- renderText({
    d <- filtered_data()
    format(sum(d$Has.BXW == "YES", na.rm = TRUE), big.mark = ",")
  })
  
  output$farmerT <- renderText({
    d <- filtered_data()
    if ("Farmer" %in% names(d)) {
      format(dplyr::n_distinct(d$Farmer, na.rm = TRUE), big.mark = ",")
    } else {
      "—"
    }
  })
  
  output$change <- renderText({
    current_positive <- sum(filtered_data()$Has.BXW == "YES", na.rm = TRUE)
    previous_positive <- sum(previous_period_data()$Has.BXW == "YES", na.rm = TRUE)
    
    if (previous_positive == 0 && current_positive == 0) {
      return("0.0%")
    }
    
    if (previous_positive == 0 && current_positive > 0) {
      return("New")
    }
    
    pct_change <- ((current_positive - previous_positive) / previous_positive) * 100
    paste0(ifelse(pct_change > 0, "+", ""), format(round(pct_change, 1), nsmall = 1), "%")
  })
  
  # Keep report.Rmd-compatible text outputs available if it uses them.
  output$district <- renderText(input$districtfinder)
  output$sector <- renderText({
    if (is_all_districts() || is.null(input$sectorfinder)) "All" else input$sectorfinder
  })
  output$date1 <- renderText(input$dateRange[1])
  output$date2 <- renderText(input$dateRange[2])
  
  # ---- Map ------------------------------------------------------------------
  output$map <- renderLeaflet({
    d <- filtered_data()
    
    m <- leaflet(options = leafletOptions(preferCanvas = TRUE)) %>%
      addTiles(
        urlTemplate = "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png",
        attribution = paste0(
          "&copy; <a href=\"https://stadiamaps.com/\" target=\"_blank\">Stadia Maps</a>, ",
          "&copy; <a href=\"https://openmaptiles.org/\" target=\"_blank\">OpenMapTiles</a>, ",
          "&copy; <a href=\"https://www.openstreetmap.org/copyright\" target=\"_blank\">OpenStreetMap</a> contributors"
        ),
        options = tileOptions(maxZoom = 20)
      )
    
    if (!is.null(rwa_sf)) {
      m <- m %>% addPolygons(
        data = rwa_sf,
        color = "#68766B",
        weight = 1,
        opacity = 0.8,
        fillOpacity = 0.03
      )
    }
    
    if (!is.null(rwad_sf)) {
      m <- m %>% addPolygons(
        data = rwad_sf,
        color = "#8B988E",
        weight = 0.8,
        opacity = 0.55,
        fillOpacity = 0,
        label = ~NAME_2
      )
    }
    
    # Highlight the selected district.
    if (!is_all_districts() && !is.null(rwad_sf)) {
      selected_boundary <- rwad_sf %>%
        filter(NAME_2 == input$districtfinder)
      
      if (nrow(selected_boundary) > 0) {
        m <- m %>% addPolygons(
          data = selected_boundary,
          color = "#6FCF62",
          weight = 3,
          opacity = 1,
          fillColor = "#38A84F",
          fillOpacity = 0.06
        )
      }
    }
    
    if (nrow(d) > 0) {
      popup_text <- paste0(
        "<div style='min-width:190px;line-height:1.45'>",
        "<div style='font-size:12px;letter-spacing:.06em;text-transform:uppercase;color:#AAB5AA;margin-bottom:4px'>Plant diagnosis</div>",
        "<b>BXW status:</b> ", dplyr::case_when(
          d$Has.BXW == "YES" ~ "Positive",
          d$Has.BXW == "NO" ~ "Negative",
          TRUE ~ "Unknown"
        ),
        "<br><b>Date:</b> ", format(d$Date.Created, "%d %b %Y"),
        if ("District" %in% names(d)) paste0("<br><b>District:</b> ", d$District) else "",
        if ("Sector" %in% names(d)) paste0("<br><b>Sector:</b> ", d$Sector) else "",
        "</div>"
      )
      d$.popup <- popup_text
      
      # Keep all diagnosis observations in one main map layer.
      # Status is still shown by colour, but positive/negative points are not
      # separated into different overlay groups or layer controls.
      d$.status <- dplyr::case_when(
        d$Has.BXW == "YES" ~ "Positive",
        d$Has.BXW == "NO" ~ "Negative",
        TRUE ~ "Unknown"
      )
      
      diagnosis_palette <- leaflet::colorFactor(
        palette = c(
          "Negative" = "#38A84F",
          "Positive" = "#D94343",
          "Unknown"  = "#8B988E"
        ),
        domain = c("Negative", "Positive", "Unknown")
      )
      
      m <- m %>% addCircleMarkers(
        data = d,
        lng = ~Longitude,
        lat = ~Latitude,
        radius = 4.2,
        stroke = TRUE,
        weight = 0.8,
        color = "#F5F7F4",
        opacity = 0.65,
        fillColor = ~diagnosis_palette(.status),
        fillOpacity = 0.88,
        popup = ~.popup,
        group = "Plant diagnoses"
      )
      
      legend_values <- c("Negative", "Positive")
      if (any(d$.status == "Unknown")) {
        legend_values <- c(legend_values, "Unknown")
      }
      
      m <- m %>% addLegend(
        position = "bottomright",
        title = "BXW diagnosis",
        colors = unname(diagnosis_palette(legend_values)),
        labels = legend_values,
        opacity = 1
      )
    }
    
    m <- m %>%
      addScaleBar(position = "bottomleft", options = scaleBarOptions(imperial = FALSE)) %>%
      addEasyButton(
        easyButton(
          icon = "fa-crosshairs",
          title = "Use my location",
          onClick = JS("function(btn, map){ map.locate({setView: true, maxZoom: 12}); }")
        )
      )
    
    # Fit the map to the selected geography.
    target <- NULL
    if (!is_all_districts() && !is.null(rwad_sf)) {
      target <- rwad_sf %>% filter(NAME_2 == input$districtfinder)
    } else if (!is.null(rwa_sf)) {
      target <- rwa_sf
    }
    
    if (!is.null(target) && nrow(target) > 0) {
      bb <- sf::st_bbox(target)
      m <- m %>% fitBounds(bb[["xmin"]], bb[["ymin"]], bb[["xmax"]], bb[["ymax"]])
    }
    
    m
  })
  
  # ---- Chart data -----------------------------------------------------------
  monthly_positive <- reactive({
    d <- filtered_data() %>% filter(Has.BXW == "YES")
    
    start_month <- floor_date(as.Date(input$dateRange[1]), "month")
    end_month <- floor_date(as.Date(input$dateRange[2]), "month")
    months <- seq(start_month, end_month, by = "month")
    
    counts <- d %>%
      mutate(month = floor_date(Date.Created, "month")) %>%
      count(month, name = "count")
    
    tibble(month = months) %>%
      left_join(counts, by = "month") %>%
      mutate(
        count = tidyr::replace_na(count, 0L),
        rolling_3m = zoo::rollmean(count, k = 3, fill = NA, align = "right")
      )
  })
  
  # ---- Monthly positive trend ----------------------------------------------
  output$graph <- renderPlotly({
    d <- monthly_positive()
    
    plot_ly() %>%
      add_trace(
        data = d,
        x = ~month,
        y = ~count,
        type = "scatter",
        mode = "lines+markers",
        name = "Monthly positives",
        line = list(color = "#D94343", width = 2.8),
        marker = list(color = "#FFD0D0", size = 6.5),
        fill = "tozeroy",
        fillcolor = "rgba(217,67,67,0.08)",
        hovertemplate = "%{x|%b %Y}<br><b>%{y}</b> positive diagnoses<extra></extra>"
      ) %>%
      add_trace(
        data = d,
        x = ~month,
        y = ~rolling_3m,
        type = "scatter",
        mode = "lines",
        name = "3-month average",
        line = list(color = "#F5D547", width = 2, dash = "dot"),
        hovertemplate = "%{x|%b %Y}<br><b>%{y:.1f}</b> 3-month average<extra></extra>"
      ) %>%
      layout(
        legend = list(orientation = "h", x = 0, y = 1.12),
        margin = list(l = 55, r = 20, t = 35, b = 55),
        xaxis = list(title = "", gridcolor = "rgba(170,181,170,0.10)"),
        yaxis = list(title = "Positive diagnoses", rangemode = "tozero", gridcolor = "rgba(170,181,170,0.10)"),
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "rgba(0,0,0,0)",
        font = list(color = "#DCE5DC")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ---- Diagnosis status donut ----------------------------------------------
  output$status_chart <- renderPlotly({
    d <- filtered_data() %>%
      mutate(status = case_when(
        Has.BXW == "YES" ~ "Positive",
        Has.BXW == "NO" ~ "Negative",
        TRUE ~ "Unknown"
      )) %>%
      count(status, name = "count")
    
    if (nrow(d) == 0) {
      return(plotly_empty(type = "scatter", mode = "markers") %>%
               layout(annotations = list(list(
                 text = "No diagnoses in this view",
                 x = 0.5, y = 0.5, showarrow = FALSE,
                 font = list(color = "#AAB5AA")
               ))))
    }
    
    d <- d %>%
      mutate(color = case_when(
        status == "Positive" ~ "#D94343",
        status == "Negative" ~ "#38A84F",
        TRUE ~ "#8B988E"
      ))
    
    positive_n <- sum(d$count[d$status == "Positive"], na.rm = TRUE)
    valid_n <- sum(d$count[d$status %in% c("Positive", "Negative")], na.rm = TRUE)
    positive_rate <- if (valid_n > 0) positive_n / valid_n else 0
    
    plot_ly(
      d,
      labels = ~status,
      values = ~count,
      type = "pie",
      hole = 0.70,
      marker = list(colors = d$color),
      textinfo = "label+percent",
      hovertemplate = "%{label}<br><b>%{value}</b> diagnoses<extra></extra>"
    ) %>%
      layout(
        showlegend = FALSE,
        margin = list(l = 20, r = 20, t = 20, b = 20),
        annotations = list(list(
          text = paste0(
            "<b>", scales::percent(positive_rate, accuracy = 0.1), "</b>",
            "<br><span style='font-size:11px;color:#AAB5AA'>positive</span>"
          ),
          x = 0.5, y = 0.5, showarrow = FALSE,
          font = list(size = 18, color = "#F5F7F4")
        )),
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "rgba(0,0,0,0)",
        font = list(color = "#DCE5DC")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ---- Yearly diagnoses -----------------------------------------------------
  output$graph2 <- renderPlotly({
    d <- filtered_data() %>%
      mutate(
        year = year(Date.Created),
        status = case_when(
          Has.BXW == "YES" ~ "Positive",
          Has.BXW == "NO" ~ "Negative",
          TRUE ~ "Unknown"
        )
      ) %>%
      count(year, status, name = "diagnoses")
    
    if (nrow(d) == 0) return(plotly_empty())
    
    
    positive <- d %>% filter(status == "Positive")
    negative <- d %>% filter(status == "Negative")
    unknown <- d %>% filter(status == "Unknown")
    
    p <- plot_ly() %>%
      add_bars(
        data = positive,
        x = ~factor(year), y = ~diagnoses,
        name = "Positive",
        marker = list(color = "#D94343"),
        hovertemplate = "%{x}<br><b>%{y}</b> positive<extra></extra>"
      ) %>%
      add_bars(
        data = negative,
        x = ~factor(year), y = ~diagnoses,
        name = "Negative",
        marker = list(color = "#38A84F"),
        hovertemplate = "%{x}<br><b>%{y}</b> negative<extra></extra>"
      )
      
    
    if (nrow(unknown) > 0) {
      p <- p %>% add_bars(
        data = unknown,
        x = ~factor(year), y = ~diagnoses,
        name = "Unknown",
        marker = list(color = "#8B988E"),
        hovertemplate = "%{x}<br><b>%{y}</b> unknown<extra></extra>"
      )
    }
    
    p %>%
      layout(
        barmode = "stack",
        legend = list(orientation = "h", x = 0, y = 1.12),
        margin = list(l = 50, r = 15, t = 35, b = 50),
        xaxis = list(title = ""),
        yaxis = list(title = "Diagnoses", rangemode = "tozero", gridcolor = "rgba(170,181,170,0.10)"),
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "rgba(0,0,0,0)",
        font = list(color = "#DCE5DC")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ---- Unique users by year -------------------------------------------------
  output$graph3 <- renderPlotly({
    d <- filtered_data()
    
    if (!"Farmer" %in% names(d)) {
      return(plotly_empty(type = "scatter", mode = "markers") %>%
               layout(annotations = list(list(
                 text = "Farmer field not available",
                 x = 0.5, y = 0.5, showarrow = FALSE,
                 font = list(color = "#8B988E")
               ))))
    }
    
    annual_users <- d %>%
      mutate(year = year(Date.Created)) %>%
      group_by(year) %>%
      summarise(users = n_distinct(Farmer, na.rm = TRUE), .groups = "drop")
    
    plot_ly(
      annual_users,
      x = ~factor(year),
      y = ~users,
      type = "bar",
      marker = list(color = "#F2A33A"),
      hovertemplate = "%{x}<br><b>%{y}</b> unique users<extra></extra>"
    ) %>%
      layout(
        margin = list(l = 50, r = 15, t = 20, b = 50),
        xaxis = list(title = ""),
        yaxis = list(title = "Unique users", rangemode = "tozero", gridcolor = "rgba(170,181,170,0.10)"),
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "rgba(0,0,0,0)",
        font = list(color = "#DCE5DC")
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ---- Gender distribution --------------------------------------------------
  output$pie <- renderPlotly({
    d <- filtered_data()
    
    # Recode the Kinyarwanda gender values used in the source data:
    # Gabo = Male; Gore = Female. Values such as "Gistina Gabo" and
    # "Gistina Gore" are handled using case-insensitive text matching.
    if ("Gender" %in% names(d)) {
      gender_data <- d %>%
        filter(!is.na(Gender), trimws(as.character(Gender)) != "") %>%
        mutate(
          Gender_display = case_when(
            grepl("gabo", as.character(Gender), ignore.case = TRUE) ~ "Male",
            grepl("gore", as.character(Gender), ignore.case = TRUE) ~ "Female",
            TRUE ~ "Other / unknown"
          )
        ) %>%
        count(Gender_display, name = "count") %>%
        mutate(
          Gender_display = factor(
            Gender_display,
            levels = c("Male", "Female", "Other / unknown")
          ),
          color = case_when(
            Gender_display == "Male" ~ "#F2A33A",
            Gender_display == "Female" ~ "#F5D547",
            TRUE ~ "#8B988E"
          )
        ) %>%
        arrange(Gender_display)
    } else {
      gender_data <- tibble(
        Gender_display = factor(character(), levels = c("Male", "Female", "Other / unknown")),
        count = integer(),
        color = character()
      )
    }
    
    if (nrow(gender_data) == 0) {
      return(plotly_empty(type = "scatter", mode = "markers") %>%
               layout(annotations = list(list(
                 text = "Gender data not available",
                 x = 0.5, y = 0.5, showarrow = FALSE,
                 font = list(color = "#8B988E")
               ))))
    }
    
    plot_ly(
      gender_data,
      labels = ~Gender_display,
      values = ~count,
      type = "pie",
      hole = 0.58,
      marker = list(colors = gender_data$color),
      textinfo = "label+percent",
      hovertemplate = "%{label}<br><b>%{value}</b> respondents<extra></extra>"
    ) %>%
      layout(
        showlegend = FALSE,
        margin = list(l = 15, r = 15, t = 20, b = 20),
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "rgba(0,0,0,0)",
        font = list(color = "#DCE5DC")
      ) %>%
      config(displayModeBar = FALSE)
  })
  # ---- Report ---------------------------------------------------------------
  
  output$report <- downloadHandler(
    
    filename = function() {
      paste0(
        "BXW_Surveillance_Report_",
        format(Sys.Date(), "%Y%m%d"),
        ".pdf"
      )
    },
    
    content = function(file) {
      
      withProgress(
        message = "Generating BXW surveillance report...",
        value = 0,
        {
          
          # ------------------------------------------------------------
          # 1. Prepare report parameters
          # ------------------------------------------------------------
          incProgress(0.15, detail = "Preparing report parameters")
          
          params <- list(
            c = input$districtfinder,
            
            d = if (
              is.null(input$sectorfinder) ||
              input$districtfinder == "All Districts"
            ) {
              "All Sectors"
            } else {
              input$sectorfinder
            },
            
            e = as.character(input$dateRange[1]),
            f = as.character(input$dateRange[2])
          )
          
          
          # ------------------------------------------------------------
          # 2. Prepare report environment
          # ------------------------------------------------------------
          incProgress(0.25, detail = "Preparing report environment")
          
          report_env <- new.env(parent = environment())
          
          # Objects required by report.Rmd
          report_env$bxw_data_e <- bxw_data_e
          report_env$country_boundary_sf <- country_boundary_sf
          report_env$rwa_shp <- rwa_shp
          report_env$rwad_shp <- rwad_shp
          
          if (exists("country_excluded_n")) {
            report_env$country_excluded_n <- country_excluded_n
          }
          
          
          # ------------------------------------------------------------
          # 3. Find report and project directories
          # ------------------------------------------------------------
          incProgress(0.35, detail = "Preparing HTML report")
          
          report_path <- normalizePath(
            "data/report.Rmd",
            winslash = "/",
            mustWork = TRUE
          )
          
          project_root <- normalizePath(
            ".",
            winslash = "/",
            mustWork = TRUE
          )
          
          
          # ------------------------------------------------------------
          # 4. Create temporary output directory
          # ------------------------------------------------------------
          temp_output_dir <- tempfile("bxw_report_")
          
          dir.create(
            temp_output_dir,
            recursive = TRUE,
            showWarnings = FALSE
          )
          
          
          # ------------------------------------------------------------
          # 5. Render Rmd -> HTML
          # ------------------------------------------------------------
          incProgress(0.50, detail = "Rendering report to HTML")
          
          rendered_html <- rmarkdown::render(
            input = report_path,
            
            output_format = rmarkdown::html_document(
              toc = FALSE,
              self_contained = TRUE
            ),
            
            output_file = "BXW_Surveillance_Report.html",
            
            output_dir = temp_output_dir,
            
            params = params,
            
            envir = report_env,
            
            # Allows relative paths inside report.Rmd
            # to resolve from the Shiny project root.
            knit_root_dir = project_root,
            
            quiet = TRUE,
            clean = TRUE
          )
          
          
          # ------------------------------------------------------------
          # 6. Check HTML was created
          # ------------------------------------------------------------
          if (!file.exists(rendered_html)) {
            stop(
              "The report could not be rendered to HTML.",
              call. = FALSE
            )
          }
          
          
          # ------------------------------------------------------------
          # 7. Convert HTML -> PDF using Chrome/Edge
          #    NO MiKTeX / pdflatex involved
          # ------------------------------------------------------------
          incProgress(0.75, detail = "Converting HTML to PDF")
          
          pagedown::chrome_print(
            input = rendered_html,
            output = file
          )
          
          
          # ------------------------------------------------------------
          # 8. Confirm PDF exists
          # ------------------------------------------------------------
          incProgress(0.95, detail = "Finalising PDF")
          
          if (!file.exists(file)) {
            stop(
              "HTML was created successfully, but conversion to PDF failed.",
              call. = FALSE
            )
          }
          
          
          incProgress(1, detail = "Complete")
        }
      )
    }
  )
  
  
  
  session$allowReconnect(TRUE)
}

shinyApp(ui = ui, server = server)
