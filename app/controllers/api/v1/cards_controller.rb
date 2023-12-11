module Api
  module V1
    class CardsController < ApplicationController
      def move_card
        MoveCardService.new(move_card_params).call

        render json: { success: true }
      rescue StandardError
        render json: { success: false }
      end

      private

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
