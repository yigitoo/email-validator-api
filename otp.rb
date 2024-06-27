require 'securerandom'

module EmailValidator
    class OTP
        @@characters = [*'A'..'Z', *'0'..'9']
        
        attr_accessor :email, :id, :secret
        
        def initialize (account_mail)
            @email = account_mail
            @id = generate_transaction_id()
            @secret = generate_secret()
        end
    
        def create_transaction_id
            SecureRandom.uuid
        end

        def create_secret
            secret = ""
            6.times do
                secret << @@characters.shuffle.first
            end

            return secret
        end

        def generate_transaction_id
            create_transaction_id
        end

        def generate_secret
            create_secret
        end

    end
end