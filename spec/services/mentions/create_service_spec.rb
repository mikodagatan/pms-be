require 'rails_helper'

RSpec.describe Mentions::CreateService do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:card) { create(:card) }

  describe '#call' do
    let(:service) { Mentions::CreateService.new(user, card, user2) }
    context 'when valid' do
      it 'creates a mention' do
        expect { service.call }.to change(Mention, :count).by(1)
      end

      it 'sends an email to the mentioned' do
        expect(MentionMailer).to receive(:send_mention).and_return(double(deliver_later: true)).once

        service.call
      end
    end

    context 'when duplicated' do
      let!(:mention) { create(:mention, resource: card, commenter: user, mentioned: user2) }

      it 'does not create a mention' do
        expect { service.call }.to change(Mention, :count).by(0)
      end
    end

    context 'when mention already sent' do
      let!(:mention) do
        create(:mention, resource: card, commenter: user, mentioned: user2, email_sent_at: DateTime.current)
      end

      it 'does not send an email' do
        expect(MentionMailer).not_to receive(:send_mention)

        service.call
      end
    end
  end
end
