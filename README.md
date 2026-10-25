# Linux Network Troubleshooting Toolkit

A small Bash utility that gathers common Linux network details, tests reachability to a configurable IP address, checks system name resolution, and prints a preliminary automatic summary.

## Features

- Lists network interfaces and IP addresses.
- Displays the routing table and default gateway.
- Tests reachability using `ping`.
- Checks DNS/system name resolution with `getent ahosts`.
- Prints a summary based on the two checks.
- Allows the IP, hostname, and ping settings to be configured with environment variables.

## Requirements

- Linux and Bash
- `ip` from `iproute2`
- `ping` (often supplied by `iputils-ping`)
- `getent` (usually supplied by the GNU C Library)

On Ubuntu, if a command is missing, install the relevant package using your system's package manager. For example:

```bash
sudo apt update
sudo apt install iproute2 iputils-ping
```

## Run

```bash
chmod +x network-check.sh
./network-check.sh
```

Or:

```bash
bash network-check.sh
```

## Configure the checks

```bash
TARGET_IP=1.1.1.1 TARGET_HOST=example.com PING_COUNT=3 ./network-check.sh
```

Defaults are `8.8.8.8`, `google.com`, 2 ping packets, and a 3-second ping timeout.

## Test shell syntax

```bash
bash -n network-check.sh
```

## Troubleshooting approach practised

1. Inspect interfaces and assigned addresses.
2. Inspect the route table and default gateway.
3. Test IP reachability independently of DNS.
4. Test hostname resolution.
5. Use the combined results to decide what to inspect next.

## Limitations

This is a beginner-friendly diagnostic helper, not a full monitoring or root-cause analysis system. Ping can be blocked by firewalls or remote hosts, and a successful name lookup does not guarantee that a website or service is reachable. The summary should be treated as a clue, not a definitive diagnosis.

## Repository contents

- `network-check.sh` — main diagnostic script
- `README.md` — setup, usage, and limitations
- `tests/test-script.sh` — lightweight local syntax and structure checks
- `.gitignore` — excludes common local/editor files
- `LICENSE` — MIT License
