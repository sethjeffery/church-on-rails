module ApplicationHelper
  def side_menu?
    user_signed_in?
  end
end
