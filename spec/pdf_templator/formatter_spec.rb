# frozen_string_literal: true

RSpec.describe PdfTemplator::Formatter do
  subject(:formatter) { described_class.new(content).format(type) }

  cases = {
    money: [{
      content:  '123.45',
      expected: '$123 45/100',
    }, {
      content:  '123.454556',
      expected: '$123 45/100',
    }, {
      content:  '12.00',
      expected: '$12 00/100',
    },],
    number: [{
      content:  '12.00',
      expected: '12.00',
    }, {
      content:  '12.43',
      expected: '12.43',
    }, {
      content:  '12.43456',
      expected: '12.43',
    },],
    date: [{
      content:  'May 15, 2018',
      expected: '15/May/2018',
    }, {
      content:  '15 May 2018',
      expected: '15/May/2018',
    }, {
      content:  '2018.05.15',
      expected: '15/May/2018',
    }, {
      content:  '2018-05-15',
      expected: '15/May/2018',
    },],
  }

  cases.each do |type, tests|
    describe "##{type}" do
      let(:type) { type }

      tests.each do |t|
        describe t[:content] do
          let(:content) { t[:content] }

          it { expect(formatter).to eq(t[:expected]) }
        end
      end
    end
  end
end
