#!/usr/bin/env bash
# Linux Network Troubleshooting Toolkit
# Basic checks for interfaces, routing, IP connectivity, and DNS.

set -u

TARGET_IP="${TARGET_IP:-8.8.8.8}"
TARGET_HOST="${TARGET_HOST:-google.com}"
PING_COUNT="${PING_COUNT:-2}"
PING_TIMEOUT="${PING_TIMEOUT:-3}"

section() { printf '\n===== %s =====\n' "$1"; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

section "LINUX NETWORK TROUBLESHOOTING TOOLKIT"
printf 'Date: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"
printf 'Host: %s\n' "$(hostname 2>/dev/null || printf 'unknown')"

section "NETWORK INTERFACES AND IP ADDRESSES"
if command_exists ip; then
  ip -brief address || ip addr
else
  echo "[WARN] 'ip' command not found (usually provided by iproute2)."
fi

section "ROUTING TABLE"
if command_exists ip; then
  ip route show || echo "[WARN] Could not read routing table."
else
  echo "[WARN] Skipping route check because 'ip' is unavailable."
fi

section "DEFAULT GATEWAY"
if command_exists ip; then
  gateway="$(ip route show default 2>/dev/null | awk 'NR==1 {print $3}')"
  if [[ -n "$gateway" ]]; then
    printf '[INFO] Default gateway: %s\n' "$gateway"
  else
    echo "[WARN] No default gateway found in the routing table."
  fi
fi

section "IP CONNECTIVITY TEST"
IP_OK=0
if command_exists ping; then
  if ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$TARGET_IP"; then
    IP_OK=1
    printf '[PASS] Target IP %s responded to ping.\n' "$TARGET_IP"
  else
    printf '[FAIL] No ping response from %s. ICMP may be filtered; this alone does not prove internet is unavailable.\n' "$TARGET_IP"
  fi
else
  echo "[WARN] 'ping' command not found; cannot test IP connectivity."
fi

section "DNS RESOLUTION TEST"
DNS_OK=0
if command_exists getent; then
  if getent ahosts "$TARGET_HOST"; then
    DNS_OK=1
    printf '[PASS] DNS/name lookup succeeded for %s.\n' "$TARGET_HOST"
  else
    printf '[FAIL] Could not resolve %s using the system name service.\n' "$TARGET_HOST"
  fi
else
  echo "[WARN] 'getent' command not found; cannot test system name resolution."
fi

section "AUTOMATIC SUMMARY"
if [[ "$IP_OK" -eq 1 && "$DNS_OK" -eq 1 ]]; then
  echo "[RESULT] IP connectivity and name resolution checks passed."
elif [[ "$IP_OK" -eq 1 && "$DNS_OK" -eq 0 ]]; then
  echo "[RESULT] IP connectivity passed but name resolution failed. Inspect DNS configuration."
elif [[ "$IP_OK" -eq 0 && "$DNS_OK" -eq 1 ]]; then
  echo "[RESULT] Name resolution works, but ping failed. ICMP filtering or a connectivity issue may be involved."
else
  echo "[RESULT] Both checks failed or could not be completed. Inspect interface status, IP configuration, default route, and DNS settings."
fi

echo "[NOTE] These checks provide clues, not a guaranteed root-cause diagnosis. Firewalls and network policies can affect results."
