require 'rails_helper'

RSpec.describe Comments::DestroyService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:comment) { create(:comment, resource: card) }

  describe '#call' do
    let(:service) { Comments::DestroyService.new(comment) }

    it 'destroys the comment' do
      expect do
        service.call
      end.to change(Comment, :count).by(-1)
    end

    it 'broadcasts the change' do
      expect do
        service.call
      end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)
    end
  end
end
