class FirstPersonJob < ApplicationJob
  queue_as :default

  def perform(person)
    unless Church.exists?
      Church.create name: "My church"
    end

    unless Property.exists?
      Property.create name: 'Disabled',          icon: 'wheelchair', description: 'This person is disabled.'
      Property.create name: 'Visually impaired', icon: 'low-vision', description: 'This person may need visual assistance.'
      Property.create name: 'Hearing impaired',  icon: 'deaf',       description: 'This person may need hearing assistance.'
      Property.create name: 'Medic',             icon: 'medkit',     description: 'This person is medically trained.'
    end

    unless Team.where(admin: true).exists?
      team = Team.create name: "Admins",
                         admin: true,
                         icon: 'star',
                         color: 'eccf0f',
                         description: "The admins team grants full site and database access to all of its members.\n\nPlease do not make everyone an admin!"
      person.join team
    end
  end
end
