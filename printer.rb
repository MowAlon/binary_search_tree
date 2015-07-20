class Printer

  def initialize(tree)
  	@tree = tree
  end

  def tree
      width = 69
      puts "🌲".center(width)
      # puts "/-\\".center(width)
      puts "|     |".center(width)
    if @tree.head
      q1, q2 = [], []
      q1 << @tree.head
      while !q1.empty? || !q2.empty?
        line = "🍂"
        while !q1.empty?
          current = q1.shift
          line += "   #{current.value}  🍁"
          q2 << current.left if current.left?
          q2 << current.right if current.right?
        end
        puts (line.chop + "🍂").center(width)
        line = "🍂"
        while !q2.empty?
          current = q2.shift
          line += "   #{current.value}  🍁"
          q1 << current.left if current.left?
          q1 << current.right if current.right?
        end
        if line[-1] != "🍂"
          puts (line.chop + "🍂").center(width)
        end
      end
    end
    print_random_base(width, 5)
  end

  def print_random_base(width, flower_count)
    puts "|     |".center(width)
    puts "|  🐹  |".center(width)
    puts "|     |".center(width)
    base = "/_______\\".center(width)
    flower_count.times do
      random_position = rand(width)
      if random_position.between?(width/10, width/10*9) && base[random_position] == " "
        random_emoji = rand(3)
        case random_emoji
        when 0
          base[random_position] = "🌻"
        when 1
          base[random_position] = "🌱"
        when 2
          base[random_position] = "🍄"
        end
      end
    end
    puts base
  end

  def matts_tree(pivot=@tree.head)
    system("CLEAR")
    puts "\n\n"
    raise ArgumentError, "Tried to print empty tree" if pivot.nil?
    current_elements = []
    next_elements = []
    line_num = 0
    current_elements << pivot
    begin
      data_line = ""
      branches_line = ""
      next_elements.clear

      while !current_elements.empty?
        current = current_elements.shift
        data_line << "#{current.value}".center(2 ** (5 - line_num))
        next_elements.concat(child_elements(current))
        branches_line << child_branches(current, line_num).center(2 ** (5 - line_num))
      end

      puts data_line.center(60)
      puts branches_line.center(60)

      current_elements.clear.concat(next_elements)
      line_num += 1
    end while branches_line =~ /[\S]+/
  end

  def child_branches(node, line_num)
    branches = ""
    branches << left_branch(node)
    branches << right_branch(node)
  end

  def left_branch(node)
    if node.left?
      "/"
    else
      " "
    end
  end

  def right_branch(node)
    if node.right?
      "\\"
    else
      " "
    end
  end

  def child_elements(node)
    elements = []
    elements << left_element(node)
    elements << right_element(node)
  end

  def left_element(node)
    node.left? ? node.left : Node.new("")
  end

  def right_element(node)
    node.right? ? node.right : Node.new("")
  end
end
