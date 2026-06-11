library(shiny)
library(plotly)
library(htmlwidgets)
library(webshot2)
library(magick)

source("parametres.R")
source("fonctions.R")
source("optimisation.R")

make_plot <- function(df, type, params = NULL) {
  
  if (type == "stress") {
    
    plot_ly(df, x = ~time) %>%
      add_lines(y = ~Irr, name = "Irradiation") %>%
      add_lines(y = ~Aox, name = "Antioxydants") %>%
      add_lines(y = ~Sta, name = "Statines") %>%
      add_lines(y = ~s, name = "Stress total") %>%
      add_lines(
        y = rep(params$stress_const, nrow(df)),
        name = "Stress basal",
        line = list(dash = "dash")
      ) %>%
      layout(
        title = "IRRADIATION, TRAITEMENTS ET STRESS TOTAL",
        xaxis = list(title = "TEMPS (H)"),
        yaxis = list(title = "INTENSITÉ")
      )
    
  } else if (type == "cyto") {
    
    plot_ly(df, x = ~time) %>%
      add_lines(y = ~DC, name = "Dimères cytoplasmiques") %>%
      add_lines(y = ~MC, name = "Monomères cytoplasmiques") %>%
      layout(
        title = "CYTOPLASME",
        xaxis = list(title = "TEMPS (H)"),
        yaxis = list(title = "CONCENTRATION")
      )
    
  } else if (type == "crown") {
    
    plot_ly(df, x = ~time) %>%
      add_lines(y = ~MA, name = "Monomères zone périnucléaire") %>%
      add_lines(y = ~CA, name = "Complexes ApoE-ATM") %>%
      add_lines(y = ~DA, name = "Dimères zone périnucléaire") %>%
      add_lines(y = ~PC, name = "Couronne périnucléaire") %>%
      layout(
        title = "COURONNE PÉRINUCLÉAIRE",
        xaxis = list(title = "TEMPS (H)"),
        yaxis = list(title = "CONCENTRATION")
      )
    
  } else if (type == "noyau") {
    
    plot_ly(df, x = ~time) %>%
      add_lines(y = ~MN, name = "Monomères nucléaires") %>%
      layout(
        title = "NOYAU",
        xaxis = list(title = "TEMPS (H)"),
        yaxis = list(title = "CONCENTRATION")
      )
    
  } else if (type == "apoe") {
    
    plot_ly(df, x = ~time) %>%
      add_lines(y = ~A, name = "ApoE libre") %>%
      add_lines(
        y = rep(params$A_star, nrow(df)),
        name = "A*",
        line = list(dash = "dash")
      ) %>%
      layout(
        title = "APOE LIBRE",
        xaxis = list(title = "TEMPS (H)"),
        yaxis = list(title = "CONCENTRATION")
      )
  }
}

server <- function(input, output, session) {
  
  resultat <- eventReactive(input$run, {
    
    params <- params_default
    
    # Paramètres visibles dans l'interface
    noms <- c(
      "stress_const",
      "irr_start", "irr_amp",
      "Aox_start", "Aox_amp",
      "Sta_start", "Sta_amp"
    )
    
    for (n in noms) {
      if (!is.null(input[[n]])) {
        params[[n]] <- input[[n]]
      }
    }
    
    times_user <- seq(0, input$Tmax, by = input$dt)
    
    # Conditions initiales fixées dans parametres.R
    state0 <- state0_default
    
    out <- simulation_rians(params, state0, times_user)
    
    list(out = out, params = params)
  })
  
  output$plot_stress <- renderPlotly({
    make_plot(resultat()$out, "stress", resultat()$params)
  })
  
  output$plot_cyto <- renderPlotly({
    make_plot(resultat()$out, "cyto")
  })
  
  output$plot_crown <- renderPlotly({
    make_plot(resultat()$out, "crown")
  })
  
  output$plot_noyau <- renderPlotly({
    make_plot(resultat()$out, "noyau")
  })
  
  output$plot_apoe <- renderPlotly({
    make_plot(resultat()$out, "apoe", resultat()$params)
  })
  
  output$table_params <- renderTable({
    
    res <- resultat()
    df <- res$out
    params <- res$params
    
    t_before <- params$irr_start - 1
    t_after  <- params$irr_start + 20
    t_late   <- max(df$time)
    
    PC_before <- df$PC[which.min(abs(df$time - t_before))]
    PC_after  <- df$PC[which.min(abs(df$time - t_after))]
    PC_late   <- df$PC[which.min(abs(df$time - t_late))]
    
    rupture_ratio  <- PC_after / PC_before
    maintien_ratio <- PC_late / PC_before
    
    destruction_pc <- 100 * (1 - rupture_ratio)
    
    if (maintien_ratio <= 1) {
      maintien_txt <- paste0(
        round(100 * (1 - maintien_ratio), 1),
        " % de réduction durable"
      )
    } else {
      maintien_txt <- paste0(
        "+",
        round(100 * (maintien_ratio - 1), 1),
        " % de reformation"
      )
    }
    
    A_min  <- min(df$A, na.rm = TRUE)
    A_late <- df$A[which.min(abs(df$time - t_late))]
    
    MN_max  <- max(df$MN, na.rm = TRUE)
    MN_late <- df$MN[which.min(abs(df$time - t_late))]
    
    success <- (
      PC_before > 150 &&
        rupture_ratio < 0.25 &&
        maintien_ratio < 0.40
    )
    
    data.frame(
      Categorie = c(
        "Paramètres du scénario",
        "Paramètres du scénario",
        "Paramètres du scénario",
        "Paramètres du scénario",
        "Paramètres du scénario",
        
        "Couronne périnucléaire",
        "Couronne périnucléaire",
        "Couronne périnucléaire",
        "Couronne périnucléaire",
        "Couronne périnucléaire",
        
        "ApoE libre",
        "ApoE libre",
        
        "ATM nucléaire",
        "ATM nucléaire",
        
        "Évaluation"
      ),
      
      Indicateur = c(
        "Moment de l'irradiation (h)",
        "Dose d'irradiation",
        "Début traitement (h)",
        "Dose antioxydants",
        "Dose statines",
        
        "PC avant irradiation",
        "PC après irradiation",
        "PC à long terme",
        "Destruction immédiate de la couronne",
        "Evolution à long terme de la couronne",
        
        "ApoE minimale",
        "ApoE à long terme",
        
        "Pic ATM nucléaire",
        "ATM nucléaire à long terme",
        
        "Conclusion"
      ),
      
      Valeur = c(
        round(params$irr_start, 2),
        round(params$irr_amp, 3),
        round(params$Aox_start, 2),
        round(params$Aox_amp, 3),
        round(params$Sta_amp, 3),
        
        round(PC_before, 2),
        round(PC_after, 2),
        round(PC_late, 2),
        paste0(round(destruction_pc, 1), " %"),
        maintien_txt,
        
        round(A_min, 2),
        round(A_late, 2),
        
        round(MN_max, 2),
        round(MN_late, 2),
        
        ifelse(
          success,
          "Succès thérapeutique",
          "Échec / reformation observée"
        )
      )
    )
  }, digits = 4)

  
  # OPTIMISATION  
  optim_result <- eventReactive(input$run_optim, {
    
    progress <- shiny::Progress$new(session)
    on.exit(progress$close())
    progress$set(message = "Optimisation en cours...", value = 0)
    
    run_optimisation_rians(
      params_base = params_default,
      state0_base = state0_default,
      
      irr_min = input$optim_irr_min,
      irr_max = input$optim_irr_max,
      irr_n = input$optim_irr_n,
      
      trait_min = input$optim_trait_min,
      trait_max = input$optim_trait_max,
      trait_n = input$optim_trait_n,
      
      temps_eval = input$optim_temps_eval,
      
      progress = progress
    )
  })
  
  output$plot_optim <- renderPlotly({
    
    req(optim_result())
    res <- optim_result()
    
    plot_ly(
      res,
      x = ~Irradiation,
      y = ~Traitement,
      type = "scatter",
      mode = "markers",
      color = ~status,
      colors = c("Échec" = "red", "Succès" = "blue"),
      marker = list(size = 9),
      text = ~paste(
        "Irradiation:", round(Irradiation, 3),
        "<br>Traitement:", round(Traitement, 3),
        "<br>PC_before:", round(PC_before, 2),
        "<br>PC_after:", round(PC_after, 2),
        "<br>PC_late:", round(PC_late, 2),
        "<br>Rupture ratio:", round(rupture_ratio, 3),
        "<br>Maintien ratio:", round(maintien_ratio, 3)
      ),
      hoverinfo = "text"
    ) %>%
      layout(
        title = "Optimisation irradiation / traitement",
        xaxis = list(title = "Dose irradiation"),
        yaxis = list(title = "Dose traitement", autorange = "reversed"),
        showlegend = FALSE
      )
  })
  
  # RAPPORT PDF
  
  output$download_pdf <- downloadHandler(
    
    filename = function() {
      paste0("rapport_RIANS_", format(Sys.time(), "%Y-%m-%d_%H-%M"), ".pdf")
    },
    
    content = function(file) {
      
      req(resultat())
      
      df <- resultat()$out
      params <- resultat()$params
      
      # =========================================================================
      # Calcul des indicateurs biologiques
      # =========================================================================
      
      t_before <- params$irr_start - 1
      t_after  <- params$irr_start + 20
      t_late   <- max(df$time)
      
      PC_before <- df$PC[which.min(abs(df$time - t_before))]
      PC_after  <- df$PC[which.min(abs(df$time - t_after))]
      PC_late   <- df$PC[which.min(abs(df$time - t_late))]
      
      rupture_ratio  <- PC_after / PC_before
      maintien_ratio <- PC_late / PC_before
      
      destruction_pc <- 100 * (1 - rupture_ratio)
      
      if (maintien_ratio <= 1) {
        maintien_txt <- paste0(
          round(100 * (1 - maintien_ratio), 1),
          " % de réduction durable"
        )
      } else {
        maintien_txt <- paste0(
          "+",
          round(100 * (maintien_ratio - 1), 1),
          " % de reformation"
        )
      }
      
      A_min  <- min(df$A, na.rm = TRUE)
      A_late <- df$A[which.min(abs(df$time - t_late))]
      
      MN_max  <- max(df$MN, na.rm = TRUE)
      MN_late <- df$MN[which.min(abs(df$time - t_late))]
      
      success <- (
        PC_before > 150 &&
          rupture_ratio < 0.25 &&
          maintien_ratio < 0.40
      )
      
      table_resume <- data.frame(
        Categorie = c(
          "Paramètres du scénario",
          "Paramètres du scénario",
          "Paramètres du scénario",
          "Paramètres du scénario",
          "Paramètres du scénario",
          
          "Couronne périnucléaire",
          "Couronne périnucléaire",
          "Couronne périnucléaire",
          "Couronne périnucléaire",
          "Couronne périnucléaire",
          
          "ApoE libre",
          "ApoE libre",
          
          "ATM nucléaire",
          "ATM nucléaire",
          
          "Évaluation"
        ),
        
        Indicateur = c(
          "Moment de l'irradiation (h)",
          "Dose d'irradiation",
          "Début traitement (h)",
          "Dose antioxydants",
          "Dose statines",
          
          "PC avant irradiation",
          "PC après irradiation",
          "PC à long terme",
          "Destruction immédiate de la couronne",
          "Evolution à long terme de la couronne",
          
          "ApoE minimale",
          "ApoE à long terme",
          
          "Pic ATM nucléaire",
          "ATM nucléaire à long terme",
          
          "Conclusion"
        ),
        
        Valeur = c(
          round(params$irr_start, 2),
          round(params$irr_amp, 3),
          round(params$Aox_start, 2),
          round(params$Aox_amp, 3),
          round(params$Sta_amp, 3),
          
          round(PC_before, 2),
          round(PC_after, 2),
          round(PC_late, 2),
          paste0(round(destruction_pc, 1), " %"),
          maintien_txt,
          
          round(A_min, 2),
          round(A_late, 2),
          
          round(MN_max, 2),
          round(MN_late, 2),
          
          ifelse(
            success,
            "Succès thérapeutique",
            "Échec / reformation observée"
          )
        )
      )
      
      # =========================================================================
      # Génération des graphes en PNG
      # =========================================================================
      
      tmp <- tempdir()
      types <- c("stress", "cyto", "crown", "noyau", "apoe")
      pngs <- file.path(tmp, paste0(types, ".png"))
      
      for (i in seq_along(types)) {
        p <- make_plot(df, types[i], params)
        html <- file.path(tmp, paste0(types[i], ".html"))
        saveWidget(p, html, selfcontained = FALSE)
        webshot(
          html,
          file = pngs[i],
          vwidth = 1200,
          vheight = 800,
          zoom = 1
        )
      }
      
      # =========================================================================
      # PDF
      # =========================================================================
      
      pdf(file, width = 14, height = 10)
      
      # Page 1 : résumé clair
      plot.new()
      
      title(
        main = "RAPPORT DE SIMULATION RIANS",
        cex.main = 1.8,
        font.main = 2
      )
      
      text(
        0.5, 0.90,
        "Résumé du scénario simulé et des indicateurs biologiques principaux",
        cex = 1.1,
        font = 3
      )
      
      # Tableau centré
      x_cat <- 0.08
      x_ind <- 0.36
      x_val <- 0.78
      
      y_start <- 0.82
      y_step <- 0.045
      
      # En-têtes
      rect(0.04, y_start + 0.015, 0.96, y_start - 0.025, col = "grey85", border = NA)
      
      text(x_cat, y_start, "Catégorie", adj = 0, font = 2, cex = 0.9)
      text(x_ind, y_start, "Indicateur", adj = 0, font = 2, cex = 0.9)
      text(x_val, y_start, "Valeur", adj = 0, font = 2, cex = 0.9)
      
      for (i in seq_len(nrow(table_resume))) {
        
        y <- y_start - i * y_step
        
        if (i %% 2 == 0) {
          rect(0.04, y + 0.018, 0.96, y - 0.018, col = "grey95", border = NA)
        }
        
        text(x_cat, y, table_resume$Categorie[i], adj = 0, cex = 0.75)
        text(x_ind, y, table_resume$Indicateur[i], adj = 0, cex = 0.75)
        
        if (table_resume$Categorie[i] == "Évaluation") {
          text(
            x_val, y,
            table_resume$Valeur[i],
            adj = 0,
            cex = 0.8,
            font = 2
          )
        } else {
          text(x_val, y, table_resume$Valeur[i], adj = 0, cex = 0.75)
        }
      }
      
      # Pages suivantes : graphes
      for (img in pngs) {
        plot.new()
        rasterImage(as.raster(image_read(img)), 0, 0, 1, 1)
      }
      
      dev.off()
    }
  )
}