module SmartManagement
  class Sorter
    def initialize(data, options)
      @data = data
      @options = options
    end

    def call
      if @options.present?
        order = @options[:reverse] ? "desc" : "asc"
        @data = @data.order("#{@options[:predicate]} #{order}")
      end
      @data
    end
  end
end
