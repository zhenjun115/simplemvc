#auhor: zhenjun
#notice:
#   1. It is a HTTP Server, but it is not a "SERVER"!!!. Better Choices:　Apache HTTP、Nginx
#  ２．Want to learn more about HTTP Server ? No No No, this is not an good exmple, just PERSONAL TOAST.
#  3. Have Fun.
#  4. And do not forget check and set your own WEB_ROOT DIR.
#
#

require 'socket'
require 'uri'

#
module Helper

  #开始 解析文件URI
  def self.ParseFilePath(request)
    request = request.split(" ")[1]
    path = URI.unescape( URI( request_uri ).path )
    path = File.join( Service::WEB_ROOT, path )

    #设置 默认访问文件为index.html
    path = File.join( path, 'index.html' ) if File.directory?( path )

    return path
  end
  #结束 解析文件URI

  #开始 解析文件类型
  def self.ParseFileType(file)
    type = File.extname(file).split(".").last
    return Service::FILE_TYPE_NAME[type]
  end
  #结束 解析文件URI
end

#开始 HTTP service
module Service
  #文件根目录
  WEB_ROOT = "~/Documents" #  4. And do not forget check and set your own WEB_ROOT DIR.
  #可访问文件类型
  FILE_TYPE_NAME = {
      'html' => 'text/html',
      'txt' => 'text/plain',
      'png' => 'image/png',
      'jpg' => 'image/jpeg'
  }

  #开始 运行
  def self.Run(request, socket)
    path = Helper::ParseFilePath(request)

    #检查 文件是否存在
    if File.exist?(path)
      File.open(path, "rb") do |file|
        socket.print "HTTP/1.1 200 OK\r\n" +
                     "Content-Type: #{Helper::ParseFileType(file)}\r\n" +
                     "Content-Length: #{file.size}\r\n" +
                     "Connection: close\r\n"
        socket.print "\r\n"
        IO.copy_stream(file, socket)
      end
    else
      message = "File not found\n"
      socket.print "HTTP/1.1 404 Not Found\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Content-Length: #{message.size}\r\n" +
                   "Connection: close\r\n"
      socket.print "\r\n"
      socket.print message
    end
    socket.close
  end
  #结束 运行
end
#结束 HTTP service

loop do
  # localhost 2346
  server = TCPServer.new( 'localhost', 2346 )
  socket = server.accept( )
  Service::Run( socket.gets, socket )
end