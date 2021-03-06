module PostsHelper
  def has_children?(comment)
    @comment_hash.any? { |k, _| k == comment.id }
  end

  def display_children_comments(comment)
    a=""
     a += <<-HTML
      <li class="clearfix">

        <div class="vote_container clearfix">
        <form action="#{ upvote_comment_url(comment) }" method="post">
          #{form_auth}
          <button>^</button>
        </form>
        <p>#{comment.score}</p>
        <form action="#{ downvote_comment_url(comment) }" method="post">
          #{form_auth}
          <button>v</button>
        </form>
        </div>
        <h5><a href="#{user_url(comment.author)}">#{comment.author.username}</a> @ #{comment.created_at.to_s(:long)}:</h5>
        <p>#{comment.content}</p>

        <p class="reply_link"><a href="#{comment_url(comment)}">reply</a></p>

      </li>
    HTML
    if has_children?(comment)
      a += "<ul>"
      @comment_hash[comment.id].each do |c2|
        a += "#{display_children_comments(c2)}"
      end
      a += "</ul>"
    end
    return a.html_safe
  end
end
