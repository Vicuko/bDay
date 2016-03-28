class RelationshipMailer < ApplicationMailer
	default from: 'info@bday.today'

	def message_email(relationship, message)
		@relationship = relationship
		@message = message
		@url = "http://bday.today"
		mail(to: @relationship.email, subject: '¡Felicidades @relationship.nickname!')
	end






end
