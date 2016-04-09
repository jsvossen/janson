class UserMailer < ApplicationMailer

	default from: 'noreply@example.com'

	def welcome_mailer(user)
		@user = user
		mail(to: @user.email, subject: 'Welcome to JAnSoN!')
	end

end
