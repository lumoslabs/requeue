require 'spec_helper'
describe Requeue::Queue do
 before(:each) do 
   @redis = Redis.new
   @queue = Requeue::Queue.new(prefix:'test', redis:@redis)
 end

 after(:each) do
   @queue.clear!
 end

 describe '.queue_name' do
  it { expect(@queue.name).to eq("test:queue") }
 end

 describe '.clear_queue!' do
   before { @queue.enqueue!('eric') }
   before { @queue.clear! }

   it 'should empty the queue' do
     expect(@redis.llen(@queue.name)).to eq(0)
   end

   it 'should see an empty queue' do
      expect(@queue).not_to be_owned 
   end
 end

 describe '.enqueue' do
   context 'when no users are enqueued' do
     after { @queue.clear! }
     it 'should return 1' do
       expect(@queue.enqueue!('eric')).to eq(1)
     end
   end

   context 'when some users are enqueued' do
     before { @queue.enqueue!('bob') }
     before { @queue.enqueue!('eric') }
     after  { @queue.clear! }
     it 'should have a length of 2' do
       expect(@queue.length).to eq(2)
     end

     it 'should only add the user to the queue if it is unique' do
       expect(@queue.enqueue!('eric')).to eq(2)
       expect(@queue.length).to eq(2)
     end
   end
 end

 describe '.list' do
   context 'when no users are enqueued' do
     it 'should return an empty list' do
       expect(@queue.list).to eq([])
     end
   end

   context 'when some users are enqueued' do
     before { @queue.enqueue!('bob') }
     before { @queue.enqueue!('eric') }
     after  { @queue.clear! }
     it 'should have the current users' do
       expect(@queue.list).to eq(['bob', 'eric'])
     end
   end
 end
 describe '.user_queued?' do
   before { @queue.enqueue!('bob') }
   before { @queue.enqueue!('eric') }
   after  { @queue.clear! }
   it 'should show eric as queued' do
     expect(@queue.queued? 'eric').to eq(true)
   end
   it 'should show bob as queued' do
     expect(@queue.queued? 'bob').to eq(true)
   end
   it 'should not show an unqueued user as queued' do
     expect(@queue.queued? 'jim').to eq(false)
   end
 end

 describe '.user_position' do
   before { @queue.enqueue!('bob') }
   before { @queue.enqueue!('eric') }
   after  { @queue.clear! }
   it 'eric should be in position 1 (the second place)' do
     expect(@queue.position 'eric').to eq(1)
     expect(@queue.position 'bob').to eq(0)
   end
 end

 describe '.dequeue' do
   before { @queue.enqueue!('bob') }
   before { @queue.enqueue!('eric') }
   before { @queue.dequeue! }
   it 'eric should be in position 1 (the second place)' do
     expect(@queue.position 'eric').to eq(0)
   end
 end

 describe '.owner' do
   context 'when no users are enqueued' do
      it 'should return empty string' do
        expect(@queue.owner).to eq(nil) 
      end
    end 

    context 'when a user is enqueued' do
      before { @queue.enqueue!('eric') }
      it 'should be owned' do
        expect(@queue.owner).to eq('eric') 
      end
    end
 end

 describe '.remove!' do
   before { @queue.enqueue!('bob') }
   before { @queue.enqueue!('eric') }
   before { @queue.remove!('eric') }
   
   it 'should not contain eric anymore' do
     expect(@queue.queued?('eric')).to eq(false)
     expect(@queue.list).to eq(['bob'])
   end
 end

 describe '.steal!' do
   before { @queue.enqueue!('bob') }
   before { @queue.enqueue!('eric') }
   before { @queue.steal!('jim') }

   it 'jim should own the queue' do
     expect(@queue.owner()).to eq('jim')
     expect(@queue.list).to eq(['jim','bob','eric'])
   end

   it 'the queue should still have everyone else in it' do
     expect(@queue.length).to eq(3)
   end
 end
 describe '.owned?' do
    context 'when no users are enqueued' do
      it 'should start unowned' do
        expect(@queue).not_to be_owned 
      end
    end 

    context 'when a user is enqueued' do
      before { @queue.enqueue!('eric') }
      it 'should be owned' do
        expect(@queue).to be_owned 
      end
    end
  end
end