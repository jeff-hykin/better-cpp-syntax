# frozen_string_literal: true

require_relative 'test_helper'

class SingleEntityTest < MiniTest::Test
    def test_empty
        assert string_single_entity?("")
    end

    def test_single
        assert string_single_entity?("a")
    end

    def test_groups
        assert string_single_entity?("(abc)")
        refute string_single_entity?("(abc)(abc)")
        assert string_single_entity?("[abc]")
        refute string_single_entity?("[abc][abc]")
    end

    def test_escapes
        assert string_single_entity?("\n")
        assert string_single_entity?("(abc\\)\\(abc)")
        assert string_single_entity?("[abc\\]\\[abc]")
    end

    def test_sets
        assert string_single_entity?("[abc(]")
        assert string_single_entity?("[abc)]")
        assert string_single_entity?("[abc[]")
    end

    def test_unbalanced
        assert_output(/Internal error:/) { string_single_entity?("(") }
        assert_output(/Internal error:/) { string_single_entity?(")") }
        assert_output(/Internal error:/) { string_single_entity?("[") }
        assert_output(/Internal error:/) { string_single_entity?("\\") }
    end
end