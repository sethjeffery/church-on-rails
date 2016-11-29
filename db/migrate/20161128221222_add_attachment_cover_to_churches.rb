class AddAttachmentCoverToChurches < ActiveRecord::Migration
  def self.up
    change_table :churches do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :churches, :cover
  end
end
