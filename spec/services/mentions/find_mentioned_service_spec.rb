require 'rails_helper'

RSpec.describe Mentions::FindMentionedService do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:card) do
    create(:card,
           description: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>")
  end

  describe '#call' do
    let(:service) { Mentions::FindMentionedService.new(card.description) }

    it 'returns users mentioned' do
      expect(service.call).to match_array([user, user2])
    end
  end
end
