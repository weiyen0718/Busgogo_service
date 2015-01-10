class CreateTutorials < ActiveRecord::Migration
  def self.up
		create_table :tutorials do |t|
		t.integer :num
		t.text :station
		t.text :address
		end
  end
  def self.down
	drop_table
  end
end
