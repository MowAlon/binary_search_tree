require './node'
require './printer'
require './writer'

class BinarySearchTree
  attr_reader :head

  def build_tree(data)
    data.each_line { |line| add_node(line.chomp) }
  end

  def add_node(value)
    if head.nil?
      @head = Node.new(value)
    else
      if value < parent(value).value
        parent(value).left = Node.new(value)
      else
        parent(value).right = Node.new(value)
      end
    end
  end

  def max
    if head
      max = head
      while max.right?
        max = max.right
      end
      max.value
    end
  end

  def min
    if head
      min = head
      while min.left?
        min = min.left
      end
      min.value
    end
  end

  def includes?(value)
    if head && value
      if value == head.value
        true
        else
        parent = parent(value)
        if value < parent.value
          parent.left? && value == parent.left.value
        else
          parent.right? && value == parent.right.value
        end
      end
    end
  end

  def parent(value)
    if head && head.value != value
      parent = head
      child = child(value, parent)
      while child && child.value != value
        parent = child
        child = child(value, child)
      end
      parent
    end
  end

  def child(value, node)
    if !is_node?(node) then node = convert_to_node(node) end
    if value < node.value then child = node.left else child = node.right end
  end

  def find(value)
  	if includes?(value)
      if head.value == value then head else child(value, parent(value)) end
    end
  end

  def is_node?(node)
    node.class == Node
  end

  def convert_to_node(value)
  	if value then find(value) end
  end

  def delete(node)
    if !is_node?(node) then node = convert_to_node(node) end
    if node
      if is_leaf?(node) || one_child?(node) then light_delete(node) else heavy_delete(node) end
    end
  end

  def light_delete(node)
    if node.left? then child = node.left else child = node.right end

    if head == node then @head = child
    else
      parent = parent(node.value)
      if parent.left == node then parent.left = child else parent.right = child end
    end
  end

  def heavy_delete(node)
    predecessor = node.left
    while predecessor.right?
      predecessor = predecessor.right
    end
    replacement_value = predecessor.value
    light_delete(predecessor)
    node.value = replacement_value
  end

  def is_leaf?(node)
    if !is_node?(node) then node = convert_to_node(node) end
    if node then node.left.nil? && node.right.nil? end
  end

  def one_child?(node)
    if !is_node?(node) then node = convert_to_node(node) end
  	if node.left? then node.right.nil? elsif node.right? then node.left.nil? end
  end

  def leaf_count
    if head
      stack = []
      count = 0
      current = head
      while current || !stack.empty?
        while current
          stack << current
          current = current.left
        end
        while current.nil? && !stack.empty?
          current = stack.last
          count += 1 if is_leaf?(stack.pop)
          current = current.right
        end
      end
    end
    count
  end

  def height
    if head
      count = 0
      q1, q2 = [], []
      q1 << head
      while !q1.empty? || !q2.empty?
        while !q1.empty?
          current = q1.shift
          q2 << current.left if current.left?
          q2 << current.right if current.right?
        end
        count += 1
        q2_filled = !q2.empty?
        while !q2.empty?
          current = q2.shift
          q1 << current.left if current.left?
          q1 << current.right if current.right?
        end
        if q2_filled
          count += 1
        end
        q2_filled = false
      end
      count
    else
      0
    end
  end

end
# require 'pry';binding.pry
