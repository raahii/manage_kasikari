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

  validates :item_id,      presence: true, allow_nil: true
  validates :from_user_id, presence: true, allow_nil: true
  validates :to_user_id,   presence: true, allow_nil: true
  validates :start_date,   presence: true
  validates :end_date,     presence: true
  validate :exist_item?, :exist_from_user?, :exist_to_user?

  default_scope -> { order(created_at: :desc) }

  def init
    self.done_flag  ||= false  # will set the default value only if it's nil
  end

  def exist_item?
    if Item.find_by(id: item_id).nil?
      errors.add(:item_id, "無効なアイテムです")
    end
  end

  def exist_from_user?
    if User.find_by(id: from_user_id).nil?
      errors.add(:from_user_id, "貸し手のユーザーが無効です")
    end
  end

  def exist_to_user?
    if User.find_by(id: to_user_id).nil?
      errors.add(:to_user_id, "借り手のユーザーが無効です")
    end
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
