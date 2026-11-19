# Programen sailkapen-metodologia (zirriborroa v0.3)

> **v0.3 (2026-11-16, PPren pilotuaren ondoren):** **Claude da sailkatzaile nagusia** dimentsio guztietan, §11ko kodeketa-liburuaren arabera. Decider bigarren iritzi gisa geratzen da bakarrik gaietan (A maila) eta "ez du aipatzen" detekzioan, pilotuan %98ko adostasuna eman zuten eremuetan; desadostasunak berrikuspenera doaz. Arrazoia: pilotuan Decider-ek huts egin zuen eremu interpretatiboetan (murrizketa ezkutuak, eragindako taldeak, testuak esaten ez duena ondorioztatzea) — ikus `03-pilotua-pp.md`. Claude-ren etiketak ere ez dira "egia": berrikusleak lagin bat egiaztatzen du eta jarrera final guztiak aipuarekin argitaratzen dira.

*2026-11-16. Helburua: 29-N hauteskundeetako programak **osorik** gaika antolatzea (gai-ikuspegia), proposamen bakoitzak **nori eragiten dion eta zer norabidetan** (murrizketak, aurrerapen sozialak, diru publikoa) neurtzea, eta partidu bakoitzaren jarrera 10 baieztapenetan finkatzea (galdetegia), modu garden, errepikagarri eta egiaztagarrian.*

**v0.2-ko aldaketak:** gai-taxonomia programa osoa estaltzeko zabaldua (§3); zeharkako dimentsioak gehituak: ongizatea, lan-eskubideak, zergak, gastu publikoa, zehaztasuna eta eragindako taldeak (§3b); "murrizketen radarra" eta "aurrerapen sozialen" ikuspegia (§5b); programak isilik dagoenean C aukera aukeratua (§7).

**Erreferentzia akademikoa:** dimentsioak [Manifesto Project (MARPOR)](https://manifesto-project.wzb.eu/) kodeketa-eskeman oinarrituta daude, programa politikoak aztertzeko nazioartean gehien erabiltzen den eskema (adib. 504 *Welfare State Expansion* / 505 *Welfare State Limitation*, 701/702 *Labour Groups positive/negative*, 303 *Governmental Efficiency*, 414 *Economic Orthodoxy*). Ez dugu MARPOR osoa kopiatzen; haren logika sinplifikatua erabiltzen dugu, eta kodeak gordetzen ditugu konparagarritasunerako.

## Printzipioak

1. **Iturri bakarra programa ofiziala da.** Partidu bakoitzaren jarrera bere 29-N programan idatzita dagoenetik ateratzen da, ez adierazpenetatik edo uste orokorretatik. Salbuespenak (ikus §7) beti markatuta.
2. **Jarrera bakoitzak froga bat du:** aipu literala + orrialdea + estekak. Frogarik gabeko jarrerarik ez da argitaratzen.
3. **Makinak proposatu, gizakiak erabaki.** Decider eta Claude sailkatzaile dira; azken hitza berrikusleak du, eta erabaki bakoitza erregistratzen da.
4. **"Ez du aipatzen" ez da "neutrala".** Programak gai bat aipatzen ez badu, partidu hori ez da baieztapen horretan kontuan hartzen galdetegian (ez zaio 0 bat jartzen).
5. **Dena argitaratzen da:** testu-unitateak, galderak, probabilitateak, azken jarrerak, berrikuspen-erregistroa eta modeloen bertsioak.

---

## 1. Iturriak jaso

| Eremua | Adibidea |
|---|---|
| `alderdia` | PP |
| `dokumentua` | La Reconstrucción Nacional |
| `url` | Alderdiaren domeinu ofizialeko PDFa |
| `data` | Argitalpen-data + deskarga-data |
| `sha256` | Fitxategiaren hash-a (gero aldatzen bada jakiteko) |
| `orrialdeak` | 82 |

- Programa nazionala + EHrako programa propioa baldin badago (PSE-EE, PSN, UPN-PP, Geroa Bai…), biak jasotzen dira, eta EHkoak lehentasuna du gatazkarik badago.
- Programa eguneratzen bada, bertsio berria jaso eta prozesu osoa errepikatzen da partidu horretarako.

## 2. Zatiketa (testu-unitateak)

**Unitatea = proposamen edo paragrafo bat**, testuingurua barne:

```
id:        PP-p023-04          (alderdia-orrialdea-ordena)
atala:     "3. Vivienda > 3.2 Alquiler"   (izenburu-katea)
testua:    paragrafoa edo buleta
```

Arauak:
- Bulet laburrak (< 150 karaktere) izenburuarekin batera doaz; Decider-i beti bidaltzen zaio `Atala: …` + testua, buleta bakarrik ulertezina izan ez dadin.
- Paragrafo luzeak (> 1.500 karaktere) esaldi-mugetan zatitzen dira.
- Aurkibidea, azalak, argazki-oinak eta goiburuak kanpoan.
- Unitate bakoitzak orrialde-zenbakia gordetzen du, frogarako.

## 3. A maila — Gaia (gai-ikuspegirako, programa osoa)

- **Programa osoa sailkatzen da**, ez bakarrik galdetegiko 10 gaiak. Unitate bakoitza gutxienez gai batean egon behar da (bestela "beste bat").
- **Etiketa anitzekoa:** paragrafo batek gai bat baino gehiago uki ditzake. Horregatik gai bakoitzeko galdera bai/ez bat (`noul`): "¿Trata este fragmento de {gaia}?". **Muga:** p ≥ 0,50.

| # | Gaia | Galdetegian |
|---|---|---|
| G01 | Etxebizitza | ✔ (1) |
| G02 | Lana, soldatak eta lan-eskubideak | ✔ (2) |
| G03 | Pentsioak eta Gizarte Segurantza | ✔ (5) |
| G04 | Osasuna | ✔ (3) |
| G05 | Hezkuntza eta unibertsitatea | |
| G06 | Zaintza, mendekotasuna eta haurtzaroa | |
| G07 | Zergak eta fiskalitatea | ✔ (4) |
| G08 | Gastu publikoa, administrazioa eta ustelkeria | |
| G09 | Bizi-kostua, energia-prezioak eta kontsumoa | |
| G10 | Ekonomia, industria eta enpresak | |
| G11 | Klima, energia eta ingurumena | |
| G12 | Garraioa eta azpiegiturak | |
| G13 | Immigrazioa | ✔ (6) |
| G14 | Segurtasuna, justizia eta askatasun zibilak | |
| G15 | Berdintasuna, feminismoa eta LGTBI | |
| G16 | Euskara, hizkuntzak eta kultura | ✔ (7) |
| G17 | Autogobernua, lurralde-eredua eta Kontzertua | ✔ (8) |
| G18 | Erabakitzeko eskubidea eta independentzia | ✔ (9) |
| G19 | Presoak, memoria eta giza eskubideak | ✔ (10) |
| G20 | Europa eta kanpo-politika | |
| G21 | Landa-eremua eta nekazaritza | |
| G22 | Demokrazia eta erakundeak (justizia-independentzia, TC, Fiskaltza, hauteskunde-sistema, gardentasuna, adierazpen-askatasuna instituzionala) — *v0.3, PPren pilotuan gehitua; Decider-ek ez du galdera hau* | |
| G99 | Beste bat | |

## 3b. Zeharkako dimentsioak (unitate guztietan)

Gaiaz gain, unitate bakoitzari galdera hauek egiten zaizkio. Hauek dira "murrizketak", "aurrerapen sozialak" eta "diru publikoa" ikuspegien oinarria.

| Kodea | Dimentsioa | Mota | Aukerak | MARPOR |
|---|---|---|---|---|
| D1 | **Ongizate-estatua** (osasuna, hezkuntza, zaintza, prestazioak, pentsioak) | choice | zabaldu · mantendu/babestu · murriztu/pribatizatu · ez dagokio | 504 / 505, 506 / 507 |
| D2 | **Langileen eskubideak** (soldatak, lanaldia, kaleratzea, sindikatuak, negoziazio kolektiboa) | choice | hobetu · mantendu · murriztu/malgutu · ez dagokio | 701 / 702 |
| D3 | **Zergak** | choice | igo errenta/enpresa handiei · igo orokorrean · jaitsi errenta/enpresa handiei · jaitsi orokorrean edo errenta baxuei · ez dagokio | 503, 414 |
| D4 | **Gastu publikoa** | choice | handitu · murriztu · berrantolatu/eraginkortasuna · ez dagokio | 414, 303 |
| D5 | **Zehaztasuna** | score 0–3 | 0 hutsala/eslogana · 1 asmo orokorra · 2 neurri zehatza · 3 neurri zehatza + zenbakiak/epea/finantzaketa | — |
| D6 | **Finantzaketa** | noul | Proposamenak esaten du nola finantzatuko den? | — |
| D7 | **Eragindako taldeak** | noul talde bakoitzeko | langileak · pentsiodunak · langabeak/prekarioak · gazteak · emakumeak · etorkinak · autonomoak/ETEak · enpresa handiak · errenta altuak | 701, 704, 705, 706 |
| D8 | **Eraginaren norabidea talde horientzat** | choice | onuragarria · kaltegarria · nahasia · ez da argia | — |

**Eufemismoak.** Murrizketak gutxitan esaten dira zuzenean. D1, D2 eta D4ren argibideetan honako formulazio hauek seinale posible gisa aipatzen dira, betiere benetako murrizketa bat adierazten badute: *racionalizar el gasto, eliminar duplicidades, adelgazar la administración, sostenibilidad del sistema, flexibilizar el mercado laboral, colaboración público-privada en sanidad/educación, libertad de elección (osasun/hezkuntza zerbitzuetan), reforma de las pensiones, reducir el gasto político*. Hitz horiek **ez dira automatikoki murrizketa**: testuinguruak erabakitzen du, eta horregatik D1/D2/D4-ko "murriztu" guztiak berrikusten dira (§6).

## 4. B maila — Jarrera baieztapen bakoitzean (galdetegirako)

- Baieztapen bakoitza bere gaiko unitateei bakarrik galdetzen zaie, **muga zabalagoarekin (p(gaia) ≥ 0,30)**, ezer ez galtzeko.
- Galdera `choice` motakoa, 6 aukera, deskribapen simetrikoekin:

| Kodea | Esanahia |
|---|---|
| +2 | Oso alde: esplizituki proposatzen du |
| +1 | Alde, ñabardurekin |
| 0 | Anbiguoa / neutrala |
| −1 | Aurka, ñabardurekin |
| −2 | Oso aurka: esplizituki baztertzen du |
| ez | Ez du gai hau aipatzen |

- Unitate bakoitzeko gordetzen da: aukera irabazlea, 6 probabilitateak eta konfiantza.
- **Balio itxarondakoa** kalkulatzen da: `E = Σ p(k)·k / (1 − p(ez))`, k ∈ {−2..+2}.

## 5. Agregazioa — partidu × baieztapen

1. Hautatu `p(ez) < 0,5` duten unitateak (jarrera bat adierazten dutenak).
2. Ez badago bat ere → **"Programak ez du aipatzen"**.
3. Badaude:
   - Jarrera proposatua = unitateen E-ren batez besteko haztatua, pisua `1 − p(ez)`; −2..+2 eskalara biribildua.
   - **Froga nagusia** = |E| handiena eta konfiantza altuena duen unitatea.
   - **Kontraesana:** unitate batek ≥ +1 eta beste batek ≤ −1 badute → berrikuspenera derrigorrez.

## 5b. Ikuspegi orokorrak partidu bakoitzeko

**Murrizketen radarra** (langileriari eragiten diotenak lehenik):
- Sartzen dira: D1 = murriztu/pribatizatu, D2 = murriztu/malgutu, edo D4 = murriztu duten unitateak.
- Ordena: lehenik D7-n langileak / pentsiodunak / langabeak-prekarioak / gazteak eta D8 = kaltegarria dutenak; gero gainerakoak.
- Bereizita erakusten dira **diru-sarreren murrizketak** (D3 = zergak jaitsi), D6 (finantzaketa) adierazita. Ez dugu esaten zerga-jaitsiera batek murrizketa dakarrenik; datua ematen dugu eta irakurleak epaitzen du.
- Etiketa publikoa neutroa da: "Gastua edo eskubideak murrizten dituzten proposamenak", aipu literalarekin.

**Aurrerapen sozialak:** D1 = zabaldu, D2 = hobetu edo G15-eko eskubide-zabalkuntzak, D7/D8-rekin nori onuragarria zaion.

**Diru publikoa ondo erabiltzea:**
- **Zehaztasun-indizea:** partidu bakoitzaren D5 batez bestekoa eta 3. mailako proposamenen %. Argi bereizten du "zer egingo duten esaten dutenak" eta "eslogan hutsak".
- **Finantzatutako proposamenak:** D6 = bai duten gastu-proposamenen %.
- **Eraginkortasun-proposamenak:** D4 = berrantolatu eta G08 (ustelkeria, administrazioa).

**Simetria:** ikuspegi guztiak partidu guztiei aplikatzen zaizkie irizpide berberekin, eta zenbakiak (zenbat proposamen kategoria bakoitzean) proportzioan ematen dira, programa luzeek abantailarik izan ez dezaten.

## 6. Kalitate-kontrola: bi sailkatzaile + berrikuspena

```
Programa → unitateak → Decider (A+B) → agregazioa → Claude-ren irakurketa independentea → desadostasunak → berrikuslea → argitaratu
```

- **Claude-k independenteki** irakurtzen ditu: (a) jarrera finalari laguntzen dioten unitate guztiak, eta (b) gainerako unitateen %10eko ausazko lagina (kalitatea neurtzeko). Claude-k ez ditu Decider-en emaitzak ikusten erabaki aurretik.
- **Berrikuslearengana doa:**
  - Decider eta Claude ez datozenean bat jarrera finalean (±1eko aldea baino gehiago, edo bat "ez" eta bestea ez).
  - Decider-en konfiantza < 0,70 duten unitate erabakigarriak.
  - Kontraesanak (§5).
  - **"Murriztu" etiketa guztiak** (D1, D2, D4) eta D8 = kaltegarria: interpretatiboak direnez, beti bi sailkatzaileek eta berrikusleak berretsi behar dituzte "Murrizketen radarrean" agertu aurretik.
- **Kalibrazio-multzoa:** eskala handian hasi aurretik, PPren programako ~40 unitate eskuz etiketatu (Claude-k proposatu, berrikusleak berretsi) eta Decider-en asmatze-tasa neurtu. Horren arabera doitzen dira mugak (0,50 / 0,30 / 0,70).
- **Argitaratutako metrikak:** Decider–Claude adostasuna (% eta Cohen-en kappa), berrikusitako kasuen kopurua.

## 7. Programak isilik dagoenean — **C aukera (erabakia)**

29-N programak baieztapen bat aipatzen ez badu, ordena honetan bilatzen da, eta jarrera beti **iturriaren markarekin** argitaratzen da:

| Lehentasuna | Iturria | Marka webean |
|---|---|---|
| 1 | 29-N programa | (markarik ez) |
| 2 | Kongresuko botoa XV. legegintzaldian (2023–2026), baieztapenarekin zuzenean lotutako lege edo ekimen batean | 🗳️ "Kongresuko botoa" + data + esteka |
| 3 | 2023ko hauteskunde orokorretako programa | 📄 "2023ko programa" |
| — | Ezer ez | "Ez dago daturik" (galdetegian ez da kontatzen) |

- **Botoak lehenago 2023ko programa baino:** egindakoa da, ez promesa, eta berriagoa.
- **Bozketen zerrenda itxia:** baieztapen bakoitzeko aldez aurretik aukeratzen dira bozketa erabakigarriak (adib. Etxebizitza Legea, lanaldiaren murrizketa, pentsioen erreforma…), zerrenda argitaratu eta bozketa guztiak partidu guztiei aplikatzen zaizkie. Datuak: Kongresuko datu irekiak (bozketak).
- **Talde-botoa:** partidu bakoitzaren jarrera bere talde parlamentarioaren botoaren arabera; Sumar taldetik Frente Amplio eta Podemos bereizten dira bakoitzaren diputatuen botoarekin, bat ez badatoz.
- **Mugak:** Kongresuan ordezkaritzarik ez duten partiduek (SALF, Geroa Bai — 2023an ez zuen eserlekurik lortu —, txikiak; egiaztatu XV. legegintzaldiko osaeraren arabera) ez dute boturik; Frente Amplio berria da (aurrekariak Sumar/IU). Kasu horietan 2023ko programa edo "ez dago daturik".
- Bigarren mailako iturriak ere bi sailkatzaileen eta berrikuspenaren prozesutik pasatzen dira (§6).

## 8. Galdetegiaren kalkulua

- Erabiltzailearen erantzuna u ∈ {−2..+2} edo "saltatu"; "garrantzitsua" → pisua w = 2, bestela 1.
- Partidu bakoitzarekiko adostasuna, bi aldeek jarrera duten baieztapenetan bakarrik:
  `adostasuna = 1 − Σ w·|u − p| / Σ w·4`
- Emaitzarekin batera: zenbat baieztapenetan dagoen datua partidu bakoitzarentzat, eta baieztapen bakoitzean partiduaren jarrera + aipua.
- Lurraldearen arabera iragazi: erabiltzaileari bere lurraldean aurkezten diren partiduak bakarrik erakutsi.
- Kalkulua nabigatzailean; ez da ezer gordetzen ez bidaltzen.

## 9. Neutraltasun-bermeak

- Baieztapenak bi hizkuntzatan, hitz kargaturik gabe, eta aukera-deskribapen simetrikoekin.
- **Ezeztapen-proba:** baieztapen bakoitza alderantzizko formulazioan ere probatu kalibrazioan; jarrerak ikurrez aldatu behar du, bestela galdera gaizki formulatuta dago.
- Galderen JSON fitxategia izoztu eta bertsionatu; aldaketa orok prozesua berriz exekutatzea eskatzen du.
- Modeloaren bertsio zehatza gorde (adib. `pplx-decider-v1.3-20261112`).

## 10. Muga teknikoak (2026-11-16)

- OpenRouter-ek ez du `locate` galdera-mota onartzen → aipuak unitatearen testu osoa dira (laburra denez, nahikoa).
- Makina honetan ez dago PDF-tresnarik (`pdftotext`) ez Python-ik → testu-erauzketa Claude-ren PDF-irakurgailuarekin; `poppler-utils` instalatzea gomendatua errepikagarritasunerako.
- Doako modeloak noiz arte iraungo duen ez dakigu; ordainpekoa 0,02 $/M token.

## 11. Kodeketa-liburua (v0.3) — Claude-k aplikatzen dituen arauak

Arau hauek berdin aplikatzen zaizkie partidu guztiei. Zalantza dagoenean, bi etiketa onargarri idazten dira (`a|b`) eta unitatea berrikuspenera doa.

**Orokorra.** Testuak esaten duena kodetzen da, ez partiduari buruz dakiguna. Ondorioztatzea debekatuta dago testuak gaia ukitzen ez duenean.

**Gaiak.** Unitateak benetan lantzen dituen gai guztiak (aipamen pasakorrak ez). Lehena = gai nagusia.

**D1 Ongizatea.**
- *zabaldu*: zerbitzu, prestazio edo finantzaketa gehiago; eskubide berriak; estaldura zabaltzea.
- *mantendu*: dagoena bermatu (adib. pentsioak KPIarekin).
- *murriztu*: prestazio/estaldura/finantzaketa gutxiago; sarbidea baldintzatu edo mugatu (nazionalitatea, arraigoa, "kontraprestazioak"); zerbitzu publikoak kudeaketa pribatura eraman edo hura indartu (itunak, mutuak, "aukeratzeko askatasuna" diru publikoarekin).
- Laguntza fiskalak (kenkariak) ez dira D1 *zabaldu*, zerbitzu edo prestazio zuzen bat sortzen ez badute → D3.

**D2 Lan-eskubideak.**
- *hobetu*: soldata, babes, lanaldi edo negoziazio kolektibo hobea.
- *murriztu*: babes gutxiago, kaleratze errazagoa, "malgutasuna" enpresaren alde, gaixo-bajen kontrol handiagoa (absentismoa, mutuak), sindikatuen papera ahultzea.
- Enpresentzako kotizazio-pizgarriak ez dira D2, eskubideak aldatzen ez badituzte.

**D3 Zergak.** *jaitsi_handiei* barne: sozietateak, ondarea, oinordetza, kapitala/aurrezkia, "inbertsioa galgatzen duten zergak", zerga-lehiaketa erkidegoen artean. *jaitsi_orokorra*: IRPF errenta ertain-baxuak, BEZa, familiak, gazteak, autonomoen kuotak.

**D4 Gastua.** Esplizituki esaten denean bakarrik. Zorra/defizita murriztea = *murriztu|berrantolatu*.

**D5 Zehaztasuna.** 3 = zenbakiak EDO epeak EDO finantzaketa zehatza.

**D6 Finantzaketa.** Kostu bat edo iturri zehatz bat (adib. "prestakuntza-kuotekin"); "Estatuak ordainduko du" ez da nahikoa.

**D7 Taldeak.** Esplizituki aipatutako edo *zuzenean eta berariaz* eragindako taldeak bakarrik; ez biztanleria orokorraren parte gisa.

**Baieztapenak (S01–S10).** Testuak baieztapenaren gaia zuzenean jorratzen duenean bakarrik; printzipio orokorretatik ondorioztatu gabe (adib. "Espainiaren batasuna" ≠ erreferendumaren aurka, erreferenduma aipatzen ez bada).

**S08 (v0.3.1, 2026-11-18, berrikuslearen erabakia).** S08 nazio-aitortzari (nazioa, plurinazionaltasuna, gatazka politikoa) eta aldebikotasunari (harreman/erregimen/estatus bilaterala ala multilaterala) buruzko aipamen **esplizituekin** bakarrik kodetzen da. **Eskumen-transferentziak** eskatzea edo ukatzea, Estatuaren presentzia indartzea edo "berdintasuna ez da negoziatzen"-moduko printzipio orokorrak **ez** dira S08: gai-ikuspegian (G17 Autogobernua) agertzen dira bakarrik. Arrazoia: froga zuzenik gabeko partiduentzat (adib. transferentziak bakarrik aipatzen dituztenak) jarrera bat asmatzea saihestea. Aldaketa PPri eta EH Bilduri atzeraeraginez aplikatu zaie (oharra: `[v0.3.1: S08 kenduta …]`).

**Oharra.** `MURRIZKETA?` eufemismoak edo murrizketa ezkutuak daudenean; `ZEHARKA` jarrera zeharkakoa denean.
