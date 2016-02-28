class Character < ActiveRecord::Base
  has_one :character_state, dependent: :destroy

  after_destroy :clear_redis


  private 

  def clear_redis
    Redis.current.del("authenticated_user_#{ social_id }")
  end
end