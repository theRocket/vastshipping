class CreateDistances < ActiveRecord::Migration[6.0]
  def change
    create_table :distances do |t|
      t.bigint :from_port, foreign_key: true
      t.bigint :to_port, foreign_key: true
      t.float :kilometers

      t.timestamps
    end
  end
end
