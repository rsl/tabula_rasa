require 'spec_helper'

describe TabulaRasa::Helpers, 'Head Specs' do
  before do
    @survivors = Survivor.all
  end

  describe 'THEAD attributes' do
    it 'sets no attributes by default' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      head = extract_first('table thead', captured)

      head.attributes.must_be_empty
    end

    it 'can set attributes via options[:head] on main method' do
      captured = capture do
        tabula_rasa @survivors, head: {id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value'} do |t|
          t.column :first_name
        end
      end
      table = extract_first('table', captured)
      head = extract_first('table thead', captured)

      head.attribute('id').value.must_equal 'id_value'
      head.attribute('class').value.must_equal 'class_value'
      head.attribute('arbitrary').value.must_equal 'arbitrary_value'

      # Side test
      table.attributes.must_be_empty
    end
  end

  # NOTE: For now, I don't see the point of adding attributes on TR element on THEAD.
  # I've had varying success styling on that and tend to style on the TH elements instead.
  # Also, unlike TBODY, there's only one row so... it's THEAD TR. Done!

  describe 'TH attributes' do
    it 'sets no attributes by default' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      cell = extract_first('table thead th', captured)

      cell.attributes.must_be_empty
    end

    it 'can set attributes via options[:head] on internal column method' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name, head: {id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value'}
        end
      end
      table = extract_first('table', captured)
      head = extract_first('table thead', captured)
      cell = extract_first('table thead th', captured)

      cell.attribute('id').value.must_equal 'id_value'
      cell.attribute('class').value.must_equal 'class_value'
      cell.attribute('arbitrary').value.must_equal 'arbitrary_value'

      # Side tests
      table.attributes.must_be_empty
      head.attributes.must_be_empty
    end
  end

  describe 'TH content' do
    it 'uses the first argument by default' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      cell = extract_first('table thead th', captured)

      cell.text.must_equal 'First Name'
    end

    it 'can override first argument via options[:head]' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name, head: 'Overridden Value'
        end
      end
      cell = extract_first('table thead th', captured)

      cell.text.must_equal 'Overridden Value'
    end

    it 'can override first argument via options[:head][:value] when setting attributes via options[:head]' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name, head: {id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value', value: 'Overridden Value'}
        end
      end
      table = extract_first('table', captured)
      head = extract_first('table thead', captured)
      cell = extract_first('table thead th', captured)

      cell.attribute('id').value.must_equal 'id_value'
      cell.attribute('class').value.must_equal 'class_value'
      cell.attribute('arbitrary').value.must_equal 'arbitrary_value'
      cell.attribute('value').must_be_nil

      cell.text.must_equal 'Overridden Value'

      # Side tests
      table.attributes.must_be_empty
      head.attributes.must_be_empty
    end

    it 'raises ArgumentError if attempting to override content via a proc [as body can]' do
      proc {
        tabula_rasa @survivors do |t|
          t.column :first_name do |c|
            c.head do
              # This will raise
            end
          end
        end
      }.must_raise(ArgumentError)
    end

    it 'raises ArgumentError if it cannot determine a value for head' do
      proc {
        tabula_rasa @survivors do |t|
          t.column
        end
      }.must_raise(ArgumentError)
    end
  end
end
