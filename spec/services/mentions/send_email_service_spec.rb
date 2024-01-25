require 'rails_helper'

RSpec.describe Mentions::MentionUsersService do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:card) do
    create(:card,
           description: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>",
           assignees: [user, user2])
  end
  let(:comment) do
    create(:comment,
           content: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>")
  end
  let(:mention_with_card) { create(:mention, resource: card) }
  let(:mention_with_comment) { create(:mention, resource: comment) }
  let(:mention_with_assignee) { create(:mention, resource: card.card_assignees.last) }

  describe '#call' do
    context 'when resource is Card' do
      let(:service) { Mentions::SendEmailService.new(mention_with_card) }

      it 'sends mention' do
        expect(MentionMailer).to receive(:send_mention).and_return(double(deliver_later: true))
        service.call
      end
    end

    context 'when resource is comment' do
      let(:service) { Mentions::SendEmailService.new(mention_with_comment) }

      it 'sends mention' do
        expect(MentionMailer).to receive(:send_mention).and_return(double(deliver_later: true))
        service.call
      end
    end

    context 'when resource is assignee' do
      let(:service) { Mentions::SendEmailService.new(mention_with_assignee) }

      it 'sends assignment' do
        expect(MentionMailer).to receive(:send_assignment).and_return(double(deliver_later: true))
        service.call
      end
    end
  end
end
