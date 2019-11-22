# frozen_string_literal: true

class BailoutTransform < GrammarTransform
    def initialize(prefix, pattern)
        @prefix = prefix
        @end_bailout = lookAheadFor(pattern).to_r
        @while_bailout = Pattern.new(/^/).maybe(/\s+/).lookAheadToAvoid(pattern).to_r
    end

    def rewrite_rule(non_duplicate, rule)
        return rule if rule["match"]

        if rule["includes"] && !non_duplicate.include?(rule["includes"])
            rule["includes"] = "##{@prefix}_#{rule['includes'][1..-1]}"
        end

        rule["end"] = "#{rule['end']}|#{@end_bailout}" if rule["end"]
        rule["while"] = "#{rule['while']}|(?:#{@while_bailout})" if rule["while"]

        rule["patterns"]&.map! { |pat| rewrite_rule(non_duplicate, pat) }

        if rule[:repository]
            rule[:repository] = Hash[
                rule[:repository].map do |key, pat|
                    next [key, pat] if non_duplicate.include? key

                    [
                        "#{@prefix}_#{key}",
                        rewrite_rule(non_duplicate, pat),
                    ]
                end
            ]
        end

        rule["captures"]&.transform_values { |pat| rewrite_rule(non_duplicate, pat) }
        rule["beginCaptures"]&.transform_values { |pat| rewrite_rule(non_duplicate, pat) }
        rule["endCaptures"]&.transform_values { |pat| rewrite_rule(non_duplicate, pat) }
        rule["whileCaptures"]&.transform_values { |pat| rewrite_rule(non_duplicate, pat) }

        rule
    end

    def collect_non_duplicate(rule, repository_name = nil)
        if rule["match"]
            return [repository_name] if repository_name

            return []
        end

        if rule["patterns"]
            if rule.length == 1
                non_duplicate = rule["patterns"].reduce([]) do |memo, pat|
                    next memo if memo.nil?

                    non_duplicate_nested = collect_non_duplicate(pat)
                    next nil if non_duplicate_nested.nil?

                    next memo.concat(non_duplicate_nested)
                end

                unless non_duplicate.nil?
                    return [repository_name] if repository_name

                    return []
                end
            end
        end

        if rule[:repository]
            return rule[:repository].keys.reduce([]) do |memo, key|
                non_duplicate = collect_non_duplicate(rule[:repository][key], key)
                memo.concat(non_duplicate) if non_duplicate

                next memo
            end
        end
        nil
    end

    def post_transform(grammar_hash)
        non_duplicate = collect_non_duplicate(grammar_hash)
        pp non_duplicate
        duplicate = rewrite_rule(
            (non_duplicate.nil? ? [] : non_duplicate),
            grammar_hash.__deep_clone__,
        )

        pp grammar_hash[:repository]

        grammar_hash.__deep_clone__.merge(duplicate)
    end
end