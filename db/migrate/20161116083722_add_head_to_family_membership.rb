class AddHeadToFamilyMembership < ActiveRecord::Migration[5.0]
  def change
    add_column :family_memberships, :head, :boolean
  end
end
