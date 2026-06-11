library(deSolve)

compute_irradiation <- function(t, params) {
  dt <- t - params$irr_start
  if (dt <= 0 || params$irr_amp <= 0) return(0)
  
  Irr_raw <- (1 - exp(-dt / params$tau_rise)) * exp(-dt / params$tau_decay)
  dt_star <- params$tau_rise * log(1 + params$tau_decay / params$tau_rise)
  Imax <- (1 - exp(-dt_star / params$tau_rise)) * exp(-dt_star / params$tau_decay)
  
  params$irr_amp * Irr_raw / Imax
}

compute_Aox <- function(t, params) {
  if (t < params$Aox_start || params$Aox_amp <= 0) return(0)
  params$Aox_amp * (1 - exp(-(t - params$Aox_start) / params$Aox_tau))
}

compute_Sta <- function(t, params) {
  if (t < params$Sta_start || params$Sta_amp <= 0) return(0)
  params$Sta_amp * (1 - exp(-(t - params$Sta_start) / params$Sta_tau))
}

compute_stress <- function(t, params) {
  Irr <- compute_irradiation(t, params)
  Aox <- compute_Aox(t, params)
  
  stress_basal_eff <- params$stress_const * (1 - params$effet_Aox_stress * Aox)
  stress_basal_eff <- max(stress_basal_eff, 0)
  
  stress_basal_eff + Irr
}

rians_model <- function(t, state, parameters) {
  with(as.list(c(state, parameters)), {
    
    tmp_params <- as.list(c(parameters))
    
    Aox <- compute_Aox(t, tmp_params)
    Sta <- compute_Sta(t, tmp_params)
    s <- compute_stress(t, tmp_params)
    
    # Traitement actif seulement après irradiation
    Irr_gate <- ifelse(t < irr_start || irr_amp <= 0, 0, 1)
    
    Irr_boost <- 1 + gamma_irr_Aox * irr_amp

    Aox_eff <- Aox * Irr_gate * Irr_boost
    Sta_eff <- Sta * Irr_gate

    Aox_eff <- max(0, min(Aox_eff, 1))
    Sta_eff <- max(0, min(Sta_eff, 1))
    
    # Effets Aox : diminution k1, k2, k4, k5 ; augmentation k6
    k1_eff <- k1 * (1 - Aox_eff + Aox_eff * facteur_k1_Aox)
    k2_eff <- k2 * (1 - Aox_eff + Aox_eff * facteur_k2_Aox)
    k4_eff <- k4 * (1 - Aox_eff + Aox_eff * facteur_k4_Aox)
    k5_eff <- k5 * (1 - Aox_eff + Aox_eff * facteur_k5_Aox)
    k6_eff <- k6 + facteur_k6_Aox * Aox_eff
    
    # Effet Sta : augmentation k3
    k3_eff_base <- k3 * (1 - Sta_eff + Sta_eff * facteur_k3_Sta)
    
    PC <- CA + DA
    
    k3_eff <- k3_eff_base / (1 + (PC / PC_th)^nPC)
    
    formation_CA <- k4_eff * A * MA
    
    activation_CA <- CA^nCA / (CA^nCA + CA_th^nCA)
    formation_DA <- 0.5 * k5_eff * MA^2 * activation_CA
    
    dDC <- lambda1 - d0 * DC + 0.5 * k1_eff * MC^2 - s * DC
    
    dMC <- -k1_eff * MC^2 - k2_eff * MC + k6_eff * MA + 2 * s * DC
    
    dMA <- k2_eff * MC - k3_eff * MA - formation_CA - 2 * formation_DA - k6_eff * MA + 2 * s * DA + s * CA
    
    dMN <- k3_eff * MA - d1 * MN
    
    dA <- lambda2 - d3 * A - formation_CA + s * CA
    
    dCA <- formation_CA - s * CA
    
    dDA <- formation_DA - s * DA
    
    list(c(dDC, dMC, dMA, dMN, dA, dCA, dDA))
  })
}

simulation_rians <- function(params, state0, times) {
  
  out <- as.data.frame(
    ode(
      y = state0,
      times = times,
      func = rians_model,
      parms = params
    )
  )
  
  out$PC <- out$CA + out$DA
  
  out$Irr <- vapply(out$time, compute_irradiation, numeric(1), params = params)
  out$Aox <- vapply(out$time, compute_Aox, numeric(1), params = params)
  out$Sta <- vapply(out$time, compute_Sta, numeric(1), params = params)
  out$s <- vapply(out$time, compute_stress, numeric(1), params = params)
  
  out$Irr_gate <- ifelse(out$time < params$irr_start | params$irr_amp <= 0, 0, 1)
  out$Aox_eff <- pmin(pmax(out$Aox * out$Irr_gate, 0), 1)
  out$Sta_eff <- pmin(pmax(out$Sta * out$Irr_gate, 0), 1)
  
  return(out)
}