module Api
  module V1
    class CardsController < ApplicationController
      def create
        column = Column.find_by(id: params[:column_id])
        card = column.cards.build(card_params)

        if card.save
          render json: { success: true, card: }, status: :created
        else
          render json: { errors: card.errors }, status: :unprocessable_entity
        end
      end

      def update
        service = Cards::UpdateService.new(card_params)

        if service.call
          render json: { success: true }
        else
          render json: { errors: card.errors }, status: :unprocessable_entity
        end
      end

      def move_card
        Cards::MoveCardService.new(move_card_params).call

        render json: { success: true }
      rescue StandardError
        render json: { success: false }
      end

      def destroy
        if card&.destroy
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private

      def card
        @card ||= Card.find_by(id: params[:id])
      end

      def card_params
        params.permit(
          :id,
          :name,
          :description,
          :requester_id,
          assignee_ids: []
        )
      end

      def move_card_params
        params.require(:params).permit(
          :project_id,
          :card_id,
          :source_column_id,
          :source_index,
          :destination_column_id,
          :destination_index
        )
      end
    end
  end
end
