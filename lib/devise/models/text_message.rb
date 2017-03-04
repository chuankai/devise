# Short message service provided by twsms.com

require 'uri'
require 'cgi'
require 'net/http'

class TextMessage

	SERVICE_URL = "http://api.twsms.com/smsSend.php?"

        attr_accessor   :text

	def initialize(username, password)
		@username = username
		@password = password
		@options = {
			sendtime: '',
			expirytime: '',
			popup: 'N',
			mo: 'N',
			drurl: ''
		}
	end

	def send(number, opts=nil)
		@options.merge!(opts) unless opts.nil?
		url = SERVICE_URL + "username=#{@username}&password=#{@password}&mobile=#{number}&message=#{CGI::escape(@text)}"
		@options.each do |k, v|
			url += "&#{k.to_s}=#{v.to_s}" unless v.empty?
		end
		r = Net::HTTP.get(URI.parse(url))
		m = r.match(/<code>(\d*)<\/code>/)
		@error =  m[1] == '00000' ? false : true
	end

        def error?
                @error
        end
end
