namespace :db do
  desc "Generates placeholder data in the database"
  task placeholders: :environment do

    def age_group
      ["0-3s", "Reception", "Primary", "4-6", "Secondary School", "Teenagers", "Middle School", "High School", "6th Form", "13-16", "7-11", "18+", "University"].sample
    end

    def create_church(args={})
      Church.create! args.reverse_merge name: "St #{Faker::Name.first_name} Church",
                                        address1: Faker::Address.street_address,
                                        address2: Faker::Address.secondary_address,
                                        postcode: Faker::Address.postcode,
                                        country: 'United Kingdom'
    end

    def create_user(args={})
      User.create! args.reverse_merge email: Faker::Internet.email,
                                      password: 'testtest0)',
                                      confirmed_at: Time.now
    end

    def create_person(args={})
      Person.create! args.reverse_merge first_name: Faker::Name.first_name,
                                        last_name: Faker::Name.last_name,
                                        middle_name: (Faker::Name.first_name if rand > 0.8),
                                        email: (Faker::Internet.email if rand > 0.5),
                                        dob: (Faker::Date.birthday if rand > 0.25),
                                        joined_at: (Date.current - rand(3000).days if rand > 0.1),
                                        created_at: Time.now - rand(30000).minutes,
                                        gender: %w(m f).sample
    end

    def create_family(args={})
      Family.create! args.reverse_merge name: Faker::Name.last_name,
                                        address1: Faker::Address.street_address,
                                        address2: Faker::Address.secondary_address,
                                        postcode: Faker::Address.postcode,
                                        country: 'United Kingdom'
    end

    def create_team(args={})
      Team.create! args.reverse_merge name: Faker::Company.catch_phrase,
                                      description: Faker::Lorem.paragraph,
                                      icon: Team::ICONS.sample,
                                      color: Team::COLORS.sample
    end

    def create_child_group(args={})
      ChildGroup.create! args.reverse_merge name: Faker::Company.catch_phrase,
                                            description: Faker::Lorem.paragraph,
                                            age_group: age_group
    end

    def create_process(args={})
      ChurchProcess.create! args.reverse_merge name: Faker::Company.catch_phrase,
                                               steps: (0..(1+rand(4))).map{ Faker::Company.bs },
                                               icon: ChurchProcess::ICONS.sample
    end

    # Prevent geocoding while creating fake addresses
    Geocoder.configure(:lookup => :test)

    church = create_church
    admin = create_person   user: create_user(email: 'test@example.com', password: 'test123'), email: 'test@example.com'
    admins = create_team    name: 'Admins', icon: 'star', admin: true
    admin.join admins

    child_groups = (1..20).to_a.map{ create_child_group }
    processes    = (1..20).to_a.map{ create_process }

    Property.create! name: 'Disabled',          icon: 'wheelchair', description: 'This person is disabled.'
    Property.create! name: 'Visually impaired', icon: 'low-vision', description: 'This person may need visual assistance.'
    Property.create! name: 'Hearing impaired',  icon: 'deaf',       description: 'This person may need hearing assistance.'
    Property.create! name: 'Medic',             icon: 'medkit',     description: 'This person is medically trained.'
    properties = Property.all

    people = (1..200).to_a.map{ create_person }
    families = (1..50).to_a.map{
      family = create_family
      adults = (0..rand(3)).to_a.map{ create_person(last_name: family.name).join(family, head: true) }
      children = (1..rand(4)).to_a.map{ create_person(last_name: family.name, dob: Faker::Date.birthday(0, 18) ).join(family) }
      children.sample&.join child_groups.sample
    }

    teams  = (1..40).to_a.map{ create_team }
    (50 + rand(150)).times{ people.sample.join  teams.sample }
    (50 + rand(50)).times{  people.sample.start processes.sample }
    (50 + rand(50)).times{  people.sample.property_joins.create property: properties.sample }

    puts "Done! Admin user is test@example.com : test123"
  end

end
