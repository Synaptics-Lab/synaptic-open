#!/usr/bin/env bash
# ==============================================================================
# SynapticChain — local node quick start
#
# Boots a standalone SynapticChain L1 node (cortex mode, 3 shards) fully
# locally: fresh genesis state, local JSON-RPC, no mesh and no external
# bootstrap. This is the same binary family deployed to the production
# validators; it initializes and seals its own state.
#
# Usage:
#   ./scripts/start-local-node.sh            # default: rpc 8545, p2p 9000
#   RPC_PORT=18545 P2P_PORT=19000 ./scripts/start-local-node.sh
#
# Then (new terminal):
#   curl -s -X POST http://127.0.0.1:$RPC_PORT \
#        -H 'content-type: application/json' \
#        -d '{"jsonrpc":"2.0","id":1,"method":"syn_chainId","params":[]}'
#
# Stop with Ctrl-C. State lives in ./data/ — delete it for a fresh chain.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
BIN="${ROOT_DIR}/bin/synaptic-node"

RPC_PORT="${RPC_PORT:-8545}"
P2P_PORT="${P2P_PORT:-9000}"
DATA_DIR="${ROOT_DIR}/data"

if [[ ! -x "${BIN}" ]]; then
    echo "bin/synaptic-node not found (or not executable) at ${BIN}" >&2
    exit 1
fi

exec "${BIN}" \
    --data-dir "${DATA_DIR}" \
    --rpc-port "${RPC_PORT}" \
    --p2p-port "${P2P_PORT}"