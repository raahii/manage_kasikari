# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  image           :string(255)
#

class User < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :items, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower


  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # ユーザー自身と友達に関わる貸し借りのデータを全部取ってくる
  def timeline_kasikaris
    following_ids = "SELECT followed_id FROM relationships " <<
                    "WHERE follower_id = :user_id"
    to = Kasikari.where("(to_user_id IN (#{following_ids})
                           OR to_user_id = :user_id) AND status = 1", user_id: id)
    from = Kasikari.where("(from_user_id IN (#{following_ids})
                           OR from_user_id = :user_id) AND status = 1", user_id: id)

    to | from
  end
  
  # そのユーザーが貸した物一覧
  def kasis
    Kasikari.where("from_user_id = #{id}").ongoing
  end

  # そのユーザーが借りた物一覧
  def karis
    Kasikari.where("to_user_id = #{id}").ongoing
  end

  # TODO: ちゃんとSQLで書く
  def kasikaris
    self.kasis | self.karis
  end
  
  # 自分と相手(user)間の貸し借りの総数
  def involve_count(user)
    Kasikari.where(from_user_id: self, to_user_id: user)
      .or(Kasikari.where(from_user_id: user, to_user_id: self))
      .ongoing.count
  end

  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # ユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  # ユーザーがフォローされていたらtrueを返す
  def followed?(other_user)
    followers.include?(other_user)
  end
  
  # 相互フォローサれていたらtrueをかえす
  def friend_with?(other_user)
    following?(other_user) && followed?(other_user)
  end
  
  # TODO: ちゃんとSQLで書く
  def friends
    (following & followers).sort{|a,b| involve_count(a) <=> involve_count(b)}.reverse
  end

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
