# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  explanation :text(65535)
#  image       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  available   :boolean          default(TRUE)
#

class Item < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: { maximum: 255 }

  default_scope -> { order(created_at: :desc) }

  def owner
    User.find(user_id)
  end
end
