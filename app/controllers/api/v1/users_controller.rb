module Api
  module V1
    class UsersController < ApplicationController
      def me
        render json: UserSerializer.render(@current_user)
      end
    end
  end
end
