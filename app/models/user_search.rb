class UserSearch
  attr_accessor :sort, :pagination, :search

  def initialize(sort: nil, pagination: nil, search: nil)
    @sort = sort
    @pagination = pagination
    @search = search
  end

  def call
    User.all.tap do |users|
      apply_sort(users) if sort && sort[:predicate]
      apply_pagination(users) if pagination
      apply_search(users) if search
    end
  end

  private

  def apply_sort(data)
    order = sort[:reverse] ? "desc" : "asc"
    data.order!("#{sort[:predicate]} #{order}")
  end

  def apply_pagination(data)
    data.limit!(pagination[:number]).offset!(pagination[:start])
  end

  def apply_search(data)
    search.each { |k, v| data.where!("#{k} like ?", "%#{v}%") }
  end
end
