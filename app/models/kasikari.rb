# == Schema Information
#
# Table name: kasikaris
#
#  id           :integer          not null, primary key
#  item_id      :integer          not null
#  from_user_id :integer          not null
#  to_user_id   :integer          not null
#  start_date   :date             not null
#  end_date     :date             not null
#  done_flag    :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Kasikari < ApplicationRecord

  validates :item_id,      presence: true
  validates :from_user_id, presence: true
  validates :to_user_id,   presence: true
  validates :start_date,   presence: true
  validates :end_date,     presence: true

  default_scope -> { order(created_at: :desc) }

  def init
    self.done_flag  ||= false  # will set the default value only if it's nil
  end

  # 設計が良くない

  def item
    Item.find_by(id: self.item_id)
  end

  def from_user
    User.find_by(id: self.from_user_id)
  end

  def to_user
    User.find_by(id: self.to_user_id)
  end
end
