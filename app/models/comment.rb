class Comment < ActiveRecord::Base
  validates :content, :user_id, :post_id, presence: true
  after_save :set_stamp

  belongs_to :author,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :child_comments,
    class_name: "Comment",
    foreign_key: :parent_comment_id,
    primary_key: :id,
    dependent: :destroy

  belongs_to :post
  has_many :votes, as: :votable, dependent: :destroy

  def score
    score = 0
    self.votes.each do |vote|
      score += vote.value
    end

    score
  end

  def set_stamp
    self.post.update(last_activity_stamp: self.updated_at)
  end
end
