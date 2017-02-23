require 'HTTParty'

class MetricService
  attr_reader :url
  attr_reader :metric_id
  attr_reader :location
  attr_reader :compute_period

  def initialize(url, metric_id, compute_period, location)
    @url = url
    @metric_id = metric_id
    @compute_period = compute_period
    @location = location
  end

  def response
    HTTParty.get(request, headers: headers)
  end

  private

  def request
    "#{url}/api/2/metrics/#{metric_id}/values.json?location=#{location}&compute_period=#{compute_period}"
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'Authorization' => 'Basic VVNFUk5BTUUxOnBhc3N3b3Jk',
      'X-API-KEY' => '9a3d7cc7806c4390e07399d362c6a04a491c5cc5ad27a16aa1f22b678b92888d'
    }
  end

end
