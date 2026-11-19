# 29-N: programak eta galdetegia

2026ko azaroaren 29ko hauteskunde orokorretarako tresna, Hego Euskal Herriko hautesleentzat. Zazpi alderdiren programak (EAJ-PNV, EH Bildu, PSOE, Frente Amplio, Podemos, PP eta Vox) zatitu eta gaika sailkatu dira. Haietan oinarrituta, 27 baieztapeneko galdetegi bat egin da, zein alderdi dagoen erabiltzailearen jarreretatik hurbilen jakiteko.

**Weba:** `docs/` karpeta (GitHub Pages). Puntuazioa gardena da: emaitza bakoitzaren arrazoia ikus daiteke, programaren orrialdearekin edo Kongresuko bozketarekin.

Ez dago alderdi edo erakunderik proiektu honen atzean.

## Dokumentazioa

| Fitxategia | Edukia |
|---|---|
| [01-gaiak-eta-hautagaitzak.md](01-gaiak-eta-hautagaitzak.md) | Hautesleen kezka nagusiak (Soziometroa, CIS) eta hautagaitzak |
| [02-metodologia.md](02-metodologia.md) | Kodeketa-liburua: programak zatitu eta sailkatzeko irizpideak |
| [03-pilotua-pp.md](03-pilotua-pp.md) … [06-konparazioa-bost-alderdi.md](06-konparazioa-bost-alderdi.md) | Pilotua eta alderdien arteko konparazioak |
| [07-galdetegia-v2.md](07-galdetegia-v2.md) | Galdetegia: blokeak, pisuak, posizioak, puntuazioa, simulazioak |
| [08-weba.md](08-weba.md) | Web-tresna: egitura, datuak, argitalpena |

## Karpetak

- `iturriak/`: programa ofizialen kopiak (PDF eta testua) eta haien zatiak (`*-unitateak.tsv`). Jatorrizko estekak: [datuak/iturriak.tsv](datuak/iturriak.tsv).
- `datuak/`:
  - alderdi bakoitzaren sailkapena (`claude-v0.3.tsv`) eta bigarren iritzia (`decider-v0.2.jsonl`);
  - galdetegia (`galdetegia-v2.tsv`, `galdetegia-v2-azalpenak.tsv`) eta Kongresuko bozketak (`c-aukera.tsv`).
- `pipeline/`: Perl script-ak (core moduluak bakarrik).
- `docs/`: weba (HTML, CSS eta JS hutsa).

## Datuak berriz sortzea

```
perl pipeline/galdetegia-v2.pl > datuak/galdetegia-v2-simulazioa.txt   # simulazioa
perl pipeline/galdetegia-v2-json.pl                                    # datuak/galdetegia-v2.json
perl pipeline/web-datuak.pl                                            # docs/datuak/*.json
perl pipeline/zerbitzari.pl                                            # http://localhost:8080/
```

## Mugak

- Programen sailkapena eta posizioak adimen artifizialaren laguntzaz egin dira (Claude, eta Decider bigarren iritzi gisa), eta berrikusten ari dira.
- Bozketak XV. legegintzaldikoak dira (2023–2026), prentsako albisteetatik egiaztatuak.
- Geroa Bai, UPN-PP eta SALF ez daude, ez zutelako programa osorik argitaratu.
