module TopicsHelper
  
  def latest_post_for(topic)
    if topic.posts.present? 
      topic.posts.first
    end
  end

end
