class FirstPersonJob < ApplicationJob
  queue_as :default

  def perform(person)
    unless Team.exists?
      Church.create name: "My church" unless Church.exists?

      team = Team.create name: "Admins", admin: true, icon: 'star', color: 'eccf0f',
                         description: "The admins team grants full site and database access to all of its members.\n\nPlease do not make everyone an admin!"
      person.join team
    end
  end
end
