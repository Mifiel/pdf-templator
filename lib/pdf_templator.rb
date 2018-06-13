# frozen_string_literal: true

require 'pdf_templator/version'
require 'active_support/core_ext/string/conversions'

module PdfTemplator
  autoload :Reader, 'pdf_templator/reader'
  autoload :Formatter, 'pdf_templator/formatter'
end
