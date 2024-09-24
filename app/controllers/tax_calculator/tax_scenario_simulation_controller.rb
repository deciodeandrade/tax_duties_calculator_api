module TaxCalculator
  class TaxScenarioSimulationController < ApplicationController
    # POST /tax_calculator/tax_scenario_simulation
    def simulate
      service = TaxCalculator::TaxScenarioSimulationService.new(tax_scenario_params)
      result = service.simulate

      if service.valid?
        render json: result, status: :ok
      else
        render json: { error: service.errors }, status: :unprocessable_entity
      end
    end

    private

    # Define os parâmetros permitidos
    def tax_scenario_params
      params.permit(:total_amount, :fiscal_regime, taxes: [])
    end
  end
end
