require 'socket'
require 'json'

host = 'localhost'
port = 2000
path = '/index.html'

user_request = ''
until user_request == "GET" || user_request == 'POST'
	puts "Enter a request: GET or POST"
	user_request = gets.chomp.upcase
end


if user_request == 'POST'
	path = "/thanks.html"
	puts "Register a name: "
	name = gets.chomp
	puts "Enter an email: "
	email = gets.chomp
	
	hash = {:user => {:name => name, :email => email }}.to_json
	request = "#{user_request} #{path} HTTP/1.0\r\nContent-Length: #{hash.to_json.length}\r\n\r\n#{hash}"
else
	request = "#{user_request} #{path} HTTP/1.0\r\n\r\n"
end



socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
puts response

headers,body = response.split("\r\n\r\n", 2)
print body
socket.close