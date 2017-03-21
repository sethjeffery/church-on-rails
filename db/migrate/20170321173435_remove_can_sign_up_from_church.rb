class RemoveCanSignUpFromChurch < ActiveRecord::Migration[5.0]
  def change
    remove_column :churches, :can_sign_up, :boolean
  end
end
