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
#

class Item < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
end
