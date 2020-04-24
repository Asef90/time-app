require_relative 'time_formatter'

class App

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new

    return not_found unless correct_request

    @time_formatter = TimeFormatter.new(@request.params['format'])

    return bad_request unless correct_format

    ok
  end

  private

  def correct_request
    @request.get? && @request.path_info == '/time' && @request.params['format']
  end

  def correct_format
    @time_formatter.valid?
  end

  def ok
    response(status: 200, body: @time_formatter.call)
  end

  def not_found
    response(status: 400, body: "Not found\n")
  end

  def bad_request
    response(status: 404, body: "Unknown time format #{@time_formatter.forbidden_values}\n")
  end

  def response(params = {})
    @response.status = params[:status]
    @response.body = [params[:body]]
    @response['Content-Type'] = 'text/plain'
    @response.finish
  end
end
