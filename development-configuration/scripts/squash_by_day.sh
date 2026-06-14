#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: squash-commits-by-day.sh [BASE]

Rebase the current branch onto BASE, then combine its commits by author date.
Each resulting commit is named "Squash for YYYY-MM-DD".

When BASE is omitted, the script tries origin/HEAD, main, then master.

The selected history must be linear and the worktree must be clean.
This command rewrites Git history and does not create a backup branch.
EOF
}

die() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

(( $# <= 1 )) || die "expected at most one BASE argument"
git rev-parse --git-dir >/dev/null 2>&1 || die "not inside a Git repository"
git symbolic-ref -q HEAD >/dev/null || die "HEAD must be attached to a branch"
[[ -z $(git status --porcelain) ]] || die "worktree and index must be clean"

branch=$(git symbolic-ref --short HEAD)

if [[ $# == 1 ]]; then
  base_ref=$1
else
  base_ref=""
  remote_default=$(git symbolic-ref -q --short refs/remotes/origin/HEAD || true)
  for candidate in "$remote_default" main master; do
    if [[ -n $candidate ]] && git rev-parse --verify "$candidate^{commit}" >/dev/null 2>&1; then
      base_ref=$candidate
      break
    fi
  done
  [[ -n $base_ref ]] || die "could not detect a default branch; pass BASE explicitly"
fi

base=$(git rev-parse --verify "$base_ref^{commit}") || die "invalid BASE: $base_ref"
[[ $base != $(git rev-parse HEAD) ]] || die "current branch is already at BASE ($base_ref)"

printf 'Rebasing %s onto %s...\n' "$branch" "$base_ref"
if ! git rebase "$base_ref"; then
  die "rebase stopped; resolve conflicts and run 'git rebase --continue' or abort it"
fi

base=$(git rev-parse --verify "$base_ref^{commit}")
old_head=$(git rev-parse HEAD)
revision_range="$base..HEAD"

commits=()
while IFS= read -r commit; do
  commits+=("$commit")
done < <(git rev-list --reverse --topo-order "$revision_range")

(( ${#commits[@]} > 0 )) || die "no commits to rewrite"

for commit in "${commits[@]}"; do
  parents=$(git rev-list --parents -n 1 "$commit")
  [[ $(wc -w <<<"$parents" | tr -d ' ') -le 2 ]] || \
    die "selected history contains merge commit $commit"
done

new_parent=$base
group_date=""
group_last=""

create_group_commit() {
  local commit=$1 day=$2 tree author_name author_email author_date new_commit
  tree=$(git rev-parse "$commit^{tree}")
  author_name=$(git show -s --format=%an "$commit")
  author_email=$(git show -s --format=%ae "$commit")
  author_date=$(git show -s --format=%aI "$commit")

  if [[ -n $new_parent ]]; then
    new_commit=$(printf 'Squash for %s\n' "$day" | \
      GIT_AUTHOR_NAME="$author_name" GIT_AUTHOR_EMAIL="$author_email" \
      GIT_AUTHOR_DATE="$author_date" GIT_COMMITTER_DATE="$author_date" \
      git commit-tree "$tree" -p "$new_parent")
  else
    new_commit=$(printf 'Squash for %s\n' "$day" | \
      GIT_AUTHOR_NAME="$author_name" GIT_AUTHOR_EMAIL="$author_email" \
      GIT_AUTHOR_DATE="$author_date" GIT_COMMITTER_DATE="$author_date" \
      git commit-tree "$tree")
  fi
  new_parent=$new_commit
}

for commit in "${commits[@]}"; do
  commit_date=$(git show -s --format=%aI "$commit")
  commit_date=${commit_date:0:10}

  if [[ -n $group_date && $commit_date != "$group_date" ]]; then
    create_group_commit "$group_last" "$group_date"
  fi
  group_date=$commit_date
  group_last=$commit
done
create_group_commit "$group_last" "$group_date"

git update-ref "refs/heads/$branch" "$new_parent" "$old_head"
git reset --hard "$new_parent" >/dev/null

printf 'Rebased and rewrote %s onto %s.\n' "$branch" "$base_ref"
git log --oneline --decorate --date=short --format='%h %ad %s' \
  ${base:+"$base.."}HEAD
