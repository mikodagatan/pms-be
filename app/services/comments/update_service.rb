module Comments
  class UpdateService
    attr_reader :comment, :params, :errors

    def initialize(comment, params)
      @comment = comment
      @params = params
    end

    def call
      comment.update!(params)
    rescue StandardError
      @errors = comment.errors
      false
    end
  end
end
