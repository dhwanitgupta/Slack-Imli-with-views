class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update,  :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
  def correct_user
    unless current_user?(User.find(params[:id]))
      flash[:danger] = "Cannot edit other user information"
      redirect_to root_url
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:success] = "Successfully deleted user"
    redirect_to users_url
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @users = User.all
    if !@user.activated?
      flash[:info] = "Please activate account first"
      redirect_to root_url
    end
  end
  
  def create
    @user = User.new(user_params)
    @user.activated =  true;
    @user.activated_at =  Time.zone.now;
    if @user.save
      #@user.send_activation_email
      flash[:info] = "Please check your email to activate your account. Activated :) no worries"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your detail edited sucessfully"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  private

   def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end
    
    def admin_user
      redirect_to root_url unless current_user.admin?  
    end
end
