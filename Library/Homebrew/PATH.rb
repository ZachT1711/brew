class PATH
  def initialize(*paths)
    @paths = parse(*paths)
  end

  def prepend(*paths)
    @paths = parse(*paths, *@paths)
    self
  end

  def append(*paths)
    @paths = parse(*@paths, *paths)
    self
  end

  def to_ary
    @paths
  end
  alias to_a to_ary

  def to_str
    @paths.join(File::PATH_SEPARATOR)
  end
  alias to_s to_str

  def ==(other)
    if other.respond_to?(:to_ary)
      return true if to_ary == other.to_ary
    end

    if other.respond_to?(:to_str)
      return true if to_str == other.to_str
    end

    false
  end

  def empty?
    @paths.empty?
  end

  def validate
    validated_path = self.class.new(@paths.select(&File.method(:directory?)))
    validated_path unless validated_path.empty?
  end

  private

  def parse(*paths)
    paths
      .flatten
      .flat_map { |p| p.respond_to?(:to_str) ? p.to_str.split(File::PATH_SEPARATOR): p }
      .compact
      .map { |p| p.respond_to?(:to_path) ? p.to_path : p.to_str }
      .uniq
  end
end
