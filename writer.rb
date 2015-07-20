class Writer

  def initialize(tree, filename)
  	@tree = tree
    @filename = filename
  end

  def ordered_file
    output = File.open(@filename, 'w')
    if @tree.head
      stack = []
      current = @tree.head
      while current || !stack.empty?
        while current
          stack << current
          current = current.left
        end
        while current.nil? && !stack.empty?
          current = stack.last
          output.write(stack.pop.value.to_s + "\n")
          current = current.right
        end
      end
    end
    output.close
  end
end
