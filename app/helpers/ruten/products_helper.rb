module Ruten::ProductsHelper
  def ruten_user_link(user)
    if controller_name == 'users'
      user.name
    else
      link_to user.name, pixnet_user_path(user)
    end
  end


  def ruten_products_breadcrumb user_id
    if user_id.present?
      breadcrumb('露天拍賣', link_to("商品管理", ruten_products_path), current_collection.take.user.account)
    else
      breadcrumb('露天拍賣', '商品管理')
    end
  end
end
