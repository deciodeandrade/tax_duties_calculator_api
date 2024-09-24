module TaxCalculator
  class TaxScenarioSimulationService
    attr_reader :total_amount, :fiscal_regime, :taxes, :errors

    REGIME_TAX_RATES = {
      "Simples Nacional" => {
        "ICMS" => 0.07,   # Exemplo: 7%
        "ISS" => 0.06,     # Exemplo: 6%
        "COFINS" => 0.06   # Exemplo: 6%
      },
      "Lucro Presumido" => {
        "ICMS" => 0.17,    # Exemplo: 17%
        "ISS" => 0.05,      # Exemplo: 5%
        "COFINS" => 0.07    # Exemplo: 7%
      },
      # Adicionar outros regimes conforme necessário
    }.freeze

    def initialize(params)
      @total_amount = params[:total_amount].to_f
      @fiscal_regime = params[:fiscal_regime]
      @taxes = params[:taxes].map(&:upcase)
      @errors = {}
    end

    # Executa a simulação do cenário tributário
    def simulate
      return unless valid?

      regime_rates = REGIME_TAX_RATES[fiscal_regime]
      if regime_rates.nil?
        @errors[:fiscal_regime] = "Regime fiscal '#{fiscal_regime}' não é reconhecido."
        return
      end

      detailed_taxes = {}
      total_tax = 0

      taxes.each do |tax|
        rate = regime_rates[tax]
        if rate
          tax_amount = total_amount * rate
          detailed_taxes[tax] = tax_amount.round(2)
          total_tax += tax_amount
        else
          @errors[:taxes] ||= []
          @errors[:taxes] << "Taxa '#{tax}' não é reconhecida para o regime '#{fiscal_regime}'."
        end
      end

      return unless @errors.empty?

      {
        fiscal_regime: fiscal_regime,
        detailed_taxes: detailed_taxes,
        total_taxes: total_tax.round(2),
        net_amount: (total_amount - total_tax).round(2)
      }
    end

    # Valida os parâmetros de entrada
    def valid?
      validate_total_amount
      validate_fiscal_regime
      validate_taxes
      @errors.empty?
    end

    private

    def validate_total_amount
      if total_amount < 0
        @errors[:total_amount] = "Deve ser um valor não negativo."
      end
    end

    def validate_fiscal_regime
      unless REGIME_TAX_RATES.key?(fiscal_regime)
        @errors[:fiscal_regime] = "Regime fiscal inválido. Opções disponíveis: #{REGIME_TAX_RATES.keys.join(', ')}."
      end
    end

    def validate_taxes
      if taxes.empty?
        @errors[:taxes] = "Nenhum imposto foi especificado."
      end
    end
  end
end
