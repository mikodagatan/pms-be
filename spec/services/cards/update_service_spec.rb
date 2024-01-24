require 'rails_helper'

RSpec.describe Cards::UpdateService do
  let!(:user) { create(:user) }
  let(:card) { create(:card) }

  describe '#call' do
    let(:service) { Cards::UpdateService.new(user, params) }

    context 'when card attributes are updated' do
      let(:params) do
        { id: card.id, name: 'new card name', description: 'new card description', estimate: '1.0', requester: user }
      end

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'updates the card' do
        service.call
        card.reload

        expect(card.name).to eq('new card name')
        expect(card.description).to eq('new card description')
        expect(card.estimate).to eq(1.0)
        expect(card.requester).to eq(user)
      end
    end

    context 'when description is changed' do
      context 'when another user is mentioned' do
        let!(:user2) { create(:user) }
        let(:params) do
          {
            id: card.id, description: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>"
          }
        end

        it 'creates a mention record' do
          expect { service.call }.to change(Mention, :count).by(1)
        end

        it 'sends a mention email' do
          expect(MentionMailer).to receive(:send_mention).and_return(double(deliver_later: true))
          service.call
        end
      end

      context 'when another user and current user are mentioned' do
        let!(:user2) { create(:user) }
        let(:params) do
          {
            id: card.id, description: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>"
          }
        end

        it 'creates one mention record' do
          expect { service.call }.to change(Mention, :count).by(1)
        end

        it 'sends one mention email' do
          expect(MentionMailer).to receive(:send_mention).and_return(double(deliver_later: true)).once
          service.call
        end
      end
    end

    context 'when card assignees are included' do
      let(:user2) { create(:user) }
      let(:params) do
        { id: card.id, assignee_ids: [user.id, user2.id] }
      end

      it 'assigns the users as the card assignees' do
        service.call

        expect(card.reload.assignees).to include(user, user2)
      end

      it 'sends an email to non-current user assignees' do
        expect(MentionMailer).to receive(:send_assignment).and_return(double(deliver_later: true)).once
        service.call
      end
    end
  end
end
