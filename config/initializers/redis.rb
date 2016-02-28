Redis::Client::DEFAULTS.merge!(Settings.redis.symbolize_keys)

Redis::Client::DEFAULTS.merge!(:logger => Rails.logger)