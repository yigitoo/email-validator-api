#!/usr/bin/env ruby

require 'sinatra/base'

require 'dotenv'
require 'json'

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

    @@mail_client = EmailValidator::Email.new{}
    @@db_client = EmailValidator::Database.new({
        :username => ENV['DB_USER'],
        :password => ENV['DB_PASSWORD'],
        :reset_table_on_start => false,
    })
    @@db_client.connect

    get '/' do
        content_type :json

        {
            message: "Email Validator API",
            version: 'v1',
        }.to_json
    end


    get '/send/:to' do |to|
        content_type :json

        otp_session = @@mail_client.send_mail(to, "Auth token")
        if @@db_client.add_otp_session(otp_session) == false
            {
                status: 500,
                success: false,
                message: "OTP Session is already taken.",
            }.to_json
        else
            {
                status: 200,
                success: true,
                message: "OTP Session added.",
            }.to_json
        end

    end


    get '/validate/:id/:secret' do |id, secret|
        content_type :json

        if @@db_client.validate(id, secret) == true
            {
                status: 200,
                success: true,
                message: "The validation is successfully completed and session deleted.",
            }.to_json
        else
            {
                status: 404,
                success: false,
                message: "The validation is failed / Cannot found OTP session.",
            }.to_json
        end
    end

    run! if app_file == $0
end
