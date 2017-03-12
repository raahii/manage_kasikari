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

  validates :item_id,      presence: true
  validates :from_user_id, presence: true
  validates :to_user_id,   presence: true
  validates :start_date,   presence: true
  validates :end_date,     presence: true
  
  # 独自のバリデータ
  validate :valid_item, :valid_from_user, :valid_to_user
  validate :valid_term

  default_scope -> { order(updated_at: :desc) }

  def valid_item
    if item_id.nil?
      return
    elsif Item.find_by(id: item_id).nil?
      errors.add(:item_id, "アイテムは存在しません")
    elsif !from_user.items.include?(item)
      errors.add(:item_id, "貸し手はそのアイテムを持っていません")
    elsif !item.available
      errors.add(:item_id, "そのアイテムは既に他の人に借りられています")
    end
  end

  def valid_from_user
    if from_user_id.nil?
      return
    elsif User.find_by(id: from_user_id).nil?
      errors.add(:from_user_id, "貸し手のユーザーは存在しません")
    end
  end

  def valid_to_user
    if to_user_id.nil?
      return
    elsif User.find_by(id: to_user_id).nil?
      errors.add(:to_user_id, "借り手のユーザーが無効です")
    end
  end

  def valid_term
    return if start_date.nil? || end_date.nil?

    if start_date > end_date
      errors.add("無効な貸出期間:   ", "貸出日、返却日の組み合わせが無効です")
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
