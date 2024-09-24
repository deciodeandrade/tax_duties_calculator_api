module TaxCalculator
  class TaxCalculationService
    attr_reader :total_amount, :taxes, :errors

    TAX_RATES = {
      "IR" => 0.275,    # Exemplo: 27,5%
      "ICMS" => 0.17,   # Exemplo: 17%
      "ISS" => 0.05,     # Exemplo: 5%
      "PIS" => 0.015,    # Exemplo: 1,5%
      "COFINS" => 0.07,  # Exemplo: 7%
      "INSS" => 0.11     # Exemplo: 11%
    }.freeze

    def initialize(params)
      @total_amount = params[:total_amount].to_f
      @taxes = params[:taxes].map(&:upcase)
      @errors = {}
    end

    # Executa o cálculo dos impostos
    def calculate
      return unless valid?

      detailed_taxes = {}
      total_tax = 0

      taxes.each do |tax|
        rate = TAX_RATES[tax]
        if rate
          tax_amount = total_amount * rate
          detailed_taxes[tax] = tax_amount.round(2)
          total_tax += tax_amount
        else
          @errors[:taxes] ||= []
          @errors[:taxes] << "Taxa '#{tax}' não é reconhecida."
        end
      end

      return unless @errors.empty?

      net_amount = total_amount - total_tax

      {
        detailed_taxes: detailed_taxes,
        net_amount: net_amount.round(2)
      }
    end

    # Valida os parâmetros de entrada
    def valid?
      validate_total_amount
      validate_taxes
      @errors.empty?
    end

    private

    def validate_total_amount
      if total_amount < 0
        @errors[:total_amount] = "Deve ser um valor não negativo."
      end
    end

    def validate_taxes
      if taxes.empty?
        @errors[:taxes] = "Nenhum imposto foi especificado."
      end
    end
  end
end
