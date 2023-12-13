module Api
  module V1
    class ColumnsController < ApplicationController
      def update
        if column.update(update_params)
          render json: { success: true }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      private

      def column
        @column ||= Column.find(params[:id])
      end

      def update_params
        params.permit(:name)
      end
    end
  end
end
