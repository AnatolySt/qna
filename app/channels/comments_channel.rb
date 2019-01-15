class CommentsChannel < ApplicationCable::Channel
  def follow_comments(data)
    stream_from "comments-for-#{data['id']}"
  end

  def unfollow
    stop_all_streams
  end
end