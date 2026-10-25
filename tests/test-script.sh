#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/network-check.sh"
bash -n "$SCRIPT"
grep -q 'AUTOMATIC SUMMARY' "$SCRIPT"
grep -q 'IP CONNECTIVITY TEST' "$SCRIPT"
grep -q 'DNS RESOLUTION TEST' "$SCRIPT"
grep -q 'ip route show' "$SCRIPT"
printf 'PASS: shell syntax and expected diagnostic sections found.\n'
