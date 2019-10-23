require 'net/http'
require 'sinatra/base'
require 'json'

class HealthDemo < Sinatra::Application

  def self.live_info
    live = {}
    live['live'] = File.exist?('/tmp/live')
    live
  end

  def self.ready_info
    ready = {}
    ready['ready'] = File.exist?('/tmp/ready')
    ready
  end

  get '/' do
    content_type :text
    "Hello world\n"
  end

  get '/.well-known/live' do
    tmp = HealthDemo.live_info
    content_type :json
    if(tmp['live'])
      status 200
    else
      status 503
    end
    tmp.to_json
  end

  get '/.well-known/ready' do
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
