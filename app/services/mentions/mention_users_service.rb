module Mentions
  class MentionUsersService
    attr_reader :current_user, :resource

    def initialize(current_user, resource)
      @current_user = current_user
      @resource = resource
    end

    def call
      mentioned_users = Mentions::FindMentionedService.new(content).call
      mentioned_users.each do |user|
        next if user == current_user

        Mentions::CreateService.new(current_user, resource, user).call
      end
      true
    end

    private

    def content
      if resource.instance_of?(Card)
        resource.description
      elsif resource.instance_of?(Comment)
        resource.content
      end
    end
  end
end
