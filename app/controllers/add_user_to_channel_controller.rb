class AddUserToChannelController < ApplicationController

  before_action :logged_in_user

  def new 
    @channel = Channel.find(params[:id])
  end
  
  def create
    @user = User.find_by(email: params[:user][:email])
    @channel = Channel.find(params[:channel_id])
    @channel.users << @user
    @channel.save
    
    redirect_to @channel
  end
end
