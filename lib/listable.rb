module Listable
  def format_description(description)
    "#{description}".ljust(25)
  end
  def format_date(options)
    start_date = options[:start_date]
    end_date = options[:end_date]
    dates = ""
    dates = start_date.strftime("%D") + " " if start_date
    dates << "due: " + end_date.strftime("%D") if end_date
    dates = "N/A" if !start_date && !end_date
    return dates
  end
  def format_priority(priority)
    value = " ⇧".colorize(:red) if priority == "high"
    value = " ⇨".colorize(:yellow) if priority == "medium"
    value = " ⇩".colorize(:green) if priority == "low"
    value = "" if !priority
    return value
  end
  def is_valid_priority?(priority)
    priority == "high" || priority == "medium" || priority == "low" || !priority
  end
end
