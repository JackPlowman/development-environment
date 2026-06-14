# /// script
# requires-python = ">=3.14"
# dependencies = []
# ///

import sys
import subprocess

def main():
    if len(sys.argv) < 2:
        print("Usage: uv run squash_by_day.py <rebase-todo-file>")
        sys.exit(1)

    todo_file = sys.argv[1]

    with open(todo_file, "r") as f:
        lines = f.readlines()

    out = []
    prev_date = None

    for line in lines:
        if line.startswith("pick "):
            commit_hash = line.split()[1]
            # Look up the commit date (YYYY-MM-DD)
            date = subprocess.check_output(
                ["git", "log", "-1", "--format=%cd", "--date=short", commit_hash]
            ).decode("utf-8").strip()

            if prev_date == date:
                # Same day as the previous commit, squash into it.
                # Note: change "squash " to "fixup " below to discard the squashed commit messages.
                out.append(line.replace("pick ", "squash ", 1))
            else:
                # First commit of a new day, keep it as 'pick'
                out.append(line)

            prev_date = date
        else:
            out.append(line)

    with open(todo_file, "w") as f:
        f.writelines(out)

if __name__ == "__main__":
    main()
