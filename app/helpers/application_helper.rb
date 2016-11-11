module ApplicationHelper
  def show_button path
    link_to '檢視', path, class: 'btn btn-xs btn-primary' if params[:action] != 'show'
  end

  def edit_button path
    link_to '編輯', path, class: 'btn btn-xs btn-success' if params[:action] != 'edit'
  end

  def delete_button path
    link_to '刪除', path, {
      method: :delete,
      class: 'btn btn-xs btn-danger',
      data: { confirm: '關聯資料也會一併刪除，確定嗎？' }
    }
  end

  def fetch_button path
    link_to '重抓資料', path, class: 'btn btn-xs btn-warning', method: :put
  end

  def origin_button path
    link_to '原始網址', path, class: 'btn btn-xs btn-default', target: '_blank'
  end

  def submit_button form
    form.button :submit, '送出', class: 'btn btn-md btn-success'
  end

  def no_data_alert
    content_tag :div, '尚無資料', class: 'alert alert-warning'
  end

  def local_time timestamp
    timestamp.in_time_zone('Taipei').strftime('%Y-%m-%d %H:%M:%S')
  end
end
