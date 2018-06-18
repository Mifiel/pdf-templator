# PDF Templator

Create PDFs from HTML templates in a breeze.

## Features

- Create a single HTML with `<field>` tags and PDF Templator will fill them for you.
- Field types include `date`, `number`, `date`, `money`, `accounting`.
- Create your own field type.
- Usage as a CLI in case you're not working on Ruby.
- It uses [wicked_pdf](https://github.com/mileszs/wicked_pdf) internally so you can use all its features too.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdf_templator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdf_templator

## Usage

```ruby
require 'pdf_templator'

html = File.read('path/to/my/template.html')
# OR
html = '<html>' \
       'My name is <field name="name">' \
       'and today is <field name="date" type="date" data-format="%b %d, %Y">' \
       '</html>'
args = {
  name: 'My Name',
  date: '06/18/2018',
}

reader = PdfTemplator::Reader.new(content: html, footer: footer)
pdf = reader.write(args)
File.open('path/to/file.pdf', 'wb') { |f| f.write(pdf) }
```

### Custom types

```ruby
module PdfTemplator
  class ListType < Type
    def call
      list = content.split(',')
      html_items = list.map do |item|
        "<li>#{item}</li>"
      end
      "<ul>#{html_items.join}</ul>"
    end
  end
end

# Then you could have an html like

<field name="my_list" type="list"></field>

# And pass the args like

args = {
  my_list: 'car,helicopter,motorcycle'
}

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `rake console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pdf_templator.
