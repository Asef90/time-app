class TimeFormatter
  FORMATS = {
    'year' => 'Y', 'month' => 'm', 'day' => 'd',
    'hour' => 'H', 'minute' => 'M', 'second' => 'S'
  }

  def initialize(query_string)
    @query_array = query_string.split('=')
  end

  def field
    @query_array[0]
  end

  def values
    return @query_array[1].split(',') if @query_array[1]
    []
  end

  def forbidden_values
    values - FORMATS.keys
  end

  def permitted_values
    values - forbidden_values
  end

  def formatted_string
    formatted_array = []
    FORMATS.each do |key, value|
      formatted_array << "%#{value}" if permitted_values.include?(key)
    end

    Time.now.strftime(formatted_array.join('-') + "\n")
  end
end
