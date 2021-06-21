class UserMailer < ApplicationMailer
	default :from => "order_app@example.com"
	def status_email(user, order)
    @user = user
    @order = order
    mail(:to => user.email, :subject => "Order status updated")
  end
end
