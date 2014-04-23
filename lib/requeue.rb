require 'redis'

module Requeue
  class Queue
    def initialize(redis: Redis.current, prefix: 'queue', unique:true)
      @prefix = prefix 
      @unique = unique 
      @redis  = redis
    end

    def name
      "#{@prefix}:queue"
    end

    def list 
      @redis.lrange(name, 0, length)
    end

    def length
      @redis.llen(name)
    end
   
    def clear!
      @redis.del(name)
    end
    
    def enqueue!(value)
      if (@unique == false || !queued?(value))
        @redis.rpush(name, value) 
      else
        length
      end
    end

    def dequeue!
      @redis.lpop(name)
    end

    def queued?(value)
      list.include?(value)
    end

    def position(value)
      list.index(value)
    end
    
    def remove!(value)
      @redis.lrem(name,0,value)
    end

    def owner
      first
    end

    def first
      @redis.lrange(name,0,1).first 
    end
    def owned?
      length > 0
    end

    def steal!(value)
      @redis.lpush(name,value)
    end
    
    def as_json
      {queue: list, owner: owner, length: length}.to_json
    end
  end
end
