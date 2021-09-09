require 'json'
require 'yaml'
require 'set'
require 'deep_clone' # gem install deep_clone
require 'pathname'

#
# Recursive value setting
#
# TODO: these names/methods should probably be formalized and then put inside their own ruby gem
# TODO: methods should probably be added for other containers, like sets
# TODO: probably should use blocks instead of a lambda
#     # the hash (or array) you want to change
#     a_hash = {
#         a: nil,
#         b: {
#             c: nil,
#             d: {
#                 e: nil
#             }
#         }
#     }
#     # lets say you want to convert all the nil's into empty arrays []
#     # then you'd do:
#     a_hash.recursively_set_each_value! ->(each_value, each_key) do
#         if each_value == nil
#             # return an empty list
#             []
#         else
#             # return the original
#             each_value
#         end
#     end
#     # this would result in:
#     a_hash = {
#         a: [],
#         b: {
#             c: []
#             d: {
#                 e: []
#             }
#         }
#     }
class Hash
    def recursively_set_each_value!(a_lambda)
        for each_key, each_value in self.clone
            # if this was a tree, then start by exploring the tip of the first root
            # (rather than the base of the tree)
            # if it has a :recursively_set_each_value! method, then call it
            if self[each_key].respond_to?(:recursively_set_each_value!)
                self[each_key].recursively_set_each_value!(a_lambda)
            end
            # then allow manipulation of the value
            self[each_key] = a_lambda[each_value, each_key]
        end
    end
end

class Array
    def recursively_set_each_value!(a_lambda)
        new_values = []
        clone = self.clone
        clone.each_with_index do |each_value, each_key|
            # if it has a :recursively_set_each_value! method, then call it
            if self[each_key].respond_to?(:recursively_set_each_value!)
                self[each_key].recursively_set_each_value!(a_lambda)
            end
            self[each_key] = a_lambda[each_value, each_key]
        end
    end
end

#
# Helpers for Tokens
#
class NegatedSymbol
    def initialize(a_symbol)
        @symbol = a_symbol
    end
    def to_s
        return "not(#{@symbol.to_s})"
    end
    def to_sym
        return @symbol
    end
end

class Symbol
    def !@
        return NegatedSymbol.new(self)
    end
end

class TokenHelper
    attr_accessor :tokens
    def initialize(tokens, for_each_token:nil)
        @tokens = tokens
        if for_each_token != nil
            for each in @tokens
                for_each_token[each]
            end
        end
    end


    def tokensThat(*adjectives)
        matches = @tokens.select do |each_token|
            output = true
            for each_adjective in adjectives
                # make sure to fail on negated symbols
                if each_adjective.is_a? NegatedSymbol
                    if each_token[each_adjective.to_sym] == true
                        output = false
                        break
                    end
                elsif each_token[each_adjective] != true
                    output = false
                    break
                end
            end
            output
        end
        # sort from longest to shortest
        matches.sort do |token1, token2|
            token2[:representation].length - token1[:representation].length
        end
    end

    def representationsThat(*adjectives)
        matches = self.tokensThat(*adjectives)
        return matches.map do |each| each[:representation] end
    end

    def lookBehindToAvoidWordsThat(*adjectives)
        array_of_invalid_names = self.representationsThat(*adjectives)
        return Pattern.new(/\b/).lookBehindToAvoid(/#{array_of_invalid_names.map { |each| '\W'+each+'|^'+each } .join('|')}/)
    end

    def lookAheadToAvoidWordsThat(*adjectives)
        array_of_invalid_names = self.representationsThat(*adjectives)
        return Pattern.new(/\b/).lookAheadToAvoid(/#{array_of_invalid_names.map { |each| each+'\W|'+each+'\$' } .join('|')}/)
    end

    def that(*adjectives)
        return oneOf(representationsThat(*adjectives))
    end
end

class Array
    def without(*args)
        copy = self.clone
        for each in args
            copy.delete(each)
        end
        return copy
    end
end
