Rails.application.routes.draw do
  namespace :tax_calculator do
    post 'tax_calculation', to: 'tax_calculation#calculate'
    post 'tax_scenario_simulation', to: 'tax_scenario_simulation#simulate'
    post 'source_withholding', to: 'source_withholding#calculate'
  end
end
