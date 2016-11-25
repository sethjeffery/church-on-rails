module PermissionsHelper
  def has_comments_area?(resource)
    return false unless resource.respond_to?(:comments)
    return false unless can?(:read, Comment)
    resource.comments.present? || can?(:create, Comment)
  end
end
