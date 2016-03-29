class DeliverMessagesJob < ActiveJob::Base
  include Sidetiq::Schedulable

  # recurrence backfill:true do
  # 	# daily.hour_of_day(13)
  # 	minutely
  # end

  def perform()
    RelationshipMailer.message_email(Relationship.last, Message.last)    
  end
end
