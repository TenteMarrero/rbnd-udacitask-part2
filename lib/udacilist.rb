class UdaciList
  include UdaciListErrors

  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title]
    @items = []
  end
  def add(type, description, options={})
    type = type.downcase
    check_valid_type(type)
    @items.push TodoItem.new(description, options) if type == "todo"
    @items.push EventItem.new(description, options) if type == "event"
    @items.push LinkItem.new(description, options) if type == "link"
    @items.push EmailItem.new(description, options) if type == "email"
  end
  def delete(*indexes)
    if are_indexes_valid? indexes
      indexes.each {|index| @items.delete_at(index - 1)}
    end
  end
  def all
    puts print_title
    puts print_table(@items)
  end
  def filter(type)
    check_valid_type(type)
    filtered_items = @items.select{|item| item.type == type}
    if (filtered_items.length > 0)
      puts print_title
      puts print_table(filtered_items)
    else
      puts "No items of type #{type} found"
    end
  end

  private
  def check_valid_type(type)
    unless is_valid_type?(type)
      raise UdaciListErrors::InvalidItemType, "Type '#{type}' is not supported"
    end
  end
  def is_valid_type?(type)
    type == "todo" || type == "event" || type == "link" || type == "email"
  end
  def valid_index?(index)
    @items.length >= index
  end
  def print_title
    if (@title)
      "-" * @title.length + "\n" +
      @title + "\n" +
      "-" * @title.length
    end
  end
  def print_table(items)
    rows = []
    items.each_with_index do |item, position|
      rows << [position + 1, item.type.capitalize].concat(item.details)
    end
    Terminal::Table.new :rows => rows
  end
  def are_indexes_valid?(indexes)
    indexes.each do |index|
      unless valid_index?(index)
        raise UdaciListErrors::IndexExceedsListSize, "#{index} exceeds the list size"
      end
    end
    true
  end
end
