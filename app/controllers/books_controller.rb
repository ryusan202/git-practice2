class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    unless ReadCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.read_counts.create(book_id: @book.id)
    end
  end

  def index
    @books = Book.all
  to = Time.current.at_end_of_day
  from = (to - 6.day).at_beginning_of_day
  @books = Book.includes(:favorited_users).
    sort_by {|x|
      x.favorited_users.includes(:favorites).where(created_at: from...to).size
    }.reverse
  @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      @book_comment = BookComment.new
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  
def looks(search, word)
    if search == "perfect_match"
      where("title LIKE ?", "#{word}")
    elsif search == "forward_match"
      where("title LIKE ?", "#{word}%")
    elsif search == "backward_match"
      where("title LIKE ?", "%#{word}")
    elsif search == "partial_match"
      where("title LIKE ?", "%#{word}%")
    else
      all
    end
end
  

  private
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end
  
  def book_params
    params.require(:book).permit(:title,:body)
  end
end