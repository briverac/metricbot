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
    id = match[:expression]
    id.slice!("<@")
    id.slice!(">")
    user = client.users[id]
    image = get_image(user.profile)
    real_name = user.real_name
    client.say(text: "<@#{id}> #{real_name.upcase} te buscan, si no contestas les doy tu correo para que hagan spam #{user.profile.email} y tu cara #{image}", channel: data.channel)
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
