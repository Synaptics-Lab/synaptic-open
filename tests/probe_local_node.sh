#!/usr/bin/env bash
# ==============================================================================
# Local node correctness probe.
#
# Boots bin/synaptic-node on sandbox ports, waits for the RPC to come up,
# and asserts:
#   1. JSON-RPC answers `syn_chainId` with chain_id 1
#   2. JSON-RPC answers `getHealth` with "ok"
#   3. JSON-RPC answers `getSlot` (number)
#
# No network access needed. Exit 0 = PASS, nonzero = FAIL.
# ==============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
BIN="${ROOT_DIR}/bin/synaptic-node"
RPC_PORT="${RPC_PORT:-18445}"
P2P_PORT="${P2P_PORT:-19400}"
BASE="http://127.0.0.1:${RPC_PORT}"

rpc() {
    curl -sm 5 -X POST "${BASE}" -H 'content-type: application/json' -d "$1"
}

PASS=0; FAIL=0
ok   () { echo "  PASS"; PASS=$((PASS+1)); }
bad  () { echo "  FAIL"; FAIL=$((FAIL+1)); }
check() { [[ $? -eq 1 ]] && bad || ok; }

if [[ ! -x "${BIN}" ]]; then echo "FAIL: ${BIN} not found"; exit 1; fi

DATA_DIR="${ROOT_DIR}/tests/.probe-data-${RPC_PORT}"
rm -rf "${DATA_DIR}"

"${BIN}" --data-dir "${DATA_DIR}" --rpc-port "${RPC_PORT}" --p2p-port "${P2P_PORT}" \
    > "${DATA_DIR}.log" 2>&1 &
NODE_PID=$!
trap 'kill ${NODE_PID} 2>/dev/null' EXIT

# wait for RPC to accept a request (up to ~15s)
UP=0
for _ in $(seq 1 15); do
    [[ $(rpc '{"jsonrpc":"2.0","id":0,"method":"getHealth","params":[]}') == *'"ok"'* ]] && { UP=1; break; }
    sleep 1
done

echo "1. node boots and answers JSON-RPC  "
[[ ${UP} -eq 1 ]] && ok || bad

echo "2. syn_chainId -> chain_id 1        "
OUT=$(rpc '{"jsonrpc":"2.0","id":1,"method":"syn_chainId","params":[]}')
echo "     ${OUT}"
[[ "${OUT}" == *'"chain_id":1'* ]] && ok || bad

echo "3. getSlot (0 ok for local genesis) "
OUT=$(rpc '{"jsonrpc":"2.0","id":2,"method":"getSlot","params":[]}')
echo "     ${OUT}"
[[ "${OUT}" == *"\"result\":"* ]] && ok || bad

echo
echo "RESULT: ${PASS} pass / ${FAIL} fail"
[[ ${FAIL} -eq 0 ]]