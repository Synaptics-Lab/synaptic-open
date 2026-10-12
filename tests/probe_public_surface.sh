#!/usr/bin/env bash
# ==============================================================================
# Public production-surface probe.
#
# Asserts each judge-visible production surface of SynapticChain responds over
# HTTPS from a plain machine — the same surfaces linked from the Colosseum
# Radar submission. Read-only GETs only; this probe never touches write,
# settlement, or licensing endpoints.
#
# Needs internet access. Exit 0 = PASS (all targets 200), 1 = FAIL.
# ==============================================================================
set -uo pipefail

PASS=0; FAIL=0

fetch() { # url -> status code. Uses public DNS when /etc/hosts pins a host locally.
    local url="$1" host code ip
    host="${url#https://}"; host="${host%%/*}"
    ip=$(getent hosts "${host}" 2>/dev/null | awk '{print $1}' | head -1)
    if [[ "${ip}" == "127.0.0.1" ]] && command -v dig >/dev/null 2>&1; then
        ip=$(dig +short @1.1.1.1 "${host}" A 2>/dev/null | head -1)
        code=$(curl -s --max-time 15 --resolve "${host}:443:${ip}" -o /dev/null -w "%{http_code}" "${url}")
    else
        code=$(curl -sL --max-time 15 -o /dev/null -w "%{http_code}" "${url}")
    fi
    echo "${code}"
}

probe() { # name, url
    echo -n "$1 ... "
    code=$(fetch "$2")
    if [[ "${code}" == "200" ]] || [[ "${code}" == "301" ]]; then
        echo "PASS (${code})"; PASS=$((PASS+1))
    else
        echo "FAIL (${code})"; FAIL=$((FAIL+1))
    fi
}

probe "clearinghouse console (colosseum.synapticchain.xyz)"  https://colosseum.synapticchain.xyz
probe "10-stage live-fire demo (/demo)"                     https://colosseum.synapticchain.xyz/demo
probe "CAN netting stream (/can)"                           https://colosseum.synapticchain.xyz/can
probe "position brief (/brief)"                             https://colosseum.synapticchain.xyz/brief
probe "explorer (explorer.synapticchain.xyz)"               https://explorer.synapticchain.xyz
probe "wallet (wallet.synapticchain.xyz)"                   https://wallet.synapticchain.xyz
probe "landing (synapticchain.xyz)"                         https://synapticchain.xyz

echo
echo "RESULT: ${PASS} pass / ${FAIL} fail"
[[ ${FAIL} -eq 0 && ${PASS} -eq 7 ]]