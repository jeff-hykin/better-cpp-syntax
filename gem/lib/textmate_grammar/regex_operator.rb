# frozen_string_literal: true

#
# Split arr in two
# Walks arr from left to right and splits it on the first element that the
# block returns false
# this means that the block returned true for all lements in the left half
# and false for the first element of the right half
# the order of elements is not changed
#
# @param [Array] arr The array to break
#
# @yield [RegexOperator,String] the element to check
#
# @return [Array<(Array,Array)>] The two halfs
#
def break_left(arr)
    left = arr.take_while do |elem|
        next !(yield elem)
    end
    [left, arr[(left.length)..-1]]
end

#
# (@see break_left)
# Walks the array from right to left spliting where the block returns false
#
def break_right(arr)
    right = arr.reverse.take_while do |elem|
        next !(yield elem)
    end.reverse
    [arr[0..-(right.length+1)], right]
end

#
# RegexOperator is used to provide complicated combining behavior that is not possible
# to implement in PatternBase#do_evaluate_self
#
# Each PatternBase when evaluated produces a RegexOperator and a regexstring
# RegexOperator::evaluate takes that array and produces a single regexstring
#
class RegexOperator
    # @return [number] The precedence of the operator, lower numbers are processed earlier
    attr_accessor :precedence
    # @return [:left, :right] is the operator left of right associative
    # right associative is processed first
    attr_accessor :association

    #
    # Evaluate the array of RegexStrings and RegexOperators
    #
    # @param [Array<String,RegexOperator>] arr the array to evaluate
    #
    # @return [String] The evaluated string
    #
    def self.evaluate(arr)
        # grab all operators and sort by precedence and association
        ops = arr.reject { |v| v.is_a?(String) }.sort do |a, b|
            if a.precedence == b.precedence
                next 0 if a.association == b.association
                next -1 if a.association == :left

                next 1
            end

            a.precedence - b.precedence
        end

        ops.each do |op|
            # TODO: consolidate left and right paths
            split = []
            if op.association == :right
                elems = break_right(arr) { |elem| elem == op }
                next if elems[0].empty?

                split = [elems[0][0..-2], elems[1]]
            else
                elems = break_left(arr) { |elem| elem == op }
                next if elems[1].empty?

                split = [elems[0], elems[1][1..-1]]
            end
            arr = op.do_evaluate_self(split[0], split[1])
        end
        if arr.length != 1
            puts "evaluate did not result in a length of 1"
            raise "see above error"
        end

        arr.first
    end

    #
    # <Description>
    #
    # @param [Array<RegexOperator,String>] arr_left the parse array to the left of self
    # @param [Array<RegexOperator,String>] arr_right the parse array to the right of self
    #
    # @abstract override to provide evaluate the operator
    #
    # @return [Array<RegexOperator,String>] the parse array as a result of evaluating self
    #
    # @note arr_left and arr_right contain the entire parse array use {#fold_left} and
    #  {#fold_right} to collect only the portions that this operator is responsible for
    #
    def do_evaluate_self(arr_left, arr_right) # rubocop:disable Lint/UnusedMethodArgument
        raise NotImplementedError
    end

    #
    # Compares for equality
    #
    # @param [RegexOperator] other the operator to compare to
    #
    # @return [Boolean] are they equal
    #
    def ==(other)
        return false unless other.instance_of?(self.class)
        return false unless @precedence == other.precedence
        return false unless @association == other.association

        true
    end

    #
    # <Description>
    #
    # @param [Array<String,RegexOperator>] arr the array to fold
    #
    # @return [Array<(String,Array<String,RegexOperator>)>] the folded array and leftovers
    # @note the leftover portion is not suitable for evaluation
    #   (it begins or ends with a RegexOperator or is an empty string)
    #
    def fold_left(arr)
        # go left until:
        #  - the precedence of self is greater than the token being tested
        #  - the precedence is the same and the association of self is :left
        fold = (arr.reverse.take_while do |t|
            next true if t.is_a? String
            next true if t.precedence > @precedence

            next false if t.precedence < @precedence
            next false if @association == :left

            true
        end).reverse

        if fold.empty? || !fold[0].is_a?(String) || !fold[-1].is_a?(String)
            puts "fold_left generated an invalid fold expression"
            raise "see above error"
        end

        # [0..-(fold.length+1)] peels the elements that are a part of fold off the end
        # of arr
        [RegexOperator.evaluate(fold), arr[0..-(fold.length+1)]]
    end

    #
    # (see #fold_left)
    #
    def fold_right(arr)
        # go right until:
        #  - the precedence of self is greater than the token being tested
        #  - the precedence is the same and the association of self is :right
        fold = arr.take_while do |t|
            next true if t.is_a? String
            next true if t.precedence > @precedence

            next false if t.precedence < @precedence
            next false if @association == :right

            true
        end

        if fold.empty? || !fold[0].is_a?(String) || !fold[-1].is_a?(String)
            puts "fold_right generated an invalid fold expression"
            raise "see above error"
        end

        [RegexOperator.evaluate(fold), arr[(fold.length)..-1]]
    end
end