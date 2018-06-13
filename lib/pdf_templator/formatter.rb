# frozen_string_literal: true

module PdfTemplator
  class Formatter
    def initialize(content)
      @content = content
    end

    # Format content
    # @param type [string] money | number | date | string
    #
    # @return [string]
    def format(type)
      I18n.enforce_available_locales = false if %w[money number].include?(type)
      respond_to?(type) ? send(type) : content
    end

  private

    attr_reader :content

    def number
      Money.new(content).format(symbol: false)
    end

    def date
      content.to_time.strftime('%-d de %^B de %Y')
    end

    def money
      formatted = Money.new(content).format(no_cents: true, symbol_before_without_space: false)
      "#{formatted} #{content.to_s[-2..-1]}/100)"
    end

    def parse_cents
      int, cents = @content.to_s.split('.')
      cents = cents[0..2]
      @content = "#{int}#{cents}".to_i
    end
  end
end
