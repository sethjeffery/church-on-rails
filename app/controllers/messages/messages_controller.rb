class Messages::MessagesController < ApplicationController
  load_and_authorize_resource only: [:new, :create]

  def index
    @messages = MessageRecipient.joins(message: :sender).where(recipient_id: current_person.id)
    @messages = @messages.page(params[:page]).per(PAGE_SIZE)
  end

  def new
    @message.send_to = :people
    @message.email = true
    @message.sms = true
  end

  def show
    @message = find_message
    authorize! :read, @message
  end

  def reply
    @message = find_message.message.build_reply
  end

  def forward
    @message = find_message.message.build_forward
  end

  def create
    @message.sender = current_person
    if @message.update_attributes(create_params)
      redirect_to messages_path, notice: 'Message sent successfully!'
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:message).permit(:send_to, :email, :sms, :team_id, :person_ids, :subject, :message, person_ids: [])
  end

  def find_message(id=nil)
    id ||= params[:id]
    MessageRecipient
      .joins(message: :sender)
      .includes(message: :sender)
      .where(recipient_id: current_person.id, message_id: id)
      .first
  end
end
