module TaxCalculator
  class SourceWithholdingService
    attr_reader :gross_amount, :taxes, :errors

    TAX_RATES = {
      "INSS" => 0.11, # Exemplo: 11%
      "IR" => 0.275    # Exemplo: 27,5%
    }.freeze

    def initialize(params)
      @gross_amount = params[:gross_amount].to_f
      @taxes = params[:taxes].map(&:upcase)
      @errors = {}
    end

    # Executa o cálculo das retenções na fonte
    def calculate
      return unless valid?

      detailed_withholdings = {}
      total_withholding = 0

      taxes.each do |tax|
        rate = TAX_RATES[tax]
        if rate
          withholding_amount = gross_amount * rate
          detailed_withholdings[tax] = withholding_amount.round(2)
          total_withholding += withholding_amount
        else
          @errors[:taxes] ||= []
          @errors[:taxes] << "Taxa '#{tax}' não é reconhecida."
        end
      end

      return unless @errors.empty?

      net_amount = gross_amount - total_withholding

      {
        detailed_withholdings: detailed_withholdings,
        net_amount: net_amount.round(2)
      }
    end

    # Valida os parâmetros de entrada
    def valid?
      validate_gross_amount
      validate_taxes
      @errors.empty?
    end

    private

    def validate_gross_amount
      if gross_amount < 0
        @errors[:gross_amount] = "Deve ser um valor não negativo."
      end
    end

    def validate_taxes
      if taxes.empty?
        @errors[:taxes] = "Nenhum imposto foi especificado."
      end
    end
  end
end
