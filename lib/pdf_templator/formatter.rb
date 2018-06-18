# frozen_string_literal: true

require 'money'
require 'numbers_and_words'
require 'active_support/core_ext/string/conversions'

module PdfTemplator
  class Formatter
    def initialize(content)
      @content = content
    end

    # Format content
    # @param type [string] money | number | date | string
    # @param args [hash] :locale, :format
    #
    # @return [string]
    def apply(type, args = {})
      @args = args.map { |k, v| [k.to_sym, v] }.to_h
      I18n.locale = args[:locale] || :en
      respond_to?(type, true) ? send(type) : content
    end

  private

    attr_reader :content, :args

    def number
      Money.new(parse_cents, args[:currency] || 'USD').format(symbol: false)
    end

    def date
      content.to_time.strftime(args[:format] || '%d/%b/%Y')
    end

    def money
      formatted = parse_cents.to_s[0..-3].to_i.to_words
      "#{formatted} #{content.to_s[-2..-1]}/100"
    end

    def accounting
      Money.new(parse_cents, args[:currency]).format
    end

    def parse_cents
      return @content if @parsed
      int, cents = @content.to_s.split('.')
      cents = cents[0..1]
      @parsed = true
      @content = "#{int}#{cents}".to_i
    end
  end
end
