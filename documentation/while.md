The textmate "while" key has almost no documentation. I'm writing this to explain what little I know about it.

### Where it is allowed
The "while" key can be used inside of a pattern range (something that normally would have a begin and end). It can be used instead of an "end" pattern. You can keep the end pattern, but I don't think it will be used for anything.

### The good part
The "while" key is stronger than the "end" pattern, as soon as the while is over, it stops and most importantly, it cuts off any ranges that are still open. This is incredibly important because almost nothing else in textmate does this, and it is useful for stopping broken syntax.

I believe it was designed to match things like the python intentation-based block.

### The bad part(s)
However, there are some caveats.
1. The "while" pattern is line-based, not charater-based. If you match a single character on a line, then the whole line is considered to be inside the pattern-range
2. On each line, nothing will start being matched until the while pattern has been fully matched
3. Once the while pattern matches, everything after the while pattern will be tagged using the patterns inside of the pattern-range
