require "http/server"

require "./fruit_jokes/app_env"

class DuctTapeServer
  Log = ::Log.for(self)

  def initialize(@app_env : FruitJokes::AppEnv, @address : String = "0.0.0.0", @port : Int32 = 8080)
    @server = HTTP::Server.new(@app_env.handlers)
    @server.bind_tcp(@address, @port)

    Process.on_terminate do
      Log.info { "Shutdown requested." }
      @server.close
      @app_env.stop
    end
  end

  def start
    @app_env.start

    Log.info { "Server started on http://#{@address}:#{@port}" }
    @server.listen
  end
end

app_env = FruitJokes::AppEnv.new
server = DuctTapeServer.new(app_env)
server.start
