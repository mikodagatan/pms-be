require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, reset_password_token: '123', confirmation_token: '123') }

  describe '#send_password_reset' do
    let(:mail) { UserMailer.send_password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('PMS - Reset your password')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@pms.com']) # Update with your sender email
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(user.reset_password_token)
    end
  end

  describe '#send_confirmation' do
    let(:mail) { UserMailer.send_confirmation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('PMS - Confirm email address')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@pms.com']) # Update with your sender email
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(user.confirmation_token)
    end
  end
end
