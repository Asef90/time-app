class App

  FORMATS = {
    'year' => 'Y', 'month' => 'm', 'day' => 'd',
    'hour' => 'H', 'minute' => 'M', 'second' => 'S'
  }

  def call(env)
    status = define_status(env)
    body = define_body(status, env['permitted'], env['forbidden'])

    [status, headers, body]
  end

  private

  def define_status(env)
    return 404 if env['PATH_INFO'] != '/time' || env['field'] != 'format' || env['REQUEST_METHOD'] != 'GET'
    return 200 if env['forbidden'].nil? || env['forbidden'].empty?
    400
  end

  def headers
    {'Content-Type' => 'text/plain'}
  end

  def define_body(status, permitted, forbidden)
    return ["Not found\n"] if status == 404
    return ["Unknown time format #{forbidden}\n"] if status == 400
    [Time.now.strftime(format_permitted(permitted)) + "\n"]
  end

  def format_permitted(permitted)
    return "" if permitted.nil?

    formatted_array = []
    FORMATS.each do |key, value|
      formatted_array << "%#{FORMATS[key]}" if permitted.include?(key)
    end
    formatted_string = formatted_array.join('-')
  end
end
