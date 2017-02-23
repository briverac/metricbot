require 'slack-ruby-bot'
require_relative 'metric_service'

class MetricBot < SlackRubyBot::Bot

  help do
    title 'MetricBot'
    desc 'Do funny stuff'

    command 'get_server' do
      desc 'Set the url of the server that will be hit'
      long_desc 'Get the user input and set it as the url of the server that will be hit'
    end
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
      metric = MetricService.new(@server, params[0], params[1], params[2])
      client.say(text: metric.response, channel: data.channel)
    end
  end
end

MetricBot.run
