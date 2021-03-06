# frozen_string_literal: true

require 'nokogiri'
require 'wicked_pdf'

module PdfTemplator
  class Reader
    FieldsMismatchError = Class.new ArgumentError

    # Create a new Template Reader
    # @param content [String] Content of the template
    # @param header=nil [Hash] {
    #   center:            'TEXT',
    #   font_name:         'NAME',
    #   font_size:         SIZE,
    #   left:              'TEXT',
    #   right:             'TEXT',
    #   spacing:           REAL,
    #   line:              true,
    #   content:           'HTML CONTENT ALREADY RENDERED'
    # }
    # @param footer=nil [Hash] {
    #   center:            'TEXT',
    #   font_name:         'NAME',
    #   font_size:         SIZE,
    #   left:              'TEXT',
    #   right:             'TEXT',
    #   spacing:           REAL,
    #   line:              true,
    #   content:           'HTML CONTENT ALREADY RENDERED'
    # }
    #
    # @see https://github.com/mileszs/wicked_pdf
    # @return [type] [description]
    def initialize(content:, header: nil, footer: nil)
      @content = content
      @header = header
      @footer = footer
    end

    # Get all the <field>s of the template.
    # @return [Hash] {
    #   type:   text|number|money|date,
    #   value:  'The value of the field',
    #   name:   'the_name_of_the_field'
    # }
    def fields
      return @fields if @fields
      @fields = {}
      nokogiri_fields.each do |field|
        name = field.attr('name').downcase.gsub(/ |-/, '_')
        type = field.attr('type')
        args = extract_args(field)
        value = field.text
        @fields[name.to_sym] = { type: type, value: value, name: name, args: args }
      end
      @fields
    end

    def fields_array
      @fields_array ||= fields.map { |_, element| element }
    end

    # Write a PDF with the fields,
    # The type of the field will be taken from the original field.
    #
    # @param fields [Hash] with format
    # {
    #   fecha: 'The content of the field'
    # }
    #
    # @return [String] String of the PDF
    def write(fields)
      fields = clean_fields(fields)

      fail FieldsMismatchError, "Missing fields #{missing_fields(fields)}" unless valid_fields?(fields)
      build_doc && replace_fields(fields)
      WickedPdf.new.pdf_from_string(
        doc.to_html,
        encoding: 'UTF-8',
        footer: @footer,
        dpi: 300,
      )
    end

    def replace_fields(fields)
      fields.each do |k, v|
        k = k.downcase.gsub(/ |-/, '_')
        field_selector = "field[name=#{k}]"
        doc.css(field_selector).each do |field|
          new_node = doc.create_element('span')
          args = extract_args(field)
          new_node.add_child(format_content(field.attr('type'), args, v))
          field.replace(new_node)
        end
      end
    end

    def valid_fields?(fields)
      a = fields_array.map { |field| field[:name] }
      b = fields if fields.is_a?(Array)
      b ||= fields.keys
      a.sort == b.sort
    end

    def missing_fields(fields)
      a = fields_array.map { |field| field[:name] }
      b = fields if fields.is_a?(Array)
      b ||= fields.keys
      a - b
    end

  private

    def extract_args(field)
      data_attrs = field.attributes.select { |atr| atr.start_with?('data-') }
      data_attrs.values.map { |atr| [atr.name.gsub('data-', ''), atr.value] }.to_h
    end

    # Cleans fields (lowercase, removes spaces and changes for underscores)
    def clean_fields(fields)
      fields.map { |k, v| [k.to_s.downcase.gsub(/ |-/, '_'), v] }.to_h
    end

    # Build content depending on the type
    # @param type [String] One of text|number|money|date|accounting
    # @param args [Hash] Extra variables to pass to the formatter
    # @param content [String] The content to be formatted
    #
    # @return [String] The formatted content
    def format_content(type, args, content)
      Formatter.new(content).apply(type, args)
    end

    def doc
      @doc ||= build_doc
    end

    def build_doc
      @doc = Nokogiri::HTML(@content)
    end

    def nokogiri_fields
      doc.css('field')
    end
  end
end
