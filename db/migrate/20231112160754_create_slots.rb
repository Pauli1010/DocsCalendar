class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.references :doctor, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.date :slot_date
      t.datetime :start_time
      t.datetime :end_time
      t.string :occupancy, default: 'open'

      t.timestamps
    end
  end
end
