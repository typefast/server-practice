require 'socket'
require 'json'

server = TCPServer.open(2000)
loop {
	Thread.start(server.accept) do |client|
		request = client.read_nonblock(256)
		header, body = request.split("\r\n\r\n", 2)
		method = header.split[0]
		path = header.split[1]
		path = path[1..-1] #remove forward slash from path

		# puts "Method: #{method}"
		# puts "Path: #{path}"

		if File.exists?(path)
			request_response = File.read(path)
			client.puts "HTTP/1.1 200 OK\r\nContent-type:text/html\r\n\r\n"
			if method == 'GET'
				client.puts request_response
			elsif method == 'POST'
				params = JSON.parse(body)
				information = "<li>name: #{params['user']['name']}</li><li>Email: #{params['user']['email']}</li>"
				client.puts request_response.gsub("<%= yield %>", information)
			end
		else
			client.puts "HTTP/1.1 404 Not Found\r\n\r\n"
			client.puts "Error file not found"
		end
		client.close
	end
}