class AddUserMessageToSlot < ActiveRecord::Migration[7.1]
  def change
    add_column :slots, :user_message, :text
    change_column_default :slots, :occupancy, 'open'
  end
end
