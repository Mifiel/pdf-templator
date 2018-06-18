module PdfTemplator
  class Type
    attr_reader :content
    attr_reader :args

    def initialize(content, args = {})
      @content = content
      @args = args
    end

    # This method is called immediately when a type is found.
    # Override it in sub-classes.
    def call(_value)
      raise NotImplementedError,
        "you must override the `call' method for option #{self.class}"
    end
  end
end
