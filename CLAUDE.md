# Conventions du portfolio

## Réponses

Court. Phrases simples. Pas d'explication technique sauf si elle est demandée.
Dire ce qui a été fait, rien de plus.

Règles à appliquer par défaut sur tout le site, sans redemander.

## Espacements

- **Tous les médias sont espacés de 12 px**, horizontalement comme verticalement.
  Cela vaut entre les vidéos d'une même grille, entre les images, et entre le
  groupe de vidéos et les images qui le suivent.
- Nom de projet sur la home : 5 px sous la vignette, ferré à droite.

## Médias des pages projet

- Les vidéos vont dans un `.media-row` (grille, `gap: 12px`), les images en
  dessous dans des `.media-full` (pleine largeur, proportion d'origine, **jamais**
  de recadrage).
- Les blocs vidéo gardent leur ratio d'origine : `1 / 1` pour les formats carrés,
  `16 / 9` pour les formats paysage.
- Toutes les iframes YouTube sont en `loading="lazy"`.
- Responsive : sous 540 px, les grilles de vidéos passent à 1 colonne (16:9) ou
  2 colonnes (carré).

## Images

- Format **WebP** uniquement.
- Largeurs : **1600 px** pour les covers de la home, **2800 px** pour les images
  de page projet. Ces valeurs couvrent l'affichage Retina — descendre en dessous
  produit du flou.
- **Sans perte** si l'image a moins de 5 000 couleurs (illustrations à aplats),
  sinon qualité 88 avec rééchantillonnage Lanczos.
- Sources conservées dans `_source/` (jamais publié, cf `.gitignore`).
- **Aucune correction colorimétrique.** Les fichiers sont encodés tels quels,
  même si une vidéo et une image voisines ne tombent pas exactement sur la
  même teinte.

## Vidéos

- MP4 H.264, 1600 px, CRF 26, sans piste audio, `-movflags +faststart`.
- `<video autoplay loop muted playsinline preload="metadata">` avec un
  `poster` en WebP tiré de la première image.

## Code

- Aucun code mort : tout ce qui n'est pas visible en ligne est supprimé, pas
  commenté.
- Ne jamais restaurer un élément supprimé sans demander d'abord.
- Les `alt` décrivent réellement le visuel.
