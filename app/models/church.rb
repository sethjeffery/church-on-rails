class Church < ApplicationRecord
  include Concerns::Geocoding

  has_attached_file :cover, styles: { md: "1200x600#" }, default_style: :md

  validates_presence_of :name
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  def to_s
    name
  end
end
