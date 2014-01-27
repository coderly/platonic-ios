describe Logger do
	it 'logs info when set to verbose' do
		entries = []

		logger = Logger.new(:verbose)
		logger.nslog = lambda { |message| entries << message }
		logger.info("Message")

		entries.should.include 'Message'
	end

	it 'doesnt log when the log level isnt explicity set' do
		entries = []

		logger = Logger.new
		logger.nslog = lambda { |message| entries << message }
		logger.info("Message")

		entries.should.not.include 'Message'
	end
end