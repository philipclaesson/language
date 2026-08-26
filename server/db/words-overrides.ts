// Hand-fixes ("overrides") for the frequency word corpus, applied on top of the
// Anki source. Some cards need edits the source deck doesn't have — a duplicate
// prompt disambiguated, an example sentence that doesn't demonstrate its word.
// Editing words.data.json directly would be lost on the next regeneration, so the
// fixes live HERE, keyed by frequency_rank (the corpus's stable card key, also how
// the backfill migrations address cards in prod), and are applied by both scripts:
//   - scripts/apply-overrides.ts — the day-to-day tool: patches the committed
//     words.data.json in place (no .apkg needed) and emits the next backfill
//     migration for the ranks that changed, preserving review progress;
//   - scripts/gen-words.ts — the full regen from the source .apkg applies the
//     table last, so regenerating never loses a fix.
//
// Workflow for a new fix:
//   1. add an entry to WORD_OVERRIDES below (one entry per rank; amend to stack fixes)
//   2. npx tsx scripts/apply-overrides.ts --name=<short_snake_case_name>
//   3. review the generated drizzle/00NN_<name>.sql, `npm run check`, commit all of it
// The test in words-overrides.test.ts fails if this table and words.data.json
// drift — i.e. if step 2 was skipped.
//
// History: 0011 fixed parser-mangled answers (a words-parse.ts fix — regen-safe, so
// not repeated here); 0012 (weiter) and 0014 (befinden) were the first content
// overrides, hand-written before this table existed. They're seeded below so a
// regeneration keeps them; their migrations already ran, so they emit no new SQL.

import type { ParsedWord } from "./words-parse";

// Fixed id of the global corpus deck. MUST match server/db/words.ts,
// scripts/gen-words.ts, and the deck row in drizzle/0005_seed_words.sql.
export const WORD_DECK_ID = "b7c8e3a0-6d4f-4e2a-9c1b-000000005000";

// The card fields an override may change. frequencyRank is the KEY (it is how the
// card is found, in data.json and in prod alike), so it can never be overridden.
export type OverrideFields = Partial<Omit<ParsedWord, "frequencyRank">>;

export type WordOverride = {
  rank: number; // frequency_rank of the card to fix
  reason: string; // one line on why — copied into the generated migration
  set: OverrideFields;
};

export const WORD_OVERRIDES: WordOverride[] = [
  {
    rank: 221,
    reason:
      'the "weiter" example used "weitere" (the rank-182 card), never the word itself — replaced with a sentence in the adverbial "onwards" sense (first shipped as 0012)',
    set: {
      exampleEn: "We’re tired, but we walk a little further.",
      exampleDe: "Wir sind müde, aber wir gehen noch ein bisschen weiter.",
    },
  },
  {
    rank: 464,
    reason:
      'prompt "to be" was an exact duplicate of the rank-4 card "sein"; "sich befinden" means to be located/situated, and the gloss now says "is located" to match (first shipped as 0014)',
    set: {
      prompt: "to be located, to be situated",
      exampleEn: "The restaurant is located near the railway station.",
    },
  },
  {
    rank: 287,
    reason: 'Swedish "erhålla" is a near-perfect cognate of erhalten (to receive)',
    set: { swedish: "erhålla" },
  },
  {
    rank: 463,
    reason: 'Swedish "trots det" maps trotzdem (nevertheless) far better than English',
    set: { swedish: "trots det" },
  },
  { rank: 75, reason: 'Swedish cognate for uns (us)', set: { swedish: "oss" } },
  { rank: 495, reason: 'Swedish cognate for euch (you pl.)', set: { swedish: "er" } },
  { rank: 340, reason: 'Swedish cognate for tatsächlich (actual)', set: { swedish: "faktisk" } },
  { rank: 321, reason: 'Swedish cognate for steigen (to climb/rise)', set: { swedish: "stiga" } },
  { rank: 302, reason: 'Swedish cognate for deutlich (clear)', set: { swedish: "tydlig" } },
  { rank: 299, reason: 'Swedish cognate for handeln (to act/trade)', set: { swedish: "handla" } },
  { rank: 297, reason: 'Swedish cognate for die Zahl (number)', set: { swedish: "tal" } },
  { rank: 280, reason: 'Swedish cognate for bestimmt (certain/definite)', set: { swedish: "bestämd" } },
  { rank: 279, reason: 'Swedish for überhaupt (at all)', set: { swedish: "över huvud taget" } },
  { rank: 523, reason: 'Swedish cognate for annehmen (to assume/accept)', set: { swedish: "anta" } },
  { rank: 569, reason: 'Swedish cognate for der Begriff (concept/term)', set: { swedish: "begrepp" } },
  { rank: 568, reason: 'Swedish cognate for aktuell (current)', set: { swedish: "aktuell" } },
  { rank: 419, reason: 'Swedish cognate for bestimmen (to decide/determine)', set: { swedish: "bestämma" } },
  {
    rank: 216,
    reason: 'Swedish "känna någon" pins kennen to knowing a person (vs. wissen)',
    set: { swedish: "känna någon" },
  },
  { rank: 189, reason: 'Swedish cognate for wirklich (real/actual)', set: { swedish: "verklig" } },
  { rank: 560, reason: 'Swedish "bo" maps wohnen (to live/reside) better than English "to live"', set: { swedish: "bo" } },
  { rank: 566, reason: 'Swedish cognate for merken (to notice)', set: { swedish: "märka" } },

  // Swedish glosses to disambiguate five near-synonymous "to happen / occur / take
  // place" verbs clustered around rank 620–654, all glossed near-identically in English.
  { rank: 623, reason: 'Swedish cognate "ske" pins geschehen (to happen/occur)', set: { swedish: "ske" } },
  { rank: 628, reason: 'Swedish cognate "förekomma" pins vorkommen (to occur/be present)', set: { swedish: "förekomma" } },
  { rank: 648, reason: 'Swedish "genomföras" pins erfolgen (to take place/be carried out); the cognate "följa" drifted to mean "follow"', set: { swedish: "genomföras" } },
  { rank: 652, reason: 'Swedish idiom "äga rum" pins stattfinden (to take place); "ta plats" is a false friend (= take up space)', set: { swedish: "äga rum" } },
  { rank: 654, reason: 'Swedish cognate "uppträda" pins auftreten (to appear/occur/perform)', set: { swedish: "uppträda" } },

  // Swedish glosses to disambiguate three "different" words all glossed the same in English.
  { rank: 254, reason: 'Swedish "olika" pins verschieden (various/different)', set: { swedish: "olika" } },
  { rank: 303, reason: 'Swedish "annorlunda" pins anders (differently); the cognate "annars" is a false friend (= otherwise/else)', set: { swedish: "annorlunda" } },
  { rank: 345, reason: 'Swedish "skilda" pins unterschiedlich (differing/distinct), mirroring Unterschied→skillnad', set: { swedish: "skilda" } },

  // Swedish glosses splitting the two "doctor" words: title vs. profession.
  { rank: 240, reason: 'Swedish cognate "doktor" pins Doktor (title/degree)', set: { swedish: "doktor" } },
  { rank: 622, reason: 'Swedish "läkare" pins Arzt (physician/profession), vs. Doktor the title', set: { swedish: "läkare" } },

  // Swedish glosses splitting three "increase" verbs (steigen already covered above,
  // rank 321 → stiga): höja (transitive, raise) vs. tilltaga (intransitive, grow).
  { rank: 617, reason: 'Swedish cognate "höja" pins erhöhen (to raise, transitive)', set: { swedish: "höja" } },
  { rank: 650, reason: 'Swedish "tilltaga" pins zunehmen (to increase/grow, intransitive) — a morpheme-for-morpheme cognate (zu-nehmen = till-taga)', set: { swedish: "tilltaga" } },
  // Completing the "increase" family: the remaining verbs + their nouns. Each verb
  // pairs with its noun (öka/ökning, höja/höjning) so the mapping stays memorable.
  { rank: 2015, reason: 'Swedish "öka" pins steigern (to boost/increase, transitive), vs. erhöhen→höja', set: { swedish: "öka" } },
  { rank: 2074, reason: 'Swedish "uppgång" pins Anstieg (a rise/increase, e.g. of prices)', set: { swedish: "uppgång" } },
  { rank: 2086, reason: 'Swedish "höjning" pins Erhöhung (a raise/increase), the noun to erhöhen→höja', set: { swedish: "höjning" } },
  { rank: 3147, reason: 'Swedish cognate "förstora" pins vergrößern (to enlarge/increase in size) — ver+größer ~ för+stor', set: { swedish: "förstora" } },
  { rank: 3579, reason: 'Swedish "ökning" pins Steigerung (an increase), the noun to steigern→öka', set: { swedish: "ökning" } },
  { rank: 3788, reason: 'Swedish "tillväxt" pins Zunahme (growth/increase), the noun to zunehmen→tilltaga', set: { swedish: "tillväxt" } },

  // Swedish glosses splitting three "experience" words: uppleva (undergo an event),
  // erfara (come to know / find out), erfarenhet (the noun).
  { rank: 570, reason: 'Swedish cognate "uppleva" pins erleben (to experience/live through) — er-leben = upp-leva', set: { swedish: "uppleva" } },
  { rank: 619, reason: 'Swedish cognate "erfarenhet" pins Erfahrung (experience, noun)', set: { swedish: "erfarenhet" } },
  { rank: 690, reason: 'Swedish cognate "erfara" pins erfahren (to experience/find out)', set: { swedish: "erfara" } },

  // gewiss vs. bestimmt (rank 280 → bestämd above): Swedish "viss" (a certain/sure).
  { rank: 552, reason: 'Swedish cognate "viss" pins gewiss (certain/sure), vs. bestimmt→bestämd', set: { swedish: "viss" } },

  // The two "because" conjunctions, split by Swedish the way German splits them
  // grammatically: eftersom is subordinating (like weil), ty is coordinating (like denn).
  { rank: 88, reason: 'Swedish "eftersom" (subordinating because) pins weil, vs. denn', set: { swedish: "eftersom" } },
  { rank: 93, reason: 'Swedish "ty" (coordinating for/because; colloq. "för") pins denn, vs. weil', set: { swedish: "ty" } },

  // The "use" family — a 12-way English collision. Only the three verbs
  // verwenden/benutzen/(nutzen) genuinely overlap in Swedish; every noun has its own
  // distinct cognate (insats, användning, bruk, nyttjande, nytta), so Swedish
  // disambiguates the family well.
  { rank: 429, reason: 'Swedish cognate "nyttja" pins nutzen (utilize/make use of); Nutzen = nytta', set: { swedish: "nyttja" } },
  { rank: 538, reason: 'Swedish "använda" pins verwenden (the general "use/employ")', set: { swedish: "använda" } },
  { rank: 780, reason: 'Swedish cognate "insats" pins Einsatz (deployment/use/stake/effort) — in-satz = in-sats', set: { swedish: "insats" } },
  { rank: 1119, reason: 'Swedish "begagna" pins benutzen (use/operate; cf. begagnad = used), vs. verwenden→använda', set: { swedish: "begagna" } },
  { rank: 1258, reason: 'Swedish "tillämpning" pins Anwendung (application; anwenden = tillämpa)', set: { swedish: "tillämpning" } },
  { rank: 1606, reason: 'Swedish "användning" pins Verwendung (usage) — the noun of verwenden→använda', set: { swedish: "användning" } },
  { rank: 2129, reason: 'Swedish cognate "bruk" pins Gebrauch (use/usage) — ge-brauch ~ bruk', set: { swedish: "bruk" } },
  { rank: 2140, reason: 'Swedish "nyttjande" pins Nutzung (usage/utilization) — the noun of nutzen→nyttja', set: { swedish: "nyttjande" } },
  { rank: 2155, reason: 'Swedish cognate "nytta" pins Nutzen (benefit/use/utility), the benefit sense', set: { swedish: "nytta" } },
  { rank: 2831, reason: 'Swedish cognate "bearbeta" pins verarbeiten (to process/work up) — ver-arbeiten ~ be-arbeta', set: { swedish: "bearbeta" } },
  { rank: 3307, reason: 'Swedish cognate "förbruka" pins verbrauchen (to consume/use up) — ver-brauchen ~ för-bruka', set: { swedish: "förbruka" } },
  { rank: 4599, reason: 'Swedish "utgift" pins Aufwendung (expense/expenditure) — the deck\'s "use" gloss is misleading', set: { swedish: "utgift" } },

  // The "appear/seem" family (auftreten→uppträda already glossed at rank 654):
  // skina (shine — the sense unique to scheinen), se ut (look), framträda (emerge),
  // dyka upp (surface).
  { rank: 275, reason: 'scheinen carries both senses: "skina" (shine — the cognate, unique in this cluster) and "verka" (seem — its most frequent everyday use)', set: { swedish: "skina, verka" } },
  { rank: 277, reason: 'Swedish "se ut" pins aussehen (to look/appear) — aus-sehen = se ut', set: { swedish: "se ut" } },
  { rank: 408, reason: 'Swedish "framträda" pins erscheinen (to appear/come forth/emerge)', set: { swedish: "framträda" } },
  { rank: 1228, reason: 'Swedish "dyka upp" pins auftauchen (to surface/pop up) — auf-tauchen = dyka upp', set: { swedish: "dyka upp" } },

  // The "put/place" family: German splits "put" by orientation and Swedish splits it
  // the same way (ställa upright, lägga flat, sätta set) — mostly cognates, incl. the
  // three place-nouns (plats/ort/ställe).
  { rank: 135, reason: 'Swedish cognate "ställa" pins stellen (put upright/vertical)', set: { swedish: "ställa" } },
  { rank: 228, reason: 'Swedish cognate "sätta" pins setzen (to set/put)', set: { swedish: "sätta" } },
  { rank: 352, reason: 'Swedish cognate "lägga" pins legen (to lay/put down, horizontal)', set: { swedish: "lägga" } },
  { rank: 688, reason: 'Swedish "stoppa in" pins stecken (put/stick into); the cognate "sticka" drifted to prick/knit', set: { swedish: "stoppa in" } },
  { rank: 326, reason: 'Swedish cognate "plats" pins Platz (place/room/square)', set: { swedish: "plats" } },
  { rank: 341, reason: 'Swedish cognate "ort" pins Ort (place/locality/town)', set: { swedish: "ort" } },
  { rank: 344, reason: 'Swedish cognate "ställe" pins Stelle (place/spot) — the noun to stellen/ställa', set: { swedish: "ställe" } },

  // Completing the "real/actual" family (wirklich→verklig, tatsächlich→faktisk above):
  { rank: 151, reason: 'Swedish cognate "egentligen" pins eigentlich (actually/strictly speaking)', set: { swedish: "egentligen" } },
  { rank: 685, reason: 'Swedish cognate "äkta" pins echt (genuine/real)', set: { swedish: "äkta" } },
  { rank: 1350, reason: 'Swedish "reell" pins real (real/actual), vs. wirklich→verklig', set: { swedish: "reell" } },

  // The "work" family — all clean cognates. "verka" also glosses scheinen's "seem"
  // sense (rank 275), which is correct: Swedish verka means both act/work and seem.
  { rank: 208, reason: 'Swedish cognate "arbete" pins Arbeit (work, noun)', set: { swedish: "arbete" } },
  { rank: 234, reason: 'Swedish cognate "arbeta" pins arbeiten (to work)', set: { swedish: "arbeta" } },
  { rank: 401, reason: 'Swedish cognate "verka" pins wirken (to have an effect/act/work)', set: { swedish: "verka" } },
  { rank: 677, reason: 'Swedish cognate "fungera" pins funktionieren (to function/work)', set: { swedish: "fungera" } },
  { rank: 681, reason: 'Swedish cognate "verk" pins Werk (work/opus/plant)', set: { swedish: "verk" } },

  // The "call" family: name/mention vs. designate vs. shout vs. telephone.
  { rank: 191, reason: 'Swedish cognate "nämna" pins nennen (to name/call/mention)', set: { swedish: "nämna" } },
  { rank: 405, reason: 'Swedish cognate "beteckna" pins bezeichnen (to designate/call as) — the als↔som construction matches: "als X bezeichnen" = "beteckna som X"', set: { swedish: "beteckna" } },
  { rank: 530, reason: 'Swedish cognate "ropa" pins rufen (to call out/shout) — rufen ~ ropa', set: { swedish: "ropa" } },
  { rank: 1146, reason: 'Swedish "ringa" pins anrufen (to call on the phone)', set: { swedish: "ringa" } },

  // The "push/press" family — all cognates, distinct.
  { rank: 924, reason: 'Swedish cognate "trycka" pins drücken (to press/push)', set: { swedish: "trycka" } },
  { rank: 1221, reason: 'Swedish cognate "stöta" pins stoßen (to bump/push) — stoßen ~ stöta', set: { swedish: "stöta" } },
  { rank: 1251, reason: 'Swedish cognate "skjuta (på)" pins schieben (to push/shove) — the "(på)" steers away from skjuta=shoot', set: { swedish: "skjuta (på)" } },
  { rank: 1632, reason: 'Swedish cognate "tränga" pins drängen (to push/press/urge) — drängen ~ tränga', set: { swedish: "tränga" } },

  // The "change" family. German splits it three ways and Swedish follows: alter
  // (ändra/förändra), switch/swap (växla/byta), transform (förvandla/omvandla).
  // Ausgleich is really "compensation/balancing" — the gloss steers away from "change".
  { rank: 448, reason: 'Swedish cognate "ändra" pins ändern (to change/alter)', set: { swedish: "ändra" } },
  { rank: 500, reason: 'Swedish cognate "förändra" pins verändern (to change/transform), vs. plain ändern→ändra', set: { swedish: "förändra" } },
  { rank: 854, reason: 'Swedish "förändring" pins Veränderung (change/transformation), the noun to verändern', set: { swedish: "förändring" } },
  { rank: 1084, reason: 'Swedish cognate "växla" pins wechseln (to switch/swap/change) — wechseln ~ växla', set: { swedish: "växla" } },
  { rank: 1326, reason: 'Swedish "ändring" pins Änderung (change/modification), the noun to ändern', set: { swedish: "ändring" } },
  { rank: 2513, reason: 'Swedish "förvandling" pins Wandel (gradual change/transformation)', set: { swedish: "förvandling" } },
  { rank: 2525, reason: 'Swedish "växling" pins Wechsel (switch/change), the noun to wechseln→växla', set: { swedish: "växling" } },
  { rank: 3169, reason: 'Swedish cognate "omvandla" pins umwandeln (to convert/transform) — um- ~ om-', set: { swedish: "omvandla" } },
  { rank: 3225, reason: 'Swedish "utjämning" pins Ausgleich (balancing/compensation) — steers away from "change"', set: { swedish: "utjämning" } },
  { rank: 3647, reason: 'Swedish cognate "byta" pins tauschen (to exchange/swap)', set: { swedish: "byta" } },
  { rank: 3700, reason: 'Swedish cognate "förvandla" pins wandeln (to change/transform)', set: { swedish: "förvandla" } },

  // The "leave" family — one of the widest collisions. Swedish separates it as cleanly
  // as German does, including the walk-off (gå iväg) vs. drive-off (åka iväg) split that
  // English "leave/go away/depart" blurs. Several are clean prefix calques (über~över,
  // hinter~efter, auf~upp, aus~ut, ab~av).
  { rank: 450, reason: 'Swedish cognate "lämna" pins verlassen (to leave/abandon a place)', set: { swedish: "lämna" } },
  { rank: 1147, reason: 'Swedish "avlägsna" pins entfernen (to remove; reflexive = leave/move away)', set: { swedish: "avlägsna" } },
  { rank: 2291, reason: 'Swedish "efterlämna" pins hinterlassen (to leave behind) — hinter- ~ efter-', set: { swedish: "efterlämna" } },
  { rank: 2419, reason: 'Swedish cognate "överlåta" pins überlassen (to leave/cede to someone) — über+lassen ~ över+låta', set: { swedish: "överlåta" } },
  { rank: 2958, reason: 'Swedish "bryta upp" pins aufbrechen — carries both senses (set off / break open) just like the German', set: { swedish: "bryta upp" } },
  { rank: 3144, reason: 'Swedish "avgå" pins ausscheiden (to leave a post/retire/drop out), vs. austreten→utträda', set: { swedish: "avgå" } },
  { rank: 3655, reason: 'Swedish "gå iväg" pins weggehen (to walk off/leave on foot), vs. losfahren→åka iväg', set: { swedish: "gå iväg" } },
  { rank: 4468, reason: 'Swedish "åka iväg" pins losfahren (to drive off/depart by vehicle)', set: { swedish: "åka iväg" } },
  { rank: 4609, reason: 'Swedish cognate "utträda" pins austreten (to resign/leave an organization) — aus+treten ~ ut+träda', set: { swedish: "utträda" } },
  { rank: 4690, reason: 'Swedish "gå av" pins abgehen (to come off/go off) — ab+gehen ~ av+gå', set: { swedish: "gå av" } },

  // The "get" family — English "get" is the widest net of all. Swedish separates most
  // of it (bli/hämta/skaffa), but bekommen and its colloquial twin kriegen genuinely
  // both = få (register-marked, not sense-marked). beziehen is deliberately pinned to
  // its dominant "refer" sense, not the marginal "get".
  { rank: 8, reason: 'Swedish cognate "bli" pins werden (to become) — the become-sense of "get", vs. bekommen=receive', set: { swedish: "bli" } },
  { rank: 212, reason: 'Swedish "få" pins bekommen (to get/receive) — note: bekommen ≠ become (=werden)', set: { swedish: "få" } },
  { rank: 547, reason: 'Swedish cognate "hämta" pins holen (to fetch/go get)', set: { swedish: "hämta" } },
  { rank: 724, reason: 'Swedish "få (vardagligt)" pins kriegen — the colloquial twin of bekommen, same word in Swedish', set: { swedish: "få (vardagligt)" } },
  { rank: 878, reason: 'Swedish "hänvisa till" pins beziehen via its dominant "sich ~ auf = refer to" sense (the "get" gloss is marginal)', set: { swedish: "hänvisa till (sich ~ auf)" } },
  { rank: 2377, reason: 'Swedish "hämta upp" pins abholen (to pick up/collect), vs. plain holen→hämta', set: { swedish: "hämta upp" } },
  { rank: 3653, reason: 'Swedish "få med sig" pins mitbekommen (to catch/notice/pick up on) — mit+bekommen ~ få med sig', set: { swedish: "få med sig" } },
  { rank: 3839, reason: 'Swedish "skaffa sig" pins zulegen (sich etwas ~ = get/acquire for oneself)', set: { swedish: "skaffa sig" } },
  { rank: 4170, reason: 'Swedish "skaffa" pins besorgen (to get/procure/provide), vs. reflexive zulegen→skaffa sig', set: { swedish: "skaffa" } },

  // The "stop" family — dense with prefix cognates (auf+halten ~ uppe+hålla,
  // ab+brechen ~ av+bryta, ein+stellen ~ ställa in, stoppen ~ stoppa). halten is
  // pinned to its dominant "hold" cognate hålla; einstellen is genuinely many-sensed.
  { rank: 155, reason: 'Swedish "hålla, stanna" pins halten: hålla (hold — dominant sense, e.g. håll boken / hålla ett tal) + stanna (stop, of a vehicle: bussen stannar)', set: { swedish: "hålla, stanna" } },
  { rank: 995, reason: 'Swedish "sluta" pins aufhören (to stop/cease an activity)', set: { swedish: "sluta" } },
  { rank: 1085, reason: 'Swedish calque "ställa in" pins einstellen (adjust/set; also cancel/discontinue) — many-sensed (employ = anställa)', set: { swedish: "ställa in" } },
  { rank: 1620, reason: 'Swedish "stanna" pins anhalten (to come to a stop/halt)', set: { swedish: "stanna" } },
  { rank: 2132, reason: 'Swedish cognate "uppehålla" pins aufhalten (to hold up/delay; sich ~ = stay) — auf+halten ~ uppe+hålla', set: { swedish: "uppehålla" } },
  { rank: 2249, reason: 'Swedish cognate "stoppa" pins stoppen (to stop)', set: { swedish: "stoppa" } },
  { rank: 2562, reason: 'Swedish "hållplats" pins Station in its "stop on a route" sense (vs. abstract stop verbs)', set: { swedish: "hållplats" } },
  { rank: 2823, reason: 'Swedish cognate "avbryta" pins abbrechen (to break off/abort) — ab+brechen ~ av+bryta', set: { swedish: "avbryta" } },
  { rank: 4388, reason: 'Swedish cognate "halt" pins Halt (a stop/halt: göra halt); support-sense = stöd', set: { swedish: "halt, stöd" } },

  // The "produce/make" family — German has a spread of make-verbs and Swedish matches
  // it, each landing on a distinct word (two clean fram- calques: hervorbringen ~
  // frambringa, vorlegen ~ lägga fram). herstellen/erzeugen/fertigen all "manufacture"
  // but split as tillverka/alstra/framställa.
  { rank: 413, reason: 'Swedish "resultera i" pins ergeben (to result in/yield), vs. the actual make-verbs', set: { swedish: "resultera i" } },
  { rank: 1000, reason: 'Swedish cognate "producera" pins produzieren (to produce)', set: { swedish: "producera" } },
  { rank: 1046, reason: 'Swedish "tillverka" pins herstellen (to manufacture/make)', set: { swedish: "tillverka" } },
  { rank: 1330, reason: 'Swedish "alstra" pins erzeugen (to generate — energy/heat: alstra el/värme), vs. herstellen→tillverka', set: { swedish: "alstra" } },
  { rank: 2383, reason: 'Swedish calque "lägga fram" pins vorlegen (to present/submit) — vor+legen ~ fram+lägga', set: { swedish: "lägga fram" } },
  { rank: 2389, reason: 'Swedish "upprätta" pins erstellen (to draw up/create a document: upprätta ett avtal)', set: { swedish: "upprätta" } },
  { rank: 3668, reason: 'Swedish "prestera" pins erbringen (to render/produce: eine Leistung erbringen = prestera)', set: { swedish: "prestera" } },
  { rank: 4562, reason: 'Swedish cognate "frambringa" pins hervorbringen (to bring forth) — hervor+bringen ~ fram+bringa', set: { swedish: "frambringa" } },
  { rank: 4999, reason: 'Swedish "framställa" pins fertigen (to manufacture); cognate förfärdiga (fertigen ~ förfärdiga)', set: { swedish: "framställa" } },

  // The German da(r)- pronominal adverbs (da/dar + preposition = "prep + it/that").
  // Swedish has the exact same construction with där-, so most map 1:1 (damit→därmed,
  // dazu→därtill, dagegen→däremot …) — a strong mnemonic. Three traps flagged inline:
  // dafür is a FALSE FRIEND (Swedish "därför" = therefore, not "for it"); damals is a
  // past-time adverb, not a där-word; and rank-374 damit is the *conjunction* (so that),
  // a homograph of rank-119 damit (with it) — keyed by rank, so both glosses coexist.
  { rank: 119, reason: 'Swedish cognate "därmed" pins damit (with it/thereby) — da+mit = där+med', set: { swedish: "därmed" } },
  { rank: 129, reason: 'Swedish "därvid" pins dabei (thereby/at that); the presence sense "dabei sein" = vara med', set: { swedish: "därvid, med" } },
  { rank: 150, reason: 'Swedish cognate "därtill" pins dazu (in addition/to that) — da+zu = där+till', set: { swedish: "därtill" } },
  { rank: 175, reason: 'FALSE FRIEND: dafür = "for it/in favor" = Swedish "för det", NOT "därför" (which means therefore). The gloss carries the warning so it is learned, not hidden', set: { swedish: "för det (≠ därför)" } },
  { rank: 195, reason: 'Swedish cognate "därpå" pins darauf (on it/thereupon) — da(r)+auf = där+på', set: { swedish: "därpå" } },
  { rank: 214, reason: 'Swedish cognate "därav" pins davon (thereof/from it) — da+von = där+av', set: { swedish: "därav" } },
  { rank: 283, reason: 'Swedish "däröver" (above it) / "därom" (about it) pin darüber — da(r)+über = där+över', set: { swedish: "däröver, därom" } },
  { rank: 286, reason: 'damals = "back then/at that time" (past-time adverb, NOT a där-compound) = Swedish "då, på den tiden"', set: { swedish: "då, på den tiden" } },
  { rank: 292, reason: 'daran (on/at it) has no clean där-form (an → på/vid) = Swedish "på det, vid det", vs. darauf→därpå', set: { swedish: "på det, vid det" } },
  { rank: 354, reason: 'daher = "därför" (therefore — here the där-word IS right, unlike dafür) + "därifrån" (from there)', set: { swedish: "därför, därifrån" } },
  { rank: 360, reason: 'Swedish cognate "däri" (therein) / "därinne" (in there) pin darin — da(r)+in = där+i', set: { swedish: "däri, därinne" } },
  { rank: 374, reason: 'The CONJUNCTION damit (so that/in order that) — homograph of rank-119 damit (with it) — = Swedish "för att, så att"', set: { swedish: "för att, så att" } },
  { rank: 457, reason: 'Swedish cognate "därefter" (thereafter) / "efteråt" (afterwards) pin danach — da+nach = där+efter', set: { swedish: "därefter, efteråt" } },
  { rank: 466, reason: 'Swedish cognate "därigenom" pins dadurch (through it/as a result) — da+durch = där+igenom', set: { swedish: "därigenom" } },
  { rank: 467, reason: 'Swedish cognate "däremot" pins dagegen (against it/on the other hand) — da+gegen = där+emot', set: { swedish: "däremot" } },
  { rank: 518, reason: 'darum = "därför" (therefore) + "runt det" (physically around it) — da+rum = där+om/runt', set: { swedish: "därför, runt det" } },
  { rank: 1026, reason: 'Swedish cognate "därunder" pins darunter (under it/among them) — da(r)+unter = där+under', set: { swedish: "därunder" } },

  // Plural-only nouns (plurale tantum) the source deck left article-less. With a
  // null article checkAnswer treats the card as a non-noun, so the *correct*
  // "die Leute" graded as a plain fail; "die" restores normal noun grading.
  // Deliberately NOT extended to the nominalized adjectives (Beamte, Deutsche,
  // Vorsitzende, …), whose article follows the referent's gender.
  { rank: 224, reason: 'plurale tantum: die Leute (article-less in the source deck)', set: { article: "die" } },
  { rank: 404, reason: 'plurale tantum: die Eltern (article-less in the source deck)', set: { article: "die" } },
  { rank: 564, reason: 'plurale tantum: die Kosten (article-less in the source deck)', set: { article: "die" } },
  { rank: 574, reason: 'plural of das Datum, used as plurale tantum: die Daten', set: { article: "die" } },
  { rank: 951, reason: 'plural of das Medium, used as plurale tantum: die Medien', set: { article: "die" } },
  { rank: 2853, reason: 'plurale tantum: die Schulden (article-less in the source deck)', set: { article: "die" } },
  { rank: 3448, reason: 'plurale tantum: die Ferien (article-less in the source deck)', set: { article: "die" } },
  { rank: 3929, reason: 'plural noun: die Geschwister (article-less in the source deck)', set: { article: "die" } },
  { rank: 4068, reason: 'plural noun: die Taliban (article-less in the source deck)', set: { article: "die" } },
  { rank: 4099, reason: 'plural-only proper noun: die Alpen (article-less in the source deck)', set: { article: "die" } },

  // Ordinary singular nouns the source deck also left article-less — same grading
  // bug as the plurals above, but each takes its own gender.
  { rank: 198, reason: 'der Teil (part of a whole) — article missing in the source deck', set: { article: "der" } },
  { rank: 1117, reason: 'der Grad (degree) — article missing in the source deck', set: { article: "der" } },
  { rank: 2172, reason: 'die E-Mail — article missing in the source deck', set: { article: "die" } },
  { rank: 4516, reason: 'der Laptop — article missing in the source deck', set: { article: "der" } },
];

/**
 * Apply the override table to a parsed corpus. Returns a new array (input rows are
 * never mutated; overridden rows are replaced). Throws on a duplicate rank in the
 * table or on an override whose rank matches no word — both mean the table is
 * stale (e.g. the source deck changed underneath it) and must fail loudly rather
 * than silently skip a fix.
 */
export function applyOverrides(
  words: ParsedWord[],
  overrides: WordOverride[] = WORD_OVERRIDES,
): ParsedWord[] {
  const byRank = new Map<number, WordOverride>();
  for (const o of overrides) {
    if (byRank.has(o.rank)) throw new Error(`duplicate override for rank ${o.rank}`);
    byRank.set(o.rank, o);
  }
  const applied = new Set<number>();
  const out = words.map((w) => {
    const o = w.frequencyRank === null ? undefined : byRank.get(w.frequencyRank);
    if (!o) return w;
    applied.add(o.rank);
    const patch = Object.fromEntries(
      Object.entries(o.set).filter(([, v]) => v !== undefined),
    );
    return { ...w, ...patch };
  });
  for (const o of overrides) {
    if (!applied.has(o.rank)) throw new Error(`override for rank ${o.rank} matched no word`);
  }
  return out;
}

// --- SQL literals + backfill emission -----------------------------------------
// Pure string builders shared by scripts/gen-words.ts (the full corpus INSERT) and
// scripts/apply-overrides.ts (the per-fix backfill UPDATEs). They live here, not in
// the scripts, so the rules are unit-tested.

export function sqlStr(s: string): string {
  return `'${s.replace(/'/g, "''")}'`;
}
export function sqlNullable(s: string | null): string {
  return s === null ? "NULL" : sqlStr(s);
}
export function sqlArray(items: string[]): string {
  return items.length === 0
    ? "ARRAY[]::text[]"
    : `ARRAY[${items.map(sqlStr).join(", ")}]::text[]`;
}

// cards column for each overridable field.
const FIELD_COLUMNS: Record<keyof OverrideFields, string> = {
  prompt: "prompt",
  answer: "answer",
  answerAlts: "answer_alts",
  article: "article",
  partOfSpeech: "part_of_speech",
  notes: "notes",
  swedish: "swedish",
  exampleEn: "example_en",
  exampleDe: "example_de",
};

function sqlValue(v: string | string[] | null): string {
  if (v === null) return "NULL";
  if (Array.isArray(v)) return sqlArray(v);
  return sqlStr(v);
}

/**
 * One idempotent, progress-preserving UPDATE for an override: sets only the fields
 * the override sets, keyed on (deck_id, frequency_rank) — same shape as the
 * hand-written backfills 0011/0012/0014.
 */
export function overrideUpdateSql(o: WordOverride): string {
  const entries = (Object.entries(o.set) as [keyof OverrideFields, string | string[] | null][])
    .filter(([, v]) => v !== undefined);
  if (entries.length === 0) throw new Error(`override for rank ${o.rank} sets no fields`);
  const sets = entries.map(([field, v]) => `"${FIELD_COLUMNS[field]}" = ${sqlValue(v)}`);
  return (
    `-- rank ${o.rank}: ${o.reason}\n` +
    `UPDATE "cards" SET ${sets.join(", ")}\n` +
    `WHERE "deck_id" = '${WORD_DECK_ID}'::uuid AND "frequency_rank" = ${o.rank};\n`
  );
}
