require 'spec_helper'

describe TabulaRasa::Helpers, 'Head Specs' do
  before do
    @survivors = Survivor.all
  end

  describe 'TBODY attributes' do
    it 'sets no attributes by default' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      body = extract_first('table tbody', captured)

      body.attributes.must_be_empty
    end

    it 'can set attributes via options[:body] on main method' do
      captured = capture do
        tabula_rasa @survivors, body: {id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value'} do |t|
          t.column :first_name
        end
      end
      table = extract_first('table', captured)
      body = extract_first('table tbody', captured)

      body.attribute('id').value.must_equal 'id_value'
      body.attribute('class').value.must_equal 'class_value'
      body.attribute('arbitrary').value.must_equal 'arbitrary_value'

      # Side test
      table.attributes.must_be_empty
    end
  end

  describe 'TR attributes' do
    it 'zebrastripes by default' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      rows = extract_all('table tbody tr', captured)
      # Smoke test
      rows.size.must_equal 3

      rows[0].attribute('class').value.must_equal 'even'
      rows[1].attribute('class').value.must_equal 'odd'
      rows[2].attribute('class').value.must_equal 'even'
    end

    it 'raises ArgumentError if row is defined more than once' do
      proc {
        tabula_rasa @survivors do |t|
          t.row class: 'foo'
          t.row class: 'bar'
        end
      }.must_raise(ArgumentError)
    end
  end

  describe 'TD attributes' do
    it 'sets no attributes by default' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      cells = extract_all('table tbody td', captured)

      cells.each do |cell|
        cell.attributes.must_be_empty
      end
    end

    it 'can set attributes via options[:body] on internal column method' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name, id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value'
        end
      end
      table = extract_first('table', captured)
      body = extract_first('table tbody', captured)
      cells = extract_first('table tbody td', captured)

      cells.each do |cell|
        cell.attribute('id').value.must_equal 'id_value'
        cell.attribute('class').value.must_equal 'class_value'
        cell.attribute('arbitrary').value.must_equal 'arbitrary_value'
      end

      # Side tests
      table.attributes.must_be_empty
      body.attributes.must_be_empty
    end
  end

  describe 'TD content' do
    it 'uses the first argument by default' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      cells = extract_all('table tbody td', captured)

      cells.each_with_index do |cell, n|
        cell.text.must_equal @survivors[n].first_name
      end
    end

    it 'can override first argument via options[:body] on internal column method' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name, body: 'Overridden Value'
        end
      end
      cells = extract_all('table tbody td', captured)

      cells.each do |cell|
        cell.text.must_equal 'Overridden Value'
      end
    end

    it 'can override first argument via options[:body][:value] when setting attributes via options[:body] on internal column method' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name, body: {id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value', value: 'Overridden Value'}
        end
      end
      table = extract_first('table', captured)
      body = extract_first('table tbody', captured)
      cells = extract_all('table tbody td', captured)

      cells.each do |cell|
        cell.attribute('id').value.must_equal 'id_value'
        cell.attribute('class').value.must_equal 'class_value'
        cell.attribute('arbitrary').value.must_equal 'arbitrary_value'

        cell.text.must_equal 'Overridden Value'
      end

      # Side tests
      table.attributes.must_be_empty
      body.attributes.must_be_empty
    end

    it 'can override first argument via a Proc argument for internal column method' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :whole_name do |c|
            c.value do |instance|
              "#{instance.first_name} #{instance.last_name}"
            end
          end
        end
      end
      cells = extract_all('table tbody td', captured)

      cells.each_with_index do |cell, n|
        survivor = @survivors[n]
        cell.text.must_equal "#{survivor.first_name} #{survivor.last_name}"
      end
    end

    it 'can override first argument via a Proc argument for internal column method while setting attributes via options[:body]' do
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :whole_name, body: {id: 'id_value', class: 'class_value', arbitrary: 'arbitrary_value', value: 'Overridden Value'} do |c|
            c.value do |instance|
              "#{instance.first_name} #{instance.last_name}"
            end
          end
        end
      end
      table = extract_first('table', captured)
      body = extract_first('table tbody', captured)
      cells = extract_all('table tbody td', captured)

      cells.each_with_index do |cell, n|
        survivor = @survivors[n]
        cell.text.must_equal "#{survivor.first_name} #{survivor.last_name}"

        cell.attribute('id').value.must_equal 'id_value'
        cell.attribute('class').value.must_equal 'class_value'
        cell.attribute('arbitrary').value.must_equal 'arbitrary_value'
      end

      # Side tests
      table.attributes.must_be_empty
      body.attributes.must_be_empty
    end

    it 'indicates the table is empty when collection is empty' do
      @survivors = Survivor.none
      captured = capture do
        tabula_rasa @survivors do |t|
          t.column :first_name
        end
      end
      table = extract_first('table', captured)
      body = extract_first('table tbody', captured)
      cells = extract_all('table tbody td', captured)

      cells.size.must_equal 1
      cell = cells.first
      cell.children.size.must_equal 1
      cell.children.first.must_be :text?
      cell.text.must_equal 'No survivors present'
    end
  end
end
