class Searcher
  def initialize(data, options)
    @data = data
    @options = options
  end

  def call
    if @options.present?
      @options.each { |k, v| @data.where!("#{k} like ?", "%#{v}%") }
    end
  end
end
