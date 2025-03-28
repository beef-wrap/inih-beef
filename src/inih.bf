/* inih -- simple .INI file parser

SPDX-License-Identifier: BSD-3-Clause

Copyright (C) 2009-2020, Ben Hoyt

inih is released under the New BSD license (see LICENSE.txt). Go to the project
home page for more info:

https://github.com/benhoyt/inih

*/

using System;

namespace inih;

public static class inih
{
	typealias char = char8;
	typealias FILE = void*;

	/* Nonzero if ini_handler callback should accept lineno parameter. */
#if !INI_HANDLER_LINENO
	const int INI_HANDLER_LINENO = 0;
#endif

	/* Typedef for prototype of handler function. */
#if INI_HANDLER_LINENO
	function int ini_handler(void* user, char* section, char* name, char* value, int lineno);
#else
	function int ini_handler(void* user, char8* section, char8* name, char8* value);
#endif

	/* function for prototype of fgets-style reader function. */
	function char** ini_reader(char* str, int num, void* stream);

	/* Parse given INI-style file. May have [section]s, name=value pairs
	(whitespace stripped), and comments starting with ';' (semicolon). Section
	is "" if name=value pair parsed before any section heading. name:value
	pairs are also supported as a concession to Python's configparser.

	For each name=value pair parsed, call handler function with given user
	pointer as well as section, name, and value (data only valid for duration
	of handler call). Handler should return nonzero on success, zero on error.

	Returns 0 on success, line number of first error on parse error (doesn't
	stop on first error), -1 on file open error, or -2 on memory allocation
	error (only when INI_USE_STACK is zero).
	*/
	[CLink] public static extern int ini_parse(char* filename, ini_handler handler, void* user);

	/* Same as ini_parse(), but takes a FILE* instead of filename. This doesn't
	close the file when it's finished -- the caller must do that. */
	[CLink] public static extern int ini_parse_file(FILE* file, ini_handler handler, void* user);

	/* Same as ini_parse(), but takes an ini_reader function pointer instead of
	filename. Used for implementing custom or string-based I/O (see also
	ini_parse_string). */
	[CLink] public static extern int ini_parse_stream(ini_reader reader, void* stream, ini_handler handler, void* user);

	/* Same as ini_parse(), but takes a zero-terminated string with the INI data
	instead of a file. Useful for parsing INI data from a network socket or
	already in memory. */
	[CLink] public static extern int ini_parse_string(char* string, ini_handler handler, void* user);

	/* Nonzero to allow multi-line value parsing, in the style of Python's
	configparser. If allowed, ini_parse() will call the handler with the same
	name for each subsequent line parsed. */
#if !INI_ALLOW_MULTILINE
	const int INI_ALLOW_MULTILINE = 1;
#endif

	/* Nonzero to allow a UTF-8 BOM sequence (0xEF 0xBB 0xBF) at the start of
	the file. See https://github.com/benhoyt/inih/issues/21 */
#if !INI_ALLOW_BOM
	const int INI_ALLOW_BOM = 1;
#endif

	/* Chars that begin a start-of-line comment. Per Python configparser, allow
	both ; and # comments at the start of a line by default. */
#if !INI_START_COMMENT_PREFIXES
	const char8* INI_START_COMMENT_PREFIXES = ";#";
#endif

	/* Nonzero to allow inline comments (with valid inline comment characters
	specified by INI_INLINE_COMMENT_PREFIXES). Set to 0 to turn off and match
	Python 3.2+ configparser behaviour. */
#if !INI_ALLOW_INLINE_COMMENTS
	const int INI_ALLOW_INLINE_COMMENTS = 1;
#endif

#if !INI_INLINE_COMMENT_PREFIXES
	const char8* INI_INLINE_COMMENT_PREFIXES = ";";
#endif

	/* Nonzero to use stack for line buffer, zero to use heap (malloc/free). */
#if !INI_USE_STACK
	const int INI_USE_STACK = 1;
#endif

	/* Maximum line length for any line in INI file (stack or heap). Note that
	this must be 3 more than the longest line (due to '\r', '\n', and '\0'). */
#if !INI_MAX_LINE
	const int INI_MAX_LINE = 200;
#endif

	/* Nonzero to allow heap line buffer to grow via realloc(), zero for a
	fixed-size buffer of INI_MAX_LINE bytes. Only applies if INI_USE_STACK is
	zero. */
#if !INI_ALLOW_REALLOC
	const int INI_ALLOW_REALLOC = 0;
#endif

	/* Initial size in bytes for heap line buffer. Only applies if INI_USE_STACK
	is zero. */
#if !INI_INITIAL_ALLOC
	const int INI_INITIAL_ALLOC = 200;
#endif

	/* Stop parsing on first error (default is to keep parsing). */
#if !INI_STOP_ON_FIRST_ERROR
	const int INI_STOP_ON_FIRST_ERROR = 0;
#endif

	/* Nonzero to call the handler at the start of each new section (with
	name and value NULL). Default is to only call the handler on
	each name=value pair. */
#if !INI_CALL_HANDLER_ON_NEW_SECTION
	const int INI_CALL_HANDLER_ON_NEW_SECTION = 0;
#endif

	/* Nonzero to allow a name without a value (no '=' or ':' on the line) and
	call the handler with value NULL in this case. Default is to treat
	no-value lines as an error. */
#if !INI_ALLOW_NO_VALUE
	const int INI_ALLOW_NO_VALUE = 0;
#endif

	/* Nonzero to use custom ini_malloc, ini_free, and ini_realloc memory
	allocation functions (INI_USE_STACK must also be 0). These functions must
	have the same signatures as malloc/free/realloc and behave in a similar
	way. ini_realloc is only needed if INI_ALLOW_REALLOC is set. */
#if !INI_CUSTOM_ALLOCATOR
	const int INI_CUSTOM_ALLOCATOR = 0;
#endif

}