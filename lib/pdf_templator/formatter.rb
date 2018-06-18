# frozen_string_literal: true

require_relative 'types'

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
      # Symbolize keys
      args = args.map { |k, v| [k.to_sym, v] }.to_h
      I18n.locale = args[:locale] || :en
      klass = PdfTemplator.string_to_type_class(type)
      klass.new(@content, args).call
    end
  end
end
