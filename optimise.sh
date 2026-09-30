#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  optimise.sh — portfolio Elodie Hu
#
#  Usage :  ./optimise.sh
#
#  Dépose tes exports pleine qualité dans :
#     _source/covers/   → covers de la home     (WebP 1200 px)
#     _source/projets/  → images de page projet (WebP 2000 px)
#     _source/gifs/     → GIF de survol         (GIF  640 px, recompressé)
#
#  Les fichiers optimisés arrivent dans images/.
#  Les sources restent dans _source/ (jamais publiées, cf .gitignore).
#
#  Prérequis, une seule fois :  brew install webp gifsicle
# ─────────────────────────────────────────────────────────────

set -e
cd "$(dirname "$0")"

QUALITY=80          # qualité WebP
W_COVER=1200        # largeur covers home
W_PROJET=2000       # largeur images page projet
W_GIF=640           # largeur GIF de survol
GIF_LOSSY=60        # compression GIF (0 = sans perte, 100 = agressif)

for bin in cwebp gifsicle; do
  command -v $bin >/dev/null || { echo "❌ '$bin' manquant. Lance : brew install webp gifsicle"; exit 1; }
done

mkdir -p _source/covers _source/projets _source/gifs images

total_before=0
total_after=0
count=0

human() { awk -v b="$1" 'BEGIN{ if(b>1048576) printf "%.1f Mo", b/1048576; else printf "%.0f Ko", b/1024 }'; }

convert_webp() {
  local dir="$1" width="$2" label="$3"
  shopt -s nullglob nocaseglob
  for src in "$dir"/*.{png,jpg,jpeg,tif,tiff}; do
    local base name out before after
    base=$(basename "$src")
    name="${base%.*}"
    out="images/${name}.webp"
    before=$(stat -f%z "$src")
    cwebp -q $QUALITY -m 6 -resize $width 0 -metadata none "$src" -o "$out" >/dev/null 2>&1
    after=$(stat -f%z "$out")
    total_before=$((total_before + before))
    total_after=$((total_after + after))
    count=$((count + 1))
    printf "  %-34s %9s → %9s   (%s)\n" "$name.webp" "$(human $before)" "$(human $after)" "$label"
  done
  shopt -u nullglob nocaseglob
}

convert_gif() {
  shopt -s nullglob nocaseglob
  for src in _source/gifs/*.gif; do
    local base out before after
    base=$(basename "$src")
    out="images/$base"
    before=$(stat -f%z "$src")
    gifsicle --resize-width $W_GIF --lossy=$GIF_LOSSY --colors 128 -O3 "$src" -o "$out"
    after=$(stat -f%z "$out")
    total_before=$((total_before + before))
    total_after=$((total_after + after))
    count=$((count + 1))
    printf "  %-34s %9s → %9s   (gif survol)\n" "$base" "$(human $before)" "$(human $after)"
    if [ "$after" -gt 2500000 ]; then
      printf "     ⚠  au-dessus de 2,5 Mo — raccourcis la boucle ou baisse le framerate\n"
    fi
  done
  shopt -u nullglob nocaseglob
}

echo ""
echo "── Optimisation ──────────────────────────────────────────"
convert_webp _source/covers  $W_COVER  "cover home"
convert_webp _source/projets $W_PROJET "page projet"
convert_gif
echo "──────────────────────────────────────────────────────────"

if [ "$count" -eq 0 ]; then
  echo "  Rien à traiter. Dépose tes fichiers dans _source/ puis relance."
else
  saved=$((100 - total_after * 100 / total_before))
  printf "  %d fichier(s)   %s → %s   (−%d %%)\n" \
    "$count" "$(human $total_before)" "$(human $total_after)" "$saved"
fi
echo ""
