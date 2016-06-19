class TodoItem
  include Listable
  include UdaciListErrors
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    @description = description
    @due = options[:due] ? Date.parse(options[:due]) : options[:due]
    unless is_valid_priority?(options[:priority])
      raise UdaciListErrors::InvalidPriorityValue, "Priority '#{options[:priority]}' is not supported"
    end
    @priority = options[:priority]
  end
  def details
    format_description(@description) +
    format_date(end_date: @due) +
    format_priority(@priority)
  end
end
