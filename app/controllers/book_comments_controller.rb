class BookCommentsController < ApplicationController
  before_action :set_book, only: [:create, :destroy, :get_comments]

  def create
    @book_comment = @book.book_comments.build(book_comment_params)
    @book_comment.user = current_user

    if @book_comment.save
      respond_to do |format|
        format.html { redirect_to @book }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'books/show' }
        format.js { render :create_failed }
      end
    end
  end

  def destroy
    @book_comment = @book.book_comments.find(params[:id])
    @book_comment.destroy
    respond_to do |format|
      format.html { redirect_to @book }
      format.js
    end
  end

  def get_comments
    @comments = @book.book_comments
    respond_to do |format|
      format.json { render json: @comments }
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
