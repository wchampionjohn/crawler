class Ruten::ProductsController < ::ResourcesController

  def fetch_remote
    current_object.fetch_remote_data!
    flash[:success] = '更新完成'
    redirect_to url_after_update
  end

  private
  def collection_scope
    if params[:user_id]
      ::Ruten::User.find(params[:user_id]).products
    else
      ::Ruten::Product.order(:id)
    end
  end

  def object_params
    params.require(:pixnet_article).permit(:title, :content)
  end
end
