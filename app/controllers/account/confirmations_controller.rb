class Account::ConfirmationsController < Devise::ConfirmationsController
  def resend
    current_user.resend_confirmation_instructions
  end

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource) unless signed_in?(resource_name)
    if resource.person.present?
      root_path
    else
      new_account_person_path
    end
   end
end
