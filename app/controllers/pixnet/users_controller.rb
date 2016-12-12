class Pixnet::UsersController < ::ResourcesController
  def index
    @users = Pixnet::User.all
  end

  def fetch_articles
    flash[:notice] = '程式背景執行中'
    current_object.fetch_articles
    redirect_to url_after_update
  end

  def sync
    user = Pixnet::User.find_or_initialize_by({ account: params[:account] })

    begin
      user.save!
    rescue OpenURI::HTTPError => e
      logger.error e
      flash[:error] = '同步失敗'
    rescue ActiveRecord::RecordInvalid => e
      logger.error e.message
      flash[:error] = '儲存失敗'
    else
      flash[:success] = '同步完成'
    end

    redirect_to edit_pixnet_user_path(user.id)
  end

  private
  def collection_scope
    ::Pixnet::User.order(:id)
  end

  def object_params
    params.require(:pixnet_user).permit(:name, :account, :description, :keyword, :site_category)
  end
end
