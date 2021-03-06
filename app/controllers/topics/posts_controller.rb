class Topics::PostsController < ApplicationController

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
    authorize! :new, Post, message: "You need to be a member to create a new post."
  end

  def create
    @user = current_user
    @topic = Topic.find(params[:topic_id])
    @post = @user.posts.build(params[:post])
    @post.topic = @topic

    authorize! :create, Post, message: "You need to be signed up to do that."
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def show
    @topic = Topic.find(params[:topic_id])
    authorize! :read, @topic, message: "You need to be signed-in to do that."
    @post = Post.find(params[:id])
    @a = Comment.new
    @comments = @post.comments.paginate(page: params[:page], per_page: 5)
  end

  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post, message: "You need to have created that post in order to edit it"
  end 

  def update
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
    authorize! :update, @post, message: "You need to own the post to edit it."
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post was updated."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the post. Please try again."
      redirect_to action :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
    title = @post.title
    authorize! :destroy, @post, message: "You need to own the post to delete it."
    if @post.delete
      flash[:notice] = "\"#{title}\" was deleted successfully."
      redirect_to @topic
    else
      flash[:error] = "There was an error deleting the post. Please try again."
      render :show
    end
  end
end