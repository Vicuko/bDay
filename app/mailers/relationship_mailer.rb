class RelationshipMailer < ApplicationMailer
	default from: 'happy@bday.today'

	def message_email(sender, relationship, message)
		@sender = sender
		@relationship = relationship
		@message = message
		@url = "http://bday.today"
		email_with_name = %("#{@relationship[:nickname]}" <#{@relationship[:email]}>)
		mail(to: email_with_name, subject: "¡Felicidades #{@relationship[:nickname]}!")
	end
end
