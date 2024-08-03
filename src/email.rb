require 'dotenv'
require 'mail'

require_relative 'otp'

module EmailValidator
    class Email

        def initialize
            Dotenv.load

            @@options = {
                :address => "smtp.gmail.com",
                :port => 587,
                :user_name => ENV['SENDER_MAIL'],
                :password => ENV['GMAIL_AUTH_TOKEN'],
                :authentication => 'plain',
                :enable_starttls_auto => true ,
            }

            @@sender_mail = ENV['SENDER_MAIL']
        end

        def send_mail(send_to, title)
            begin
                otp = EmailValidator::OTP.new(send_to)
                otp.generate_secret

                Mail.defaults do
                delivery_method :smtp, @@options
                end

                Mail.deliver do
                    to send_to
                    from @@sender_mail
                    subject title
                    body %{
                        Your app code is: #{otp.secret}
                        For: #{otp.email}
                        Transaction ID: #{otp.id}
                        Your validation link is: http://localhost:8080/validate/#{otp.id}/#{otp.secret}
                    }
                end

                return otp

            rescue Exception => e
                print "Exception occured:\n" + e.full_message
            end
        end
    end
end
