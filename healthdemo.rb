require 'date'
require 'json'
require 'net/http'
require 'sinatra/base'
require 'socket'

class HealthDemo < Sinatra::Application

  @host = Socket.gethostname

  def self.live_info
    live = {}
    live['live'] = File.exist?('/tmp/live')
    live['hostname'] = @host
    live['timestamp'] = Time.now.iso8601
    live
  end

  def self.ready_info
    ready = {}
    ready['ready'] = File.exist?('/tmp/ready')
    ready['hostname'] = @host
    ready['timestamp'] = Time.now.iso8601
    ready
  end

  get '/' do
    content_type :text
    "Hello world\n"
  end

  get '/env' do
    tmp = {}
    ENV.map do |k,v|
      tmp[k] = v
    end
    content_type :json
    tmp.to_json
  end

  get '/health/live' do
    tmp = HealthDemo.live_info
    content_type :json
    if(tmp['live'])
      status 200
    else
      status 503
    end
    tmp.to_json
  end

  get '/health/ready' do
    tmp = HealthDemo.ready_info
    content_type :json
    if(tmp['ready'])
      status 200
    else
      status 503
    end
    tmp.to_json
  end

end
