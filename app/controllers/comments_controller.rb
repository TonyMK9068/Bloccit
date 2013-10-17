class CommentsController < ApplicationController
  
  def new
    @post = posts.find(params[:post_id])
    @comment = Comment.new
  end

  def create
  @post = posts.find(params[:post_id])
  @topic = @post.topic
  @comment = current_user.comments.build(params[:comment])
    if @comment.save
      #flash[:notice] = "Comment was saved."
      redirect_to [@topic, @post]
    else
      #flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end
end