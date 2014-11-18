class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end
  def show
    @comment = Comment.find_by_id(params[:id])
  end

  def new
    @comment = Comment.new
  end
  def create
    @comment = Comment.new(params_comment)
    if @comment.save

      flash[:notice] = "Comment Saved"
      redirect_to article_url(@comment.article_id)
    else
      flash[:error] = "data not valid"
      render 'new'
    end
  end

  def edit
    @comment = Comment.find_by_id(params[:id])
    if @comment.update(params_comment)
      flash[:notice] = "Comment updated"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'edit'
    end
  end

private
  def params_comment
    params.require(:comment).permit(:article_id,:content)
  end
end
