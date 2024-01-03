module Openai
  class CreateProjectCardService
    attr_reader :params, :project, :column

    def initialize(project, params)
      @project = project
      @params = params
      @column = project.columns.order(position: :asc).first
    end

    def call
      card = column.cards.build(params)

      return unless card.save

      card.id
    end
  end
end
