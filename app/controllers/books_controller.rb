class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user ,only: [:edit, :update]
  
  def show
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def index
    @books = Book.all
    @book =Book.new
    @user = current_user
    @users =User.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @user = current_user
    if @book.save
      redirect_to book_path(@book)
      flash[:notice]="You have created book successfully."
    else
      @books = Book.all
      render 'index'
      flash[:notice]="Failed to save"
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

  def delete
    @book = Book.find(params[:id])
    @book.destoy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def ensure_correct_user
    @book = Book.find_by(id:params[:id])
    if @book.user_id != current_user.id
      redirect_to("/books")
    end
  end
end
