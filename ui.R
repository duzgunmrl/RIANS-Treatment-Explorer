library(shiny)
library(bslib)
library(plotly)

source("presentation.R")

ui <- page_fluid(
  
  theme = bs_theme(version = 5, bootswatch = "minty", primary = "#6C63FF", bg = "#F5F7FA", fg = "#1E1E1E"),
  
  tags$head(tags$style(HTML("
    .sidebar { background-color: white; padding: 25px; border-radius: 20px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.08); height: 95vh; overflow-y: auto; }
    .card-custom { background-color: white; border-radius: 20px; padding: 20px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-top: 15px; }
    .btn-primary { border-radius: 12px; font-size: 18px; padding: 12px; width: 100%;
      background-color: #6C63FF; border: none; }
    h2 { font-weight: 700; margin-bottom: 20px; }
    .form-label { font-weight: 600; }
  "))),
  
  h2("RIANS SIMULATOR"),
  
  navset_tab(
    
    nav_panel("Présentation", div(class = "card-custom", presentation_page())),
    
    nav_panel(
      "Simulation",
      
      layout_columns(
        col_widths = c(3, 9),
        
        div(
          class = "sidebar",
          
          h4("Stress basal"),
          numericInput("stress_const", "Stress basal", 0.08),
          
          hr(),
          
          h4("Irradiation"),
          numericInput("irr_start", "Moment d'application de l'irradiation", 100),
          numericInput("irr_amp", "Dose irradiation", 1),
          
          hr(),
          
          h4("Traitement"),
          numericInput("Aox_start", "Moment d'application des antioxydants", 90),
          numericInput("Aox_amp", "Dose antioxydants", 0.4),
          numericInput("Sta_start", "Moment d'application des statines", 90),
          numericInput("Sta_amp", "Dose statines", 0.3),
          
          hr(),
          
          h4("Simulation"),
          numericInput("Tmax", "Temps de simulation", 500),
          numericInput("dt", "Pas de temps", 0.1),
          
          actionButton("run", "RUN SIMULATION", class = "btn-primary"),
          br(), br(),
          downloadButton("download_pdf", "Télécharger le rapport PDF", class = "btn-primary")
        ),
        
        div(
          class = "card-custom",
          navset_tab(
            nav_panel("Stress", plotlyOutput("plot_stress", height = "700px")),
            nav_panel("Cytoplasme", plotlyOutput("plot_cyto", height = "700px")),
            nav_panel("Couronne", plotlyOutput("plot_crown", height = "700px")),
            nav_panel("Noyau", plotlyOutput("plot_noyau", height = "700px")),
            nav_panel("ApoE", plotlyOutput("plot_apoe", height = "700px")),
            nav_panel("Résultats", tableOutput("table_params"))
          )
        )
      )
    ),
    
    nav_panel(
      "Aide à la décision",
      div(
        class = "card-custom",
        
        h3("Recherche de stratégies thérapeutiques"),
        
        p("Cette section recherche les couples irradiation / traitement les plus efficaces."),
        
        p(
          "Succès : couronne présente avant irradiation, destruction après irradiation et absence de reformation à long terme."
        ),
        
        hr(),
        
        layout_columns(
          col_widths = c(4, 4, 4),
          
          div(
            h4("Irradiation testée"),
            numericInput("optim_irr_min", "Dose minimale", 0),
            numericInput("optim_irr_max", "Dose maximale", 100),
            numericInput("optim_irr_n", "Nombre de valeurs testées", 30)
          ),
          
          div(
            h4("Traitement testé"),
            numericInput("optim_trait_min", "Dose minimale", 0),
            numericInput("optim_trait_max", "Dose maximale", 1),
            numericInput("optim_trait_n", "Nombre de valeurs testées", 30)
          ),
          
          div(
            h4("Évaluation"),
            numericInput(
              "optim_temps_eval",
              "Temps d'évaluation long terme (h)",
              500
            )
          )
        ),
        
        br(),
        
        actionButton(
          "run_optim",
          "Lancer l'optimisation",
          class = "btn-primary"
        ),
        
        br(), br(),
        
        plotlyOutput("plot_optim", height = "700px")
      )
    )
  )
)