# TabulaRasa [![Code Climate](https://codeclimate.com/github/rsl/tabula_rasa.png)](https://codeclimate.com/github/rsl/tabula_rasa) [![Build Status](https://travis-ci.org/rsl/tabula_rasa.png)](https://travis-ci.org/rsl/tabula_rasa)


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

TabulaRasa is designed to make it easy to make valid HTML[5] tables for ActiveRecord::Relations. Here are examples on how to set attributes:

```ruby
# TABLE
# NOTE: special options here:
# * zebra: Accepts boolean or array of string values for ActionView's cycle helper. Defaults to true, creating zebra-striped tables (using 'even' and 'odd' values) out of the box.
# * dom_id: Accepts boolean, for setting TBODY TR id attribute to dom_id for the row's instance. Defaults to false.
# * dom_class: Accepts boolean, for adding dom_class for the row's instance to the TBODY TR class attribute. Defaults to false.
tabula_rasa @collection id: 'foo' do |table|
  t.column :foo
end

# THEAD
tabula_rasa @collection, head: {id: 'foo'} do |table|
  t.column :foo
end

# THEAD TR not supported. There's only one row. Use the THEAD TR selector instead.

# TH
tabula_rasa @collection do |table|
  t.column :foo, head: {id: 'foo'}
  # You can also set both TH and TD attributes with the same values
  t.column :bar, shared: {class: 'bar'}
  # NOTE: block column arguments are not supported for TH element
end

# TBODY
tabula_rasa @collection, body: {id: 'foo'} do |table|
  t.column :foo
end

# TBODY TR
tabula_rasa @collection do |table|
  t.column :foo # Just here for validity
  # This is the code that actually does the work for the TR
  t.row class: 'foobar'
  # OR you can use a block argument. Do note though...
  # Defining the row twice in real code will raise ArgumentError.
  t.row do |row|
    row.id do |instance|
      dom_id instance
    end
    # Sets attribute 'data-foo'
    row.data :foo do |instance|
      "foo-#{instance.id}"
    end
  end
end

# TD
tabula_rasa @collection do |table|
  t.column :foo, body: {class: 'foo'}
  t.column :bar do |column|
    column.class do |instance|
      instance.bar? ? 'bar' : 'unbar'
    end
    # Just an example of another attribute where setting by string might make sense. Use CSS for this really!
    column.attribute :width, '100'
  end
  # You can also set both TH and TD attributes with the same values
  t.column :baz, shared: {class: 'baz'}
end
```

Cell values default to the attribute name [for the TH element] and value [for the TD element]. You can easily override this by using the :value key for the :head or :body options for the column method as seen below:

```ruby
tabula_rasa @collection do |table|
  t.column :foo, head: {value: 'Foo Header'}, body: {value: 'Foo Body Content'}
end
```

Most use cases for overriding the body value though would be better served by using a block which provides access to the collection member for that row.

```ruby
tabula_rasa @collection do |table|
  t.column :foo do |column|
    column.value do |instance|
      "A massaged value for instance #{instance.id}"
    end
  end
end
```

A lot of the time though you should just be able to get by with a simple symbol argument, since you aren't limited to simple attributes but can use methods that massage attribute data.

```ruby
tabula_rasa @collection do |table|
  t.column :foo
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Discover more things to do

## Footnotes

<sup>1</sup> TabulaRasa really only relies on ActiveRecord and ActionView/ActionPack so you could use in a non-Rails stack that had those two elements but it seemed silly to differentiate this in the summary sentence.

<sup>2</sup> These conventions may only be my own. Time will tell.
