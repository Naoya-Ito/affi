class ArticlesController < ApplicationController
  inherit_resources

  def index
    @articles = Article.active.recent.page(params[:page]).per(30).uniq
  end

  def all_articles
    @articles = Article.recent.page(params[:page]).per(30).uniq
    render :index
  end
  
  def create
    if params[:word].present?
      article = Article.new_post(nil, params[:word], false)
    else
      article = Article.new_post(params[:mode], nil, false)
    end
    redirect_to article_path(article), notice: '投稿完了しました'
  rescue => e
    redirect_to :back, flash: { error: "記事投稿に失敗しました。\n #{ e.message }" }
  end

  def post_hatena
    resource.upload_hatena
    redirect_to articles_path, notice: '投稿完了しました'
  rescue => e
    redirect_to :back, flash: { error: "記事投稿に失敗しました。\n #{ e.message }" }
  end

  def destroy
    destroy! do |format|
      format.js {render 'destroy'}
      format.html { redirect_to :back, notice: '削除完了しました' and return }
    end
  rescue => e
    redirect_to :back, flash: { error: "削除に失敗しました。\n #{ e.message }" }
  end

  # はてなの記事非公開
  def rm_hatena
    resource.rm_hatena_blog
    respond_to do |format|
      format.js {render 'rm_hatena'}
      format.html {redirect_to articles_path, notice: 'はてなの記事を削除しました'}
    end
  rescue => e
    redirect_to :back, flash: { error: "記事非公開に失敗しました。\n #{ e.message }" }
  end

  # 記事を公開せず deleted_at を設定する
  def rm_blog
    resource.rm_blog
    respond_to do |format|
      format.js {render 'rm_blog'}
      format.html {redirect_to articles_path, notice: 'delted_at を設定しました'}
    end
  rescue => e
    redirect_to :back, flash: { error: "削除に失敗しました。\n #{ e.message }" }
  end

end
