require_relative 'time_formatter'

class App

  def call(env)
    request = Rack::Request.new(env)

    return response(200, ["Not found\n"]) if wrong_request?(request)
    set_response(request)
  end

  private

  def wrong_request?(request)
    !request.get? || request.path_info != '/time' || request.params['format'].nil?
  end

  def set_response(request)
    time_formatter = TimeFormatter.new(request.params['format'])

    if time_formatter.invalid?
      response(404, ["Unknown time format #{time_formatter.forbidden_values}\n"])
    else
      response(200, [time_formatter.call])
    end
  end

  def response(status, body)
    [status, { 'Content-Type' => 'text/plain' }, body]
  end
end
