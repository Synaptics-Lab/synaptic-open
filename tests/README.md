# Runnable probes

Each probe is self-contained, prints PASS/FAIL per assertion, and exits 0 only
when every assertion passes.

- `probe_local_node.sh` — offline. Boots `bin/synaptic-node` on sandbox ports,
  waits for RPC, asserts `syn_chainId` (chain_id 1), `getHealth` (ok), and
  `getSlot`. Last run: 3/3 x2. Requires bash, curl.
- `probe_public_surface.sh` — online. Asserts the seven judge-visible
  production surfaces answer over HTTPS (read-only GETs; never touches write,
  settlement, or licensing endpoints). Last run: 7/7 x2. Requires curl.
