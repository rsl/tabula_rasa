require 'spec_helper'

describe TabulaRasa::Helpers, 'Table Specs' do
  describe 'arguments' do
    it 'raises ArgumentError if no arguments are passed' do
      proc {
        tabula_rasa
      }.must_raise(ArgumentError)
    end

    it 'raises ArgumentError if collection is not ActiveRecord::Relation' do
      proc {
        tabula_rasa 'foo'
      }.must_raise(ArgumentError)
    end

    it 'returns nothing when no block is given' do
      captured = capture do
        tabula_rasa Survivor.all
      end

      assert captured.blank?
    end
  end

  describe 'default table HTML' do
    before do
      captured = capture do
        tabula_rasa Survivor.all do |t|
          t.column :first_name
        end
      end
      @doc = Nokogiri::HTML::DocumentFragment.parse(captured)
    end

    it 'returns well-formed HTML' do
      @doc.errors.must_be_empty
    end

    it 'returns a valid HTML table' do
      @doc.css('table').size.must_equal 1
      @doc.css('table').children.size.must_equal 2
      @doc.css('table > thead').size.must_equal 1
      @doc.css('table > thead').children.size.must_equal 1
      @doc.css('table > thead > tr').size.must_equal 1
      @doc.css('table > thead > tr').children.size.must_equal 1
      @doc.css('table > thead > tr > th').size.must_equal 1
      @doc.css('table > thead > tr > th').children.size.must_equal 1
      # Assert the one child [from above] is just a text node
      @doc.css('table > thead > tr > th').children.first.must_be :text?
      @doc.css('table > tbody').size.must_equal 1
      @doc.css('table > tbody').children.size.must_equal 3
      @doc.css('table > tbody > tr').size.must_equal 3
      @doc.css('table > tbody > tr').each do |row|
        row.children.size.must_equal 1
        row.css('td').must_equal row.children
        row.css('td').children.size.must_equal 1
        # Assert the one child [from above] is just a text node
        row.css('td').children.first.must_be :text?
      end
    end

    describe 'TABLE attributes' do
      before do
        @survivors = Survivor.all
      end

      it 'sets no attributes by default' do
        captured = capture do
          tabula_rasa @survivors do |t|
            t.column :first_name
          end
        end
        table = extract_first('table', captured)

        table.attributes.must_be_empty
      end

      it 'can set attributes via options on main method' do
        captured = capture do
          tabula_rasa @survivors, id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value' do |t|
            t.column :first_name
          end
        end
        table = extract_first('table', captured)

        table.attribute('id').value.must_equal 'id_value'
        table.attribute('class').value.must_equal 'class_value'
        table.attribute('arbitrary').value.must_equal 'arbitrary_value'
      end
    end
  end
end
