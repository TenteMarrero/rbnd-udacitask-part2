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
    allowed_types = { todo: TodoItem, link: LinkItem, event: EventItem, email: EmailItem }
    # Another option: set allowed_types as a class variable, but that will mean you will need to use 'require'
    # for each item at the top of the file as well. If done that way, the requires aren't necessary in app.rb
    @items.push allowed_types[type.to_sym].new description, options
  end
  def delete(*indexes)
    if are_indexes_valid? indexes
      indexes.sort! { |x,y| y <=> x }
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
    types = ['todo', 'event', 'link', 'email']
    types.include? type
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
