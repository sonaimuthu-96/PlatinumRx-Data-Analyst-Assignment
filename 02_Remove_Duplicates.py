"""
FILE: 02_Remove_Duplicates.py
PURPOSE: Given a string, remove all duplicate characters while preserving
         the order of first appearance. Must use a loop (no sets / dict tricks).

Examples:
    "programming"  →  "progamin"
    "aabbcc"       →  "abc"
    "hello world"  →  "helo wrd"
    "abcd"         →  "abcd"   (no duplicates, unchanged)
"""


def remove_duplicates(input_string):
    """
    Remove duplicate characters from a string using a for-loop.
    The first occurrence of every character is kept; subsequent
    occurrences are skipped.

    Parameters:
        input_string (str): The input string.

    Returns:
        str: String with duplicate characters removed.
    """

    # This variable will hold our result — we build it one char at a time
    result = ""

    # Loop through every character in the input string
    for char in input_string:

        # Only add the character if it has NOT been seen yet
        if char not in result:
            result = result + char   # append to result
        # If char IS already in result, we simply skip it (do nothing)

    return result


# ── Main: test with several strings ──────────────────────────────

if __name__ == "__main__":

    test_cases = [
        "programming",
        "aabbcc",
        "hello world",
        "abcd",
        "mississippi",
        "Google",           # case-sensitive: 'G' ≠ 'g'
        "",                 # empty string edge case
        "aaaa",             # all same character
    ]

    print("=" * 50)
    print(f"  {'Input':<20}  →  Unique String")
    print("=" * 50)

    for s in test_cases:
        output = remove_duplicates(s)
        print(f"  {repr(s):<20}  →  {repr(output)}")

    print("=" * 50)

    # ── Interactive mode ──────────────────────────────────────────
    print("\nEnter a string (or 'q' to quit):")
    while True:
        user_input = input(">> ")
        if user_input.lower() == 'q':
            break
        print("Unique string:", remove_duplicates(user_input))
