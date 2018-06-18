# frozen_string_literal: true

require 'money'
require 'active_support/core_ext/string/conversions'
require 'numbers_and_words'

module PdfTemplator
  class TextType < Type
    def call
      "<strong>#{content}</strong>"
    end
  end

  class NumericType < Type
    def initialize(content, args = {})
      super
      @content = cents
    end

  private

    def cents
      int, decimals = @content.to_s.split('.')
      decimals = decimals[0..1]
      "#{int}#{decimals}".to_i
    end
  end

  class MoneyType < NumericType
    def call
      formatted = content.to_s[0..-3].to_i.to_words
      "#{formatted} #{content.to_s[-2..-1]}/100"
    end
  end

  class AccountingType < NumericType
    def call
      Money.new(content, args[:currency]).format
    end
  end

  class NumberType < NumericType
    def call
      Money.new(content).format(symbol: false)
    end
  end

  class DateType < TextType
    def call
      content.to_time.strftime(args[:format] || '%d/%b/%Y')
    end
  end
end
