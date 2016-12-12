class Pixnet::ArticlesController < ::ResourcesController

  def fetch_remote
    current_object.fetch_article_data
    flash[:notice] = '程式背景執行中'
    redirect_to url_after_update
  end

  private
  def collection_scope
    if params[:user_id]
      @current_pixnet_user ||= ::Pixnet::User.find(params[:user_id])
      @current_pixnet_user.articles
    else
      ::Pixnet::Article.order(:id)
    end
  end

  def object_params
    params.require(:pixnet_article).permit(:title, :content)
  end

end
