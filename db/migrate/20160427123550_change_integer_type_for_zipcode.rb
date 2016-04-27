class ChangeIntegerTypeForZipcode < ActiveRecord::Migration
   def self.up
    change_table :addresses do |t|
      t.change :zipcode, :string
    end
  end
  def self.down
    change_table :addresses do |t|
      t.change :zipcode, :integer
    end
  end
end
