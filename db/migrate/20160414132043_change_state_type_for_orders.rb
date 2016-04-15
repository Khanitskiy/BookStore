class ChangeStateTypeForOrders < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.change :state, :string, default: "in_progress"
    end
  end
  def self.down
    change_table :orders do |t|
      t.change :state, :integer
    end
  end
end