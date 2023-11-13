class AddSorceryFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :login_token, :string
    add_column :users, :login_token_valid_until, :datetime
    add_column :users, :admin, :boolean, default: false
  end
end
