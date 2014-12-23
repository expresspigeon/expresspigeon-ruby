module ExpressPigeon
  class MetaHash < Hash
    def initialize(delegate)
      super
      @delegate = delegate
      @delegate.each_key do |k|
        v = @delegate[k] # lets go only one level down for now
        if v.kind_of? Hash
          @delegate[k] = MetaHash.new(v)
        end
      end
    end

    def method_missing(m, *_args, &_block)
      @delegate[m.to_s]
    end

    def to_s
      @delegate.to_s
    end
  end
end
