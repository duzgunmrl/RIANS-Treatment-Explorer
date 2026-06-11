run_optimisation_rians <- function(
    params_base,
    state0_base,
    irr_min = 0,
    irr_max = 3,
    irr_n = 30,
    trait_min = 0,
    trait_max = 1,
    trait_n = 30,
    temps_eval = 300,
    progress = NULL
) {
  
  irr_values <- seq(irr_min, irr_max, length.out = irr_n)
  trait_values <- seq(trait_min, trait_max, length.out = trait_n)
  
  results <- data.frame()
  total <- length(irr_values) * length(trait_values)
  compteur <- 0
  
  for (irr in irr_values) {
    for (trait in trait_values) {
      
      compteur <- compteur + 1
      
      if (!is.null(progress)) {
        progress$set(
          value = compteur / total,
          detail = paste("Irr =", round(irr, 3), "| Trait =", round(trait, 3))
        )
      }
      
      params <- params_base
      
      # Couple optimisé :
      params$irr_amp <- irr
      params$Aox_amp <- trait
      params$Sta_amp <- trait
      
      times <- seq(0, max(params$irr_start + 20, temps_eval), by = 0.5)
      
      out <- simulation_rians(params, state0_base, times)
      
      # Fenêtres temporelles
      t_before <- params$irr_start - 1
      t_after  <- params$irr_start + 20
      t_late   <- temps_eval
      
      PC_before <- out$PC[which.min(abs(out$time - t_before))]
      PC_after  <- out$PC[which.min(abs(out$time - t_after))]
      PC_late   <- out$PC[which.min(abs(out$time - t_late))]
      
      rupture_ratio <- PC_after / PC_before
      maintien_ratio <- PC_late / PC_before
      
      success <- (
        PC_before > 150 &&
          rupture_ratio < 0.25 &&
          maintien_ratio < 0.3
      )
      
      results <- rbind(
        results,
        data.frame(
          Irradiation = irr,
          Traitement = trait,
          PC_before = PC_before,
          PC_after = PC_after,
          PC_late = PC_late,
          rupture_ratio = rupture_ratio,
          maintien_ratio = maintien_ratio,
          status = ifelse(success, "Succès", "Échec")
        )
      )
    }
  }
  
  return(results)
}