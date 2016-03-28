class DeliverMessagesJob < ActiveJob::Base
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  queue_as :default

  recurrence backfill:true do
  	daily.hour_of_day(13)

  	minutely
  end

  def perform(*args)
    
    
  end
end
