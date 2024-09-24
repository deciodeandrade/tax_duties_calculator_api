module TaxCalculator
  class TaxCalculationController < ApplicationController
    # POST /tax_calculator/tax_calculation
    def calculate
      service = TaxCalculator::TaxCalculationService.new(tax_calculation_params)
      result = service.calculate

      if service.valid?
        render json: result, status: :ok
      else
        render json: { error: service.errors }, status: :unprocessable_entity
      end
    end

    private

    # Define os parâmetros permitidos
    def tax_calculation_params
      params.permit(:total_amount, taxes: [])
    end
  end
end
