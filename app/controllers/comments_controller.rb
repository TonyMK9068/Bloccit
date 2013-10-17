class CommentsController < ApplicationController
  
  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:post_id])
    @comment = Comment.new
  end

  def create
  @topic = Topic.find(params[:topic_id])
  @post = Post.find(params[:post_id])
  @comment = current_user.comments.build(params[:comment])
  @comment.update_attribute(:post, @post)
    if @comment.save
      flash[:notice] = "Comment was saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the post. Please try again."
      redirect_to [@topic, @post]
    
    end
  end
end