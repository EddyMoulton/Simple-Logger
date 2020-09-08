class AddTimestampToRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :records, :timestamp, :DateTime
  end
end
