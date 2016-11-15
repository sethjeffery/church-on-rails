class Users::ConfirmationsController < Devise::ConfirmationsController
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      sign_in(resource) # auto-login after confirmation
      new_session_path(resource_name)
    end
   end
end
