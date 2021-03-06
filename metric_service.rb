require 'httparty'

class MetricService

  CREDENTIALS_YAML_PATH = 'config/credentials.yml'

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
    @yml = YAML.load_file(CREDENTIALS_YAML_PATH)
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
    case response.code.to_i
    when 200
      response.map { |metric| metric_row(metric) }
    when 404
      'Sorry there is no data'
    when 500...600
      'Something went wrong, try again later'
    end
  end

  def metric_row(metric)
    "start_date: `#{metric["start_date"]}` end_date: `#{metric["end_date"]}` score: `#{metric["score"]}`"
  end

end
