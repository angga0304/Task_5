class ArticlesController < ApplicationController
#  include ActionView::Helpers::UrlHelper
  def index
    @articles = Article.order(:id).page params[:page]
  end
  def show
    @article = Article.find_by_id(params[:id])
  end

  def export
    @article = Article.find_by_id(params[:id])

    if @article.to_xls
      flash[:notice] ="Your file is ready"
      redirect_to article_url(@article.id)
    else
      flash[:error] ="Error"
      redirect_to article_url(params[:id])
    end
  end

  def pdf
    @article = Article.find_by_id(params[:id])

    if @article.to_pdf
      flash[:notice] ="Your file is ready"
      redirect_to article_url(@article.id)
    else
      flash[:error] ="Error"
      redirect_to article_url(params[:id])
    end
  end

  def to_import
    debugger
    Article.import(params[:file])
    redirect_to action: 'index'
  end

  def new
    @article = Article.new
  end
  def create
    @article = Article.new(params_article)
    if @article.save
      flash[:notice] = "Success Add Records"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'new'
    end
  end

  def edit
    @article = Article.find_by_id(params[:id])
  end

  def update
    @article = Article.find_by_id(params[:id])
    if @article.update(params_article)
      flash[:notice] = "Success Update Record"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'edit'
    end
  end

  def destroy
    @article = Article.find_by_id(params[:id])
    if @article.destroy
      flash[:notice] ="Success Delete Data"
      redirect_to action: 'index'
    else
      flash[:error] = "fails delete a records"
      redirect_to action: 'index'
    end
  end

  private
    def params_article
      params.require(:article).permit(:title, :content,:photo)
    end
end
