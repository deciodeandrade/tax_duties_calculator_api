module TaxCalculator
  class SourceWithholdingController < ApplicationController
    # POST /tax_calculator/source_withholding
    def calculate
      service = TaxCalculator::SourceWithholdingService.new(source_withholding_params)
      result = service.calculate

      if service.valid?
        render json: result, status: :ok
      else
        render json: { error: service.errors }, status: :unprocessable_entity
      end
    end

    private

    # Define os parâmetros permitidos
    def source_withholding_params
      params.permit(:gross_amount, taxes: [])
    end
  end
end
