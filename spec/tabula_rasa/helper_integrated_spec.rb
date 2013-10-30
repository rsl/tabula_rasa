require 'spec_helper'

describe TabulaRasa::Helpers, 'Integrated [Head and Body] Specs' do
  before do
    @survivors = Survivor.all
  end

  it 'can override head value while using attribute argument for body values' do
    captured = capture do
      tabula_rasa @survivors do |t|
        t.column :first_name, head: 'First'
        t.column :last_name, head: 'Last'
      end
    end

    head_cells = extract_all('table thead th', captured)
    head_cells[0].text.must_equal 'First'
    head_cells[1].text.must_equal 'Last'

    body_rows = extract_all('table tbody tr', captured)
    body_rows.each_with_index do |row, n|
      survivor = @survivors[n]
      cells = row.css('td')
      cells[0].text.must_equal survivor.first_name
      cells[1].text.must_equal survivor.last_name
    end
  end

  it 'can override body values via proc while using attribute argument for head value' do
    captured = capture do
      tabula_rasa @survivors do |t|
        t.column :whole_name do |c|
          c.body do |instance|
            "#{instance.first_name} #{instance.last_name}"
          end
        end
      end
    end

    head_cell = extract_first('table thead th', captured)
    head_cell.text.must_equal 'Whole Name'

    body_rows = extract_all('table tbody tr', captured)
    body_rows.each_with_index do |row, n|
      survivor = @survivors[n]
      cell = row.css('td').first
      cell.text.must_equal "#{survivor.first_name} #{survivor.last_name}"
    end
  end
end
