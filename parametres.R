T_half <- 24
d0 <- log(2) / T_half

A_star <- 200
lambda1 <- d0 * 300

Tmax <- 500
times <- seq(0, Tmax, by = 0.1)

params_default <- list(
  
  lambda1 = lambda1,
  lambda2 = 0.49,
  
  d0 = d0,
  d1 = 0.1,
  d3 = 0.0027,
  
  stress_const = 0.08,
  
  irr_start = 100,
  irr_amp = 1.5,
  tau_rise = 0.2,
  tau_decay = 30,
  
  Aox_start = 90,
  Aox_amp = 1,
  Aox_tau = 8,
  effet_Aox_stress = 0.5,
  
  Sta_start = 90,
  Sta_amp = 1,
  Sta_tau = 8,
  
  k1 = 0.001,
  k2 = 0.015,
  k3 = 0.03,
  k4 = 0.015,
  k5 = 0.01,
  k6 = 0,
  
  facteur_k1_Aox = 0.5,
  facteur_k2_Aox = 0.5,
  facteur_k4_Aox = 0.005,
  facteur_k5_Aox = 0.02,
  facteur_k6_Aox = 0.03,
  
  facteur_k3_Sta = 5,
  gamma_irr_Aox = 0.02,
  
  PC_th = 200,
  nPC = 4,
  
  CA_th = 80,
  nCA = 4,
  
  A_star = A_star
)

state0_default <- c(
  DC = 320,
  MC = 1,
  MA = 0,
  MN = 0,
  A  = A_star,
  CA = 0,
  DA = 0
)