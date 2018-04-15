module LinkedList
  # Node class to manage the stack
  class Node
    attr_accessor :value, :next_node

    def initialize(value, next_node)
      @value = value
      @next_node = next_node
      @size = 0
    end
  end

  # Stack class to manage the linked list for the math method
  class Stack
    attr_accessor :size
    def initialize
      @first = nil
      @size = 0
    end

    def push(value)
      @first = Node.new(value, @first)
      @size += 1
    end
    alias_method :"<<", :push

    def pop
      return 'Stack is empty' if empty?
      value = @first.value
      @first = @first.next_node
      @size -= 1
      value
    end

    def empty?
      @first.nil?
    end
  end
end
