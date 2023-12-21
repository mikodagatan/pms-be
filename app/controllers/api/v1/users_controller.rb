module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: { success: true, users: UserSerializer.render_as_hash(User.all) }
      end

      def me
        render json: UserSerializer.render(@current_user)
      end
    end
  end
end
