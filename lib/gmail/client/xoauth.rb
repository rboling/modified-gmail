require 'gmail_xoauth'

module Gmail
  module Client
    class XOAuth < Base
      attr_reader :token
      attr_reader :secret
      attr_reader :consumer_key
      attr_reader :consumer_secret

      def initialize(username, options={})
        @token           = options.delete(:token)
        @secret          = options.delete(:secret)
        @consumer_key    = options.delete(:consumer_key)
        @consumer_secret = options.delete(:consumer_secret)
       
        super(username, options)
      end

      def login(raise_errors=false)
        puts "in the login  method of the XOAuth class"
        #@imap and @logged_in = (login = @imap.authenticate('XOAUTH', username,
        #  :consumer_key    => consumer_key,
        #  :consumer_secret => consumer_secret,
        #  :token           => token,
        #  :token_secret    => secret
        #)) && login.name == 'OK'
        @imap.authenticate('XOAUTH2', username, token)
        puts "after authentication"
        #@imap and @logged_in = (login = @imap.authenticate('XOAUTH', username, token)) && login.name == 'OK'
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
        puts "in the rescue block"
        raise_errors and raise AuthorizationError, "Couldn't login to given GMail account: #{username}"        
      end

      def smtp_settings
        [:smtp, {
           :address => GMAIL_SMTP_HOST,
           :port => GMAIL_SMTP_PORT,
           :domain => mail_domain,
           :user_name => username,
           :password => secret = {
             :consumer_key    => consumer_key,
             :consumer_secret => consumer_secret,
             :token           => token,
             :token_secret    => token_secret
           },
           :authentication => :xoauth,
           :enable_starttls_auto => true
         }]
      end
    end # XOAuth
  end # Client
end # Gmail
