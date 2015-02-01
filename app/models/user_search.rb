class UserSearch
  attr_accessor :sort, :pagination

  def initialize(sort: nil, pagination: nil)
    @sort = sort
    @pagination = pagination
  end

  def call
    result = User.all.tap do |users|
      apply_sort(users) if sort && sort[:predicate]
      apply_pagination(users) if pagination
    end
    result
  end

  private

  def apply_sort(data)
    order = sort[:reverse] ? "desc" : "asc"
    data.order!("#{sort[:predicate]} #{order}")
  end

  def apply_pagination(data)
    data.limit!(pagination[:number]).offset!(pagination[:start])
  end
end
