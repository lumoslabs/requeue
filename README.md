# Requeue

Requeue is a rediciulosly simple queue backed by redis.

## Installation

Add this line to your application's Gemfile:

    gem 'requeue'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install requeue

## Usage

Usage is simple
```ruby
#create a new queue 
q = Requeue::Queue.new

#optionally you can specify your prefix or the redis object you want to use
q = Requeue::Queue.new(redis:Redis.new,prefix:'awesome')

#you can also tell the queue to only add unique items to it's self
q = Requeue::Queue.new(unique:true)

#All functions that change the state of the queue are suffixed with '!'
#To enqueue a thing
q.enqueue!('thing')

#To dequeue the first item 
q.dequeue!

#To remove an item from the queue
q.remove!('thing')

#To clear the queue
q.clear!

#To steal the first place in the queue 
q.steal!

#To get the position of a value
q.position('thing') => 0

#To see if an item is queued
q.queued?('thing') => true

#To see the the current first item of the queue
q.owner => 'thing'

#To get the queue as a hash 
q.as_hash

#To get the queue as a json blob
q.as_json

#To get the internal name of the queue
q.name

#To get the length of the queue
q.length

#To get all of the items in the queue
q.list
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/requeue/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
