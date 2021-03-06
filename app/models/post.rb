class Post < ActiveRecord::Base
  validates :title, :user_id, presence: true
  after_save :set_stamp

  belongs_to :author,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :post_subs, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  has_many :subs,
  through: :post_subs,
  source: :sub,
  dependent: :destroy

  def comments_by_parent_id
    comment_hash = Hash.new { |h, k| h[k] = [] }
    self.comments.order(updated_at: :desc).each do |comment|
      comment_hash[comment.parent_comment_id] << comment
    end

    comment_hash
  end

  def score
    score = 0
    self.votes.each do |vote|
      score += vote.value
    end

    score
  end

  def set_stamp
    self.update_columns(last_activity_stamp: self.updated_at)   #skip the callback
    self.subs.each do |sub|
      sub.update(last_activity_stamp: self.updated_at)
    end
  end

end
