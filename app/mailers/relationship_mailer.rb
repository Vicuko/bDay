class RelationshipMailer < ApplicationMailer
	default from: 'info@bday.today'

	def message_email(relationship)
		@relationship = relationship
		@url = "http://bday.today"
		mail(to: @relationship.email, subject: '¡Felicidades!')
	end






end
