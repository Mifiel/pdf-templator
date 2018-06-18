# frozen_string_literal: true

require 'pdf_templator/version'

module PdfTemplator
  autoload :Reader, 'pdf_templator/reader'
  autoload :Formatter, 'pdf_templator/formatter'
  autoload :Type, 'pdf_templator/type'

  # Example:
  #
  #   Slop.string_to_type("string")     #=> "StringType"
  #   Slop.string_to_type("some_thing") #=> "SomeThingType"
  #
  # Returns a camel-cased class looking string with Type suffix.
  def self.string_to_type(s)
    s.to_s.gsub(/(?:^|_)([a-z])/) { $1.capitalize } + 'Type'
  end

  # Example:
  #
  #   Slop.string_to_type_class("string") #=> Slop::StringType
  #   Slop.string_to_type_class("foo")    #=> uninitialized constant FooType
  #
  # Returns the full qualified type class. Uses `#string_to_type`.
  def self.string_to_type_class(s)
    const_get(string_to_type(s))
  end
end
