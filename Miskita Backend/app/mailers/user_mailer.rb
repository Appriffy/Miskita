class UserMailer < ApplicationMailer
  default from: 'abhishek@miskita.com'

  def welcome_email1(user)
  	@user = user
  	@url  = 'http://localhost:3000'
  	mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def welcome_email2(user)
    @user = user
    @url  = 'http://localhost:3000'
    mg_client = Mailgun::Client.new ENV['api_key']
    message_params = {:from    => ENV['gmail_username'],
                      :to      => @user.email,
                      :subject => 'Sample Mail using Mailgun API',
                      :text    => 'This mail is sent using Mailgun API via mailgun-ruby'}
    mg_client.send_message ENV['domain'], message_params
  end

  def welcome_email(user)
    @user = user
    p @user
    @url  = 'http://localhost:3000'
    mg_client = Mailgun::Client.new ENV['MAILGUN_API_KEY']
    message_params = {:from    => ENV['FITFIGHT_SUPPORT'],
                      :to      => @user.email,
                      :subject => "Welcome here",
                      :html => (render_to_string(template: "../views/user_mailer/welcome_email")).to_str}
    mg_client.send_message ENV['MAILGUN_DOMAIN'], message_params
  end

end
