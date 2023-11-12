class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :specialization
      t.jsonb :working_days_summary

      t.timestamps
    end
  end
end
