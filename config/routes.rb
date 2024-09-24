Rails.application.routes.draw do
  namespace :tax_calculator do
    post 'tax-calculation', to: 'tax_calculation#calculate'
    post 'tax-scenario-simulation', to: 'tax_scenario_simulation#simulate'
    post 'source-withholding', to: 'source_withholding#calculate'
  end
end
