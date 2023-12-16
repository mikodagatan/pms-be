require 'redis'

class StateManager
  REDIS = Redis.new

  def cache_state(state)
    REDIS.setex(state_key(state), 300, true)
  end

  def valid_state?(state)
    REDIS.exists?(state_key(state))
  end

  def clear_state(state)
    REDIS.del(state_key(state))
  end

  private

  def state_key(state)
    "oauth2_state:#{state}"
  end
end
