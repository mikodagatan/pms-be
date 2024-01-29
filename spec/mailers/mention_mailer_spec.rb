require 'rails_helper'

RSpec.describe MentionMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:card) { create(:card) }
  let(:mention) { create(:mention, mentioned: user, resource: card) }

  describe '#send_mention' do
    let(:mail) { MentionMailer.send_mention(mention) }

    it 'renders the headers' do
      expect(mail.subject).to include('PMS - Mentioned in')
      expect(mail.to).to eq([mention.mentioned.email])
      expect(mail.from).to eq(['from@pms.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(mention.resource.project.code)
    end
  end

  describe '#send_assignment' do
    let(:mail) { MentionMailer.send_assignment(mention) }

    it 'renders the headers' do
      expect(mail.subject).to include('PMS - Assigned to')
      expect(mail.to).to eq([mention.mentioned.email])
      expect(mail.from).to eq(['from@pms.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(mention.resource.project.code)
    end
  end
end
