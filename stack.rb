module LinkedList
  class Node
    attr_accessor :value, :next_node, :size

    def initialize(value, next_node)
      @value = value
      @next_node = next_node
      @size = 0
    end
  end

  class Stack
    def initialize
      @first = nil
      @size = 0
    end

    def push(value)
      @first = Node.new(value, @first)
      @size = @size + 1
    end
    alias_method :"<<", :push

    def pop
      raise "Stack is empty" if is_empty?
      value = @first.value
      @first = @first.next_node
      @size -= 1
      value
    end

    def is_empty?
      @first.nil?
    end

    def size
      @size
    end
  end
end