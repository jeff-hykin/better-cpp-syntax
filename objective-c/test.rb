repo = { 
    "bracketed_content" => {
			"begin" => "\\[",
			"beginCaptures" => {
				"0" => {
					"name" => "punctuation.section.scope.begin.objc"
				}
			},
			"end" => "\\]",
			"endCaptures" => {
				"0" => {
					"name" => "punctuation.section.scope.end.objc"
				}
			},
			"name" => "meta.bracketed.objc",
			"patterns" => [
				{
					"begin" => "(?=predicateWithFormat:)(?<=NSPredicate )(predicateWithFormat:)",
					"beginCaptures" => {
						"1" => {
							"name" => "support.function.any-method.objc"
						},
						"2" => {
							"name" => "punctuation.separator.arguments.objc"
						}
					},
					"end" => "(?=\\])",
					"name" => "meta.function-call.predicate.objc",
					"patterns" => [
						{
							"captures" => {
								"1" => {
									"name" => "punctuation.separator.arguments.objc"
								}
							},
							"match" => "\\bargument(Array|s)(:)",
							"name" => "support.function.any-method.name-of-parameter.objc"
						},
						{
							"captures" => {
								"1" => {
									"name" => "punctuation.separator.arguments.objc"
								}
							},
							"match" => "\\b\\w+(:)",
							"name" => "invalid.illegal.unknown-method.objc"
						},
						{
							"begin" => "@\"",
							"beginCaptures" => {
								"0" => {
									"name" => "punctuation.definition.string.begin.objc"
								}
							},
							"end" => "\"",
							"endCaptures" => {
								"0" => {
									"name" => "punctuation.definition.string.end.objc"
								}
							},
							"name" => "string.quoted.double.objc",
							"patterns" => [
								{
									"match" => "\\b(AND|OR|NOT|IN)\\b",
									"name" => "keyword.operator.logical.predicate.cocoa"
								},
								{
									"match" => "\\b(ALL|ANY|SOME|NONE)\\b",
									"name" => "constant.language.predicate.cocoa"
								},
								{
									"match" => "\\b(NULL|NIL|SELF|TRUE|YES|FALSE|NO|FIRST|LAST|SIZE)\\b",
									"name" => "constant.language.predicate.cocoa"
								},
								{
									"match" => "\\b(MATCHES|CONTAINS|BEGINSWITH|ENDSWITH|BETWEEN)\\b",
									"name" => "keyword.operator.comparison.predicate.cocoa"
								},
								{
									"match" => "\\bC(ASEINSENSITIVE|I)\\b",
									"name" => "keyword.other.modifier.predicate.cocoa"
								},
								{
									"match" => "\\b(ANYKEY|SUBQUERY|CAST|TRUEPREDICATE|FALSEPREDICATE)\\b",
									"name" => "keyword.other.predicate.cocoa"
								},
								{
									"match" => "\\\\(\\\\|[abefnrtv'\"?]|[0-3]\\d{,2}|[4-7]\\d?|x[a-zA-Z0-9]+)",
									"name" => "constant.character.escape.objc"
								},
								{
									"match" => "\\\\.",
									"name" => "invalid.illegal.unknown-escape.objc"
								}
							]
						},
						{
							"include" => "#special_variables"
						},
						{
							"include" => "#c_functions"
						},
						{
							"include" => "$base"
						}
					]
				},
				{
					"begin" => "(?=\\w)(?<=[\\w\\])\"] )(\\w+(?:(:)|(?=\\])))",
					"beginCaptures" => {
						"1" => {
							"name" => "support.function.any-method.objc"
						},
						"2" => {
							"name" => "punctuation.separator.arguments.objc"
						}
					},
					"end" => "(?=\\])",
					"name" => "meta.function-call.objc",
					"patterns" => [
						{
							"captures" => {
								"1" => {
									"name" => "punctuation.separator.arguments.objc"
								}
							},
							"match" => "\\b\\w+(:)",
							"name" => "support.function.any-method.name-of-parameter.objc"
						},
						{
							"include" => "#special_variables"
						},
						{
							"include" => "#c_functions"
						},
						{
							"include" => "$base"
						}
					]
				},
				{
					"include" => "#special_variables"
				},
				{
					"include" => "#c_functions"
				},
				{
					"include" => "$self"
				}
			]
		},
		"c_functions" => {
			"patterns" => [
				{
					"captures" => {
						"1" => {
							"name" => "punctuation.whitespace.support.function.leading.c"
						},
						"2" => {
							"name" => "support.function.C99.c"
						}
					},
					"match" => "(\\s*)\\b(hypot(f|l)?|s(scanf|ystem|nprintf|ca(nf|lb(n(f|l)?|ln(f|l)?))|i(n(h(f|l)?|f|l)?|gn(al|bit))|tr(s(tr|pn)|nc(py|at|mp)|c(spn|hr|oll|py|at|mp)|to(imax|d|u(l(l)?|max)|k|f|l(d|l)?)|error|pbrk|ftime|len|rchr|xfrm)|printf|et(jmp|vbuf|locale|buf)|qrt(f|l)?|w(scanf|printf)|rand)|n(e(arbyint(f|l)?|xt(toward(f|l)?|after(f|l)?))|an(f|l)?)|c(s(in(h(f|l)?|f|l)?|qrt(f|l)?)|cos(h(f)?|f|l)?|imag(f|l)?|t(ime|an(h(f|l)?|f|l)?)|o(s(h(f|l)?|f|l)?|nj(f|l)?|pysign(f|l)?)|p(ow(f|l)?|roj(f|l)?)|e(il(f|l)?|xp(f|l)?)|l(o(ck|g(f|l)?)|earerr)|a(sin(h(f|l)?|f|l)?|cos(h(f|l)?|f|l)?|tan(h(f|l)?|f|l)?|lloc|rg(f|l)?|bs(f|l)?)|real(f|l)?|brt(f|l)?)|t(ime|o(upper|lower)|an(h(f|l)?|f|l)?|runc(f|l)?|gamma(f|l)?|mp(nam|file))|i(s(space|n(ormal|an)|cntrl|inf|digit|u(nordered|pper)|p(unct|rint)|finite|w(space|c(ntrl|type)|digit|upper|p(unct|rint)|lower|al(num|pha)|graph|xdigit|blank)|l(ower|ess(equal|greater)?)|al(num|pha)|gr(eater(equal)?|aph)|xdigit|blank)|logb(f|l)?|max(div|abs))|di(v|fftime)|_Exit|unget(c|wc)|p(ow(f|l)?|ut(s|c(har)?|wc(har)?)|error|rintf)|e(rf(c(f|l)?|f|l)?|x(it|p(2(f|l)?|f|l|m1(f|l)?)?))|v(s(scanf|nprintf|canf|printf|w(scanf|printf))|printf|f(scanf|printf|w(scanf|printf))|w(scanf|printf)|a_(start|copy|end|arg))|qsort|f(s(canf|e(tpos|ek))|close|tell|open|dim(f|l)?|p(classify|ut(s|c|w(s|c))|rintf)|e(holdexcept|set(e(nv|xceptflag)|round)|clearexcept|testexcept|of|updateenv|r(aiseexcept|ror)|get(e(nv|xceptflag)|round))|flush|w(scanf|ide|printf|rite)|loor(f|l)?|abs(f|l)?|get(s|c|pos|w(s|c))|re(open|e|ad|xp(f|l)?)|m(in(f|l)?|od(f|l)?|a(f|l|x(f|l)?)?))|l(d(iv|exp(f|l)?)|o(ngjmp|cal(time|econv)|g(1(p(f|l)?|0(f|l)?)|2(f|l)?|f|l|b(f|l)?)?)|abs|l(div|abs|r(int(f|l)?|ound(f|l)?))|r(int(f|l)?|ound(f|l)?)|gamma(f|l)?)|w(scanf|c(s(s(tr|pn)|nc(py|at|mp)|c(spn|hr|oll|py|at|mp)|to(imax|d|u(l(l)?|max)|k|f|l(d|l)?|mbs)|pbrk|ftime|len|r(chr|tombs)|xfrm)|to(b|mb)|rtomb)|printf|mem(set|c(hr|py|mp)|move))|a(s(sert|ctime|in(h(f|l)?|f|l)?)|cos(h(f|l)?|f|l)?|t(o(i|f|l(l)?)|exit|an(h(f|l)?|2(f|l)?|f|l)?)|b(s|ort))|g(et(s|c(har)?|env|wc(har)?)|mtime)|r(int(f|l)?|ound(f|l)?|e(name|alloc|wind|m(ove|quo(f|l)?|ainder(f|l)?))|a(nd|ise))|b(search|towc)|m(odf(f|l)?|em(set|c(hr|py|mp)|move)|ktime|alloc|b(s(init|towcs|rtowcs)|towc|len|r(towc|len))))\\b"
				},
				{
					"captures" => {
						"1" => {
							"name" => "punctuation.whitespace.function-call.leading.c"
						},
						"2" => {
							"name" => "support.function.any-method.c"
						},
						"3" => {
							"name" => "punctuation.definition.parameters.c"
						}
					},
					"match" => "(?x) (?: (?= \\s )  (?:(?<=else|new|return) | (?<!\\w)) (\\s+))?\n            \t\t\t(\\b \n            \t\t\t\t(?!(while|for|do|if|else|switch|catch|enumerate|return|r?iterate)\\s*\\()(?:(?!NS)[A-Za-z_][A-Za-z0-9_]*+\\b | :: )++                  # actual name\n            \t\t\t)\n            \t\t\t \\s*(\\()",
					"name" => "meta.function-call.c"
				}
			]
		},
		"comment" => {
			"patterns" => [
				{
					"begin" => "/\\*",
					"captures" => {
						"0" => {
							"name" => "punctuation.definition.comment.objc"
						}
					},
					"end" => "\\*/",
					"name" => "comment.block.objc"
				},
				{
					"begin" => "(^[ \\t]+)?(?=//)",
					"beginCaptures" => {
						"1" => {
							"name" => "punctuation.whitespace.comment.leading.objc"
						}
					},
					"end" => "(?!\\G)",
					"patterns" => [
						{
							"begin" => "//",
							"beginCaptures" => {
								"0" => {
									"name" => "punctuation.definition.comment.objc"
								}
							},
							"end" => "\\n",
							"name" => "comment.line.double-slash.objc",
							"patterns" => [
								{
									"match" => "(?>\\\\\\s*\\n)",
									"name" => "punctuation.separator.continuation.objc"
								}
							]
						}
					]
				}
			]
		},
		"disabled" => {
			"begin" => "^\\s*#\\s*if(n?def)?\\b.*$",
			"comment" => "eat nested preprocessor if(def)s",
			"end" => "^\\s*#\\s*endif\\b.*$",
			"patterns" => [
				{
					"include" => "#disabled"
				},
				{
					"include" => "#pragma-mark"
				}
			]
		},
		"implementation_innards" => {
			"patterns" => [
				{
					"include" => "#preprocessor-rule-enabled-implementation"
				},
				{
					"include" => "#preprocessor-rule-disabled-implementation"
				},
				{
					"include" => "#preprocessor-rule-other-implementation"
				},
				{
					"include" => "#property_directive"
				},
				{
					"include" => "#special_variables"
				},
				{
					"include" => "#method_super"
				},
				{
					"include" => "$base"
				}
			]
		},
		"interface_innards" => {
			"patterns" => [
				{
					"include" => "#preprocessor-rule-enabled-interface"
				},
				{
					"include" => "#preprocessor-rule-disabled-interface"
				},
				{
					"include" => "#preprocessor-rule-other-interface"
				},
				{
					"include" => "#properties"
				},
				{
					"include" => "#protocol_list"
				},
				{
					"include" => "#method"
				},
				{
					"include" => "$base"
				}
			]
		},
		"method" => {
			"begin" => "^(-|\\+)\\s*",
			"end" => "(?=\\{|#)|;",
			"name" => "meta.function.objc",
			"patterns" => [
				{
					"begin" => "(\\()",
					"beginCaptures" => {
						"1" => {
							"name" => "punctuation.definition.type.begin.objc"
						}
					},
					"end" => "(\\))\\s*(\\w+\\b)",
					"endCaptures" => {
						"1" => {
							"name" => "punctuation.definition.type.end.objc"
						},
						"2" => {
							"name" => "entity.name.function.objc"
						}
					},
					"name" => "meta.return-type.objc",
					"patterns" => [
						{
							"include" => "#protocol_list"
						},
						{
							"include" => "#protocol_type_qualifier"
						},
						{
							"include" => "$base"
						}
					]
				},
				{
					"match" => "\\b\\w+(?=:)",
					"name" => "entity.name.function.name-of-parameter.objc"
				},
				{
					"begin" => "((:))\\s*(\\()",
					"beginCaptures" => {
						"1" => {
							"name" => "entity.name.function.name-of-parameter.objc"
						},
						"2" => {
							"name" => "punctuation.separator.arguments.objc"
						},
						"3" => {
							"name" => "punctuation.definition.type.begin.objc"
						}
					},
					"end" => "(\\))\\s*(\\w+\\b)?",
					"endCaptures" => {
						"1" => {
							"name" => "punctuation.definition.type.end.objc"
						},
						"2" => {
							"name" => "variable.parameter.function.objc"
						}
					},
					"name" => "meta.argument-type.objc",
					"patterns" => [
						{
							"include" => "#protocol_list"
						},
						{
							"include" => "#protocol_type_qualifier"
						},
						{
							"include" => "$base"
						}
					]
				},
				{
					"include" => "#comment"
				}
			]
		},
		"method_super" => {
			"begin" => "^(?=-|\\+)",
			"end" => "(?<=\\})|(?=#)",
			"name" => "meta.function-with-body.objc",
			"patterns" => [
				{
					"include" => "#method"
				},
				{
					"include" => "$base"
				}
			]
		},
		"pragma-mark": {
			"captures" => {
				"1" => {
					"name" => "meta.preprocessor.c"
				},
				"2" => {
					"name" => "keyword.control.import.pragma.c"
				},
				"3" => {
					"name" => "meta.toc-list.pragma-mark.c"
				}
			},
			"match" => "^\\s*(#\\s*(pragma\\s+mark)\\s+(.*))",
			"name" => "meta.section"
		},
		"preprocessor-rule-disabled-implementation": {
			"begin" => "^\\s*(#(if)\\s+(0)\\b).*",
			"captures" => {
				"1" => {
					"name" => "meta.preprocessor.c"
				},
				"2" => {
					"name" => "keyword.control.import.if.c"
				},
				"3" => {
					"name" => "constant.numeric.preprocessor.c"
				}
			},
			"end" => "^\\s*(#\\s*(endif)\\b.*?(?:(?=(?://|/\\*))|$))",
			"patterns" => [
				{
					"begin" => "^\\s*(#\\s*(else)\\b)",
					"captures" => {
						"1" => {
							"name" => "meta.preprocessor.c"
						},
						"2" => {
							"name" => "keyword.control.import.else.c"
						}
					},
					"end" => "(?=^\\s*#\\s*endif\\b.*?(?:(?=(?://|/\\*))|$))",
					"patterns" => [
						{
							"include" => "#interface_innards"
						}
					]
				},
				{
					"begin" => "",
					"end" => "(?=^\\s*#\\s*(else|endif)\\b.*?(?:(?=(?://|/\\*))|$))",
					"name" => "comment.block.preprocessor.if-branch.c",
					"patterns" => [
						{
							"include" => "#disabled"
						},
						{
							"include" => "#pragma-mark"
						}
					]
				}
			]
		},
		"preprocessor-rule-disabled-interface": {
			"begin" => "^\\s*(#(if)\\s+(0)\\b).*",
			"captures" => {
				"1" => {
					"name" => "meta.preprocessor.c"
				},
				"2" => {
					"name" => "keyword.control.import.if.c"
				},
				"3" => {
					"name" => "constant.numeric.preprocessor.c"
				}
			},
			"end" => "^\\s*(#\\s*(endif)\\b.*?(?:(?=(?://|/\\*))|$))",
			"patterns" => [
				{
					"begin" => "^\\s*(#\\s*(else)\\b)",
					"captures" => {
						"1" => {
							"name" => "meta.preprocessor.c"
						},
						"2" => {
							"name" => "keyword.control.import.else.c"
						}
					},
					"end" => "(?=^\\s*#\\s*endif\\b.*?(?:(?=(?://|/\\*))|$))",
					"patterns" => [
						{
							"include" => "#interface_innards"
						}
					]
				},
				{
					"begin" => "",
					"end" => "(?=^\\s*#\\s*(else|endif)\\b.*?(?:(?=(?://|/\\*))|$))",
					"name" => "comment.block.preprocessor.if-branch.c",
					"patterns" => [
						{
							"include" => "#disabled"
						},
						{
							"include" => "#pragma-mark"
						}
					]
				}
			]
		},
		"preprocessor-rule-enabled-implementation": {
			"begin" => "^\\s*(#(if)\\s+(0*1)\\b)",
			"captures" => {
				"1" => {
					"name" => "meta.preprocessor.c"
				},
				"2" => {
					"name" => "keyword.control.import.if.c"
				},
				"3" => {
					"name" => "constant.numeric.preprocessor.c"
				}
			},
			"end" => "^\\s*(#\\s*(endif)\\b.*?(?:(?=(?://|/\\*))|$))",
			"patterns" => [
				{
					"begin" => "^\\s*(#\\s*(else)\\b).*",
					"captures" => {
						"1" => {
							"name" => "meta.preprocessor.c"
						},
						"2" => {
							"name" => "keyword.control.import.else.c"
						}
					},
					"contentName" => "comment.block.preprocessor.else-branch.c",
					"end" => "(?=^\\s*#\\s*endif\\b.*?(?:(?=(?://|/\\*))|$))",
					"patterns" => [
						{
							"include" => "#disabled"
						},
						{
							"include" => "#pragma-mark"
						}
					]
				},
				{
					"begin" => "",
					"end" => "(?=^\\s*#\\s*(else|endif)\\b.*?(?:(?=(?://|/\\*))|$))",
					"patterns" => [
						{
							"include" => "#implementation_innards"
						}
					]
				}
			]
		},
		"preprocessor-rule-enabled-interface": {
			"begin" => "^\\s*(#(if)\\s+(0*1)\\b)",
			"captures" => {
				"1" => {
					"name" => "meta.preprocessor.c"
				},
				"2" => {
					"name" => "keyword.control.import.if.c"
				},
				"3" => {
					"name" => "constant.numeric.preprocessor.c"
				}
			},
			"end" => "^\\s*(#\\s*(endif)\\b.*?(?:(?=(?://|/\\*))|$))",
			"patterns" => [
				{
					"begin" => "^\\s*(#\\s*(else)\\b).*",
					"captures" => {
						"1" => {
							"name" => "meta.preprocessor.c"
						},
						"2" => {
							"name" => "keyword.control.import.else.c"
						}
					},
					"contentName" => "comment.block.preprocessor.else-branch.c",
					"end" => "(?=^\\s*#\\s*endif\\b.*?(?:(?=(?://|/\\*))|$))",
					"patterns" => [
						{
							"include" => "#disabled"
						},
						{
							"include" => "#pragma-mark"
						}
					]
				},
				{
					"begin" => "",
					"end" => "(?=^\\s*#\\s*(else|endif)\\b.*?(?:(?=(?://|/\\*))|$))",
					"patterns" => [
						{
							"include" => "#interface_innards"
						}
					]
				}
			]
		},
		"preprocessor-rule-other-implementation": {
			"begin" => "^\\s*(#\\s*(if(n?def)?)\\b.*?(?:(?=(?://|/\\*))|$))",
			"captures" => {
				"1" => {
					"name" => "meta.preprocessor.c"
				},
				"2" => {
					"name" => "keyword.control.import.c"
				}
			},
			"end" => "^\\s*(#\\s*(endif)\\b).*?(?:(?=(?://|/\\*))|$)",
			"patterns" => [
				{
					"include" => "#implementation_innards"
				}
			]
		},
		"preprocessor-rule-other-interface": {
			"begin" => "^\\s*(#\\s*(if(n?def)?)\\b.*?(?:(?=(?://|/\\*))|$))",
			"captures" => {
				"1" => {
					"name" => "meta.preprocessor.c"
				},
				"2" => {
					"name" => "keyword.control.import.c"
				}
			},
			"end" => "^\\s*(#\\s*(endif)\\b).*?(?:(?=(?://|/\\*))|$)",
			"patterns" => [
				{
					"include" => "#interface_innards"
				}
			]
		},
		"properties" => {
			"patterns" => [
				{
					"begin" => "((@)property)\\s*(\\()",
					"beginCaptures" => {
						"1" => {
							"name" => "keyword.other.property.objc"
						},
						"2" => {
							"name" => "punctuation.definition.keyword.objc"
						},
						"3" => {
							"name" => "punctuation.section.scope.begin.objc"
						}
					},
					"end" => "(\\))",
					"endCaptures" => {
						"1" => {
							"name" => "punctuation.section.scope.end.objc"
						}
					},
					"name" => "meta.property-with-attributes.objc",
					"patterns" => [
						{
							"match" => "\\b(getter|setter|readonly|readwrite|assign|retain|copy|nonatomic|strong|weak)\\b",
							"name" => "keyword.other.property.attribute"
						}
					]
				},
				{
					"captures" => {
						"1" => {
							"name" => "keyword.other.property.objc"
						},
						"2" => {
							"name" => "punctuation.definition.keyword.objc"
						}
					},
					"match" => "((@)property)\\b",
					"name" => "meta.property.objc"
				}
			]
		},
		"property_directive" => {
			"captures" => {
				"1" => {
					"name" => "punctuation.definition.keyword.objc"
				}
			},
			"match" => "(@)(dynamic|synthesize)\\b",
			"name" => "keyword.other.property.directive.objc"
		},
		"protocol_list" => {
			"begin" => "(<)",
			"beginCaptures" => {
				"1" => {
					"name" => "punctuation.section.scope.begin.objc"
				}
			},
			"end" => "(>)",
			"endCaptures" => {
				"1" => {
					"name" => "punctuation.section.scope.end.objc"
				}
			},
			"name" => "meta.protocol-list.objc",
			"patterns" => [
				{
					"match" => "\\bNS(GlyphStorage|M(utableCopying|enuItem)|C(hangeSpelling|o(ding|pying|lorPicking(Custom|Default)))|T(oolbarItemValidations|ext(Input|AttachmentCell))|I(nputServ(iceProvider|erMouseTracker)|gnoreMisspelledWords)|Obj(CTypeSerializationCallBack|ect)|D(ecimalNumberBehaviors|raggingInfo)|U(serInterfaceValidations|RL(HandleClient|DownloadDelegate|ProtocolClient|AuthenticationChallengeSender))|Validated(ToobarItem|UserInterfaceItem)|Locking)\\b",
					"name" => "support.other.protocol.objc"
				}
			]
		},
		"protocol_type_qualifier" => {
			"match" => "\\b(in|out|inout|oneway|bycopy|byref)\\b",
			"name" => "storage.modifier.protocol.objc"
		},
		"special_variables" => {
			"patterns" => [
				{
					"match" => "\\b_cmd\\b",
					"name" => "variable.other.selector.objc"
				},
				{
					"match" => "\\b(self|super)\\b",
					"name" => "variable.language.objc"
				}
			]
		}
}
for each_key, each_value in repo
    puts "objective_cpp_grammar[:#{each_key}] = #THISTHINGq348794"
    pp each_value
end