# TabulaRasa

An opinionated yet simple table generator for Rails<sup>1</sup>.

TabulaRasa is designed to leverage ActiveRecord::Relation instances and conventions<sup>2</sup> to make table generation a snap but still readable and editable.

## Installation

Add this line to your application's Gemfile:

    gem 'tabula_rasa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tabula_rasa

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Footnotes

<sup>1</sup> TabulaRasa really only relies on ActiveRecord and ActionView/ActionPack so you could use in a non-Rails stack that had those two elements but it seemed silly to differentiate this in the summary sentence.

<sup>2</sup> These conventions may only be my own. Time will tell.
