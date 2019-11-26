apply_exposure <- function(treated_units, ConfigObject) {
  ConfigObject$data$treatment <- 0
  for (t_state in names(treated_units)) {
    for (i in 1:length(treated_units[[t_state]][["policy_years"]])) {
      yr <- treated_units[[t_state]][["policy_years"]][i]
      exposure <- treated_units[[t_state]][["exposure"]][i]
      
      ConfigObject$data <- ConfigObject$data %>%
        mutate(treatment = ifelse(state == t_state & year == yr, exposure, treatment))
    }
  }
}
