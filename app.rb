require_relative 'time_formatter'

class App

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new
    @time_formatter = TimeFormatter.new(@request.query_string)

    @response['Content-Type'] = 'text/plain'
    @response.status = set_status
    @response.body = set_body
    @response.finish
  end

  private

  def set_status
    return 404 unless @request.path_info == '/time' && @request.get? && @time_formatter.field == 'format'
    return 200 if @time_formatter.forbidden_values.empty?
    400
  end

  def set_body
    return ["Not found\n"] if @response.status == 404
    return ["Unknown time format #{@time_formatter.forbidden_values}\n"] if @response.status == 400
    [@time_formatter.formatted_string]
  end
end
