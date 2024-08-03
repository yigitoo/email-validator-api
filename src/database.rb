require 'pg'

module EmailValidator
    class Database
        attr_accessor :options

        def initialize(options = {})
            @options = options
            @database = options[:database] || 'email_validator'
            @tablename = options[:table_name] || 'otp_session'
            @client = nil
        end

        def connect
            @client = PG::connect(
                :host => @options[:host] || 'localhost',
                :port => @options[:port] || 5432,
                :user => @options[:username] || 'postgres',
                :password => @options[:password] || 'postgres',
                :dbname => @database
            )

            @tablename = @client.quote_ident(@tablename)
            if options[:reset_table_on_start] == true
                reset_table
            end
        end

        def disconnect
            @client.close
        end

        def close
            @client.close
        end

        def query(sql)
            @client.exec(sql)
        end

        def exec(sql)
            @client.exec(sql)
        end

        def reset_table
            @client.exec(
                "DROP TABLE IF EXISTS #{@tablename}",
            )

            @client.exec(
                "CREATE TABLE #{@tablename} (
                    sql_id SERIAL PRIMARY KEY,
                    email varchar(255) NOT NULL,
                    id varchar(255) NOT NULL UNIQUE,
                    secret varchar(255) NOT NULL);"
            )
        end

        def get_otp_session (id)
            @client.exec()
        end

        def validate(id, secret)
            id = @client.escape(id)
            secret = @client.escape(secret)

            @client.exec("SELECT * FROM otp_session WHERE id='#{id}' AND secret='#{secret}'") do |rows|
                rows.each do |row|
                    if row.empty? then
                        return false
                    else
                        @client.exec("DELETE FROM otp_session WHERE id='#{id}' AND secret='#{secret}'")
                        return true
                    end
                end
            end
        end

        def add_otp_session(otp_session)
            is_otp_session_exist = check_otp_session(otp_session)
            if is_otp_session_exist == true then
                return false
            end

            @client.exec("INSERT INTO otp_session (email, id, secret) "+
            "VALUES ('#{otp_session.email}', '#{otp_session.id}', '#{otp_session.secret}')")
            return true
        end

        def check_otp_session(otp_session)
            @client.exec("SELECT * FROM otp_session WHERE email='#{otp_session.email}'") do |rows|
                rows.each do |row|
                    if row.empty? or row.nil? then
                        return false
                    else
                        return true
                    end
                end
            end

        end

    end
end
