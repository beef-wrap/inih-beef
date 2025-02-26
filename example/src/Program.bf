using System;
using System.Diagnostics;
using static inihBeef.inih;

namespace example;

class Program
{
	static int dumper(void* user, char8* section, char8* name, char8* value)
	{
		Debug.WriteLine($"[{StringView(section)}] {StringView(name)}={StringView(value)};");

		return 1;
	}

	public static void parse(String name, String value)
	{
		Debug.WriteLine($"\n{name}:\n");
		ini_parse_string(value.Ptr, => dumper, null);
	}

	public static int Main(String[] args)
	{
		parse("empty string", "");
		parse("basic", "[section]\nfoo = bar\nbazz = buzz quxx");
		parse("crlf", "[section]\r\nhello = world\r\nforty_two = 42\r\n");
		parse("long line", "[sec]\nfoo = 01234567890123456789\nbar=4321\n");
		parse("long continued", "[sec]\nfoo = 0123456789012bix=1234\n");
		parse("error", "[s]\na=1\nb\nc=3");

		return 0;
	}
}