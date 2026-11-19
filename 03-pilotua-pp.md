# Pilotua: PPren programa (2026-11-16)

## Datuak

| | |
|---|---|
| Iturria | *La Reconstrucción Nacional*, PP, 82 or. — `iturriak/pp/pp-2026-la-reconstruccion-nacional.pdf` (sha256 `cea8f2a0…5ffbe`) |
| Unitateak | 262: 241 neurri zenbakidun + 21 sarrera-paragrafo — `iturriak/pp/pp-2026-unitateak.tsv` |
| Sailkapena | Decider `pplx-decider-v1.3` (OpenRouter, doakoa), 47 galdera/unitate — `datuak/pp/decider-v0.2.jsonl` |
| Kostua | 0 $ · huts egindako eskaerak: 0 |
| Kalibrazioa | 40 unitate, Claude-k independenteki etiketatuak — `datuak/pp/kalibrazioa-claude.tsv` |

**Kanpainarako gordetako neurriak.** PPk 8 neurri ez ditu argitaratu; haien tokian *"Permanezca atento a la campaña para conocer esta nueva medida"* dago: **83** (ustelkeria), **109** (pentsioak / belaunaldiak, 108 pentsio-neurriaren ondoren), **132** (memoria / sinboloak), **164, 167** (familia), **173** (autonomoak / lana), **200** (ura / landa), **210** (hezkuntza). Programa eguneratzen bada, hash-ak aldatuko du eta berriz prozesatuko da.

## Kalibrazioa: Decider vs Claude (40 unitate)

| Dimentsioa | Adostasuna |
|---|---|
| Gaia nagusia | 39/40 (98%) |
| Gaiak — recall / precision | 88% / 86% |
| D1 Ongizatea | 88% |
| D2 Lan-eskubideak | 90% |
| D3 Zergak | 98% |
| D4 Gastu publikoa | 95% |
| D5 Zehaztasuna (±0,75) | 92% |
| D6 Finantzaketa | 92% |
| D7 Taldeak — Claude-k eragina ikusten duenean | 97% |
| **D7 Taldeak — Claude-k eraginik ez duenean** | **72%** ⚠️ |
| Baieztapenak — "ez du aipatzen" | 98% |
| **Baieztapenak — jarrera dagoenean** | **9/13 (69%)** ⚠️ |

**Konfiantza oso ondo kalibratuta dago:** adostasunetan mediana 0,97; desadostasunetan 0,48.

| Muga automatikoa | Onartuak | Horietatik okerrak |
|---|---|---|
| 0,7 | 662 | 22 (3,3%) |
| **0,8** | **594** | **12 (2,0%)** |
| 0,9 | 509 | 2 (0,4%) |

## Ikasitakoa

1. **D7 (eragindako taldeak) gehiegi zabaltzen du.** Decider-ek "onura" ematen dio zeharka eragiten zaion edozein taldeari (adib. itxarote-zerrendak → pentsiodunak; nuklearrak → autonomoak). Galderaren formulazioa da arazoa, ez modeloa: "zuzenean" ez da nahikoa zehaztuta.
2. **Murrizketa ezkutuak: Decider-ek N175 galdu du.** *"Atajaremos el absentismo… reforzaremos el papel de las mutuas en la incapacidad temporal"* → Decider: ongizatea **zabaldu** (0,82), langileentzat **onura**. Hori da hain zuzen radarrak harrapatu behar duen eufemismo-mota. 0,82ko konfiantzarekin automatikoki onartuko litzateke → **ezin da soilik "murriztu" etiketak berrikusi; lan/ongizate gaietako unitate guztiak berrikusi behar dira D1/D2rako.**
3. **Baieztapenetan inferentzia gehiegi.** "Espainiaren batasuna defendatuko dugu" → S09 (erreferenduma) −2 (0,80–0,95), testuak erreferendumik aipatzen ez duen arren. N060 (amnistia/indultuak) → S10 +1 (0,51), alderantziz. Metodologiak jada eskatzen du jarrera finalak Claude-k berrikustea; pilotuak berresten du ezinbestekoa dela.
4. **D6 anbiguoa:** "el Estado financiará la mitad" finantzaketa da ala ez? Decider-ek baietz; nik ezetz. Galdera zehaztu behar da.

## Metodologia v0.3 proposamena

- **Muga automatikoa: 0,80** (D1–D4, D7, baieztapenak). Azpitik → berrikuspena.
- **D7 berridatzi:** "¿La propuesta se dirige *explícitamente* a este grupo o le afecta de forma *específica y directa* (no solo como parte de la población general)?" — eta D7 bakarrik berriz exekutatu (doakoa).
- **D6 zehaztu:** "¿Indica el coste o una fuente de financiación concreta? (No basta con decir qué administración pagará.)"
- **Murrizketen berrikuspena:** Claude-k D1/D2 berrikusten ditu G02, G03, G04, G05, G06 gaietako unitate **guztietan** (PPn ~70), ez bakarrik "murriztu" etiketadunetan.
- **Baieztapenak:** "ez du aipatzen" ez den unitate oro Claude-k berrikusten du aipuarekin; inferentzia hutsak (testuak gaia aipatzen ez duenean) baztertu.

## PPren behin-behineko jarrerak (berrikusi gabe)

| Baieztapena | Jarrera | Froga |
|---|---|---|
| S01 Alokairu-muga | −2 | N145 "Derogaremos la Ley de Vivienda… Eliminaremos las zonas tensionadas y el índice de precios" |
| S02 Lanaldi-murrizketa | — | Programak ez du aipatzen → 🗳️ Kongresuko botoa bilatu |
| S03 Osasun publikoa / itunak | +1 | N219, N220: finantzaketa eta 4.500 mediku gehiago; ez du itun pribatuak mugatzerik aipatzen |
| S04 Zerga aberatsei | −1/−2 | N183, N185 (zeharka) — berrikusteko |
| S05 Pentsioak KPI | +2 | N108 "suban cada año con el IPC" |
| S06 Erregularizazioa | −2 | N042 "Prohibiremos por ley las regularizaciones masivas" |
| S07 Euskara eskakizuna | −1 | N097 "Los requisitos lingüísticos respetarán las libertades…" |
| S08 Nazioa / aldebikotasuna | −2 | N101 "ni habrá nuevos regímenes singulares negociados bilateralmente" |
| S09 Erreferenduma | ? | Ez du esplizituki aipatzen → 🗳️ / 📄 bilatu |
| S10 Presoak | −2 | N131 "no habrá tercer grado ni libertad condicional… sin arrepentimiento" |

**Murrizketa-hautagaiak (Decider, berrikusi gabe):** N003 (egitura politikoa murriztu), N042 eta N098 (laguntzak arraigoaren arabera), N107 (defizit eta zor publikoa murriztu, pentsioak aipatuta), sarrera-paragrafo bi. Gehi N175 (absentismoa/mutuak), Decider-ek galdua. **Zerga-jaitsierak:** 30 unitate (8 errenta/enpresa handiei, 22 orokorrak).
