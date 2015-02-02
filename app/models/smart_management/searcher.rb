module SmartManagement
  class Searcher
    def initialize(data, options)
      @data = data
      @options = options
    end

    def call
      if @options.present?
        @options.each { |k, v| @data = @data.where("#{k} like ?", "%#{v}%") }
      end
      @data
    end
  end
end
