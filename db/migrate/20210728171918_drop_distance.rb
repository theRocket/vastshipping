class DropDistance < ActiveRecord::Migration[6.0]
  def change
    drop_table :distances
  end
end
