class Pixnet::UsersController < ::ResourcesController
  def index
    @users = Pixnet::User.all
  end

  private
  def collection_scope
    ::Pixnet::User.order(:id)
  end

  def object_params
    params.require(:pixnet_user).permit(:name, :account, :description, :keyword, :site_category)
  end
end
