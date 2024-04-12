class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

#BST class for X,Y,Z sets
class BST
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    @root = insert_helper(@root, value)  #Calls function to insert node, sets root if first node
  end

  #Recursive function to put node in right spot
  def insert_helper(node, value)
    return Node.new(value) unless node #Found right node place, creates node

    #Left or right subtree based on smaller or larger value
    if value < node.value
      node.left = insert_helper(node.left, value)
    elsif value > node.value
      node.right = insert_helper(node.right, value)
    end
    #Nothing is done when value is equal, no duplicates inserted
    node
  end

  #Function to print BST with inorder traversal, done recursively
  def inorder_traversal(node = @root)
    if node
      left_str = inorder_traversal(node.left)
      node_str = "#{node.value} "
      right_str = inorder_traversal(node.right)

      left_str + node_str + right_str
    else
      ""
    end
  end
end

#Class to perform set operations on X,Y,Z
class SetOperations
  attr_accessor :xset, :yset, :zset

  def initialize
    @xset = BST.new
    @yset = BST.new
    @zset = BST.new
  end

  #Split input values by comma into array of integers, and for each value, insert into the bst
  def insert_values(bst, values)
    values.split(",").map(&:to_i).each do |value|
      bst.insert(value)
    end
  end

  #Prints contents of x,y,z
  def print_sets
    x_traversal = @xset.inorder_traversal
    y_traversal = @yset.inorder_traversal
    z_traversal = @zset.inorder_traversal
    puts "X -> " + x_traversal
    puts "Y -> " + y_traversal
    puts "Z -> " + z_traversal
  end

  #Rotates set contents of x,y,z
  def rotate_sets
    temp = @xset
    @xset = @zset
    @zset = @yset
    @yset = temp
  end

  #Switches set contents of x and y
  def switch_sets
    @xset, @yset = @yset, @xset
  end

  #Union set x and y
  def union_sets
    merge_sets(@xset, @yset.root)
  end

  #Helper function that iterates and inserts every element of y into x
  def merge_sets(set, node)
    if node
      merge_sets(set, node.left)
      merge_sets(set, node.right)
      @xset.insert(node.value)
    end
  end

  #Intersection of set x and y, stored in result, and xset set to result
  def intersection_sets
    result = BST.new
    intersect_sets(@xset.root, @yset.root, result)
    @xset = result
  end

  #Helper intersection function
  def intersect_sets(node1, node2, result)
    #Reached end of one of the trees, No more intersection, return null
    return nil if node1.nil? || node2.nil?

    #Check right subtree or left subtree if not equal value
    if node1.value < node2.value
      intersect_sets(node1.right, node2, result)
    elsif node1.value > node2.value
      intersect_sets(node1.left, node2, result)
    else
      result.insert(node1.value) #Found intersection, add to result
      intersect_sets(node1.left, node2.left, result)
      intersect_sets(node1.right, node2.right, result)
    end
  end

  #Creates deep copy of x into y
  def deep_copy
    @yset = BST.new
    deep_copy_recursive(@xset.root, @yset)
  end

  #Recursively iterates through x, inserts node into y
  def deep_copy_recursive(node, new_set)
    return unless node

    new_set.insert(node.value)
    deep_copy_recursive(node.left, new_set)
    deep_copy_recursive(node.right, new_set)
  end

  #Applying lambda string to x
  def apply_lambda(lambda_string)
    lambda_function = eval(lambda_string)
    apply_lambda_to_set(@xset.root, lambda_function)
  end

  #Updates each node value with the lambda function call applied
  def apply_lambda_to_set(node, lambda_function)
    return unless node

    apply_lambda_to_set(node.left, lambda_function)
    node.value = lambda_function.call(node.value)
    apply_lambda_to_set(node.right, lambda_function)
  end
end

def main
  sets = SetOperations.new

  loop do
    puts "Command: "
    command = gets.chomp.downcase
    c = command.split(" ")[0]

    case c
    when /x/
      sets.xset = BST.new
      sets.insert_values(sets.xset, command.split(" ")[1])
      sets.print_sets
      puts ""
    when /y/
      sets.yset = BST.new
      sets.insert_values(sets.yset, command.split(" ")[1])
      sets.print_sets
      puts ""
    when /z/
      sets.zset = BST.new
      sets.insert_values(sets.zset, command.split(" ")[1])
      sets.print_sets
      puts ""
    when /a/
      sets.insert_values(sets.xset, command.split(" ")[1])
      sets.print_sets
      puts ""
    when /r/
      sets.rotate_sets
      sets.print_sets
      puts ""
    when /s/
      sets.switch_sets
      sets.print_sets
      puts ""
    when /u/
      sets.union_sets
      sets.print_sets
      puts ""
    when /i/
      sets.intersection_sets
      sets.print_sets
      puts ""
    when /c/
      sets.deep_copy
      sets.print_sets
    when /l/
      sets.apply_lambda(command.split(" ", 2)[1])
      sets.print_sets
    when /q/
      break
    else
      puts "Invalid command. Please try again."
      puts ""
    end
  end
end

main
