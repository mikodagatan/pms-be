require 'rails_helper'

RSpec.describe Comments::CreateService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }

  describe '#call' do
    let(:service) { Comments::CreateService.new(user, params) }
    context 'when valid' do
      let(:params) { { resource_id: card.id, resource_type: card.class.to_s, content: 'new comment' } }

      it 'creates a comment' do
        expect { service.call }.to change(Comment, :count).by(1)
      end

      it 'broadcasts the change' do
        expect do
          service.call
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)
      end
    end

    context 'when other users are mentioned' do
      let!(:user2) { create(:user) }
      let(:params) do
        { resource_id: card.id, resource_type: card.class.to_s,
          content: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>" }
      end
      it 'sends email to other users' do
        expect(MentionMailer).to receive(:send_mention).and_return(double(deliver_later: true)).once
        service.call
      end
    end

    context 'when no resource' do
      let(:params) { { content: 'new content' } }

      it 'returns an error' do
        service.call
        expect(service.errors).to eq({ error: 'Validation failed: Resource must exist',
                                       resource: ['must exist'] })
      end
    end
  end
end
