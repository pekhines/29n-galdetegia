# Galdetegia v2.2 — 27 baieztapen, 9 bloke (2026-11-19)

*Zein alderdiren gertuen zaude? EH Hegoaldeko hautesle batentzat, 29-N hauteskunde orokorretarako. Datuak: [`datuak/galdetegia-v2.tsv`](datuak/galdetegia-v2.tsv). Puntuazioa eta simulazioa: [`pipeline/galdetegia-v2.pl`](pipeline/galdetegia-v2.pl) → [`datuak/galdetegia-v2-simulazioa.txt`](datuak/galdetegia-v2-simulazioa.txt). Posizioak Claude-ren sailkapenetik datoz (v0.3.1). Zuk ez dituzu oraindik berrikusi.*

## Zergatik v2

v1eko 10 baieztapenekin EH Bildu, Frente Amplio eta Podemos ia bereiztezinak ziren. v2k hiru gauza aldatu zituen:

1. **Gai gehiago, barometroaren arabera pisatuta:** etxebizitza, lana, osasuna, segurtasuna eta immigrazioa (Soziometroa 2026-10), gehi euskara eta nazioa (zure lehentasunak).
2. **Intentsitatea bereizten zuten baieztapenak:** adibidez, "alokairuak mugatu *eta jaitsi*" edo "erreferendum lotesle bat *independentzia barne*".
3. **Euskal Herriko berariazko gaiak:** euskal lan-esparrua, Kontzertua, Ertzaintza integrala eta Estatutua osorik.

## Zergatik v2.2 (2026-11-19): alborapena zuzentzea

v2.1ean, 25 baieztapenetatik 23tan "ados" egotea ezkerreko edo abertzale jarrera zen. Jende askok "bai" esateko joera du edukia gorabehera (*acquiescence bias*). Ondorioz, baieztapen guztiei "Guztiz alde" erantzunda EH Bildu % 93rekin ateratzen zen, eta Vox % 29rekin. Gainera, baieztapen batzuek bi gauza galdetzen zituzten batera, eta beste batzuek alde bateko hitz kargatuak erabiltzen zituzten. v2.2ko aldaketak:

1. **Norabidea orekatuta:** 13 baieztapenetan "ados" = ezker/abertzale, 13tan = eskuin/zentralista, eta bat adostasunezkoa da (P1). Alderantzikatutako baieztapenetan, alderdien posizioak eta bozketak zeinuz aldatu dira; frogak eta azalpenak berdinak dira.
2. **Baieztapen bikoitzak sinplifikatuta:**
   - H1: "mugatu" bakarrik, "jaitsi" gabe.
   - L1: "murriztu", 32 ordu gabe.
   - L2: "garestitu", 45 egun eta berronartzea gabe.
   - N1: aldebikotasuna kenduta.
   - N3: birzentralizazioa kenduta; N5 berrian dago orain.
   - K2: 135. artikulua kenduta.
   - K3: NATO kenduta.
   - G2: espetxe iraunkorra kenduta.
   - G3: "Estatuko indarrak atera" kenduta.
   - P1: erretiro-adina kenduta.
3. **Hitz neutroagoak:**
   - "Herritarren Segurtasunerako Legea («Mozal Legea»)".
   - "Etxebizitza-funts handiak" (lehen: "espekulatzeko").
   - N4 (presoak) PPren proposamen zehatzaren inguruan idatzita: damua eta lankidetza onurak lortzeko. Lehen EH Bilduren hitzak ziren ("salbuespen-neurririk gabe").
4. **Eskuina bereizteko bi baieztapen berri:**
   - N5: eskumenak Estatuari itzultzea (Vox +1z, PP −1).
   - G4: genero-indarkeriaren legea indargabetzea (Vox +2, PP −1z).
5. **Proba iraunkorra simulazioan:** erantzun uniformeen proba (5. atala). v2.2an, alderdien arteko aldea 15 puntukoa da gehienez edozein erantzun uniformerekin. v2.1ean 64 puntukoa zen.

Kostua: ezkerraren barruko intentsitate-bereizketa galdu da. FA–Podemos adostasuna % 97ra igo da, eta EH Bildu–FA % 92ra.

## Blokeak eta pisuak (100 puntu)

| Blokea | Pisua | Baieztapenak | Arrazoia |
|---|---|---|---|
| Etxebizitza | 20 | H1–H3 | Soziometroa: % 72, lehena |
| Lana eta soldatak | 15 | L1–L3 | % 40, bigarrena |
| Euskal nazioa eta autogobernua | 15 | N1–N5 | Zure lehentasuna |
| Ekonomia | 12 | K1–K4 | Arazo pertsonaletan lehena (% 27) |
| Euskara | 10 | E1–E3 | Zure lehentasuna |
| Osasuna | 10 | O1–O2 | % 22; Nafarroan lehena |
| Segurtasuna | 8 | G1–G4 | % 16; udalerri batzuetan lehena |
| Immigrazioa | 5 | I1–I2 | % 13 |
| Pentsioak | 5 | P1 | Langileentzat garrantzitsua, baina alderdiek antzeko jarrera dute |

Gaien aukeraketa eta pisuak diseinu-erabakiak dira: EHko tresna bat, euskara eta nazioa lehenetsita. Webeko metodologian hala esaten da.

## Baieztapenak eta alderdien posizioak

*+2 guztiz ados · +1 ados · 0 neutroa · −1 aurka · −2 guztiz aurka · **·** ez du aipatzen · z = zeharka · C = programa isilik, Kongresuko jokabidea (`datuak/c-aukera.tsv`). "Ados =" zutabeak adierazten du baieztapenarekin ados egotea zein jarrerari dagokion. Froga bakoitzaren unitate-IDak datu-fitxategian daude.*

| # | Ados = | Baieztapena | PNV | EHB | PSOE | FA | POD | PP | VOX |
|---|---|---|---|---|---|---|---|---|---|
| **H1** | eskuin./zentr. | Estatuak ez luke alokairuen preziorik legez mugatu behar. | · | −2 | −2 | −2 | −2 | +2 | +2 |
| **H2** | ezker/abertz. | Etxebizitza-funts handiei eta jabe handiei etxebizitzak erostea mugatu edo zerga bereziekin kargatu behar zaie. | +1 | +2 | +1 | +2 | +2 | −1z | +1 |
| **H3** | eskuin./zentr. | Ez da pisu turistikoen kopurua legez murriztu behar. | −1 | −1 | −1 | −2 | −2 | +1C | −1 |
| **L1** | ezker/abertz. | Lanaldi legala murriztu behar da (adibidez, 37,5 ordura), soldata jaitsi gabe. | +2C | +2 | +2 | +2 | +2 | −2C | −2C |
| **L2** | eskuin./zentr. | Ez da bidegabeko kaleratzea garestitu behar. | −1C | −2 | −2 | −2 | −2 | +1C | +2 |
| **L3** | ezker/abertz. | Hego Euskal Herriak lan-arloan erabakitzeko gaitasun propioa izan behar du (gutxieneko soldata eta hitzarmen kolektiboak barne). | +2 | +2 | +1C | 0C | · | 0C | 0C |
| **N1** | ezker/abertz. | Euskal Herria nazio gisa aitortu behar da. | +2 | +2 | · | +1 | +1 | −2 | −2 |
| **N2** | eskuin./zentr. | Ez da onartu behar independentziari buruzko erreferendum loteslerik Euskal Herrian. | −1z | −2 | +1C | −1 | · | +2 | +2 |
| **N3** | ezker/abertz. | Gernikako Estatutua eta Nafarroako Amejoramendua osorik bete behar dira, falta diren eskumen guztiak transferituta. | +2 | +2 | 0 | +1 | · | −2 | −2 |
| **N4** | eskuin./zentr. | ETAgatik zigortutako presoek espetxe-onurak (hirugarren gradua, baldintzapeko askatasuna) lortzeko, damua eta justiziarekiko lankidetza eskatu behar zaizkie. | · | −2 | · | · | · | +2 | +2 |
| **N5** | eskuin./zentr. | Autonomia-erkidegoen eskumen batzuk (hezkuntza, osasuna) Estatuari itzuli behar zaizkio. | −2 | −2 | −2 | −2 | · | −1 | +1z |
| **K1** | eskuin./zentr. | Enpresei eta errenta altuenei zergak jaitsi behar zaizkie. | 0C | −2 | −2 | −2 | −2 | +1z | +2 |
| **K2** | ezker/abertz. | Gastu sozialak lehentasuna izan behar du defizita eta zorra murriztearen aurretik. | +1 | +2 | −1 | +2 | +2 | −2 | −2 |
| **K3** | eskuin./zentr. | Defentsa-gastua handitu behar da. | +1C | −2 | +1 | −2 | −2 | +2 | +2 |
| **K4** | ezker/abertz. | Kontzertu Ekonomikoa eta Hitzarmena zabaldu behar dira, euskal erakundeei zerga-gaitasun gehiago emanez. | +2 | +2 | +2C | +2C | +2C | −1 | −2C |
| **E1** | eskuin./zentr. | Estatuko administrazioan, Euskal Herrian lan egiteko nahikoa izan behar da gaztelania jakitea. | −1 | −2 | −1 | −1 | · | +1 | +2 |
| **E2** | ezker/abertz. | Euskarak ofiziala izan behar du Estatuko erakunde komunetan eta Europar Batasunean, gaztelaniaren pare. | +2 | +2 | +2 | +2 | +1z | −2 | −2C |
| **E3** | ezker/abertz. | Euskarazko kultura eta ikus-entzunezkoak legez babestu eta finantzatu behar dira (kuotak, funtsak). | · | +2 | +1 | +1 | +1 | · | · |
| **O1** | eskuin./zentr. | Itxaron-zerrendak murrizteko, osasun publikoak zentro pribatuekin itun gehiago egin behar ditu. | · | −2 | −2 | −2 | −2 | · | +1 |
| **O2** | ezker/abertz. | Osasun publikoaren finantzaketa legez bermatu behar da (BPGaren % 7 gutxienez). | · | · | +2 | +2 | +2 | +1 | +1z |
| **G1** | ezker/abertz. | Herritarren Segurtasunerako Legea («Mozal Legea») indargabetu behar da. | +1 | +2 | +1C | +2 | +2 | −1z | −2C |
| **G2** | eskuin./zentr. | Delinkuentziari zigor gogorragoekin erantzun behar zaio, batez ere multierreinzidentziari. | +1 | −2C | +1C | −2 | −1 | +2 | +2 |
| **G3** | ezker/abertz. | Ertzaintzak eta Foruzaingoak polizia integral izan behar dute, beren lurraldeetako segurtasun-eskumen guztiekin. | +2 | +2 | +1C | +1 | +1C | −1z | −1C |
| **G4** | eskuin./zentr. | Genero-indarkeriaren aurkako legea (2004) indargabetu behar da. | −1z | −2 | −2 | −2 | −2 | −1z | +2 |
| **I1** | eskuin./zentr. | Ez da egoera irregularrean dauden etorkinen erregularizazio orokorrik egin behar. | −1 | −2 | −1C | −2 | −2 | +2 | +2 |
| **I2** | ezker/abertz. | Etorkinek zerbitzu publikoetarako (osasuna, prestazioak, etxebizitza) sarbide berdina izan behar dute, egoera administratiboa edozein dela ere. | +1 | +2 | +1 | +2 | +2 | −1 | −2 |
| **P1** | adostasuna | Pentsioak KPIaren arabera eguneratu behar dira. | +2 | +2 | +2 | +2 | +2 | +2 | −1C |

**Erabaki nabarmenak (zuk berrikusteko):**
- **H1, PNV isilik:** programak alokairua "arautzea" eta praktika espekulatiboak murriztea aipatzen ditu, baina ez prezio-mugarik (PNV-1.1-05, 1.1-06).
- **H2/H3, Vox:** Voxek fondo espekulatiboen eta EBtik kanpoko erosleen gaineko "fiskalitate astuna" proposatzen du (H2 +1), eta pisu turistikoen "ugaritze masiboaren" erregulazioa (H3 −1). Hala ere, H3n iragarki ilegalen legearen aurka bozkatu zuen (kontraesana).
- **N1, FA eta Podemos +1:** biek Estatu plurinazionala proposatzen dute, baina ez dute Euskal Herria nazio gisa izendatzen.
- **N2, PSOE +1C:** PSOEk eta PPk Mahaian blokeatu zituzten PNVren zuzenketak. Prozedura-erabakia da, ez bozketa.
- **N4:** PPren proposamena da (PP-N131). EH Bilduk aurka egiten du (EHB-27-08), eta beste lauak isilik daude. 2024ko aho bateko bozketa (EBn betetako zigorrak) ez dago baieztapen honi lotuta.
- **N5, Vox +1z:** Voxen 2026ko programak ez du esplizituki eskumenak itzultzea aipatzen, zerbitzuak Espainia osoan "berdinak" izatea baizik (VOX-025). PPk Autonomien Estatua defendatzen du (PP-N016).
- **G3, PNV +2:** "Estatuko indarrak atera" kenduta, PNVren jarrera (Ertzaintza polizia integrala) EH Bildurenarekin bat dator.
- **G4, PNV eta PP −1z:** ez dute legea aipatzen, baina egungo babes-esparrua garatzeko neurriak proposatzen dituzte.
- **Aho bateko bozketak ez dira kontatzen** (2026-11-19).
- **2026-11-18 eguneraketa:** programa isilik zegoen gelaxka asko Kongresuko bozketekin bete ziren (PNVren K3: adierazpen publikoa), C gisa markatuta. Kontraesanak eta bi kontaketa-moduak: ikus "Puntuazioa".

## Puntuazioa

1. Erabiltzaileak baieztapen bakoitzean −2 eta +2 artean erantzuten du, edo "ez dakit" (orduan ez da zenbatzen).
2. Gelaxka bakoitzak bi geruza ditu: **programa** (2026ko programaren posizioa) eta **bozka** (XV. legegintzaldiko Kongresuko jokabidea, 2023–2026, `datuak/c-aukera.tsv`). Bozka-geruza 32 gelaxkatan dago: programa isilik zegoen 27tan, eta programa ere badagoen 5etan.
3. **Kontraesana:** programak eta bozkak zeinu kontrakoa dute (bata > 0, bestea < 0). Norabide bereko intentsitate-aldeak ez dira kontraesana: adibidez, Podemosek multierreinzidentzia-legearen aurka bozkatu izana (−2) bat dator haren programarekin (−1). Hiru kontraesan daude:

   | Gelaxka | Programa | Bozka |
   |---|---|---|
   | PP · K4 | −1 (zerga-agentziaren batasuna) | +2 (Kontzertuaren erreforma, 2025-04) |
   | PP · I1 | +2 (erregularizazio masiboak debekatu) | −1 (ILPa izapidetzearen alde, 2024-04) |
   | Vox · H3 | −1 (pisu turistikoak arautu) | +1 (iragarki ilegalen legearen aurka, 2025-10) |

   (v2.2an I1 eta H3 baieztapenen norabidea aldatu da; horregatik dira zeinuak v2.1ekoen kontrakoak.) PNVren G2 ez da kontraesana: programak (+1) eta bozkak (+1) bat egiten dute.
4. **Bi kontaketa-modu.** Web-tresnak hautagailu bat izango du; lehenetsia "programak" da.

   | Kasua | **Programak** (lehenetsia) | **Bozketak ere** (azken 4 urteak) |
   |---|---|---|
   | Programa bai, bozka bat dator edo ez dago | programa | programa |
   | Kontraesana | programa, 0,5 mugituta bozkaren aldera (PP K4: −1 → −0,5) | programaren eta bozkaren batez bestekoa (PP K4: +0,5) |
   | Programa isilik, bozka bai | 0,5 ± desenpatea: bozkaren norabidean, 0,0625 erantzun-puntu bakoitzeko (±0,125 gehienez) | bozka da posizioa |
   | Ez programarik, ez bozkarik | 0,5 | 0,5 |

   "Programak" moduan bozketak **desenpate gisa** baino ez dira erabiltzen. ±0,125eko desenpatea posizioa 0,5 mugitzearen baliokidea da. Ondorioz, bozka batek ezin du programa-posizio oso baten pisua hartu.

   **Aho bateko bozketak ez dira kontatzen** bi moduetan, ez baitute alderdirik bereizten (adibidez, 2024ko EBn betetako zigorren erreforma: PPk eta Voxek ere alde bozkatu zuten). Txartelean informazio gisa agertzen dira.
5. Adostasuna, posizioa (x) dagoenean: **1 − |erantzuna − x| / 4** (0tik 1era).
6. Baieztapenaren pisua: **blokearen pisua / blokeko baieztapen-kopurua**. Erabiltzaileak bloke bat "oso garrantzitsua" marka dezake, eta orduan pisua bikoizten da.
7. Emaitza: **Σ pisua·adostasuna / Σ pisua**, ehunekotan.

Kalkulua `pipeline/Galdetegia.pm` moduluan dago. Simulazioak eta JSON-sortzaileak biek erabiltzen dute, eta web-tresnak formula bera erabili beharko du.

## Simulazioa

v2.2, 2026-11-19. Iturria: `perl pipeline/galdetegia-v2.pl` → `datuak/galdetegia-v2-simulazioa.txt` (bi moduak).

**1. Alderdi bakoitza bere posizioekin erantzuten** (posiziorik gabekoak saltatuta). Alderdi bakoitza lehen ateratzen da (% 100). Hurrengoak:

| Erantzuten duena | Programak: 2. | 3. | Bozketak: 2. | 3. |
|---|---|---|---|---|
| PNV (18 / 22 erantzun) | EHB 88 | PSOE 78 / FA 78 | PSOE 86 | EHB 83 |
| EH Bildu | FA 88 | POD 83 | FA 89 | POD 84 |
| PSOE (18 / 25) | FA 88 | EHB 83 | FA 84 | EHB 80 |
| Frente Amplio | POD 91 | EHB 90 | POD 90 | EHB 89 |
| Podemos | FA 98 | EHB 90 | FA 98 | EHB 90 |
| PP | VOX 77 | PSOE 51 | VOX 80 | PSOE 50 |
| Vox | PP 76 | PNV 48 | PP 78 | PSOE 40 |

**2. Pertsona-profilak:**

| Profila | Programak | Bozketak ere |
|---|---|---|
| Abertzale ezkertiarra | EHB 95 · FA 90 · POD 85 | EHB 96 · FA 92 · POD 86 |
| … euskara eta nazioa "oso garrantzitsua" | EHB 96 · FA 88 · POD 80 | EHB 97 · FA 89 · POD 81 |
| Abertzale zentrista | PNV 80 · EHB 77 · PSOE 73 | PNV 85 · PSOE 78 · EHB 77 |
| Independentista, ekonomian zentrista | EHB 77 · PNV 76 · PSOE 70 | PNV 80 · EHB 77 · PSOE 74 |
| Langile ezkertiar ez-abertzalea | POD 83 · FA 83 · EHB 74 | FA 86 · POD 84 · PSOE 79 |
| … etxebizitza eta lana "oso garrantzitsua" | POD 86 · FA 86 · EHB 78 | FA 89 · POD 86 · PSOE 81 |
| Segurtasunak kezkatutako langilea | PSOE 76 · FA 75 · POD 73 | PSOE 79 · FA 77 · POD 74 |
| Eskuin moderatua (berria) | PP 81 · VOX 72 · PSOE 54 | PP 88 · VOX 78 · PSOE 55 |
| Eskuineko kontserbadorea | VOX 81 · PP 80 · PSOE 43 | VOX 88 · PP 85 · PSOE 44 |

Profilen definizioak `pipeline/galdetegia-v2.pl`-n daude, v2.2ko norabidera egokituta. "Eskuin moderatua" PP antzekoa da: Autonomien Estatua eta genero-indarkeriaren legea mantendu nahi ditu.

**3. Alderdien arteko adostasuna** (biek posizioa duten baieztapenetan):

| Bikotea | Programak | Bozketak ere |
|---|---|---|
| FA–POD | 97 | 98 |
| EHB–POD | 94 | 92 |
| EHB–FA | 92 | 91 |
| PNV–EHB | 88 | 81 |
| PNV–PSOE | 88 | 86 |
| PP–VOX | 84 | 80 |

**4. Posiziorik gabeko gelaxkak (27tik):**

| Modua | PNV | EHB | PSOE | FA | POD | PP | VOX |
|---|---|---|---|---|---|---|---|
| Programak | 9 | 2 | 9 | 3 | 8 | 6 | 8 |
| Bozketak ere | 5 | 1 | 2 | 1 | 6 | 2 | 1 |

**5. Erantzun uniformeen proba** (programak / bozketak ere):

| Baieztapen guztiei… | v2.1 | v2.2 |
|---|---|---|
| "Guztiz alde" (+2) | EHB 93 … Vox 29 (aldea 64) | Vox 63, PNV 61 … FA 48 (15) / PNV 62 … FA 50 (12) |
| "Alde" (+1) | PSOE 77 … Vox 47 (30) | Vox 65, PNV 64 … EHB 52 (13) / PNV 67 … EHB 51 (16) |
| "Neutrala" (0) | PSOE eta PNV 63 … EHB 53 (10) | PP 59, PSOE 59 … EHB 52 (7) / PP 65 … EHB 52 (13) |
| "Guztiz aurka" (−2) | Vox 71 … EHB 8 (63) | FA 52 … Vox 37 (15) / FA 50 … PNV 38 (12) |

Erantzun uniformeek ez dute bloke bat sistematikoki saritzen. Gelditzen den aldea isiltasunetatik dator: isilik dagoen alderdiak 0,5 jasotzen du beti.

**Irakurketa:**
- **Alborapena zuzenduta, kostu batekin.** Erantzun uniformeek ez dute bloke bat bakarrik saritzen. Baina ezkerraren barruko bereizketa ahuldu da: intentsitate-baieztapenak (32 ordu, % 40 jaitsiera) sinplifikatzean, FA eta Podemos % 97an daude, eta EH Bildu–FA % 92an. EH Bildu euskara eta nazio-gaiei esker bereizten da, ez ardatz ekonomikoari esker.
- **Eskuina orain bereizten da:** "Eskuin moderatua" PP (81) / Vox (72), eta "Eskuineko kontserbadorea" Vox (81) / PP (80). N5 eta G4 baieztapenek egiten dute aldea.
- **Abertzaletasunaren bi ardatzak mantentzen dira:** abertzale zentristarentzat PNV lehena da. Independentista zentristarentzat, EH Bildu eta PNV ia berdinduta daude (77/76). Bozketekin PSOE bigarrena da abertzale zentristarentzat, PNVrekin adostutako bozketengatik.
- **"Segurtasunak kezkatutako langilea":** PSOE apur bat aurretik dago bi moduetan (76/79).

## Gardentasuna: azalpen-txartelak

Puntuazioa ikusterakoan, erabiltzaileak gelaxka bakoitzaren arrazoia ikusi behar du: zer dioen programak (orrialdearekin), eta zer bozkatu zuen eta noiz. Informazio hori guztia **`datuak/galdetegia-v2.json`** fitxategian dago (v2.1), web-tresnak zuzenean irakurtzeko moduan.

**Sortzea:** `perl pipeline/galdetegia-v2-json.pl`. Script-ak hauek batzen ditu:

| Fitxategia | Edukia |
|---|---|
| `datuak/galdetegia-v2.tsv` | Posizioak (−2…+2) eta froga-IDak |
| `datuak/galdetegia-v2-azalpenak.tsv` | Programa-gelaxken azalpena euskaraz (parafrasia, ez aipu literala) |
| `datuak/c-aukera.tsv` | Bozketak: balioa, data, zer bozkatu zen, oharra, albistearen URLa |
| `datuak/iturriak.tsv` | Programa ofizialen PDFen URLak |
| `iturriak/*/*-unitateak.tsv` | Unitate bakoitzaren orrialdea (`#page=N` estekarako) |

Gelaxka batek azalpenik, bozka-sarrerarik edo unitaterik ez badu, script-a errorearekin gelditzen da. Bozka-balioa TSVkoarekin bat ez badator ere bai. Horrela, ezin da txartel hutsik edo okerrik argitaratu.

**JSONaren egitura:**
- `puntuazioa`: formulak, `moduak` (programak / bozketak, testu-azalpenarekin), `lehenetsia` eta `kontraesana`ren definizioa;
- `motak`, `alderdiak` (izena + programaren URLa) eta `blokeak` (pisuak);
- `baieztapenak[]`. Baieztapen bakoitzak 7 `gelaxkak` ditu, eremu hauekin:
  - `alderdia`, `mota` (`programa` 134, `zeharka` 10, `C-bozketa` 23, `C-bozketa+2023` 2, `C-Mahaia` 1, `C-adierazpena` 1, `isilik` 18);
  - `kontraesana`: `true`/`false` (3 `true`);
  - `programa`: `{balioa, zeharka, azalpena, iturriak[]}`. `balioa` `null` da programa isilik badago. Iturriek PDFaren orrialdera daramate (`…pdf#page=17`);
  - `bozka`: `{balioa, zenbatzen, mota, data, azalpena, oharra, iturriak[]}` edo `null`. `zenbatzen: false` aho bateko bozketetan (v2.2an ez dago halakorik). Iturriek albistera daramate;
  - `kontaketa.programak` eta `kontaketa.bozketak`: `{posizioa, desenpatea, testua}`. Gelaxka horrek modu bakoitzean zer posizio hartzen duen. `testua` txartelean erakusteko prest dago.

**Txartel-adibideak** (`kontaketa.<modua>.testua` + azalpenak):

> **PSOE · G2 (Zigor gogorragoak) · programa isilik · 🗳️ 2026-02-12**
> Programak ez du ezer esaten. Multierreinzidentzia-legearen alde bozkatu zuen (302 alde, 36 aurka).
> *Programak:* neutroa (0,5), desenpatea bozkaren norabidean. *Bozketak ere:* +1.

> **PP · K4 (Kontzertu Ekonomikoa zabaldu) · ⚠️ kontraesana**
> 📄 Programa (−1): Zerga Agentziaren batasuna blindatu, "ez da gehiago zatituko" (PP-N018, 17. or.).
> 🗳️ 2025-04 (+2): Kontzertuaren erreformaren alde bozkatu zuen; Vox izan zen aurka bakarra.
> *Programak:* −0,5. *Bozketak ere:* +0,5 (batez bestekoa).

> **EH Bildu · H1 ("Estatuak ez luke alokairuen preziorik mugatu behar") · −2 · programa**
> Alokairuen urteko igoera % 2ra mugatu nahi du modu iraunkorrean, eta prezioak erregulatu.
> 📄 EHB-05-10, EHB-05-01 · 5. or.

> **Podemos · N2 (Erabakitzeko eskubidea) · isilik · 0,5**
> Programak ez du erabakitzeko eskubidea aipatzen. Bere erreferendum bakarra monarkia edo errepublikari buruzkoa da. Ez da bozketarik aurkitu.

**Web-tresnarako gomendioak:**
- Emaitzen gainean, hautagailua: "Programak bakarrik (bozketak desenpate gisa)" / "Azken 4 urteetako bozketak ere kontuan hartu". Modua aldatzean, emaitza berehala berriz kalkulatu.
- Alderdi bakoitzaren ehunekoa sakatuta, baieztapen guztien txartelak erakutsi, erabiltzailearen erantzuna eta lortutako adostasuna (0–1) alboan.
- Kontraesanak ⚠️ ikurrarekin nabarmendu, bi moduetan.
- Programa (📄) eta bozka (🗳️) kolore desberdinarekin erakutsi; zeharka eta adierazpena ahulago.
- Puntuazioa `Galdetegia.pm`-ko formula berarekin kalkulatu. Egiaztatzeko, simulazioko profilek emaitza berak eman behar dituzte.

## Mugak

- **Isiltasunak:** "programak" moduan, PNVk eta PSOEk 9, Podemosek eta Voxek 8, PPk 6, FAk 3 eta EH Bilduk 2 baieztapenetan ez dute programa-jarrerarik (27tik). "Bozketak ere" moduan, Podemosek 6, PNVk 5, PSOEk eta PPk 2, eta EH Bilduk, FAk eta Voxek 1. Bozketak programa baino froga ahulagoak dira (prentsako albisteak, ez aktak; PNVren K3 adierazpena da, PSOEren N2 Mahaiaren erabakia) eta beti markatuta agertzen dira. 0,5ek ez ditu saritzen ez zigortzen, baina emaitza ertainera hurbiltzen du.
- **Eskumenak:** etxebizitza, osasuna eta hezkuntza neurri handi batean EAE eta Nafarroako erakundeen eskumena dira. Galdetegiak alderdien Gorteetarako proposamenak neurtzen ditu, ez euskal erakundeetako politika.
- **Falta direnak:** Geroa Bai, UPN-PP eta SALF (ez dute programa osorik). Nafarroako erabiltzaileentzat Geroa Bairen eta UPNren posizioak garrantzitsuak lirateke.
- **Berrikuspena:** posizioak ez dituzu zuk berrikusi. Lehenengo, "Erabaki nabarmenak" atalekoak.

## Hurrengo urratsak (zuk erabakitzeko)

- Posizioak berrikusi, batez ere z, C eta v2.2an aldatutako baieztapenak (N4, N5, G4, H1 PNV).
- Geroa Bai eta UPN-PP gehitu, haien web-orrietako konpromisoekin, argi markatuta.
- Weba argitaratu (GitHub Pages, `docs/`): prest dago, zure baimenaren zain (08-weba.md).
