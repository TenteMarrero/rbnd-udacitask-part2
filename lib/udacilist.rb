class UdaciList
  include UdaciListErrors

  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title]
    @items = []
  end
  def add(type, description, options={})
    type = type.downcase
    @items.push TodoItem.new(description, options) if type == "todo"
    @items.push EventItem.new(description, options) if type == "event"
    @items.push LinkItem.new(description, options) if type == "link"
    unless is_valid_type?(type)
      raise UdaciListErrors::InvalidItemType, "Type '#{type}' is not supported"
    end
  end
  def delete(index)
    unless valid_index?(index)
      raise UdaciListErrors::IndexExceedsListSize, "#{index} exceeds the list size"
    end
    @items.delete_at(index - 1)
  end
  def all
    puts "-" * @title.length
    puts @title
    puts "-" * @title.length
    @items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end

  private
  def is_valid_type?(type)
    type == "todo" || type == "event" || type == "link"
  end
  def valid_index?(index)
    @items.length >= index
  end
end
