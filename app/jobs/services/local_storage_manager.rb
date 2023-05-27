require 'redis'

module Services
  class LocalStorageManager

    TIME_SET = 60

    def initialize(key, value = nil)
      @key = key
      @value = value
      @redis ||= Redis.new(host: "localhost")
    end

    def fetch
      result = @redis.get(@key)
      result
    end

    def load
      @redis.setex(@key, TIME_SET, @value)
    end
  end
end



