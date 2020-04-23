class QueryParser
  PERMITTED = %w[year month day hour minute second]

  def initialize(app)
    @app = app
  end

  def call(env)
    parse(env) unless env['QUERY_STRING'].empty?
    @app.call(env)
  end

  private

  def parse(env)
    query = env['QUERY_STRING'].split("=")
    env['field'] = 'format' if query[0] == 'format'

    if query[1]
      values = query[1].split("%2c")
      forbidden = values - PERMITTED

      env['forbidden'] = forbidden
      env['permitted'] = values - forbidden
    end

  end
end
