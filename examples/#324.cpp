#define HARVEST_REQUEST_PARAM_APPEND(string, key, value, edited, ampersand) \
	do {                                                                    \
		if(edited) {                                                        \
			if(ampersand) {                                                 \
				g_string_append_printf(string, "&%s=%s", #key, #value);     \
			} else {                                                        \
				ampersand = TRUE;                                           \
				g_string_append_printf(string, "%s=%s", #key, #value);      \
			}                                                               \
		}                                                                   \
	} while(0)
