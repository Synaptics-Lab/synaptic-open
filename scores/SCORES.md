# Verification record — SynapticChain estate (2026-10-12)

Measured on the live tree; every live receipt below was run twice unless noted.

## Platform test census (grep-based, measured on the live tree)

- **>4,800 test functions/assertions platform-wide** — 3,347 Rust test functions
  across the 23-crate L1 workspace (2,713 in 554 `.rs` files, 226,550 LOC —
  heaviest: consensus 694, synaptic-types 373, state 299, compiler 247, p2p 221,
  node 220, vm 180) plus 634 across the estate's Rust service programs (CAN
  executor, Solana escrow program, verification suite, fuzz targets).
- **178 property-test macros** (`proptest`/`quickcheck`) and `criterion`
  benchmark suites for consensus, node, and storage.
- **1,161 SDK test functions** (Python + TypeScript SDKs, 37 test files) and
  ~310 more across the gateway, terminal, and service test suites.
- **Formal invariant verification (FIV v4.4): 12/12 invariants passing**;
  automated vulnerability-triage harness (SVAH v1.0).
- **FINOS Open Source Maturity Model: Level 5 (highest tier), Grade A+, 24/24.**

## Cross-rail end-to-end suites (live receipts, each run twice)

| Suite | Score |
|---|---|
| Colosseum app preflight (edge-mode, strict TLS) | 21 PASS / 0 FAIL ×2 |
| finITe — FINOS conformance suite vs our agent | 131/132 ×2 |
| Interledger devnet E2E (two-ledger loop) | 13/13 ×2 |
| FDC3 StartPayment → clearinghouse bridge | 15/15 ×2 |
| R15 MCP m2m corridors | 81/81 ×2 |
| R15 watermark rolling settlement | 24/24 ×2 |
| R13 multi-rail (Solana + XRPL mixed) phase 10 | 14/14 ×2 |
| Corridor 17 (sUSD/cTZS) | 24/24 ×2 |
| Stripe-compatible card-rail shim (honest-core :8092) | E2E ×2 GREEN, F1–F9 closed, spend-cap 9/9 ×2 |
| 10-stage live wire loop (FDC3 intent → netting → dual-rail evidence → margin settlement → finalize → same-UETR pacs.008 render) | ALL 11 stages GREEN ×2 (2026-10-12) |
| Uhuru/UTA audit battery | 17/17 ×2; verdict PASS-WITH-NOTES |
| Daily preflight + phase ladder (cron) | 2 pairs/day, GREEN since 2026-10-08 |
| `tests/probe_local_node.sh` in this repo | 3/3 ×2 (2026-10-12) |
| `tests/probe_public_surface.sh` in this repo | 7/7 ×2 (2026-10-12) |

## Receipts

The two JSON files under `scores/receipts/` are the raw demo-driver run logs of
the 10-stage live wire loop's most recent consecutive GREEN pair
(`leg-33c2125537a0.json`, `leg-b22d0ce87a55.json`, sessions 102/103): the
clearinghouse sessions seal with `final_status=3`, idempotency replay answers
honestly, and the outbound pacs.008.001.08 renders from the same UETR.

## Honest boundary (stated plainly)

- The Tier-0 external audit is scoped and packaged but **not yet executed** by
  an external third party.
- Every address in our repositories is live-read from the mesh, never
  fabricated; refusals are rendered verbatim; write transactions are never
  trusted without an on-ledger readback.
- Testnet rails named exactly: XRPL TESTNET (altnet), Solana DEVNET,
  SynapticChain L1 testnet.

## Live consoles

- Clearinghouse console — https://colosseum.synapticchain.xyz
- 10-stage live-fire demo — https://colosseum.synapticchain.xyz/demo
- CAN netting stream — https://colosseum.synapticchain.xyz/can
- Position brief — https://colosseum.synapticchain.xyz/brief
- Institutional FX terminal — https://terminal.synapticchain.xyz
- Explorer — https://explorer.synapticchain.xyz · Wallet — https://wallet.synapticchain.xyz