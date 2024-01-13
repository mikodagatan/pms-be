module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      # I personally used Rails' session hash to identify the current user.
      # There are a number of other ways to do this
      self.current_user = User.find(request.params['user_id'])
    end
  end
end
