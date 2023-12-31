class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorites_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.search_for(word, method)
    if method == 'perfect_match'
      Book.where(title: word)
    elsif method == 'forward_match'
      Book.where('title LIKE?', word + '%')
    elsif method == 'backward_match'
      Book.where('title LIKE?', '%' + word)
    else
      Book.where('title LIKE?', '%' + word + '%')
    end
  end

  # n日前（n=0なら今日）
  scope :created_days_ago, -> (n) { where(created_at: n.day.ago.all_day) }
  # 今週
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  # 先週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
end
