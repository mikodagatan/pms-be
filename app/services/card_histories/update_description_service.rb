module CardHistories
  class UpdateDescriptionService
    attr_reader :current_user, :card

    def initialize(current_user, card)
      @current_user = current_user
      @card = card
    end

    def call
      history = card.histories.build(
        attr: :description,
        action: :update_action,
        user: current_user,
        from: card.description_was,
        to: generate_diff,
        output: "<strong>#{current_user.full_name}</strong> changed the description"
      )
      history.save!
    end

    private

    def generate_diff
      previous = HtmlBeautifier.beautify(card.description_was)
      new_description = HtmlBeautifier.beautify(card.description)
      Diffy::Diff.new(previous, new_description, ignore_crlf: true).map do |line|
        case line
        when /^\+/
          "<div class='ins'>#{line.chomp[1..-1]}</div>"
        when /^-/
          "<div class='del'>#{line.chomp[1..-1]}</div>"
        when "\\ No newline at end of file\n"
          nil
        else
          "<div class='unchanged'>#{line.chomp}</div>"
        end
      end.compact.join
    end
  end
end
