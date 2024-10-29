# ------------------------------------------------------------------------------
# Prettier
# ------------------------------------------------------------------------------

# Check files are prettier formatted
prettier-check:
    prettier . --check

# Format files with prettier
prettier-format:
    prettier . --check --write

# ------------------------------------------------------------------------------
# Justfile
# ------------------------------------------------------------------------------

# Format the justfile
just-format:
    just --fmt --unstable

# Check if the justfile is formatted correctly
just-format-check:
    just --fmt --check --unstable

# ------------------------------------------------------------------------------
# Git Leaks
# ------------------------------------------------------------------------------

# Detect secrets in the repos
gitleaks-detect:
    gitleaks detect --source .

# ------------------------------------------------------------------------------
# Git Hooks
# ------------------------------------------------------------------------------

# Install pre commit hook to run on all commits
install-git-hooks:
    cp -f githooks/pre-commit .git/hooks/pre-commit
    cp -f githooks/post-commit .git/hooks/post-commit
    chmod ug+x .git/hooks/*
