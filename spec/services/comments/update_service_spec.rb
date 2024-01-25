require 'rails_helper'

RSpec.describe Comments::UpdateService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:comment) { create(:comment, resource: card) }

  describe '#call' do
    let(:service) { Comments::UpdateService.new(user, comment, params) }

    context 'when valid' do
      let(:params) { { content: 'New comment' } }

      it 'updates the comment' do
        service.call
        comment.reload
        expect(comment.content).to eq('New comment')
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
        { content: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>" }
      end

      it 'sends email to other users' do
        expect(MentionMailer).to receive(:send_mention).and_return(double(deliver_later: true)).once
        service.call
      end
    end
  end
end
