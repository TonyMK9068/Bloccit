class PostsController < ApplicationController
  def index
    @posts = Post.all #returns an array of Post objects
  end

  def show
    @post = Post.find(params[:id]) #params hash variable that is populated with given argument
  end

  def new
    @post = Post.new
  end

  # Adding a create method to the posts_controller.rb
  #works behind the seems, passing on user input or displaying error 
  
  def create 
    @post = Post.new(params[:post])
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to @post
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end
  
    def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = "Post was updated."
      redirect_to @post
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :new
    end
  end
end
