# esendex.gem

Gem for interacting with the Esendex API

This is in very early stages of development but supports sending one or more messages either straight away or at a scheduled time

## Usage

### Setting up

	gem install esendex

### Sending Messages

First instantiate an Account with your credentials
	
	account = Account.new("EX123456", "user@company.com", "yourpassword")
	
then, call the send method on the account object with a message. The return value is a batch_id you can use to obtain the status of the messages you have sent.

	batch_id = account.send_message(Message.new("07777111222", "Saying hello to the world with the help of Esendex"))

Multiple messages are sent by passing an array of Messages to the send_messages method
	
	batch_id = account.send_messages([Message.new("07777111222", "Hello"), Message.new("07777111333", "Hi")])
	
### Testing

	rake test
	
will run unit tests, ie those in the root of the test folder

	rake integration_test

will run integration tests, ie only those in the /test/integration folder

## Contributing

Please fork as you see fit and let us know when you have something that should be part of the gem.

## Copyright

Copyright (c) Adam Bird. See LICENSE.txt for
further details.

