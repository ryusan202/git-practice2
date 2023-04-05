class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update,:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end
  
  def edit
     @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
      
    end
  end
  
     def looks(search, word)
       
    if search == "perfect_match"
      where("name LIKE ?", "#{word}")
    elsif search == "forward_match"
      where("name LIKE ?", "#{word}%")
    elsif search == "backward_match"
      where("name LIKE ?", "%#{word}")
    elsif search == "partial_match"
      where("name LIKE ?", "%#{word}%")
    else
      all
    end
 　 end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
