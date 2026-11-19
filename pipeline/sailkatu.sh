#!/usr/bin/env bash
# Erabilera: sailkatu.sh <unitateak.tsv> <irteera.jsonl> [galderak.json] [modeloa]
# unitateak.tsv: id <TAB> atala <TAB> orrialdea <TAB> testua   (lerro bat unitate bakoitzeko)
# Irteera: JSONL, lerro bat unitate bakoitzeko: {"id":..., "erantzuna": <Decider-en JSON gordina>}
# Gakoa: OPENROUTER_API_KEY, edo grok-image-gen skill-aren .apikey fitxategia.
set -euo pipefail

UNITATEAK="$1"
IRTEERA="$2"
GALDERAK="${3:-$(dirname "$0")/galderak-v0.2.json}"
MODELOA="${4:-perplexity/pplx-decider-v1.3:free}"
URL="https://openrouter.ai/api/alpha/decisions"

if [ -z "${OPENROUTER_API_KEY:-}" ]; then
  OPENROUTER_API_KEY=$(tr -d '[:space:]' < "$HOME/.claude/skills/grok-image-gen/.apikey")
fi

Q=$(cat "$GALDERAK")
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Lehendik sailkatutako unitateak saltatu (berrabiarazteko)
touch "$IRTEERA"

json_escape() {
  perl -0777 -pe 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g; s/\r//g; s/\n/\\n/g; s/([\x00-\x08\x0b\x0c\x0e-\x1f])/sprintf("\\u%04x", ord($1))/ge'
}

n=0
while IFS=$'\t' read -r id atala orria testua; do
  [ -z "$id" ] && continue
  if grep -q "^{\"id\":\"$id\"" "$IRTEERA"; then continue; fi
  state=$(printf 'Partido: %s\nSección: %s\n\n%s' "${ALDERDIA:-}" "$atala" "$testua" | json_escape)
  printf '{"model":"%s","state":"%s","questions":%s}' "$MODELOA" "$state" "$Q" > "$TMP/req.json"
  for saiakera in 1 2 3; do
    erantzuna=$(curl -s -m 90 -X POST "$URL" \
      -H "Authorization: Bearer $OPENROUTER_API_KEY" \
      -H "Content-Type: application/json" \
      --data-binary @"$TMP/req.json") || erantzuna=""
    if printf '%s' "$erantzuna" | grep -q '"answers"'; then break; fi
    echo "  $id: $saiakera. saiakerak huts egin du: $(printf '%s' "$erantzuna" | head -c 200)" >&2
    sleep $((saiakera * 5))
  done
  printf '{"id":"%s","orria":"%s","erantzuna":%s}\n' "$id" "$orria" "${erantzuna:-null}" >> "$IRTEERA"
  n=$((n + 1))
  [ $((n % 20)) -eq 0 ] && echo "  $n unitate sailkatuta" >&2
done < "$UNITATEAK"
echo "Eginda: $n unitate berri → $IRTEERA" >&2
