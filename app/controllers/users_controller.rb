class UsersController < ApplicationController
	before_action :set_user, only:[:edit, :update, :show, :destroy]
	before_action :required_same_user, only:[:edit, :update, :destroy]

  def index
		@users = User.paginate(page: params[:page], per_page: 4)
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 4)
  end

  def new
    @user = User.new
	end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username}!"
			redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
		if @user.update(user_params)
			flash[:notice] = "User info updated!"
			redirect_to user_path(@user)
		else
			render 'edit'
		end
	end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:notice] = "Account and articles associated succesfully deleted"
		redirect_to root_path
  end


  private

  def user_params
		params.require(:user).permit(:username, :email, :password)
	end

  def set_user
		@user = User.find(params[:id])
  end

	def required_same_user
		if current_user != @user && !current_user.admin?
			flash[:alert] = "Access forbidden"
      redirect_to root_path
		end
	end
end