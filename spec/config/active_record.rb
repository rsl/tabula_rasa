require 'active_record/fixtures'

ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :survivors, force: true do |t|
    t.string :first_name, :last_name
    t.timestamps
  end
end
ActiveRecord::Migration.verbose = true

class Survivor < ActiveRecord::Base
  def display_name
    [first_name, last_name].join ' '
  end
end

# Manual fixture loading
Dir.glob('spec/fixtures/*.yml').each do |file|
  ActiveRecord::FixtureSet.create_fixtures 'spec/fixtures', File.basename(file, '.yml')
end
