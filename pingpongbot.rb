require 'slack-ruby-bot'

class PingPongBot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  command 'quiero' do |client, data, match|
    text = match[:expression]
    client.say(text: "<@#{data.user}> toma #{text}", channel: data.channel, gif: text)
  end
  command 'llama_a' do |client, data, match|
    text = match[:expression]
    text.slice! "<@"
    text.slice! ">"
    user = client.users[text]
    real_name = user.real_name
    client.say(text: "<@#{text}> #{real_name.upcase} te buscan, si no contestas les doy tu correo para que hagan spam #{user.profile.email} y tu cara #{user.profile.image_1024}", channel: data.channel)
  end
end

PingPongBot.run
