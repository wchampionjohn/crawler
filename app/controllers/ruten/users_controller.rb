class Ruten::UsersController < ::ResourcesController

  def fetch_products
    flash[:notice] = '程式背景執行中'
    current_object.fetch_products
    redirect_to url_after_update
  end

  def sync
    @current_object = Ruten::User.find_or_initialize_by({ account: params[:account] })

    begin
      @current_object.fetch_base_info
      @current_object.save!
    rescue Net::HTTPServerException => e
      logger.error e
      flash.now[:error] = '不存在的露天帳號'
      render :new
    else
      flash[:success] = '同步完成'
      redirect_to edit_ruten_user_path(@current_object.id)
    end
  end

  private
  def collection_scope
    ::Ruten::User.order(:id)
  end

  def object_params
    params.require(:ruten_user).permit(:account, :memo)
  end
end
