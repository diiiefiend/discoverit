json.extract! post, :id, :title, :url, :content, :last_activity_stamp

if !json.last_activity_stamp.nil?
  json.last_activity_stamp.to_formatted_s(:long_ordinal)
end

json.score post.score
json.created_at post.created_at.to_formatted_s(:long)

json.comment_count post.comments.length

json.author do
  json.id post.author.id
  json.username post.author.username
end

json.subs post.subs.order(last_activity_stamp: :desc) do |subreddit|
  json.partial! 'api/subs/sub', sub: subreddit
end
