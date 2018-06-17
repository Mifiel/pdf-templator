# frozen_string_literal: true

require 'money'

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
      respond_to?(type, true) ? send(type) : content
    end

  private

    attr_reader :content

    def number
      Money.new(parse_cents).format(symbol: false)
    end

    def date
      content.to_time.strftime('%d/%b/%Y')
    end

    def money
      formatted = Money.new(parse_cents).format(no_cents: true)
      "#{formatted} #{content.to_s[-2..-1]}/100"
    end

    def parse_cents
      int, cents = @content.to_s.split('.')
      cents = cents[0..1]
      @content = "#{int}#{cents}".to_i
    end
  end
end
