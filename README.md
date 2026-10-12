# SynapticChain — Open Node

> Run the SynapticChain Layer-1 node and verify the platform — **without the
> proprietary source**. You get the production node binaries, an example
> SynapticLang contract set, a local-corridor config sample, the live test
> receipts, and two runnable probes.

SynapticChain is an L1 built around **compiler-driven static scheduling**:
contracts in SynapticLang compile to fully resolved execution plans
(dependency-aware, statically scheduled) that the SynapticVM executes with
parallel lanes — deterministic by construction. The product on top is a
**zero-trust banking clearinghouse**: multilateral netting with margin custody
plus x402/MCP gateway services and ISO 20022 (pacs.008/pacs.002) interop.

The core monorepo (23-crate Rust workspace) is proprietary. This repository is
the public verification path: run it, probe it, read the receipts. Deeper
source access is granted on diligence request — the boundary is
confidentiality, not concealment.

---

## Quick start

Linux x86_64, no build step, no stake, no keys required:

```bash
git clone https://github.com/Synaptics-Lab/synaptic-open.git
cd synaptic-open
./scripts/start-local-node.sh
```

In a second terminal:

```bash
curl -s -X POST http://127.0.0.1:8545 -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"syn_chainId","params":[]}'
# {"jsonrpc":"2.0","result":{"chain_id":1},"id":1}
```

The node boots in seconds into a fresh local genesis (cortex mode, 3 shards),
serves JSON-RPC on `:8545` and P2P on `:9000`, and initializes its own state —
no genesis file and no external bootstrap needed. Ctrl-C stops it; `data/`
holds state and can be deleted for a fresh chain.

CLI (`bin/synaptic`) supports `init`, `start`, `status`, `keys`, `deploy`,
`call`, `query`, `tx`. Run `./bin/synaptic --help`.

### The RPC surface

The node answers **67 JSON-RPC methods** — the Solana-compatible subset (24
methods: `getBalance`, `getBlock`, `getSlot`, `sendTransaction`,
`getSignatureStatuses`, ...) plus 43 `syn_*` methods (`syn_chainId`,
`syn_getCheckpoint`, `syn_listCorridors`, `syn_getValidators`,
`syn_callContractV2`, `syn_getSequencerAttestation`, `syn_getDagTip`,
`syn_getSATAMetrics`, ...). An unknown method answers with the full list —
that is one reliable way to see the API shape without any credentials:

```bash
curl -s -X POST http://127.0.0.1:8545 -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"nope","params":[]}'
```

---

## What is in this repository

| Path | Contents |
|---|---|
| `bin/` | `synaptic-node` (cortex node) and `synaptic` (CLI), Linux x86_64, release build, Sept 2026 — the same binary family running the production validators. `CHECKSUMS.txt` carries SHA-256. |
| `scripts/` | `start-local-node.sh` — the 20-line launcher used in the quick start. |
| `contracts/` | Three example SynapticLang contracts (`coinflip.syn`, `minimal_token.syn`, `staking.syn`) showing the language: annotated access patterns (`#[reads]/#[writes]`), static scheduling, `require!`, `msg.sender`. This is the DSL taste sample; the production clearinghouse contract stays private. |
| `config/` | `corridors.example.toml` — the interledger corridor registry format the settlement engine loads (XRPL testnet corridors). |
| `scores/` | `SCORES.md` — the full verification record: platform test census, the 13 suite scores with live receipts, and honest-boundary language. `scores/receipts/` carries the raw JSON of the most recent cross-rail receipts. |
| `tests/` | Runnable probes: `probe_local_node.sh` (boots the node on sandbox ports and asserts three RPC facts — ran 3/3 twice), `probe_public_surface.sh` (asserts all 7 judge-visible production surfaces answer HTTPS — ran 7/7 twice). |

---

## Run the probes yourself

```bash
./tests/probe_local_node.sh     # offline; 3/3 PASS expected
./tests/probe_public_surface.sh # online; 7/7 PASS expected
```

`probe_local_node.sh` proves the shipped binary initializes fresh state and
serves the JSON-RPC honestly. `probe_public_surface.sh` proves the live
production surfaces (clearinghouse console, /demo, /can, /brief, explorer,
wallet, landing) answer from anywhere — the same checks a judge can repeat on
day one of review.

---

## What is deliberately not here

- The 23-crate Rust workspace (node runtime, SCBFT consensus with
  DAG-primary multi-proposer ordering, SynapticLang compiler, VM,
  libp2p networking, RocksDB/QMDB state, ISO 20022 gateway). Proprietary —
  available to diligence partners under NDA.
- The production clearinghouse contract
  (`MultilateralNettingClearinghouse.syn`) and estate operations tooling.
- Any private endpoint, mesh topology, or key material — verified by scan
  before publishing.

What replaces that access: the live consoles listed below, the scores with
receipts, and the two runnable probes in `tests/`.

---

## Live surfaces

- **Clearinghouse console** — [colosseum.synapticchain.xyz](https://colosseum.synapticchain.xyz)
- **10-stage live-fire demo** — [colosseum.synapticchain.xyz/demo](https://colosseum.synapticchain.xyz/demo)
- **Continuous Atomic Netting stream** — [colosseum.synapticchain.xyz/can](https://colosseum.synapticchain.xyz/can)
- **Position brief** — [colosseum.synapticchain.xyz/brief](https://colosseum.synapticchain.xyz/brief)
- **Explorer** — [explorer.synapticchain.xyz](https://explorer.synapticchain.xyz)
- **Wallet** — [wallet.synapticchain.xyz](https://wallet.synapticchain.xyz)
- **Landing** — [synapticchain.xyz](https://synapticchain.xyz)

Testnet rails are named exactly: XRPL TESTNET (altnet), Solana DEVNET,
SynapticChain L1 testnet.

---

## Verification record

See [`scores/SCORES.md`](scores/SCORES.md) for the full record: >4,800 test
functions/assertions platform-wide, the 13-suite score table, and the honest
boundary. Score companion repositories:
[synaptic-fx-terminal](https://github.com/Synaptics-Lab/synaptic-fx-terminal),
[x402-tswp](https://github.com/Synaptics-Lab/x402-tswp),
[finITe](https://github.com/Synaptics-Lab/finITe),
[syn-stripe-bridge](https://github.com/Synaptics-Lab/syn-stripe-bridge), and
the rest of [Synaptics-Lab](https://github.com/Synaptics-Lab).

## License

© Synaptics Lab. All rights reserved. The binaries in `bin/` are provided for
evaluation and private testing; redistribution or commercial use requires
written permission. Source code remains proprietary; the example contracts in
`contracts/` and the configuration sample in `config/` are provided as-is for
evaluation. Contact: veritasvaultone@gmail.com.

*SynapticChain — Rewiring value transfer.*