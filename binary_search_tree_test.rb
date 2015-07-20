gem 'minitest', '~> 5.7.0'
require 'minitest/autorun'
require 'minitest/pride'
require './binary_search_tree'

class BinarySearchTreeTest < Minitest::Test
  attr_accessor :tree
  attr_reader :writer

  def setup
    filename = ARGV.sample(1)[0]
    @tree = BinarySearchTree.new
    # @printer = Printer.new(tree)
  end

  def test_it_starts_with_a_dead_head
    assert_nil tree.head
  end

  def test_it_adds_a_node_to_the_tree
    tree.add_node("hello")

    assert_equal "hello", tree.head.value
  end

  def test_it_adds_many_nodes_in_the_correct_locations
    tree.add_node("you're")
    tree.add_node("the")
    tree.add_node("man")
    tree.add_node("now")
    tree.add_node("dawg")

    assert_equal "you're", tree.head.value
    assert_equal "the", tree.head.left.value
    assert_equal "man", tree.head.left.left.value
    assert_equal "now", tree.head.left.left.right.value
    assert_equal "dawg", tree.head.left.left.left.value
  end

  def test_it_knows_when_a_value_is_in_the_tree
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))

    assert tree.includes?('00057')
    assert tree.includes?('03245')
  end

  def test_it_finds_a_nodes_location
    tree.add_node("you're")
    tree.add_node("the")
    tree.add_node("man")
    tree.add_node("now")
    tree.add_node("dawg")

      assert_equal "man", tree.head.left.left.value
    assert_equal tree.head.left.left, tree.find("man")
      assert_equal "now", tree.head.left.left.right.value
  	assert_equal tree.head.left.left.right, tree.find("now")
  end

  def test_it_builds_a_tree_from_a_file
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))

  	assert_equal '00003', tree.head.value
    assert_equal '00002', tree.head.left.value
    assert_equal '00034', tree.head.right.value
    assert_equal '00004', tree.head.right.left.value

    assert_equal '00006', tree.find('00006').value
    assert_equal '03245', tree.find('03245').value
    assert tree.includes?('00346')
    assert tree.includes?('02334')
  end

  def test_it_finds_the_minimum_value_in_the_tree
    numbers = BinarySearchTree.new
    numbers.build_tree(File.read('./lib/input/numeric_data.txt'))
    words = BinarySearchTree.new
    words.build_tree(File.read('./lib/input/word_data.txt'))
    more_numbers = BinarySearchTree.new
    more_numbers.build_tree(File.read('./lib/input/numeric_data2.txt'))

    assert_equal "00002", numbers.min
    assert_equal "'items'", words.min
    assert_equal "089", more_numbers.min
  end

  def test_it_finds_the_maximum_value_in_the_tree
    numbers = BinarySearchTree.new
    numbers.build_tree(File.read('./lib/input/numeric_data.txt'))
    words = BinarySearchTree.new
    words.build_tree(File.read('./lib/input/word_data.txt'))
    more_numbers = BinarySearchTree.new
    more_numbers.build_tree(File.read('./lib/input/numeric_data2.txt'))

    assert_equal "03245", numbers.max
    assert_equal "type", words.max
    assert_equal "890", more_numbers.max
  end

  def test_it_can_find_a_parent_node_from_value
    tree.add_node("you're")
    tree.add_node("the")
    tree.add_node("zippiest")
    tree.add_node("man")
    tree.add_node("now")
    tree.add_node("dawg")

    assert_nil tree.parent("you're")
    assert_equal tree.head, tree.parent("the")
    assert_equal tree.head, tree.parent("zippiest")
    assert_equal tree.head.left, tree.parent("man")
    assert_equal tree.head.left.left, tree.parent("now")
    assert_equal tree.head.left.left, tree.parent("dawg")
  end

  def test_it_deletes_by_node_or_value
    tree.add_node(42)
    tree.delete(tree.find(42))
    tree.add_node(36)
    tree.delete(36)

    assert_nil tree.head
  end

  def test_it_deletes_a_solo_node
    tree.add_node("Dawg")
    tree.delete("Dawg")

    assert_nil tree.head
  end

  def test_it_does_not_delete_when_the_data_does_not_match
    tree.add_node("42")
    tree.add_node("Dawg")
    tree.delete("Socko")

    assert tree.includes?("42")
    assert tree.includes?("Dawg")
  end

  def test_it_recognizes_leaves
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))

    assert tree.is_leaf?(tree.find('00002'))
    assert tree.is_leaf?(tree.find('00006'))
    assert tree.is_leaf?(tree.find('00346'))
    refute tree.is_leaf?(tree.find('00004'))
    refute tree.is_leaf?(tree.find('00034'))
    refute tree.is_leaf?(tree.find('absent value'))
  end

  def test_it_deletes_a_leaf
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))

    assert tree.is_leaf?('00057')
      tree.delete('00057')
    refute tree.includes?('00057')
  end

  def test_it_recognizes_parents_of_an_only_child
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))

  	assert tree.one_child?('03234')
    assert tree.one_child?(tree.find('00004'))
    refute tree.one_child?('00003')
    refute tree.one_child?(tree.find('00345'))
  end

  def test_it_deletes_a_node_with_one_child
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))

    assert tree.one_child?('03234')
      tree.delete('03234')
    refute tree.includes?('03234')
    assert_equal tree.find('02334'), tree.child('02334','03245')
    assert tree.one_child?('00004')
      tree.delete('00004')
    refute tree.includes?('00004')
    assert_equal tree.find('00006'), tree.child('00006','00034')
  end

  def test_it_deletes_a_node_with_two_children
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))
    tree.delete('00345')

    refute tree.includes?('00345')
    assert tree.find('00057') == tree.child('00057','00045') && tree.find('00057') == tree.parent('03245')
  end

  def test_it_deletes_head_when_it_has_two_children
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))
    tree.delete(tree.find('00003'))

    refute tree.includes?('00003')
    assert tree.find('00002') == tree.head && tree.find('00002') == tree.parent('00034')
  end

  def test_it_writes_a_sorted_file_of_values
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))
    @writer = Writer.new(tree, './lib/output/test_output.txt')
    writer.ordered_file
    output_check = File.read('./lib/output/test_output.txt')

    assert_equal "00002\n00003\n00004\n00006\n00034\n00045\n00057\n00345\n00346\n02334\n03234\n03245\n", output_check
  end

  def test_it_can_count_the_leaves
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))
    word_tree = BinarySearchTree.new
    word_tree.build_tree(File.read('./lib/input/word_data.txt'))

    assert_equal 4, tree.leaf_count
    assert_equal 8, word_tree.leaf_count
  end

  def test_it_knows_tree_height
    tree.build_tree(File.read('./lib/input/numeric_data.txt'))
    word_tree = BinarySearchTree.new
    word_tree.build_tree(File.read('./lib/input/word_data.txt'))

    assert_equal 8, tree.height
    assert_equal 13, word_tree.height
  end

end
