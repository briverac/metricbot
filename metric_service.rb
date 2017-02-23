require 'HTTParty'

class MetricService
  attr_reader :url
  attr_reader :metric_id
  attr_reader :location
  attr_reader :compute_period
  attr_reader :yml

  def initialize(url, metric_id, compute_period, location)
    @url = url
    @metric_id = metric_id
    @compute_period = compute_period
    @location = location
    @yml = YAML.load_file('credentials.yml')
  end

  def response
    human_response(HTTParty.get(request, headers: headers))
  end

  private

  def request
    "#{url}/api/2/metrics/#{metric_id}/values.json?location=#{location}&compute_period=#{compute_period}"
  end

  def headers
    {
      'Content-Type' => yml['content_type'],
      'Authorization' => yml['authorization'],
      'X-API-KEY' => yml['x_api_key']
    }
  end

  def human_response(response)
    response.map { |metric| metric_row(metric) }
  end

  def metric_row(metric)
    "start_date: #{metric["start_date"]} end_date: #{metric["end_date"]} score: #{metric["score"]}"
  end

end
