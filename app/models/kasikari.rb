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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :integer          default("applying")
#  flag         :integer          default("unread")
#

class Kasikari < ApplicationRecord
  enum status: { 
    applying: 0,
    ongoing:  1,
    denied:   2,
    done:     3,
  }
  enum flag: { 
    unread: 0,
    read:  1,
  }

  validates :item_id,      presence: true, allow_nil: true
  validates :from_user_id, presence: true, allow_nil: true
  validates :to_user_id,   presence: true, allow_nil: true
  validates :start_date,   presence: true
  validates :end_date,     presence: true
  
  # 独自のバリデータ
  validate :exist_item?, :exist_from_user?, :exist_to_user?
  validate :valid_item?

  default_scope -> { order(created_at: :desc) }

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

  def valid_item?
    if !from_user.items.include?(item)
      errors.add(:item_id, "貸し手はそのアイテムを持っていません")
    elsif !item.available
      errors.add(:item_id, "そのアイテムは既に他の人に借りられています")
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
