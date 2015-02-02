module SmartManagement
  class Paginer
    def initialize(data, options)
      @data = data
      @options = options
    end

    def call
      if @options.present?
        @data = @data.limit(@options[:number]).offset(@options[:start])
      end
      @data
    end
  end
end
