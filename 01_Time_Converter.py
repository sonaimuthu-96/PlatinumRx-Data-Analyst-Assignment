"""
FILE: 01_Time_Converter.py
PURPOSE: Convert an integer number of minutes into a human-readable string.

Examples:
    130  →  "2 hrs 10 minutes"
    110  →  "1 hr 50 minutes"
    60   →  "1 hr 0 minutes"
    45   →  "0 hrs 45 minutes"
    0    →  "0 hrs 0 minutes"
"""


def convert_minutes(total_minutes):
    """
    Convert total minutes (int) to a human-readable hours & minutes string.

    Parameters:
        total_minutes (int): Non-negative number of minutes.

    Returns:
        str: Formatted string like "2 hrs 10 minutes".
    """

    # ── Input validation ──────────────────────────────────────────
    if not isinstance(total_minutes, (int, float)):
        return "Error: Please provide a numeric value."
    if total_minutes < 0:
        return "Error: Minutes cannot be negative."

    total_minutes = int(total_minutes)

    # ── Core logic ────────────────────────────────────────────────
    # Integer division gives full hours
    hours = total_minutes // 60

    # Modulo gives the leftover minutes
    remaining_minutes = total_minutes % 60

    # ── Format the output string ──────────────────────────────────
    # Use "hr" for exactly 1 hour, "hrs" for everything else
    hour_label = "hr" if hours == 1 else "hrs"

    return f"{hours} {hour_label} {remaining_minutes} minutes"


# ── Main: test with several values ────────────────────────────────

if __name__ == "__main__":

    test_cases = [130, 110, 60, 45, 0, 200, 1, 61, 119]

    print("=" * 40)
    print("  Minutes  →  Human Readable Form")
    print("=" * 40)

    for minutes in test_cases:
        result = convert_minutes(minutes)
        print(f"  {minutes:>6}   →  {result}")

    print("=" * 40)

    # ── Interactive mode ──────────────────────────────────────────
    print("\nEnter a number of minutes (or 'q' to quit):")
    while True:
        user_input = input(">> ").strip()
        if user_input.lower() == 'q':
            break
        try:
            mins = int(user_input)
            print(convert_minutes(mins))
        except ValueError:
            print("Please enter a valid integer.")
