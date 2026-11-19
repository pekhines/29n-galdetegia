# 08 — Web-tresna (GitHub Pages)

Egoera (2026-11-19): lehen bertsioa lokalean dabil eta probatuta dago. Oraindik ez da argitaratu.

## Zer da

Webgune estatikoa da: HTML, CSS eta JavaScript hutsa, liburutegirik eta build urratsik gabe. Ez du zerbitzaririk, gakorik, cookierik edo analitikarik. Erabiltzailearen erantzunak `localStorage`-n gordetzen dira bakarrik.

| Orria | Edukia |
|---|---|
| `#/` | Sarrera: zer den, zazpi alderdiak, bederatzi gaiak |
| `#/programak/<gaia>/<alderdia>` | Gai bakoitzean: (1) galdetegiko baieztapenak, alderdi guztien jarrera eta azalpen-txartelarekin; (2) alderdiaren programa-zatiak, hitzez hitz, PDFaren orrialde-estekarekin eta bilatzailearekin. "Beste gaiak" atalean galdetegitik kanpoko 13 gaiak daude (hezkuntza, zaintza, klima…) |
| `#/galdetegia` | 27 baieztapen (v2.2), 9 gaitan. Eskala: −2…+2 gehi "Ez dakit". "Oso garrantzitsua" gai bakoitzeko (×2) |
| `#/emaitzak` | Sailkapena, "Programak / Bozketak ere" hautagailuarekin. Alderdi bat sakatuta, baieztapenez baieztapeneko adostasuna; errenkada bat sakatuta, azalpen-txartela. Partekatzeko esteka |
| `#/metodologia` | Pisuak, formula, bi moduak, gelaxka-motak, iturriak, mugak |

**Partekatzeko esteka:** `#/emaitzak?e=<27 karaktere>&g=<gai garrantzitsuak>&m=<p|b>`. `e`-ko karaktereak: `a`…`e` = −2…+2, `x` = erantzunik ez. Estekak erantzunak bakarrik dauzka.

## Fitxategiak

```
docs/
  index.html  style.css  app.js  .nojekyll
  datuak/
    galdetegia.json        ← datuak/galdetegia-v2.json (kopia)
    atalak.json            ← gaiak (G01–G22) eta blokeekiko lotura
    programa-<ID>.json     ← unitateak + gai-sailkapena (G99 kenduta), behar denean kargatzen dira
```

Tamaina: 1,8 MB guztira. Lehen kargan 130 KB inguru jaisten dira; programak alderdika kargatzen dira, behar direnean (60–450 KB).

## Datuak berriz sortzea

```
perl pipeline/galdetegia-v2-json.pl
perl pipeline/web-datuak.pl
```

Puntuazioaren formula `pipeline/Galdetegia.pm` moduluan bakarrik dago. JSONak gelaxka bakoitzaren posizioa dakar modu bakoitzean (`kontaketa.<modua>.posizioa` / `desenpatea`), eta `app.js`-k hori bakarrik aplikatzen du. Egiaztatuta: JSko emaitzak eta `galdetegia-v2.pl`-renak berdinak dira 7 profil/modu konbinaziotan.

## Lokalean probatzea

```
perl pipeline/zerbitzari.pl docs 8080
```

Gero, ireki http://localhost:8080/. `file://` bidez ez dabil, `fetch` behar duelako.

## GitHub Pages: argitalpena

**Erabakia (2026-11-19):** proiektu osoa errepo bakarrean argitaratuko da, eta weba `docs/` karpetatik zerbitzatuko da. GitHub Pages doan erabiltzeko, errepoak publikoa izan behar du. Beraz, analisiak, pipeline-a eta programen kopiak ere publikoak izango dira.

Argitaratu aurretik egiaztatutakoak:
- Ez dago gakorik. `pipeline/sailkatu.sh`-k OpenRouterren gakoa proiektutik kanpoko fitxategi batetik irakurtzen du.
- Ez dago datu pertsonalik.
- Fitxategi handiena 14 MB da (Voxen PDFa); 80 MB guztira. GitHub-en muga 100 MB da fitxategiko.
- Iturrietako HTMLak alderdien webguneetakoak dira (EH Bildu, Geroa Bai), ez prentsakoak.
- `.gitignore`-k `.claude/` eta behin-behineko fitxategiak kanpo uzten ditu.

**Urratsak.** Ingurune honetan ez dago `git`-ik, beraz git duen ordenagailu batean egin behar da:

1. GitHub-en errepo publiko berria sortu (README gabe).
2. Proiektuaren karpetan:
   ```
   git init -b main
   git add .
   git commit -m "29-N: programak, galdetegia eta weba"
   git remote add origin git@github.com:<erabiltzailea>/<errepoa>.git
   git push -u origin main
   ```
3. GitHub-en: Settings → Pages → Build and deployment → Source: *Deploy from a branch* → Branch: `main`, karpeta `/docs` → Save.
4. Minutu batzuk geroago, weba hemen egongo da: `https://<erabiltzailea>.github.io/<errepoa>/`.

**Eguneratzea:** datuak aldatu → `perl pipeline/galdetegia-v2-json.pl && perl pipeline/web-datuak.pl` → commit eta push. Pages-ek automatikoki eguneratzen du.

Bide guztiak erlatiboak dira, beraz weba edozein errepo-izenekin dabil. `docs/.nojekyll` fitxategiak Jekyll-en prozesamendua saihesten du.

## Hurrengo ideiak (ez eginak)

- **Alderdi biren alderaketa:** baieztapenez baieztapen, bi zutabetan.
- **Gaztelaniazko bertsioa** (Nafarroako erabiltzaileentzat batez ere).
- **Geroa Bai eta UPN** gehitzea, haien web-orrietako konpromisoekin, argi markatuta.
- **Zuzenketak jasotzeko bidea:** "Akats bat ikusi duzu?" esteka, GitHub issue batera edo posta-helbide publiko batera.
- **Bertsio-oharra:** datuak aldatzen badira, data eta aldaketen zerrenda orri nagusian.
- **Partekatzeko irudia (Open Graph)** sare sozialetarako.
