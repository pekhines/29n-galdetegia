/* 29-N: programak eta galdetegia. JavaScript hutsa, liburutegirik gabe.
 * Datuak: datuak/galdetegia.json (pipeline/galdetegia-v2-json.pl), datuak/atalak.json eta
 * datuak/programa-<ID>.json (pipeline/web-datuak.pl).
 * Puntuazioa: pipeline/Galdetegia.pm-ren berdina. Gelaxka bakoitzaren posizioa modu bakoitzean
 * JSONean aurrekalkulatuta dago (kontaketa.<modua>.posizioa / desenpatea), formula bakarra izan dadin.
 */
'use strict';

const GORDE = 'elekzioak-29n-v2.2';   // v2.2: baieztapen batzuen norabidea aldatu da; v2.1eko erantzunak ez dira baliagarriak
const ESKALA = [
  { v: -2, izena: 'Guztiz aurka' }, { v: -1, izena: 'Aurka' }, { v: 0, izena: 'Neutrala' },
  { v: 1, izena: 'Alde' }, { v: 2, izena: 'Guztiz alde' },
];
const MODUAK = {
  programak: { izena: 'Programak', azalpena: '2026ko programek erabakitzen dute. Programa isilik dagoenean edo kontraesanean dagoenean, Kongresuko bozketek desenpate txiki gisa bakarrik balio dute.' },
  bozketak: { izena: 'Bozketak ere', azalpena: 'Azken lau urteetako (2023–2026) Kongresuko bozketek programaren pisu bera dute: programa isilik badago, bozka da posizioa; kontraesana badago, bien batez bestekoa.' },
};
const MOTA_IZENAK = {
  'programa': 'programa', 'zeharka': 'zeharka', 'isilik': 'isilik',
  'C-bozketa': 'bozketa', 'C-bozketa+2023': 'bozketa + 2023', 'C-Mahaia': 'Mahaia', 'C-adierazpena': 'adierazpena',
};

const D = { galdetegia: null, atalak: null, programak: {}, alderdiak: {}, blokeak: {} };
let egoera = { erantzunak: {}, garrantzi: {}, modua: 'programak' };

/* ---------- Laguntzaileak ---------- */
function h(tag, attrs, ...kids) {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs || {})) {
    if (v === null || v === undefined || v === false) continue;
    if (k.startsWith('on')) e.addEventListener(k.slice(2), v);
    else if (k === 'class') e.className = v;
    else e.setAttribute(k, v === true ? '' : v);
  }
  for (const k of kids.flat(Infinity)) {
    if (k === null || k === undefined || k === false) continue;
    e.append(k instanceof Node ? k : document.createTextNode(String(k)));
  }
  return e;
}
const zenb = (x) => (x > 0 ? '+' : x < 0 ? '−' : '') + String(Math.abs(x)).replace('.', ',');
const ehuneko = (x) => Math.round(x) + '%';
function balioIkurra(x) {
  if (x === null || x === undefined) return h('span', { class: 'balioa bnull', title: 'Jarrerarik ez' }, '·');
  const k = Math.max(-2, Math.min(2, Math.round(x)));
  return h('span', { class: 'balioa b' + k, title: balioIzena(x) }, zenb(x));
}
function balioIzena(x) {
  if (x === null || x === undefined) return 'jarrerarik ez';
  const e = ESKALA.find((s) => s.v === x);
  return e ? e.izena : zenb(x);
}
async function kargatu(url) {
  const r = await fetch(url);
  if (!r.ok) throw new Error(url + ': ' + r.status);
  return r.json();
}
function gorde() { try { localStorage.setItem(GORDE, JSON.stringify(egoera)); } catch (e) { /* modu pribatua */ } }
function berreskuratu() {
  try { const s = JSON.parse(localStorage.getItem(GORDE)); if (s && s.erantzunak) egoera = Object.assign(egoera, s); } catch (e) { /* hutsik */ }
}

/* ---------- Puntuazioa (Galdetegia.pm-ren berdina) ---------- */
const DESENPATEA = 0.0625;
function adostasuna(a, gelaxka, modua) {
  const k = gelaxka.kontaketa[modua];
  if (k.posizioa !== null && k.posizioa !== undefined) return 1 - Math.abs(a - k.posizioa) / 4;
  return 0.5 + DESENPATEA * a * (k.desenpatea || 0);
}
function pisua(bai, garrantzi) {
  const b = D.blokeak[bai.blokea];
  return (b.pisua / b.kop) * (garrantzi[bai.blokea] ? 2 : 1);
}
function puntuazioa(erantzunak, garrantzi, modua) {
  const r = {};
  for (const p of D.galdetegia.alderdiak) {
    let num = 0, den = 0;
    for (const bai of D.galdetegia.baieztapenak) {
      const a = erantzunak[bai.id];
      if (a === undefined || a === null) continue;
      const w = pisua(bai, garrantzi);
      num += w * adostasuna(a, bai.gelaxkak.find((g) => g.alderdia === p.id), modua);
      den += w;
    }
    r[p.id] = den ? (100 * num) / den : 0;
  }
  return r;
}

/* ---------- Azalpen-txartela ---------- */
function txartela(bai, g, modua) {
  const alderdia = D.alderdiak[g.alderdia];
  const k = g.kontaketa[modua];
  const goia = h('div', { class: 'goia' },
    h('strong', {}, alderdia.izena), balioIkurra(k.posizioa),
    h('span', { class: 'marka' }, MOTA_IZENAK[g.mota] || g.mota),
    g.kontraesana ? h('span', { class: 'marka abisua' }, '⚠ kontraesana') : null);
  const prog = h('div', { class: 'geruza' },
    h('div', { class: 'geruza-izena' }, '📄 Programa', g.programa.balioa !== null ? ' (' + zenb(g.programa.balioa) + ')' : ''),
    h('p', {}, g.programa.azalpena),
    g.programa.iturriak.length ? h('p', { class: 'txikia' }, 'Iturria: ',
      g.programa.iturriak.map((s, i) => [i ? ' · ' : '', h('a', { href: s.url, target: '_blank', rel: 'noopener' }, s.unitatea + (s.orria ? ', ' + s.orria + '. or.' : ''))])) : null);
  let bozka = null;
  if (g.bozka) {
    const b = g.bozka;
    bozka = h('div', { class: 'geruza' },
      h('div', { class: 'geruza-izena' }, '🗳 Kongresua, ', b.data, ' (', zenb(b.balioa), ')', b.zenbatzen === false ? ' — ez da kontatzen' : ''),
      h('p', {}, b.azalpena),
      b.oharra ? h('p', { class: 'txikia' }, 'Oharra: ', b.oharra) : null,
      b.iturriak.length ? h('p', { class: 'txikia' }, b.iturriak.map((s) => h('a', { href: s.url, target: '_blank', rel: 'noopener' }, 'Albistea'))) : null);
  }
  return h('div', { class: 'txartela' + (g.kontraesana ? ' kontraesana' : '') }, goia, prog, bozka,
    h('p', { class: 'kontaketa' }, MODUAK[modua].izena, ' moduan: ', k.testua));
}

/* ---------- Ikuspegiak ---------- */
function hasiera(app) {
  const n = D.galdetegia.baieztapenak.length;
  app.append(
    h('div', { class: 'sarrera' },
      h('h1', {}, 'Zein alderdi dago zure jarreretatik hurbilen?'),
      h('p', {}, '2026ko azaroaren 29ko hauteskunde orokorretarako tresna, Hego Euskal Herriko hautesleentzat. ',
        'Alderdien programak gaika irakur ditzakezu, eta ', n, ' baieztapeneko galdetegia bete. ',
        'Emaitzan, puntu bakoitzaren arrazoia ikusiko duzu: zer dioen programak (orrialdearekin) edo, programak ezer esaten ez badu, nola bozkatu zuen alderdiak Kongresuan.'),
      h('div', { class: 'ekintzak' },
        h('a', { class: 'botoia nagusia', href: '#/galdetegia' }, 'Galdetegia bete →'),
        h('a', { class: 'botoia', href: '#/programak' }, 'Programak arakatu'))),
    h('div', { class: 'zutabeak' },
      h('div', { class: 'lauza' }, h('h3', {}, 'Zazpi alderdi'),
        h('p', {}, D.galdetegia.alderdiak.map((p) => p.izena).join(', '), '.'),
        h('p', { class: 'txikia' }, 'Geroa Bai, UPN-PP eta SALF falta dira: ez zuten programa osorik argitaratu.')),
      h('div', { class: 'lauza' }, h('h3', {}, 'Bederatzi gai'),
        h('p', {}, D.galdetegia.blokeak.map((b) => b.izena).join(', '), '.'),
        h('p', { class: 'txikia' }, 'Pisuak Euskal Soziometroaren kezka nagusien arabera.')),
      h('div', { class: 'lauza' }, h('h3', {}, 'Gardena'),
        h('p', {}, 'Ez dago kutxa beltzik: formula, iturriak eta erabaki guztiak ikus ditzakezu.'),
        h('p', { class: 'txikia' }, h('a', { href: '#/metodologia' }, 'Metodologia')))));
}

async function programak(app, blokea, alderdia, gaia) {
  const blokeak = D.galdetegia.blokeak;
  blokea = blokea || blokeak[0].id;
  alderdia = alderdia || D.galdetegia.alderdiak[0].id;
  const besteak = blokea === 'besteak';
  if (besteak) gaia = gaia || D.atalak.besteak[0];
  const esteka = (b, p, g) => '#/programak/' + b + '/' + p + (g ? '/' + g : '');

  app.append(h('h1', {}, 'Programak gaika'),
    h('p', { class: 'txikia' }, 'Aukeratu gaia eta alderdia. Testuak programetatik hitzez hitz hartuak dira, jatorrizko hizkuntzan; orrialde-estekak PDF ofizialera daramatza.'),
    h('div', { class: 'fitxak', role: 'navigation', 'aria-label': 'Gaiak' },
      blokeak.map((b) => h('a', { href: esteka(b.id, alderdia), class: b.id === blokea ? 'aktiboa' : null, 'aria-current': b.id === blokea ? 'page' : null }, b.izena)),
      h('a', { href: esteka('besteak', alderdia), class: besteak ? 'aktiboa' : null }, 'Beste gaiak')));
  if (besteak) {
    app.append(h('div', { class: 'fitxak', 'aria-label': 'Beste gaiak' },
      D.atalak.besteak.map((g) => h('a', { href: esteka('besteak', alderdia, g), class: g === gaia ? 'aktiboa' : null }, D.atalak.gaiak[g]))));
  }
  app.append(h('div', { class: 'fitxak', 'aria-label': 'Alderdiak' },
    D.galdetegia.alderdiak.map((p) => h('a', { href: esteka(blokea, p.id, besteak ? gaia : null), class: p.id === alderdia ? 'aktiboa' : null }, p.izena))));

  // Galdetegiko baieztapenak bloke honetan
  if (!besteak) {
    const bai = D.galdetegia.baieztapenak.filter((b) => b.blokea === blokea);
    const sek = h('section', {}, h('h2', {}, 'Galdetegiko baieztapenak'),
      h('p', { class: 'txikia' }, 'Alderdi bakoitzaren jarrera (−2 guztiz aurka … +2 guztiz alde). Sakatu alderdi bat haren arrazoia ikusteko.'));
    for (const b of bai) {
      const txokoa = h('div', {});
      const botoiak = [];
      const erakutsi = (p) => {
        txokoa.replaceChildren(txartela(b, b.gelaxkak.find((g) => g.alderdia === p), egoera.modua));
        botoiak.forEach((x) => x.classList.toggle('aktiboa', x.dataset.p === p));
      };
      for (const g of b.gelaxkak) {
        const bt = h('button', { type: 'button', 'data-p': g.alderdia, onclick: () => erakutsi(g.alderdia) },
          D.alderdiak[g.alderdia].laburra, balioIkurra(g.kontaketa[egoera.modua].posizioa));
        botoiak.push(bt);
      }
      sek.append(h('div', { class: 'baieztapena' }, h('p', {}, b.testua), h('div', { class: 'alderdi-errenkada' }, botoiak), txokoa));
      erakutsi(alderdia);
    }
    app.append(sek);
  }

  // Programaren unitateak
  const zerrenda = h('div', {}, h('p', { class: 'kargatzen' }, 'Programa kargatzen…'));
  const bilatu = h('input', { type: 'search', class: 'bilatzailea', placeholder: 'Bilatu testuan…', 'aria-label': 'Bilatu programaren testuan' });
  app.append(h('h2', {}, D.alderdiak[alderdia].izena, ': programa', besteak ? ' — ' + D.atalak.gaiak[gaia] : ''),
    h('p', { class: 'txikia' }, h('a', { href: D.alderdiak[alderdia].url, target: '_blank', rel: 'noopener' }, D.alderdiak[alderdia].programa, ' (PDF osoa)')),
    h('div', { class: 'oharra' }, 'Zatien gai-sailkapena automatikoki egin da (Claude), eta ez da eskuz berrikusi: zati batzuk gai okerrean egon daitezke, edo falta.'),
    bilatu, zerrenda);

  let prog;
  try { prog = await programaKargatu(alderdia); } catch (e) { zerrenda.replaceChildren(h('p', {}, 'Ezin izan da programa kargatu.')); return; }
  const gaiak = besteak ? [gaia] : D.atalak.blokeak.find((b) => b.id === blokea).gaiak;
  const unitateak = prog.unitateak.filter((u) => u.gaiak.some((g) => gaiak.includes(g)));
  const marraztu = () => {
    const q = bilatu.value.trim().toLowerCase();
    const iragazi = q ? unitateak.filter((u) => u.testua.toLowerCase().includes(q) || u.atala.toLowerCase().includes(q)) : unitateak;
    const out = [h('p', { class: 'txikia' }, iragazi.length, ' zati', q ? ' (bilaketarekin)' : '', '.')];
    let atala = null;
    for (const u of iragazi) {
      if (u.atala !== atala) { atala = u.atala; out.push(h('h3', { class: 'atala' }, atala)); }
      out.push(unitatea(u, alderdia));
    }
    if (!iragazi.length) out.push(h('p', {}, 'Programak ez du zatirik gai honetan', q ? ' bilaketa honekin' : '', '.'));
    zerrenda.replaceChildren(...out);
  };
  let tm;
  bilatu.addEventListener('input', () => { clearTimeout(tm); tm = setTimeout(marraztu, 150); });
  marraztu();
}

function unitatea(u, alderdia) {
  const luzea = u.testua.length > 420;
  const p = h('p', { class: 'testua' + (luzea ? ' laburtua' : '') }, u.testua);
  const bt = luzea ? h('button', { type: 'button', onclick: () => { const l = p.classList.toggle('laburtua'); bt.textContent = l ? 'Gehiago' : 'Gutxiago'; } }, 'Gehiago') : null;
  const url = D.alderdiak[alderdia].url + (u.orria ? '#page=' + u.orria : '');
  return h('div', { class: 'unitatea' }, p, h('div', { class: 'meta' }, bt,
    h('a', { href: url, target: '_blank', rel: 'noopener' }, u.orria ? u.orria + '. orrialdea' : 'PDFa'),
    h('span', {}, u.id), h('span', {}, u.gaiak.map((g) => D.atalak.gaiak[g]).join(' · '))));
}

async function programaKargatu(p) {
  if (!D.programak[p]) D.programak[p] = kargatu('datuak/programa-' + p + '.json');
  return D.programak[p];
}

function galdetegia(app) {
  const guztira = D.galdetegia.baieztapenak.length;
  const kontagailua = h('span', {});
  const eguneratu = () => {
    const n = Object.keys(egoera.erantzunak).filter((k) => egoera.erantzunak[k] !== null).length;
    kontagailua.textContent = n + ' / ' + guztira + ' erantzunda';
  };
  app.append(h('h1', {}, 'Galdetegia'),
    h('p', {}, 'Esan zenbateraino zauden ados baieztapen bakoitzarekin. Ez badakizu edo ez bazaizu axola, sakatu "Ez dakit": ez da kontatuko. ',
      'Gai bat zuretzat bereziki garrantzitsua bada, markatu "Oso garrantzitsua", eta haren pisua bikoiztu egingo da.'),
    h('p', { class: 'txikia' }, 'Erantzunak zure nabigatzailean gordetzen dira, eta ez dira inora bidaltzen.'));
  for (const b of D.galdetegia.blokeak) {
    const kb = h('input', { type: 'checkbox', onchange: (e) => { egoera.garrantzi[b.id] = e.target.checked; gorde(); } });
    kb.checked = !!egoera.garrantzi[b.id];
    app.append(h('div', { class: 'blokea' }, h('h2', {}, b.izena), h('label', {}, kb, 'Oso garrantzitsua')));
    for (const bai of D.galdetegia.baieztapenak.filter((x) => x.blokea === b.id)) {
      const kutxa = h('div', { class: 'galdera' });
      const botoiak = [];
      const markatu = () => {
        const a = egoera.erantzunak[bai.id];
        kutxa.classList.toggle('erantzunda', a !== undefined);
        botoiak.forEach((bt) => bt.setAttribute('aria-pressed', String(bt.dataset.v === String(a === undefined ? 'x' : a === null ? 'n' : a))));
      };
      const aukeratu = (v) => {
        if (egoera.erantzunak[bai.id] === v) delete egoera.erantzunak[bai.id]; else egoera.erantzunak[bai.id] = v;
        gorde(); markatu(); eguneratu();
      };
      for (const e of ESKALA) botoiak.push(h('button', { type: 'button', class: 'e' + e.v, 'data-v': String(e.v), 'aria-pressed': 'false', onclick: () => aukeratu(e.v) }, e.izena));
      botoiak.push(h('button', { type: 'button', class: 'ezdakit', 'data-v': 'n', 'aria-pressed': 'false', onclick: () => aukeratu(null) }, 'Ez dakit'));
      kutxa.append(h('p', {}, bai.testua), h('div', { class: 'eskala', role: 'group', 'aria-label': bai.testua }, botoiak));
      markatu();
      app.append(kutxa);
    }
  }
  eguneratu();
  app.append(h('div', { class: 'aurrerapena' }, kontagailua,
    h('span', { class: 'ekintzak', style: 'margin:0' },
      h('button', { type: 'button', onclick: () => { if (confirm('Erantzun guztiak ezabatu?')) { egoera.erantzunak = {}; egoera.garrantzi = {}; gorde(); bidatu(); } } }, 'Hasieratu'),
      h('a', { class: 'botoia nagusia', href: '#/emaitzak' }, 'Emaitzak ikusi →'))));
}

/* Erantzunak URLan partekatzeko: e = 25 karaktere (a..e = −2..+2, x = erantzunik ez), g = bloke garrantzitsuen indizeak */
function kodetu() {
  const e = D.galdetegia.baieztapenak.map((b) => { const a = egoera.erantzunak[b.id]; return a === undefined || a === null ? 'x' : 'abcde'[a + 2]; }).join('');
  const g = D.galdetegia.blokeak.map((b, i) => (egoera.garrantzi[b.id] ? i : '')).join('');
  return 'e=' + e + (g ? '&g=' + g : '') + '&m=' + (egoera.modua === 'bozketak' ? 'b' : 'p');
}
function deskodetu(q) {
  const p = new URLSearchParams(q);
  const e = p.get('e');
  if (!e || e.length !== D.galdetegia.baieztapenak.length) return null;
  const erantzunak = {}, garrantzi = {};
  D.galdetegia.baieztapenak.forEach((b, i) => { const k = 'abcde'.indexOf(e[i]); if (k >= 0) erantzunak[b.id] = k - 2; });
  for (const c of p.get('g') || '') { const b = D.galdetegia.blokeak[+c]; if (b) garrantzi[b.id] = true; }
  return { erantzunak, garrantzi, modua: p.get('m') === 'b' ? 'bozketak' : 'programak' };
}

function emaitzak(app, query) {
  let egoe = egoera, partekatua = false;
  const desk = query ? deskodetu(query) : null;
  if (desk) { egoe = desk; partekatua = true; }
  const erantzunak = Object.fromEntries(Object.entries(egoe.erantzunak).filter(([, v]) => v !== null));
  const n = Object.keys(erantzunak).length;
  app.append(h('h1', {}, 'Emaitzak'));
  if (partekatua) app.append(h('div', { class: 'oharra' }, 'Partekatutako erantzunak ikusten ari zara. ', h('a', { href: '#/galdetegia' }, 'Bete zurea'), '.'));
  if (!n) { app.append(h('p', {}, 'Oraindik ez duzu baieztapenik erantzun. ', h('a', { href: '#/galdetegia' }, 'Galdetegia bete'), '.')); return; }
  if (n < 10) app.append(h('div', { class: 'oharra' }, n, ' baieztapen baino ez dituzu erantzun; emaitza ez da oso fidagarria.'));

  const modua = egoe.modua || 'programak';
  const aldatu = (m) => {
    if (partekatua) { egoe.modua = m; const u = new URLSearchParams(query); u.set('m', m === 'bozketak' ? 'b' : 'p'); location.hash = '#/emaitzak?' + u.toString(); }
    else { egoera.modua = m; gorde(); bidatu(); }
  };
  app.append(h('div', { class: 'moduak', role: 'radiogroup', 'aria-label': 'Kontaketa-modua' },
    Object.entries(MODUAK).map(([k, m]) => {
      const i = h('input', { type: 'radio', name: 'modua', value: k, onchange: () => aldatu(k) });
      i.checked = k === modua;
      return h('label', {}, i, m.izena);
    })),
    h('p', { class: 'modu-azalpena' }, MODUAK[modua].azalpena));

  const r = puntuazioa(erantzunak, egoe.garrantzi || {}, modua);
  const ordena = D.galdetegia.alderdiak.map((p) => p.id).sort((a, b) => r[b] - r[a]);
  const zerrenda = h('ol', { class: 'sailkapena' });
  for (const p of ordena) {
    const xeh = h('div', { class: 'xehetasuna' });
    const det = h('details', {}, h('summary', {},
      h('span', { class: 'izena' }, D.alderdiak[p].izena),
      h('span', { class: 'barra', 'aria-hidden': 'true' }, h('span', { style: 'width:' + r[p].toFixed(1) + '%' })),
      h('span', { class: 'ehunekoa' }, ehuneko(r[p]))), xeh);
    det.addEventListener('toggle', () => { if (det.open && !xeh.childElementCount) xehetasuna(xeh, p, erantzunak, egoe.garrantzi || {}, modua); });
    zerrenda.append(h('li', {}, det));
  }
  app.append(zerrenda,
    h('p', { class: 'txikia' }, 'Sakatu alderdi bat baieztapenez baieztapeneko kalkulua eta haren arrazoiak ikusteko. Adostasuna: 100% = jarrera bera; 0% = kontrako muturra; 50% = alderdiak ez du jarrerarik.'));

  const url = partekatua ? location.href : location.href.split('#')[0] + '#/emaitzak?' + kodetu();
  const sarrera = h('input', { type: 'text', readonly: true, value: url, 'aria-label': 'Partekatzeko esteka', onfocus: (e) => e.target.select() });
  app.append(h('div', { class: 'partekatu' }, h('strong', {}, 'Partekatu:'), sarrera,
    h('button', { type: 'button', onclick: async (e) => { try { await navigator.clipboard.writeText(sarrera.value); e.target.textContent = 'Kopiatuta ✓'; } catch (_) { sarrera.select(); } } }, 'Kopiatu')),
    h('p', { class: 'txikia' }, 'Estekak zure erantzunak dauzka (ez beste ezer). Zerbitzaririk ez dago: ez da ezer gordetzen.'),
    h('div', { class: 'ekintzak' }, h('a', { class: 'botoia', href: '#/galdetegia' }, '← Erantzunak aldatu'), h('a', { class: 'botoia', href: '#/programak' }, 'Programak arakatu')));
}

function xehetasuna(kutxa, p, erantzunak, garrantzi, modua) {
  for (const b of D.blokeak.ordena) {
    const bai = D.galdetegia.baieztapenak.filter((x) => x.blokea === b && erantzunak[x.id] !== undefined);
    if (!bai.length) continue;
    kutxa.append(h('h3', {}, D.blokeak[b].izena, garrantzi[b] ? ' (oso garrantzitsua, ×2)' : ''));
    for (const x of bai) {
      const g = x.gelaxkak.find((c) => c.alderdia === p);
      const a = erantzunak[x.id];
      const ad = adostasuna(a, g, modua);
      const txokoa = h('div', {});
      const bt = h('button', { type: 'button', 'aria-expanded': 'false' },
        h('span', { class: 'bai-testua' }, x.testua),
        h('span', { class: 'zenbakiak' }, 'Zu ', balioIkurra(a), ' · ', D.alderdiak[p].laburra, ' ', balioIkurra(g.kontaketa[modua].posizioa),
          g.kontraesana ? ' ⚠' : '', h('span', { class: 'adost' }, ehuneko(ad * 100))));
      bt.addEventListener('click', () => {
        const ireki = !txokoa.childElementCount;
        txokoa.replaceChildren(...(ireki ? [txartela(x, g, modua)] : []));
        bt.setAttribute('aria-expanded', String(ireki));
      });
      kutxa.append(h('div', { class: 'xehe-errenkada' }, bt, txokoa));
    }
  }
}

function metodologia(app) {
  const G = D.galdetegia;
  const ados = 'adostasuna = 1 − |zure erantzuna − alderdiaren posizioa| / 4';
  app.append(h('h1', {}, 'Metodologia'),
    h('p', {}, 'Bertsioa ', G.bertsioa, ', ', G.data, '. Tresnak alderdien Gorteetarako proposamenak neurtzen ditu, ez euskal erakundeetako politika.'),
    h('h2', {}, 'Gaiak eta pisuak'),
    h('p', {}, 'Bederatzi gai, 100 puntu guztira, Euskal Soziometroko kezka nagusien eta EHko gai bereizgarrien arabera. Gai baten pisua haren baieztapenen artean banatzen da.'),
    h('table', {}, h('thead', {}, h('tr', {}, h('th', {}, 'Gaia'), h('th', {}, 'Pisua'), h('th', {}, 'Baieztapenak'))),
      h('tbody', {}, G.blokeak.map((b) => h('tr', {}, h('td', {}, b.izena), h('td', {}, b.pisua), h('td', {}, D.blokeak[b.id].kop))))),
    h('h2', {}, 'Puntuazioa'),
    h('p', { class: 'formula' }, ados, h('br'), 'pisua = gaiaren pisua / gaiko baieztapenak (×2 "oso garrantzitsua" bada)', h('br'), 'emaitza = Σ pisua·adostasuna / Σ pisua'),
    h('p', {}, 'Baieztapenen erdiak norabide batean daude eta beste erdiak kontrakoan: batzuetan "ados" egotea ezkerreko edo abertzale jarrera da, eta besteetan eskuineko edo zentralista. Horrela, "bai" esateko joerak ez du emaitza alderdi-multzo baterantz desbideratzen. Proba: baieztapen guztiei erantzun bera emanez gero, alderdien arteko aldea 15 puntukoa da gehienez.'),
    h('p', {}, '"Ez dakit" erantzunak ez dira kontatzen. Alderdiak jarrerarik ez badu (ez programan, ez bozketetan), adostasuna 50% da: ez da saritzen ez zigortzen.'),
    h('h2', {}, 'Bi kontaketa-modu'),
    h('table', {}, h('thead', {}, h('tr', {}, h('th', {}, 'Kasua'), h('th', {}, 'Programak (lehenetsia)'), h('th', {}, 'Bozketak ere'))),
      h('tbody', {},
        h('tr', {}, h('td', {}, 'Programak jarrera du'), h('td', {}, 'programa'), h('td', {}, 'programa')),
        h('tr', {}, h('td', {}, 'Programa eta bozka kontrakoak (kontraesana)'), h('td', {}, 'programa, 0,5 mugituta bozkaren aldera'), h('td', {}, 'bien batez bestekoa')),
        h('tr', {}, h('td', {}, 'Programa isilik, bozka bai'), h('td', {}, '50% ± 12,5% gehienez, bozkaren norabidean (desenpatea)'), h('td', {}, 'bozka da posizioa')),
        h('tr', {}, h('td', {}, 'Ez programarik, ez bozkarik'), h('td', {}, '50%'), h('td', {}, '50%')))),
    h('p', {}, 'Aho bateko bozketak ez dira kontatzen, ez baitute alderdirik bereizten. Bozketak XV. legegintzaldikoak dira (2023–2026), prentsako albisteetatik egiaztatuak; Frente Amplioren kasuan, Sumarren bozketak.'),
    h('h2', {}, 'Nola erabaki dira posizioak?'),
    h('p', {}, 'Programak zatitan banatu dira, eta zati bakoitza gaika sailkatu da. Baieztapen bakoitzean, alderdiaren jarrera (−2…+2) programaren zati zehatzetan oinarrituta erabaki da, eta zati horiek txarteletan ikus daitezke, PDFaren orrialdearekin. ',
      'Gelaxka-motak: ', Object.entries(G.motak).map(([k, v], i) => [i ? '; ' : '', h('strong', {}, MOTA_IZENAK[k] || k), ': ', v.toLowerCase()]), '.'),
    h('h2', {}, 'Iturriak'),
    h('ul', {}, G.alderdiak.map((p) => h('li', {}, p.izena, ': ', h('a', { href: p.url, target: '_blank', rel: 'noopener' }, p.programa)))),
    h('h2', {}, 'Mugak'),
    h('ul', {},
      h('li', {}, 'Geroa Bai, UPN-PP eta SALF ez daude: ez zuten programa osorik argitaratu.'),
      h('li', {}, 'Programen sailkapena eta posizioak adimen artifizialaren laguntzaz egin dira (Claude), eta berrikusten ari dira. Akatsik ikusten baduzu, txarteleko iturria egiaztatu.'),
      h('li', {}, 'Etxebizitza, osasuna eta hezkuntza neurri handi batean EAE eta Nafarroako erakundeen eskumena dira.'),
      h('li', {}, 'Frente Amplio eta Podemos oso hurbil daude (% 97 inguru): galdetegiak nekez bereizten ditu.')));
}

/* ---------- Bideratzailea ---------- */
function bidatu() {
  const [bidea, query] = location.hash.replace(/^#\/?/, '').split('?');
  const zatiak = bidea.split('/').filter(Boolean).map(decodeURIComponent);
  const app = document.getElementById('app');
  app.replaceChildren();
  document.querySelectorAll('nav a').forEach((a) => a.classList.toggle('aktiboa', a.dataset.bidea === zatiak[0]));
  const izenburuak = { programak: 'Programak', galdetegia: 'Galdetegia', emaitzak: 'Emaitzak', metodologia: 'Metodologia' };
  document.title = (izenburuak[zatiak[0]] ? izenburuak[zatiak[0]] + ' · ' : '') + '29-N: programak eta galdetegia';
  switch (zatiak[0]) {
    case 'programak': programak(app, zatiak[1], zatiak[2], zatiak[3]); break;
    case 'galdetegia': galdetegia(app); break;
    case 'emaitzak': emaitzak(app, query); break;
    case 'metodologia': metodologia(app); break;
    default: hasiera(app);
  }
  if (zatiak[0] !== 'programak' || !zatiak[1]) window.scrollTo(0, 0);
}

async function abiarazi() {
  try {
    [D.galdetegia, D.atalak] = await Promise.all([kargatu('datuak/galdetegia.json'), kargatu('datuak/atalak.json')]);
  } catch (e) {
    document.getElementById('app').replaceChildren(h('p', {}, 'Ezin izan dira datuak kargatu. (', e.message, ')'));
    return;
  }
  const laburrak = { PNV: 'PNV', EHB: 'EHB', PSOE: 'PSOE', FA: 'FA', POD: 'Podemos', PP: 'PP', VOX: 'Vox' };
  for (const p of D.galdetegia.alderdiak) D.alderdiak[p.id] = Object.assign({ laburra: laburrak[p.id] || p.id }, p);
  D.blokeak.ordena = D.galdetegia.blokeak.map((b) => b.id);
  for (const b of D.galdetegia.blokeak) D.blokeak[b.id] = Object.assign({ kop: D.galdetegia.baieztapenak.filter((x) => x.blokea === b.id).length }, b);
  berreskuratu();
  window.addEventListener('hashchange', bidatu);
  bidatu();
}
abiarazi();
