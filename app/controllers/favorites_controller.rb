class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    current_user.favorites.create(book_id: @book.id)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    current_user.favorites.find_by(book_id: @book.id).destroy
    respond_to do |format|
      format.js
    end
  end
end