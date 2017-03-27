class Message < ApplicationRecord
  belongs_to :sender, class_name: 'Person'
  has_many :message_recipients
  has_many :recipients, through: :message_recipients, class_name: 'Person'

  attr_accessor :send_to, :person_ids, :team_id, :email, :sms

  validates_presence_of :subject, :message, :sender_id
  validates_presence_of :person_ids, if: :send_to_people?
  validates_presence_of :team_id, if: :send_to_team?
  before_validation :compact_person_ids

  after_create :send!

  def send_to_people?
    send_to&.to_sym == :people
  end

  def send_to_team?
    send_to&.to_sym == :team
  end

  def send!
    send_to_people! if send_to_people?
    send_to_team! if send_to_team?
  end

  def people
    @people ||= Person.where(id: person_ids).all
  end

  def team
    @team ||= Team.find_by(id: team_id)
  end

  def build_reply(args={})
    Message.new({ person_ids: [sender_id],
                  message: "\n\n" + message.split("\n").map{|line| "> #{line}"}.join("\n"),
                  send_to: :people,
                  subject: "Re: #{subject}",
                  email: true,
                  sms: true }.merge(args))
  end

  def build_forward(args={})
    build_reply({ person_ids: [],
                  subject: "Fw: #{subject}" }.merge(args))
  end

  def self.reply_to(message, args={})
    message.build_reply(args)
  end

  def self.forward(message, args={})
    message.build_forward(args)
  end

  private

  def compact_person_ids
    self.person_ids&.select!(&:present?)
    true
  end

  def send_to_people!
    Person.find(person_ids).each do |person|
      unless message_recipients.find_by(recipient_id: person.id)
        message_recipients.create! recipient: person, email: email, sms: sms
      end
    end
  end

  def send_to_team!
    Team.find(team_id).people.each do |person|
      unless message_recipients.find_by(recipient_id: person.id)
        message_recipients.create! recipient: person,
                                   email: self.email && person.email.present?,
                                   sms: self.sms && person.phone.present?
      end
    end
  end
end
