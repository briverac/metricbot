require 'slack-ruby-bot'
require_relative 'metric_service'

class MetricBot < SlackRubyBot::Bot

  help do
    title 'MetricBot'
    desc 'Gets the scores of a metric from a specific location, based on a compute_period'

    command 'get_server' do
      desc 'Shows the url of the server that will be hit'
      long_desc 'Shows the url of the server that will be hit, if there is not set an url, it will show an error message. Usage: `get_server`'
    end
    command 'set_server' do
      desc 'Sets the url of the server that will be hit'
      long_desc 'Gets the user input and sets it as the url of the server that will be hit. Usage: `set_server http://url.com`'
    end
    command 'metric' do
      desc 'Lists the scores of the metric based on the metric, the compute_period, and the location'
      long_desc 'This is the usage: `metric metric_id compute_period location`. You must enter all the values'
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
      client.say(text: "Usage: 'metric metric_id compute_period location'", channel: data.channel)
    else
      metric = MetricService.new(@server, params[0], params[1], params[2])
      client.say(text: metric.response, channel: data.channel)
    end
  end
end

MetricBot.run
