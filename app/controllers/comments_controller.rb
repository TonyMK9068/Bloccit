class CommentsController < ApplicationController
  
  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    authorize! :new, Comment, message: "You need to be signed up to do that."
  end

  def create
  @topic = Topic.find(params[:topic_id])
  @post = Post.find(params[:post_id])
  @comment = current_user.comments.build(params[:comment])
  @comment.update_attribute(:post, @post)
  authorize! :new, Comment, message: "You need to be signed up to do that."
    if @comment.save

      redirect_to [@topic, @post], notice: "Comment was saved successfully"
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    
    end
  end
end