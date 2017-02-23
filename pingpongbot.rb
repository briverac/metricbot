require 'slack-ruby-bot'
require_relative 'Metric'

class PingPongBot < SlackRubyBot::Bot

  help do
    title 'PingPongBot'
    desc 'Do funny stuff'

    command 'quiero' do
      desc 'Show you a picture that represent whatever you write'
      long_desc 'It takes the phrase you enter and look for an image that represent it'
    end
  end

  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  command 'quiero' do |client, data, match|
    text = match[:expression]
    client.say(text: "<@#{data.user}> toma #{text}", channel: data.channel, gif: text)
  end

  command 'llama_a' do |client, data, match|
    id = match[:expression]
    id.slice!("<@")
    id.slice!(">")
    user = client.users[id]
    image = get_image(user.profile)
    real_name = user.real_name
    client.say(text: "<@#{id}> #{real_name.upcase} te buscan, si no contestas les doy tu correo para que hagan spam #{user.profile.email} y tu cara #{image}", channel: data.channel)
  end

  command 'get_server' do |client, data, match|
    client.say(text: @server || 'Server not setted', channel: data.channel)
  end

  command 'set_server' do |client, data, match|
    text = match[:expression]
    return client.say(text: 'You must enter the server name', channel: data.channel) unless text
    text.slice!("<")
    text.slice!(">")
    @server = text
    client.say(text: @server || 'Server setted', channel: data.channel)
  end

  command 'metric' do |client, data, match|
    return client.say(text: 'Please first set the server', channel: data.channel) unless @server
    params = match[:expression].split(' ')
    if params.size != 3
      client.say(text: 'You must enter the metric_id, the computed_period and the location', channel: data.channel)
    else
      metric = Metric.new(@server, params[0], params[1], params[2])
      client.say(text: metric.response, channel: data.channel)
    end
  end

  class << self
    private
    def get_image(profile)
      return profile.image_1024 unless profile.image_1024.nil?
      return profile.image_512 unless profile.image_512.nil?
      return profile.image_192 unless profile.image_192.nil?
      return profile.image_72 unless profile.image_72.nil?
      return profile.image_48 unless profile.image_48.nil?
      return profile.image_32 unless profile.image_32.nil?
      return profile.image_24 unless profile.image_24.nil?
    end
  end
end

PingPongBot.run
