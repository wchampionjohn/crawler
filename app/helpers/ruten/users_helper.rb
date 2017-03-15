module Ruten::UsersHelper

  def ruten_origin_button path
    link_to '賣場首頁', path, class: 'btn btn-xs btn-default', target: '_blank'
  end

  def formated_point user
    if !user.new_record? && user.good_point.present?
      "#{user.total_point}(總) #{user.good_point}(優良) #{user.soso_point}(普通) #{user.bad_point}(差) #{user.point_percent}(好評比)"
    else
      '未同步'
    end
  end

  def render_office_products_count user
    if user.office_products_count.nil?
      '未同步'
    else
      user.office_products_count.to_i
    end
  end

  def total_point_for_index user
    unless user.total_point.nil?
      link_to(user.total_point.to_i, user.credit_url, target: '_blank')
    end
  end

end
