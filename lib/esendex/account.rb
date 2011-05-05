require 'nestful'
require 'nokogiri'

module Esendex
  class Account
    attr_accessor :account_reference, :username, :password
    attr_reader :messages_remaining
    
    def initialize(account_reference, username, password, connection = Nestful::Connection.new('http://api.esendex.com'))
      @account_reference = account_reference
      @username = username
      @password = password

      @connection = connection
      @connection.user = @username
      @connection.password = @password
      @connection.auth_type = :basic
      
      begin
        response = @connection.get "/v0.1/accounts/#{@account_reference}", default_headers
        doc = Nokogiri::XML(response.body)
        @messages_remaining = doc.at_xpath('//api:accounts/api:account/api:messagesremaining', 'api' => Esendex::API_NAMESPACE).content.to_i
      rescue Exception => exception
        raise ApiErrorFactory.new.get_api_error(exception)
      end
    end
    
    def default_headers
      {"User-Agent" => "Esendex Gem #{Esendex::Version::STRING}"}
    end
    
    def send_message(message)
      self.send_messages([message])
    end
    
    def send_messages(messages)
      
      batch_submission = MessageBatchSubmission.new(@account_reference, messages)
      
      begin
        response = @connection.post "/v1.0/messagedispatcher", batch_submission.to_s, default_headers
        doc = Nokogiri::XML(response.body)
        doc.at_xpath('//api:messageheaders', 'api' => Esendex::API_NAMESPACE)['batchid']
      rescue Exception => exception
        raise ApiErrorFactory.new.get_api_error(exception)
      end
    end

  end
end
