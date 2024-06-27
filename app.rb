require 'sinatra/base'

require 'dotenv'

require_relative 'email'
require_relative 'otp'
require_relative 'database'

class EmailValidatorAPI < Sinatra::Base
    # set root folder of the project
    set :root, File.dirname(__FILE__) 
    set :public_folder, File.dirname(__FILE__) + '/static'
    enable :sessions
    enable :loggin

    Dotenv.load

    @@mail_client = EmailValidator::Email.new
    @@db_client = EmailValidator::Database.new(options={
        :username => ENV['DB_USER'],
        :password => ENV['DB_PASSWORD'],
    })
    @@db_client.connect

    get '/' do
        "Hello World"
    end


    get '/send/:to' do |to|
        otp_session = @@mail_client.send_mail(to, "Auth token")
        @@db_client.add_otp_session(otp_session)
    end


    get '/validate/:id/:secret' do |id, secret|
        otp_session = @@db_client.get_otp_session(id)
        if otp_session.nil?
            return "OTP session not found"
        end

        if otp_session.validate(secret)
            return "Success"
        else
            return "Invalid OTP"
        end
    end



    run! if app_file == $0
end