# frozen_string_literal: true

RSpec.describe PdfTemplator::Reader do
  subject(:reader) do
    footer = { left: 'left text', center: 'centered text', right: 'right text' }
    described_class.new(content: content, footer: footer)
  end

  let!(:content) { File.read('./spec/fixtures/example.html') }
  let!(:expected_fields) do
    %i[
      date
      organization_name_1
      legal_name_1
      organization_name_2
      legal_name_2
      service_name
    ]
  end

  describe 'fields' do
    it 'is valid' do
      expect(reader.fields.keys).to eq(expected_fields)
    end
  end

  describe 'write' do
    context 'when fields dont match' do
      let!(:fields) { { 'some-field' => { name: 'the field name' } } }

      it 'does not write a PDF' do
        expect { reader.write(fields) }.to raise_error(PdfTemplator::Reader::FieldsMismatchError)
      end
    end

    context 'when field match' do
      let!(:fields) do
        {
          date: 'June 17, 2018',
          organization_name_1: 'My Organization',
          legal_name_1: 'Organization Inc.',
          organization_name_2: 'His Organization',
          legal_name_2: 'His Organization Inc.',
          service_name: 'API Gateway',
        }
      end

      it 'writes a PDF' do
        pdf = reader.write(fields)
        File.open('./tmp/example.pdf', 'wb') { |f| f.write(pdf) }
      end
    end
  end
end
