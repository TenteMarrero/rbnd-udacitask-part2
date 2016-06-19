class EmailItem
  include Listable
  attr_reader :description, :name, :type

  def initialize(email, options={})
    @type = "email"
    @description = email
    @name = options[:name]
  end
  def format_name
    @name ? @name : ""
  end
  def details
    [format_description(@description), "name: " + format_name]
  end
end
