module Api
  module V1
    class CommentsController < ApplicationController
      def create
        service = Comments::CreateService.new(@current_user, create_params)

        if service.call
          render json: { success: true, comment: CommentSerializer.render_as_hash(service.comment) }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      def update
        service = Comments::UpdateService.new(@current_user, comment, update_params)

        if service.call
          render json: { success: true, comment: CommentSerializer.render_as_hash(service.comment) }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if comment.commenter_id != @current_user.id
          return render json: { success: false,
                                error: "Cannot delete other users' comments" }
        end

        service = Comments::DestroyService.new(comment)

        render json: { success: true } if service.call
      end

      private

      def comment
        @comment ||= Comment.find(params[:id])
      end

      def create_params
        params.permit(:resource_type, :resource_id, :content)
      end

      def update_params
        params.permit(:id, :content)
      end
    end
  end
end
