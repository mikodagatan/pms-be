module Api
  module V1
    class ColumnsController < ApplicationController
      def create
        column = Column.create(project_id: params[:project_id], name: 'New Column')

        render json: { success: true, column: ColumnSerializer.render_as_hash(column) }
      end

      def update
        if column.update(update_params)
          render json: { success: true }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      def move_column
        service = Columns::MoveColumnService.new(params)

        if service.call
          render json: { success: true }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      def destroy
        if column&.destroy
          render json: { success: true }
        else
          render json: { success: false }
        end
      end

      private

      def column
        @column ||= Column.find_by(id: params[:id])
      end

      def update_params
        params.permit(:name)
      end

      def move_column_params
        params.permit(:column_id, :destination_index)
      end
    end
  end
end
