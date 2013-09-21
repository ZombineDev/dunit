/**
 * Assert toolkit for more expressive unit testing.
 *
 * Many methods implement compile-time parameters (file, line) that are set at the call site.
 * It is preferred that these parameters are ignored when using these methods.
 *
 * License:
 *     MIT. See LICENSE.txt for full details.
 */
module dunit.toolkit;

/**
 * Imports.
 */
import dunit.report;
import std.algorithm;
import std.array;
import std.regex;
import std.string;

/**
 * Assert that two values are equal.
 *
 * Params:
 *     value = The value used during the assertion.
 *     target = The target value.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertEqual(A, B)(A value, B target, string message = "Failed asserting equal", string file = __FILE__, ulong line = __LINE__)
{
	if (target != value)
	{
		reportError(message, "Expected", target, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	123.assertEqual(123);
	"hello".assertEqual("hello");
}

/**
 * Assert that an associative array contains a particular key.
 *
 * Params:
 *     haystack = The associative array to interogate.
 *     needle = The key the array should contain.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertHasKey(A, B)(A[B] haystack, B needle, string message = "Failed asserting array has key", string file = __FILE__, ulong line = __LINE__)
{
	if (needle !in haystack)
	{
		reportError(message, "Array", haystack, "Key", needle, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	["foo":1, "bar":2, "baz":3, "qux":4].assertHasKey("foo");
	[1:"foo", 2:"bar", 3:"baz", 4:"qux"].assertHasKey(1);
}

/**
 * Assert that an array contains a particular value.
 *
 * Params:
 *     haystack = The array to interogate.
 *     needle = The value the array should contain.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertHasValue(A)(A[] haystack, A needle, string message = "Failed asserting array has value", string file = __FILE__, ulong line = __LINE__)
{
	if (!canFind(haystack, needle))
	{
		reportError(message, "Array", haystack, "Value", needle, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	[1, 2, 3, 4].assertHasValue(2);
	["foo", "bar", "baz", "qux"].assertHasValue("foo");
	[["foo", "bar"], ["baz", "qux"]].assertHasValue(["foo", "bar"]);
}

/**
 * Assert that an array contains a particular value count.
 *
 * Params:
 *     array = The array to interogate.
 *     count = The amount of values the array should hold.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertCount(A)(A[] array, ulong count, string message = "Failed asserting array count", string file = __FILE__, ulong line = __LINE__)
{
	if (array.length != count)
	{
		reportError(message, "Array", array, "Count", count, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	[1, 2, 3, 4].assertCount(4);
	["foo", "bar", "baz", "qux"].assertCount(4);
	[["foo", "bar"], ["baz", "qux"]].assertCount(2);
}

/**
 * Assert that an array is empty.
 *
 * Params:
 *     array = The array to interogate.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertEmpty(A)(A[] array, string message = "Failed asserting empty array", string file = __FILE__, ulong line = __LINE__)
{
	if (!array.empty())
	{
		reportError(message, "Array", array, "Count", array.length, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	[].assertEmpty();
}

/**
 * Assert that a value is false.
 *
 * Params:
 *     value = The value used during the assertion.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertFalse(T)(T value, string message = "Failed asserting false", string file = __FILE__, ulong line = __LINE__)
{
	if (!!value)
	{
		reportError(message, "Expected", false, "Actual", !!value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	false.assertFalse();
	[].assertFalse();
	null.assertFalse();
	0.assertFalse();
}

/**
 * Assert that a value is true.
 *
 * Params:
 *     value = The value used during the assertion.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertTrue(T)(T value, string message = "Failed asserting true", string file = __FILE__, ulong line = __LINE__)
{
	if (!value)
	{
		reportError(message, "Expected", true, "Actual", !!value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	true.assertTrue();
	["foo"].assertTrue();
	1.assertTrue();
}

/**
 * Assert that a value is of a particular type.
 *
 * Params:
 *     value = The value used during the assertion.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertType(A, B)(B value, string message = "Failed asserting type", string file = __FILE__, ulong line = __LINE__)
{
	if (!is(A == B))
	{
		reportError(message, "Expected", typeid(A), "Actual", typeid(B), file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	1.assertType!(int)();
	"foo".assertType!(string)();
	["bar"].assertType!(string[])();
	['a'].assertType!(char[])();
}

/**
 * Assert that a value is greater than a threshold value.
 *
 * Params:
 *     value = The value used during the assertion.
 *     threshold = The threshold value.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertGreaterThan(A, B)(A value, B threshold, string message = "Failed asserting greater than", string file = __FILE__, ulong line = __LINE__)
{
	if (threshold >= value)
	{
		reportError(message, "Threshold", threshold, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	11.assertGreaterThan(10);
}

/**
 * Assert that a value is greater than or equal to a threshold value.
 *
 * Params:
 *     value = The value used during the assertion.
 *     threshold = The threshold value.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertGreaterThanOrEqual(A, B)(A value, B threshold, string message = "Failed asserting greater than or equal", string file = __FILE__, ulong line = __LINE__)
{
	if (threshold > value)
	{
		reportError(message, "Threshold", threshold, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	10.assertGreaterThanOrEqual(10);
	11.assertGreaterThanOrEqual(10);
}

/**
 * Assert that a value is less than a threshold value.
 *
 * Params:
 *     value = The value used during the assertion.
 *     threshold = The threshold value.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertLessThan(A, B)(A value, B threshold, string message = "Failed asserting less than", string file = __FILE__, ulong line = __LINE__)
{
	if (threshold <= value)
	{
		reportError(message, "Threshold", threshold, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	9.assertLessThan(10);
}

/**
 * Assert that a value is less than or equal to a threshold value.
 *
 * Params:
 *     value = The value used during the assertion.
 *     threshold = The threshold value.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertLessThanOrEqual(A, B)(A value, B threshold, string message = "Failed asserting less than or equal", string file = __FILE__, ulong line = __LINE__)
{
	if (threshold < value)
	{
		reportError(message, "Threshold", threshold, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	10.assertLessThanOrEqual(10);
	9.assertLessThanOrEqual(10);
}

/**
 * Assert that a value is null.
 *
 * Params:
 *     value = The value to assert as null.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertNull(A)(A value, string message = "Failed asserting null", string file = __FILE__, ulong line = __LINE__) if (A.init is null)
{
	if (value !is null)
	{
		reportError(message, "Expected", null, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	class T {}

	string foo;
	int[] bar;
	T t;

	foo.assertNull();
	bar.assertNull();
	t.assertNull();
	null.assertNull();
}

/**
 * Assert that a string matches a regular expression.
 *
 * Params:
 *     value = The value used during the assertion.
 *     pattern = The regular expression pattern.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertMatchRegex(string value, string pattern, string message = "Failed asserting match to regex", string file = __FILE__, ulong line = __LINE__)
{
	if (match(value, pattern).empty())
	{
		reportError(message, "Regex", pattern, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	"foo".assertMatchRegex(r"^foo$");
	"192.168.0.1".assertMatchRegex(r"((?:[\d]{1,3}\.){3}[\d]{1,3})");
}

/**
 * Assert that a string starts with a particular string.
 *
 * Params:
 *     value = The value used during the assertion.
 *     prefix = The prefix to match.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertStartsWith(string value, string prefix, string message = "Failed asserting starts with", string file = __FILE__, ulong line = __LINE__)
{
	if (!startsWith(value, prefix))
	{
		reportError(message, "Expected prefix", prefix, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	"foo bar".assertStartsWith("foo");
	"baz qux".assertStartsWith("baz");
}

/**
 * Assert that a string ends with a particular string.
 *
 * Params:
 *     value = The value used during the assertion.
 *     suffix = The suffix to match.
 *     message = The error message to display.
 *     file = The file name where the error occurred. The value is added automatically at the call site.
 *     line = The line where the error occurred. The value is added automatically at the call site.
 */
public void assertEndsWith(string value, string suffix, string message = "Failed asserting ends with", string file = __FILE__, ulong line = __LINE__)
{
	if (!endsWith(value, suffix))
	{
		reportError(message, "Expected suffix", suffix, "Actual", value, file, line);
	}
}

/**
 * A simple example.
 */
unittest
{
	"foo bar".assertEndsWith("bar");
	"baz qux".assertEndsWith("qux");
}