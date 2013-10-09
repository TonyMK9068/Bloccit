class TopicsController < ApplicationController
  def index
    @topics = Topic.all
  end

  def new
    @topic = Topic.new
    authorize! :create, @topic, message: "You need to be an admin to do that."
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts
  end

  def edit
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to have created that topic in order to edit it"
  end

  def create
    @topic = Topic.new(params[:topic])
    !authorize! :create, @topic, message: "You need to be a member to create a new topic."
    if @topic.save
    redirect_to @topic, notice: "Topic was saved successfully."
    else
      flash[:error] = "There was an error saving the topic. Please try again."
      render :new
    end
  end

  def update
    @topic = Topic.find(params[:id])
    authorize! :update, @topic, message: "You need to own the topic to edit it."
    if @topic.update_attributes(params[:topic])
      redirect_to @topic, notice: "Topic was updated successfully."
    else
      flash[:error] = "There was an error updating the topic. Please try again."
      render :edit
    end
  end
end
