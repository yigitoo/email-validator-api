require 'pg'

module EmailValidator
    class Database
        attr_accessor :options

        def initialize(options = {})
            @options = options
            @database = options[:database] || 'email_validator'
            @client = nil
        end

        def connect
            @client = PG::connect(
                :host => @options[:host] || 'localhost',
                :port => @options[:port] || 5432,
                :username => @options[:username] || 'postgres',
                :password => @options[:password] || 'postgres',
                :database => @database
            )
        end

        def disconnect
            @client.close
        end

        def close
            @client.close
        end

        def query(sql)
            @client.query(sql)
        end

        def add_otp_session(otp_session)
            is_otp_session_exist = check_otp_session(otp_session)
            if is_otp_session_exist then
                return false
            end

            @client.query("INSERT INTO otp_session (email, id, secret) "+
            "VALUES (#{@client.escape(otp.email)}, #{@client.escape(otp.id)}, "+
            "#{@client.escape(otp.secret)});")

        end

        def check_otp_session(otp_session)
            results = @client.query("SELECT * FROM otp_session WHERE email=#{@client.escape(otp_session.email)};")
            if results.empty? or results.count == 0 then
                return false
            end

            return true
        end

    end
end
