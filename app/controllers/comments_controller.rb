class CommentsController < ApplicationController
  
  def new

  end

  def create
  @post = Post.find(params[:post_id])
  @comment = current_user.comments.build(params[:comment])
  @topic = Topic.find(params[:topic_id])
  @comment.post = @post
  
  authorize! :create, @comment, message: "You need to be signed up to do that."
    if @comment.save

      redirect_to [@topic, @post], notice: "Comment was saved successfully"
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      redirect_to [@topic, @post]
    
    end
  end

    def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    if @comment.destroy
      flash[:notice] = "Comment was removed."
      redirect_to [@topic, @post]
    else
      flash[:error] = "Comment couldn't be deleted. Try again."
      redirect_to [@topic, @post]
    end
  end

end