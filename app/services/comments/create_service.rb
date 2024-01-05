module Comments
  class CreateService
    attr_reader :current_user, :params, :comment, :errors

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def call
      @comment = Comment.new(create_params)

      comment.save!
    rescue StandardError
      @errors = comment.errors
      false
    end

    private

    def create_params
      params.merge(commenter_id: current_user.id)
    end
  end
end
