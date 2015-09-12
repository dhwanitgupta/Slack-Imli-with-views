class MessagesFromUserController < ApplicationController
  
  before_action :logged_in_user

  def show
    
    @reciever_id = params[:id]
    @m1 = Message.where(:sender_id => current_user.id, :reciever_id => params[:id])
    @m2 = Message.where(:sender_id => params[:id], :reciever_id => current_user.id)
    
    @totalMessaage = @m1 + @m2
    @totalMessaage.sort!{ |a,b| a.created_at  <=> b.created_at }
    
  end
  
  def create
    
    message = Message.new
    message.reciever_id = params[:reciever_id]
    message.sender_id = params[:sender_id]
    message.content = params[:message][:content]
    message.save
    
    redirect_to messages_from_user_path(:id => message.reciever_id)
  end

end
