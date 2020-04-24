class TimeFormatter
  FORMATS = {
    "year" => "%Y", "month" => "%m", "day" => "%d",
    "hour" => "%H", "minute" => "%M", "second" => "%S"
  }

  def initialize(format)
    @values = format.split(',')
    @forbidden_values = []
    @allowed_values = []
  end

  def call
    self.forbidden_values = values - FORMATS.keys
    self.allowed_values = (values - forbidden_values).uniq
  end

  def valid?
    forbidden_values.empty?
  end

  def get_time
    string = allowed_values.map { |value| FORMATS[value] }.join('-') + "\n"
    Time.now.strftime(string)
  end

  def get_error
    "Unknown time format #{forbidden_values}\n"
  end

  private

  attr_accessor :forbidden_values, :allowed_values, :values
end
