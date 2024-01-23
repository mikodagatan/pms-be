module Columns
  class MoveColumnService
    attr_reader :column

    def initialize(params)
      @column = Column.find(params[:column_id])
      @destination_index = params[:destination_index]
    end

    def call
      ActiveRecord::Base.transaction do
        column.insert_at(@destination_index.to_i + 1)
      end
      true
    rescue StandardError
      false
    end
  end
end
