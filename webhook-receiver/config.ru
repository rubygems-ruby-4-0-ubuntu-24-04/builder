# -*- ruby -*-

require "json"
require "open-uri"

class WebhookReceiver
  def initialize
  end

  def call(env)
    request = Rack::Request.new(env)
    process(request) if request.post?
    [200, {"Content-Type" => "text/plain"}, [""]]
  end

  private
  def process(request)
    data = request.body.read
    gem_info = JSON.parse(data)
    submit_build_job(gem_info["name"], gem_info["version"])
  end

  def github_token
    File.read(File.join(base_dir, ".github_token")).strip
  end

  def submit_build_job(name, version)
    user = "rubygems-ruby-4-0-ubuntu-24-04"
    repository = "builder"
    workflow = "build.yaml"
    url = "https://api.github.com/repos/#{user}/#{repository}/actions/workflows/#{workflow}/dispatches"
    data = {
      "ref" => "main",
      "inputs" => {
        "name" => name,
        "version" => version,
      }
    }
    headers = {
      "authorization" => "Bearer #{github_token}",
      "content-type" => "application/json",
    }
    Net::HTTP.post(url, data.to_json, headers)
  end

  def base_dir
    File.dirname(__FILE__)
  end
end

use Rack::ShowExceptions
use Rack::ContentType, "text/plain"
use Rack::ContentLength

run WebhookReceiver.new
