require 'rails_helper'

RSpec.describe MailHelper do
  describe 'mail_from' do
    context 'when church is present' do
      context 'with email' do
        before { create(:church, email: 'test@example.com') }

        it 'is the church email' do
          expect(mail_from).to eq 'test@example.com'
        end
      end

      context 'without email' do
        before { create(:church, email: '') }

        it 'is a default email' do
          expect(mail_from).to eq 'no-reply@example.com'
        end
      end
    end

    context 'when church is not present' do
      it 'is a default email' do
        expect(mail_from).to eq 'no-reply@example.com'
      end
    end
  end
end
