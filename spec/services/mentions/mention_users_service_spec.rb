require 'rails_helper'

RSpec.describe Mentions::MentionUsersService do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:card) do
    create(:card,
           description: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>")
  end
  let(:comment) do
    create(:comment,
           content: "Sample <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user2.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span> <span class=\"mention\" data-index=\"0\" data-denotation-char=\"@\" data-id=\"#{user.id}\" data-value=\"Miguel Dagatan\">﻿<span contenteditable=\"false\">@Miguel Dagatan</span>﻿</span>")
  end

  describe '#call' do
    context 'when resource is Card with mentions' do
      let(:service) { Mentions::MentionUsersService.new(user, card) }

      it 'creates one mention' do
        expect do
          service.call
        end.to change(Mention, :count).by(1)
      end
    end

    context 'when resource is comment with mentions' do
      let(:service) { Mentions::MentionUsersService.new(user, comment) }

      it 'creates one mention' do
        expect do
          service.call
        end.to change(Mention, :count).by(1)
      end
    end
  end
end
