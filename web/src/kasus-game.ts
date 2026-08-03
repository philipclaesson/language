// Kasus Krieg: pure data + logic (UI in games.tsx). A curated bank of German
// sentences, each with the article blanked (`___`) — the player names the CASE
// of the blank (Nominativ/Akkusativ/Dativ), and the feedback line teaches the
// one rule that decides it. Hand-authored and structurally validated by
// kasus-game.test.ts; genders were checked by hand, so edit with care.

export type Kasus = "nominativ" | "akkusativ" | "dativ";
export const KASUS_OPTIONS: Kasus[] = ["nominativ", "akkusativ", "dativ"];
export const KASUS_LABELS: Record<Kasus, string> = {
  nominativ: "Nominativ",
  akkusativ: "Akkusativ",
  dativ: "Dativ",
};

// The rule family each sentence drills — the end-of-round breakdown groups by
// this, so you can see WHICH deciding rule you're weak on.
export type KasusCategory =
  | "fixed-prep"
  | "two-way-prep"
  | "verb-object"
  | "dative-verb"
  | "subject";
export const KASUS_CATEGORY_LABELS: Record<KasusCategory, string> = {
  "fixed-prep": "Fixed prepositions",
  "two-way-prep": "Two-way prepositions",
  "verb-object": "Verb objects",
  "dative-verb": "Dativ verbs",
  subject: "Subjects",
};

export type KasusItem = {
  id: string;
  sentence: string; // contains exactly one `___` where the article goes
  article: string; // the word that fills the blank (lowercase; solveSentence capitalizes)
  kasus: Kasus;
  category: KasusCategory;
  rule: string; // the one-liner that decides the case, shown after every answer
};

// The blanked sentence's full solution, capitalized if the blank starts the
// sentence: "___ Hund schläft." + "der" → "Der Hund schläft."
export function solveSentence(item: KasusItem): string {
  const article = item.sentence.startsWith("___")
    ? item.article.charAt(0).toUpperCase() + item.article.slice(1)
    : item.article;
  return item.sentence.replace("___", article);
}

export const KASUS_ROUND_SIZE = 25;

// A fresh random round. Plain sample of the whole bank — with ~90 items across
// five categories the mix comes out varied on its own.
export function kasusRound(size = KASUS_ROUND_SIZE): KasusItem[] {
  return shuffle([...KASUS_BANK]).slice(0, size);
}

function shuffle<T>(arr: T[]): T[] {
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

// Authoring rules for the bank (checked by the test where possible):
// - exactly one `___`, always where an article goes; singular nouns only (plural
//   dative "den" would muddy the case↔article picture);
// - no sentences where a der/dem contraction is the only natural form (zum, im,
//   beim …) — after von/zu/bei/gegenüber we use feminine nouns for that reason;
// - two-way MOTION sentences use unambiguous direction verbs (legen, stellen,
//   hängen, sich setzen …), LOCATION ones use static verbs (liegen, stehen,
//   sitzen, warten …) so the intended reading is the only one.
export const KASUS_BANK: KasusItem[] = [
  // ---- Fixed dative prepositions: mit nach bei seit von zu aus gegenüber ----
  { id: "mit-bus", sentence: "Ich fahre mit ___ Bus in die Stadt.", article: "dem", kasus: "dativ", category: "fixed-prep", rule: "mit → always Dativ" },
  { id: "mit-freundin", sentence: "Sie fährt mit ___ Freundin nach Berlin.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "mit → always Dativ" },
  { id: "nach-essen", sentence: "Nach ___ Essen gehen wir spazieren.", article: "dem", kasus: "dativ", category: "fixed-prep", rule: "nach → always Dativ" },
  { id: "nach-arbeit", sentence: "Nach ___ Arbeit trinken wir ein Bier.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "nach → always Dativ" },
  { id: "bei-oma", sentence: "Sie wohnt noch bei ___ Großmutter.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "bei → always Dativ" },
  { id: "bei-hitze", sentence: "Bei ___ Hitze bleibe ich zu Hause.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "bei → always Dativ" },
  { id: "seit-sommer", sentence: "Seit ___ Sommer lerne ich Deutsch.", article: "dem", kasus: "dativ", category: "fixed-prep", rule: "seit → always Dativ" },
  { id: "seit-unfall", sentence: "Seit ___ Unfall trägt er einen Helm.", article: "dem", kasus: "dativ", category: "fixed-prep", rule: "seit → always Dativ" },
  { id: "von-tante", sentence: "Das Geschenk ist von ___ Tante.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "von → always Dativ" },
  { id: "von-reise", sentence: "Ich träume von ___ Reise nach Japan.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "von → always Dativ" },
  { id: "von-bruecke", sentence: "Von ___ Brücke sieht man die Berge.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "von → always Dativ" },
  { id: "zu-aerztin", sentence: "Wir gehen heute zu ___ Ärztin.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "zu → always Dativ" },
  { id: "zu-oma", sentence: "Wir fahren am Sonntag zu ___ Oma.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "zu → always Dativ" },
  { id: "aus-schule", sentence: "Er kommt gerade aus ___ Schule.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "aus → always Dativ" },
  { id: "aus-kueche", sentence: "Aus ___ Küche riecht es nach Kuchen.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "aus → always Dativ" },
  { id: "gegenueber-kirche", sentence: "Die Bäckerei liegt gegenüber ___ Kirche.", article: "der", kasus: "dativ", category: "fixed-prep", rule: "gegenüber → always Dativ" },

  // ---- Fixed accusative prepositions: durch für gegen ohne um ----
  { id: "durch-park", sentence: "Wir gehen durch ___ Park.", article: "den", kasus: "akkusativ", category: "fixed-prep", rule: "durch → always Akkusativ" },
  { id: "durch-fluss", sentence: "Sie schwimmt durch ___ Fluss.", article: "den", kasus: "akkusativ", category: "fixed-prep", rule: "durch → always Akkusativ" },
  { id: "durch-fenster", sentence: "Durch ___ Fenster sieht man den Garten.", article: "das", kasus: "akkusativ", category: "fixed-prep", rule: "durch → always Akkusativ" },
  { id: "fuer-lehrerin", sentence: "Das Geschenk ist für ___ Lehrerin.", article: "die", kasus: "akkusativ", category: "fixed-prep", rule: "für → always Akkusativ" },
  { id: "fuer-familie", sentence: "Der Kuchen ist für ___ Familie.", article: "die", kasus: "akkusativ", category: "fixed-prep", rule: "für → always Akkusativ" },
  { id: "fuer-firma", sentence: "Er arbeitet für ___ Firma in München.", article: "die", kasus: "akkusativ", category: "fixed-prep", rule: "für → always Akkusativ" },
  { id: "gegen-baum", sentence: "Er ist gegen ___ Baum gefahren.", article: "den", kasus: "akkusativ", category: "fixed-prep", rule: "gegen → always Akkusativ" },
  { id: "gegen-wind", sentence: "Wir laufen gegen ___ Wind.", article: "den", kasus: "akkusativ", category: "fixed-prep", rule: "gegen → always Akkusativ" },
  { id: "ohne-schluessel", sentence: "Ohne ___ Schlüssel kommen wir nicht rein.", article: "den", kasus: "akkusativ", category: "fixed-prep", rule: "ohne → always Akkusativ" },
  { id: "ohne-brille", sentence: "Ohne ___ Brille sehe ich nichts.", article: "die", kasus: "akkusativ", category: "fixed-prep", rule: "ohne → always Akkusativ" },
  { id: "um-tisch", sentence: "Die Katze läuft um ___ Tisch.", article: "den", kasus: "akkusativ", category: "fixed-prep", rule: "um → always Akkusativ" },
  { id: "um-sonne", sentence: "Die Erde dreht sich um ___ Sonne.", article: "die", kasus: "akkusativ", category: "fixed-prep", rule: "um → always Akkusativ" },

  // ---- Two-way prepositions, MOTION → Akkusativ ----
  { id: "an-wand-akk", sentence: "Ich hänge das Bild an ___ Wand.", article: "die", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "auf-tisch-akk", sentence: "Er legt das Buch auf ___ Tisch.", article: "den", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "in-garten-akk", sentence: "Wir gehen jetzt in ___ Garten.", article: "den", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "auf-regal-akk", sentence: "Sie stellt die Vase auf ___ Regal.", article: "das", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "unter-bett-akk", sentence: "Der Hund kriecht unter ___ Bett.", article: "das", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "in-stadt-akk", sentence: "Wir fahren am Samstag in ___ Stadt.", article: "die", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "vor-tuer-akk", sentence: "Er stellt die Schuhe vor ___ Tür.", article: "die", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "auf-sofa-akk", sentence: "Die Katze springt auf ___ Sofa.", article: "das", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "in-tasche-akk", sentence: "Ich stecke das Geld in ___ Tasche.", article: "die", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "neben-fenster-akk", sentence: "Setz dich neben ___ Fenster!", article: "das", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "hinter-schrank-akk", sentence: "Stell den Koffer hinter ___ Schrank!", article: "den", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },
  { id: "ueber-tisch-akk", sentence: "Sie hängt die Lampe über ___ Tisch.", article: "den", kasus: "akkusativ", category: "two-way-prep", rule: "Wohin? Motion → Akkusativ" },

  // ---- Two-way prepositions, LOCATION → Dativ ----
  { id: "an-wand-dat", sentence: "Das Bild hängt an ___ Wand.", article: "der", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "auf-tisch-dat", sentence: "Das Buch liegt auf ___ Tisch.", article: "dem", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "in-kueche-dat", sentence: "Wir kochen zusammen in ___ Küche.", article: "der", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "auf-regal-dat", sentence: "Die Vase steht auf ___ Regal.", article: "dem", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "unter-bett-dat", sentence: "Der Hund schläft unter ___ Bett.", article: "dem", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "vor-tuer-dat", sentence: "Sie wartet vor ___ Tür.", article: "der", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "auf-sofa-dat", sentence: "Die Katze liegt auf ___ Sofa.", article: "dem", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "hinter-haus-dat", sentence: "Das Auto steht hinter ___ Haus.", article: "dem", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "ueber-tisch-dat", sentence: "Die Lampe hängt über ___ Tisch.", article: "dem", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "in-tasche-dat", sentence: "Der Schlüssel ist in ___ Tasche.", article: "der", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "neben-uhr-dat", sentence: "Das Poster hängt neben ___ Uhr.", article: "der", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "neben-ausgang-dat", sentence: "Er sitzt neben ___ Ausgang.", article: "dem", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },
  { id: "zwischen-bank-dat", sentence: "Der Supermarkt liegt zwischen ___ Bank und der Post.", article: "der", kasus: "dativ", category: "two-way-prep", rule: "Wo? Location → Dativ" },

  // ---- Direct objects → Akkusativ ----
  { id: "kaufen-apfel", sentence: "Ich kaufe ___ Apfel.", article: "den", kasus: "akkusativ", category: "verb-object", rule: "Direct object of kaufen → Akkusativ" },
  { id: "lesen-zeitung", sentence: "Sie liest ___ Zeitung.", article: "die", kasus: "akkusativ", category: "verb-object", rule: "Direct object of lesen → Akkusativ" },
  { id: "trinken-kaffee", sentence: "Er trinkt ___ Kaffee.", article: "den", kasus: "akkusativ", category: "verb-object", rule: "Direct object of trinken → Akkusativ" },
  { id: "besuchen-museum", sentence: "Wir besuchen ___ Museum.", article: "das", kasus: "akkusativ", category: "verb-object", rule: "Direct object of besuchen → Akkusativ" },
  { id: "kennen-film", sentence: "Kennst du ___ Film?", article: "den", kasus: "akkusativ", category: "verb-object", rule: "Direct object of kennen → Akkusativ" },
  { id: "oeffnen-tuer", sentence: "Sie öffnet ___ Tür.", article: "die", kasus: "akkusativ", category: "verb-object", rule: "Direct object of öffnen → Akkusativ" },
  { id: "suchen-schluessel", sentence: "Ich suche ___ Schlüssel.", article: "den", kasus: "akkusativ", category: "verb-object", rule: "Direct object of suchen → Akkusativ" },
  { id: "reparieren-fahrrad", sentence: "Er repariert ___ Fahrrad.", article: "das", kasus: "akkusativ", category: "verb-object", rule: "Direct object of reparieren → Akkusativ" },
  { id: "fragen-lehrerin", sentence: "Ich frage ___ Lehrerin.", article: "die", kasus: "akkusativ", category: "verb-object", rule: "fragen takes Akkusativ (unlike antworten!)" },
  { id: "finden-fehler", sentence: "Sie findet ___ Fehler sofort.", article: "den", kasus: "akkusativ", category: "verb-object", rule: "Direct object of finden → Akkusativ" },
  { id: "brauchen-stift", sentence: "Ich brauche ___ Stift.", article: "den", kasus: "akkusativ", category: "verb-object", rule: "Direct object of brauchen → Akkusativ" },
  { id: "verstehen-frage", sentence: "Er versteht ___ Frage nicht.", article: "die", kasus: "akkusativ", category: "verb-object", rule: "Direct object of verstehen → Akkusativ" },

  // ---- Indirect objects (the receiver) → Dativ ----
  { id: "geben-mann", sentence: "Ich gebe ___ Mann den Apfel.", article: "dem", kasus: "dativ", category: "verb-object", rule: "geben: the receiver → Dativ" },
  { id: "zeigen-touristin", sentence: "Sie zeigt ___ Touristin den Weg.", article: "der", kasus: "dativ", category: "verb-object", rule: "zeigen: the receiver → Dativ" },
  { id: "schenken-kind", sentence: "Er schenkt ___ Kind ein Buch.", article: "dem", kasus: "dativ", category: "verb-object", rule: "schenken: the receiver → Dativ" },
  { id: "bringen-nachbarin", sentence: "Wir bringen ___ Nachbarin die Post.", article: "der", kasus: "dativ", category: "verb-object", rule: "bringen: the receiver → Dativ" },
  { id: "schreiben-chef", sentence: "Ich schreibe ___ Chef eine E-Mail.", article: "dem", kasus: "dativ", category: "verb-object", rule: "schreiben: the receiver → Dativ" },
  { id: "erklaeren-schueler", sentence: "Sie erklärt ___ Schüler die Aufgabe.", article: "dem", kasus: "dativ", category: "verb-object", rule: "erklären: the receiver → Dativ" },
  { id: "kochen-familie", sentence: "Er kocht ___ Familie eine Suppe.", article: "der", kasus: "dativ", category: "verb-object", rule: "kochen (for someone): the receiver → Dativ" },
  { id: "leihen-freundin", sentence: "Ich leihe ___ Freundin mein Auto.", article: "der", kasus: "dativ", category: "verb-object", rule: "leihen: the receiver → Dativ" },

  // ---- Dative verbs: helfen danken gefallen gehören folgen antworten … ----
  { id: "helfen-frau", sentence: "Ich helfe ___ Frau mit den Taschen.", article: "der", kasus: "dativ", category: "dative-verb", rule: "helfen always takes Dativ" },
  { id: "helfen-opa", sentence: "Kannst du ___ Opa helfen?", article: "dem", kasus: "dativ", category: "dative-verb", rule: "helfen always takes Dativ" },
  { id: "gehoeren-nachbarin", sentence: "Das Auto gehört ___ Nachbarin.", article: "der", kasus: "dativ", category: "dative-verb", rule: "gehören always takes Dativ" },
  { id: "gefallen-publikum", sentence: "Der Film gefällt ___ Publikum.", article: "dem", kasus: "dativ", category: "dative-verb", rule: "gefallen always takes Dativ" },
  { id: "danken-fahrer", sentence: "Wir danken ___ Fahrer.", article: "dem", kasus: "dativ", category: "dative-verb", rule: "danken always takes Dativ" },
  { id: "folgen-kind", sentence: "Der Hund folgt ___ Kind.", article: "dem", kasus: "dativ", category: "dative-verb", rule: "folgen always takes Dativ" },
  { id: "antworten-lehrer", sentence: "Sie antwortet ___ Lehrer.", article: "dem", kasus: "dativ", category: "dative-verb", rule: "antworten takes Dativ (unlike fragen!)" },
  { id: "schmecken-gast", sentence: "Das Essen schmeckt ___ Gast.", article: "dem", kasus: "dativ", category: "dative-verb", rule: "schmecken always takes Dativ" },
  { id: "glauben-politikerin", sentence: "Er glaubt ___ Politikerin nicht.", article: "der", kasus: "dativ", category: "dative-verb", rule: "glauben (a person) takes Dativ" },
  { id: "passen-maedchen", sentence: "Der Pullover passt ___ Mädchen.", article: "dem", kasus: "dativ", category: "dative-verb", rule: "passen always takes Dativ" },

  // ---- Subjects → Nominativ ----
  { id: "subjekt-hund", sentence: "___ Hund schläft im Garten.", article: "der", kasus: "nominativ", category: "subject", rule: "The subject → Nominativ" },
  { id: "subjekt-kind", sentence: "___ Kind schläft schon.", article: "das", kasus: "nominativ", category: "subject", rule: "The subject → Nominativ" },
  { id: "subjekt-frau", sentence: "___ Frau liest ein Buch.", article: "die", kasus: "nominativ", category: "subject", rule: "The subject → Nominativ" },
  { id: "subjekt-onkel", sentence: "Morgen kommt ___ Onkel zu Besuch.", article: "der", kasus: "nominativ", category: "subject", rule: "Subject (wer kommt?) → Nominativ, even after the verb" },
  { id: "subjekt-zug", sentence: "___ Zug hat Verspätung.", article: "der", kasus: "nominativ", category: "subject", rule: "The subject → Nominativ" },
  { id: "subjekt-chefin", sentence: "Heute bezahlt ___ Chefin.", article: "die", kasus: "nominativ", category: "subject", rule: "Subject (wer bezahlt?) → Nominativ, even after the verb" },
  { id: "subjekt-suppe", sentence: "___ Suppe schmeckt fantastisch.", article: "die", kasus: "nominativ", category: "subject", rule: "The subject → Nominativ" },
  { id: "subjekt-mannschaft", sentence: "Am Ende gewinnt ___ Mannschaft in Rot.", article: "die", kasus: "nominativ", category: "subject", rule: "Subject (wer gewinnt?) → Nominativ, even after the verb" },
  { id: "sein-bruder", sentence: "Das ist ___ Bruder von Maria.", article: "der", kasus: "nominativ", category: "subject", rule: "After sein both sides are Nominativ" },
];
