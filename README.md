# Portfolio Elodie Hu — mode d'emploi

Site statique, hébergé sur GitHub Pages → **elodiehu.com**

---

## 1. Installer les outils (une seule fois)

Ouvre le Terminal et colle ces deux lignes :

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install webp gifsicle
```

La première installe Homebrew (le gestionnaire de logiciels en ligne de commande du Mac), la seconde installe les deux outils de compression. Si Homebrew est déjà installé, saute la première ligne.

---

## 2. Optimiser des images

Dépose tes exports **pleine qualité** dans le bon dossier :

| Dossier | Pour quoi | Sortie |
|---|---|---|
| `_source/covers/` | Vignettes de la page d'accueil | WebP 1200 px |
| `_source/projets/` | Images dans les pages projet | WebP 2000 px |
| `_source/gifs/` | Boucles de survol | GIF 640 px recompressé |

Puis, dans le terminal de VS Code :

```bash
./optimise.sh
```

Les fichiers optimisés arrivent dans `images/`, et le script affiche le poids avant/après de chacun.

Le dossier `_source/` n'est **jamais publié** (il est dans `.gitignore`) : tu peux y garder tes fichiers lourds sans alourdir le site.

---

## 3. Réglages d'export recommandés

### Cover statique
- Format d'export : PNG ou JPG qualité maximale, peu importe la taille
- Ratio **16:9** (la vignette recadre automatiquement au centre sinon)
- Le script s'occupe du redimensionnement et de la compression

### GIF de survol (export Adobe)
- **640 px de large**, ratio 16:9
- **3 à 4 secondes**, boucle sans coupure franche
- **12 à 15 images/seconde**
- **128 couleurs**, tramage Diffusion, transparence désactivée
- Le script recompresse derrière et retire 30-50 % du poids

Objectif : **moins de 2,5 Mo par GIF**. Le script prévient si c'est dépassé.

---

## 4. Ajouter un projet à la page d'accueil

Dans `index.html`, copie un bloc de carte et adapte-le :

```html
<a class="project-card" href="mon-projet.html">
  <div class="thumbnail">
    <img src="images/mon-cover.webp"
         alt="Description du visuel"
         loading="lazy"
         data-gif="" />
  </div>
  <p class="project-name">Nom du projet</p>
</a>
```

- `href` → la page du projet
- `src` → la cover statique
- `alt` → une vraie description (c'est ce que lit Google, et les lecteurs d'écran)
- `data-gif` → **laisse vide tant que tu n'as pas de GIF**
- `loading="lazy"` → à retirer uniquement sur les 3 premières cartes

### Activer le survol GIF

Une fois le GIF dans `images/`, remplis l'attribut :

```html
data-gif="images/mon-projet.gif"
```

C'est tout. Le GIF ne se télécharge qu'au moment du survol, et jamais sur mobile.

---

## 5. Publier

```bash
git add .
git commit -m "Description de ce que tu as changé"
git push
```

GitHub Pages met le site à jour en 1 à 2 minutes.

---

## Repères de poids

| Élément | Cible |
|---|---|
| Cover home (WebP 1200 px) | 40 – 150 Ko |
| Image page projet (WebP 2000 px) | 100 – 400 Ko |
| GIF de survol (640 px) | 1 – 2,5 Mo |
| **Page d'accueil complète, au chargement** | **~1,5 Mo** |

Si un fichier dépasse largement ces valeurs, c'est qu'il est trop grand ou trop long, pas qu'il est trop beau.
