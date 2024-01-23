module Api
  module V1
    class CardsController < ApplicationController
      def show
        if card
          render json: { success: true, card: CardSerializer.render_as_hash(card) }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      def create
        service = Cards::CreateService.new(@current_user, create_card_params)

        if service.call
          render json: { success: true, card: CardSerializer.render_as_hash(service.card) }, status: :created
        else
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      end

      def update
        service = Cards::UpdateService.new(@current_user, card_params)

        if service.call
          render json: { success: true, card: CardSerializer.render_as_hash(service.card) }
        else
          render json: { errors: card.errors }, status: :unprocessable_entity
        end
      end

      def move_card
        service = Cards::MoveCardService.new(@current_user, move_card_params)
        service.call

        render json: { success: true, card: CardSerializer.render_as_hash(service.card) }
      rescue StandardError => e
        render json: { success: false, errors: { error: e.message } }
      end

      def destroy
        service = Cards::DestroyService.new(@current_user, card)

        if service.call
          render json: { success: true }
        else
          render json: { success: false, errors: service.errors }
        end
      end

      private

      def card
        @card ||= Card.find_by(id: params[:id])
      end

      def create_card_params
        params.permit(:column_id, :name)
      end

      def card_params
        params.permit(
          :id,
          :name,
          :description,
          :estimate,
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
