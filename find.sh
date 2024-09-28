#!/bin/bash

set -eu
args=()

opit=$PWD/E3Q_EUR_OPENX.pit
pit=${opit}.readable

/Applications/heimdall-frontend.app/Contents/MacOS/heimdall print-pit --file $opit >$pit

# for f in BL/* AP/* CP/* CSC_OXM/*; do
for f in BL/* AP/* CP/* HOME_CSC_OXM/*; do
	if test -d "$f"; then continue; fi
	fn="${f##*/}"
	pn="$(grep -B1 "Flash Filename: ${fn}" "${pit}")" || exit 1
	pn="$(echo "$pn" | head -n1 | awk '{print $3}')"
	args+=(--${pn} ${f})
done

echo /Applications/heimdall-frontend.app/Contents/MacOS/heimdall flash "${args[@]}"
