class TimeFormatter
  FORMATS = {
    "year" => "%Y", "month" => "%m", "day" => "%d",
    "hour" => "%H", "minute" => "%M", "second" => "%S"
  }

  attr_reader :forbidden_values, :allowed_values

  def initialize(format)
    values = format.split(',')
    @forbidden_values = values - FORMATS.keys
    @allowed_values = (values - @forbidden_values).uniq
  end

  def call
    Time.now.strftime(formatted_string)
  end

  def invalid?
    forbidden_values.any?
  end

  private

  def formatted_string
    allowed_values.map { |value| FORMATS[value] }.join('-') + "\n"
  end
end
