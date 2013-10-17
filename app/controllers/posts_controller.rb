class PostsController < ApplicationController

  def show
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
    @comments = @post.comments.paginate(page: params[:page], per_page: 5)
    @a = Comment.new
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
    authorize! :create, Post, message: "You need to be a member to create a new post."
  end

  # Adding a create method to the posts_controller.rb
  # works behind the seems, passing on user input or displaying error 
  def edit
    @post = Post.find(params[:id])
    authorize! :edit, @post, message: "You need to have created that post in order to edit it"
  end 


  def create 
    @topic = Topic.find(params[:topic_id])
    @post = current_user.posts.build(params[:post])
    @post.topic = @topic
    authorize! :create, @post, message: "You need to be signed up to do that."
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
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
      render :edit
    end
  end
end