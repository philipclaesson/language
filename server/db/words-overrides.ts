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
      'the "weiter" example used "weitere" (the rank-182 card), never the word itself — replaced with a sentence in the adverbial "onwards" sense (first shipped as 0012); Swedish "vidare" splits it from weitere→ytterligare, the same confusion the example fix was for',
    set: {
      swedish: "vidare",
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

  // The "finally / -schließlich" family — English "finally/exclusive" flattens a
  // distinction Swedish keeps: endlich is the relief "at last", schließlich the
  // "in the end / after all", ausschließlich the "solely".
  { rank: 454, reason: 'endlich = the relief "at last" — Swedish "äntligen" (not the "eventually" of schließlich)', set: { swedish: "äntligen" } },
  { rank: 351, reason: 'schließlich = "eventually / in the end / after all" — Swedish "slutligen, till slut"', set: { swedish: "slutligen, till slut" } },
  { rank: 1485, reason: 'ausschließlich = "solely, exclusively" — Swedish cognate "uteslutande" (aus-schließen → ute-sluta)', set: { swedish: "uteslutande" } },
  { rank: 661, reason: 'wesentlich (essential, substantial) — clean Swedish cognate "väsentlig", senses line up', set: { swedish: "väsentlig" } },
  { rank: 416, reason: 'betreffen (to concern/affect) — modern everyday "angå" (det angår mig), not the stilted cognate "beträffa" (only alive in "vad beträffar")', set: { swedish: "angå" } },

  // außerdem / zudem — synonyms in both languages (both ≈ dessutom); split by
  // register to give each a distinct anchor: außerdem everyday, zudem more formal.
  { rank: 424, reason: 'außerdem (besides, in addition) — everyday Swedish "dessutom" (des-utom ≈ außer-dem)', set: { swedish: "dessutom" } },
  { rank: 542, reason: 'zudem (moreover, furthermore) — more formal register, Swedish "därtill"', set: { swedish: "därtill" } },

  // Beziehung / Verhältnis — English flattens both to "relation(ship)"; the cognate
  // splits them: Verhältnis → förhållande (also ratio/proportion, circumstances),
  // Beziehung → relation (personal relations, connections).
  { rank: 649, reason: 'Beziehung (relation, connection) — Swedish "relation"', set: { swedish: "relation" } },
  { rank: 668, reason: 'Verhältnis (relationship; also ratio/proportion) — cognate "förhållande" (ver-hält-nis ≈ för-håll-ande)', set: { swedish: "förhållande" } },
  { rank: 912, reason: 'Bindung (emotional bond/attachment) — everyday "anknytning, band"; avoid the cognate "bindning" (technical: chemical/ski/book binding)', set: { swedish: "anknytning, band" } },
  { rank: 3577, reason: 'Relation (formal: proportion, ratio) — Swedish "proportion, samband", kept distinct from Beziehung → relation', set: { swedish: "proportion, samband" } },

  // Lage / Situation — English "situation" collides; the Germanic Lage → läge
  // (position/location) vs the loanword Situation → situation.
  { rank: 555, reason: 'Lage (situation, location, position) — cognate "läge"', set: { swedish: "läge" } },
  { rank: 423, reason: 'Situation — the loanword, identical Swedish "situation"; glossed to complete the Lage/Situation split', set: { swedish: "situation" } },

  // The "to exist" family — cognates split it: existieren the loanword, bestehen the
  // consist/persist/pass verb, vorliegen the "be at hand/present" verb.
  { rank: 1061, reason: 'existieren (to exist) — loanword "existera"', set: { swedish: "existera" } },
  { rank: 246, reason: 'bestehen — cognate "bestå" covers consist of / persist / pass (an exam); the "insist" sense (bestehen auf) is separate (insistera på)', set: { swedish: "bestå" } },
  { rank: 647, reason: 'vorliegen (to be at hand/present, exist) — cognate "föreligga" (vor-liegen ≈ före-ligga); formal but current, everyday alt "finnas"', set: { swedish: "föreligga" } },

  // The "just / now" family — modal particles + "now" adverbs. Swedish splits the
  // particles (eben/halt) and nunmehr → numera, but jetzt/nun are genuine synonyms
  // both landing on "nu".
  { rank: 196, reason: 'eben — temporal "just now" (han gick nyss) + the "exactly" sense; Swedish "nyss, just"', set: { swedish: "nyss, just" } },
  { rank: 478, reason: 'halt — modal particle "simply / that\'s just how it is" (det är helt enkelt så); Swedish "helt enkelt"', set: { swedish: "helt enkelt" } },
  { rank: 114, reason: 'nun (now; discourse "well then") — Swedish "nu, nå"', set: { swedish: "nu, nå" } },
  { rank: 72, reason: 'jetzt — the plain concrete "now", Swedish "nu"', set: { swedish: "nu" } },
  { rank: 4228, reason: 'nunmehr (now, by now, henceforth) — cognate "numera" (nun-mehr ≈ nu-mera)', set: { swedish: "numera" } },
  { rank: 672, reason: 'beispielsweise (for example) — clean structural match "exempelvis" (Beispiel-s-weise ≈ exempel-vis)', set: { swedish: "exempelvis" } },
  { rank: 258, reason: 'entsprechen (to correspond to, match) — Swedish "motsvara" (etwas entspricht ≈ motsvara något)', set: { swedish: "motsvara" } },

  // The "look" family — English "look" flattens perception, search, and care-for.
  // aussehen (se ut) already glossed. Perception verbs split by register (neutral
  // titta/betrakta vs colloquial kolla/kika); ansehen/anschauen stay synonyms.
  { rank: 510, reason: 'schauen (to look) — general everyday "titta"', set: { swedish: "titta" } },
  { rank: 507, reason: 'ansehen (to look at, watch) — "titta på, se på" (≈ anschauen, genuine synonym)', set: { swedish: "titta på, se på" } },
  { rank: 949, reason: 'anschauen (to look at, watch) — South-German ≈ ansehen; "titta på"', set: { swedish: "titta på" } },
  { rank: 485, reason: 'betrachten (to look at, consider) — cognate "betrakta" (the considered regard/contemplate)', set: { swedish: "betrakta" } },
  { rank: 1256, reason: 'blicken (to look, glance) — cognate "blicka"', set: { swedish: "blicka" } },
  { rank: 306, reason: 'Blick (noun: look, glance, gaze) — Swedish "blick"', set: { swedish: "blick" } },
  { rank: 1362, reason: 'gucken (to look) — colloquial "kika, kolla"', set: { swedish: "kika, kolla" } },
  { rank: 3078, reason: 'angucken (to look at) — colloquial "kolla på, kika på"', set: { swedish: "kolla på, kika på" } },
  { rank: 293, reason: 'suchen (to search, look for) — "söka, leta"', set: { swedish: "söka, leta" } },
  { rank: 1944, reason: 'versorgen (to supply, provide, look after) — cognate "försörja" (ver-sorgen ≈ för-sörja) + "ta hand om"', set: { swedish: "försörja, ta hand om" } },
  { rank: 3123, reason: 'betreuen (to look after, take care, supervise) — "ta hand om, sköta"', set: { swedish: "ta hand om, sköta" } },
  { rank: 1540, reason: 'vorsehen (to plan, earmark, provide for; sich vorsehen = watch out) — "planera, avse; akta sig"', set: { swedish: "planera, avse; akta sig" } },
  { rank: 270, reason: 'besonders (adverb: particularly, especially) — "särskilt"', set: { swedish: "särskilt" } },
  { rank: 512, reason: 'besondere (adjective: special) — "särskild"', set: { swedish: "särskild" } },
  { rank: 655, reason: 'insbesondere (in particular, especially) — "i synnerhet" (keeps it distinct from besonders = särskilt)', set: { swedish: "i synnerhet" } },
  {
    rank: 115,
    reason:
      'sondern is the not-X-but-Y "but" (Swedish "utan"); the old example glossed an aber-style clause contrast ("...but his sister does") and had awkward German word order — replaced with a proper not-X-but-Y pair, plus the Swedish gloss',
    set: {
      swedish: "utan",
      exampleEn: "It's not him but his sister who likes soccer.",
      exampleDe: "Nicht er, sondern seine Schwester mag Fußball.",
    },
  },
  // The "however / but" contrast cluster: English flattens these onto one or two
  // words, Swedish keeps them apart by register and position.
  { rank: 73, reason: 'Swedish cognate "dock" pins doch (however/but) — literally the same word; leaves "men" to aber', set: { swedish: "dock" } },
  { rank: 227, reason: 'Swedish "emellertid" pins jedoch (however) in the same written register, keeping it distinct from doch→dock', set: { swedish: "emellertid" } },
  { rank: 31, reason: 'Swedish "men" pins aber as the default "but" — the anchor that makes doch→dock informative, since English calls both "but"', set: { swedish: "men" } },
  { rank: 206, reason: 'zwar has two uses and the prompt names both: zwar…aber = "visserligen", und zwar = "närmare bestämt" (the sense the example tests)', set: { swedish: "visserligen / närmare bestämt" } },
  { rank: 225, reason: 'Swedish "minsann" carries the emphatic, I-grant-you-that sense of allerdings that the example tests (Das ist allerdings… = Det är minsann…)', set: { swedish: "minsann, verkligen" } },
  { rank: 390, reason: 'Swedish "fastän" pins obwohl — same subordinating conjunction; the full form over bare "fast" keeps it unmistakably the conjunction', set: { swedish: "fastän" } },
  { rank: 717, reason: 'Swedish "ändå" pins dennoch (nevertheless) and leaves "trots det" to trotzdem (463), the card it would otherwise be confused with', set: { swedish: "ändå" } },
  { rank: 1016, reason: 'Swedish "å andra sidan" pins hingegen; the literal match "däremot" is already on dagegen (467), so this keeps the two apart', set: { swedish: "å andra sidan" } },
  // The "further / additional" family — weiter vs. weitere is the confusion the
  // rank-221 example fix (0012) was already about; Swedish splits them outright.
  { rank: 182, reason: 'Swedish "ytterligare" pins weitere (additional/further, attributive) — Weitere Informationen = Ytterligare information; weiter (221) takes "vidare"', set: { swedish: "ytterligare" } },
  { rank: 583, reason: 'Swedish "extra, kompletterande" pins zusätzlich (additional), keeping it distinct from weitere→ytterligare', set: { swedish: "extra, kompletterande" } },
  { rank: 827, reason: 'Swedish "vidare, fortfarande" pins weiterhin — both its senses (going forward / still), matching its example "Es gibt weiterhin Probleme" = "Det finns fortfarande problem"', set: { swedish: "vidare, fortfarande" } },
  // "At least": English says it for both the numerical floor and the concessive,
  // Swedish does not — minst counts, åtminstone concedes.
  { rank: 604, reason: 'Swedish cognate "minst" pins mindestens as the numerical floor (mindestens acht Stunden = minst åtta timmar), vs. zumindest→åtminstone', set: { swedish: "minst" } },
  { rank: 612, reason: 'Swedish "åtminstone" pins zumindest as the concessive "at least" (aber zumindest habe ich es versucht), vs. mindestens→minst', set: { swedish: "åtminstone" } },
  { rank: 1138, reason: 'Swedish "i alla fall" pins wenigstens (at least, if nothing else), keeping "åtminstone" on zumindest', set: { swedish: "i alla fall" } },
  { rank: 2362, reason: 'Swedish cognate "högst" pins höchstens (at most) — the mirror of mindestens→minst', set: { swedish: "högst" } },

  // "At the moment / current": derzeit vs. derzeitig is adverb vs. adjective, and
  // Swedish mirrors the split exactly (för närvarande / nuvarande).
  { rank: 676, reason: 'Swedish "för närvarande" pins derzeit (adverb: at the moment), mirroring derzeitig→nuvarande', set: { swedish: "för närvarande" } },
  { rank: 4459, reason: 'Swedish "nuvarande" pins derzeitig (adjective: current) — die derzeitige Situation = den nuvarande situationen', set: { swedish: "nuvarande" } },
  { rank: 3014, reason: 'Swedish "just nu" pins zurzeit as the everyday "at the moment", distinct from derzeit→för närvarande', set: { swedish: "just nu" } },
  { rank: 2661, reason: 'Swedish "för tillfället" pins momentan (at the moment), distinct from derzeit and zurzeit', set: { swedish: "för tillfället" } },
  { rank: 2378, reason: 'Swedish "rådande" pins gegenwärtig (present/current) — die gegenwärtige politische Lage = den rådande politiska situationen; keeps "nuvarande" on derzeitig', set: { swedish: "rådande" } },

  // "In the meantime": three near-twins, split by what each actually stresses.
  { rank: 534, reason: 'inzwischen carries both senses and its prompt is "in the meantime", so the gloss leads with "under tiden" and keeps "numera" for the by-now use its example shows', set: { swedish: "under tiden, numera" } },
  { rank: 862, reason: 'Swedish "vid det här laget" pins mittlerweile as the by-this-point sense (Mittlerweile haben alle Dörfer Internet)', set: { swedish: "vid det här laget" } },
  { rank: 4617, reason: 'Swedish "samtidigt" pins unterdessen as pure simultaneity (ich koche unterdessen das Abendessen), leaving "under tiden" to inzwischen', set: { swedish: "samtidigt" } },

  { rank: 3162, reason: 'Swedish "när som helst" pins jederzeit (anytime) exactly', set: { swedish: "när som helst" } },
  // The ziehen family. German and Swedish both build these from one root
  // (ziehen = dra) where English reaches for unrelated Latin words — vorziehen is
  // före-dra, not "prefer"; abziehen is dra av, not "subtract". Glossing the family
  // together is what makes that visible. (beziehen, rank 878, was glossed earlier.)
  { rank: 193, reason: 'Swedish cognate "dra" pins ziehen — the root that makes the whole compound family legible', set: { swedish: "dra" } },
  { rank: 4348, reason: 'Swedish "föredra" is vorziehen morpheme-for-morpheme (vor+ziehen = före+dra), which English "prefer" hides completely', set: { swedish: "föredra" } },
  { rank: 3796, reason: 'Swedish "dra av" is abziehen morpheme-for-morpheme (ab = av); the example is the subtract sense', set: { swedish: "dra av" } },
  { rank: 2111, reason: 'Swedish "dra sig tillbaka" is zurückziehen morpheme-for-morpheme (zurück = tillbaka), reflexive like the example', set: { swedish: "dra sig tillbaka" } },
  { rank: 1436, reason: 'anziehen spans attract and put-on, so the gloss carries both: "dra till sig" (the example) and "ta på sig"', set: { swedish: "dra till sig; ta på sig" } },
  { rank: 3870, reason: 'überziehen spans put-on (its example) and the banking overdraw, so the gloss carries both Swedish words', set: { swedish: "dra på sig; övertrassera" } },
  { rank: 4854, reason: 'aufziehen spans rear (its example) and wind-up; "uppfostra; dra upp" carries both, with auf = upp visible in the second', set: { swedish: "uppfostra; dra upp" } },
  { rank: 2973, reason: 'Swedish "dra ut ur, frånta" pins entziehen — Salz entzieht dem Körper Wasser = saltet drar ut vatten ur kroppen', set: { swedish: "dra ut ur, frånta" } },

  // Same family, but Swedish drops the dra- root — worth glossing precisely
  // because they break the pattern the ones above establish.
  { rank: 2434, reason: 'ausziehen spans move-out (its example) and take-off-clothes; Swedish uses neither dra- compound, hence "flytta ut; ta av sig"', set: { swedish: "flytta ut; ta av sig" } },
  { rank: 2665, reason: 'Swedish "flytta in" pins einziehen (to move in) — no dra- compound, unlike most of the family', set: { swedish: "flytta in" } },
  { rank: 3190, reason: 'Swedish "involvera, räkna in" pins einbeziehen (to include/involve), matching its example about involving the children', set: { swedish: "involvera, räkna in" } },
  { rank: 3968, reason: 'Swedish "förstå, sätta sig in i" pins nachvollziehen (to understand/relate to) — the empathetic understanding its example shows', set: { swedish: "förstå, sätta sig in i" } },
  { rank: 3782, reason: 'Swedish "anlita, ta hjälp av" pins heranziehen in the consult-a-source sense its example uses', set: { swedish: "anlita, ta hjälp av" } },
  { rank: 4119, reason: 'Swedish "förvrida (munnen)" pins verziehen (to distort/twist), matching its pucker-the-mouth example', set: { swedish: "förvrida (munnen)" } },
  { rank: 3975, reason: 'Swedish "fullfölja" pins durchziehen (see it through); the obvious "genomföra" is avoided because erfolgen (648) already holds "genomföras"', set: { swedish: "fullfölja" } },
  { rank: 3436, reason: 'vollziehen spans transitive carry-out and reflexive take-place (its example is the latter), so the gloss carries both; "äga rum" was unavailable — it is on stattfinden (652)', set: { swedish: "verkställa; (sich ~) ske" } },

  { rank: 561, reason: 'Swedish "röra (sig)" pins bewegen as moving oneself, reflexive like its example — distinct from ziehen→dra', set: { swedish: "röra (sig)" } },
  // Place and direction. Swedish keeps the location/motion split German makes
  // (där/dit = da/dahin) and English lost — every one of these is just "there".
  // Grid: da→där, dort→där borta (location) | dahin→dit, dorthin→dit bort (motion).
  { rank: 48, reason: 'Swedish "där" pins da as the neutral location "there", the anchor of the där/dit grid', set: { swedish: "där" } },
  { rank: 139, reason: 'Swedish "där borta" pins dort as the distal location "there" — its own example is "dort drüben"', set: { swedish: "där borta" } },
  { rank: 1520, reason: 'Swedish "dit" pins dahin as motion-toward-there; dit vs. där is exactly dahin vs. da, a split English cannot express', set: { swedish: "dit" } },
  { rank: 2599, reason: 'Swedish "dit bort" pins dorthin as distal motion-toward, completing the där/där borta/dit/dit bort grid', set: { swedish: "dit bort" } },
  { rank: 712, reason: 'Swedish "dit, bort" pins hin as the direction-away marker the whole -hin column is built from', set: { swedish: "dit, bort" } },
  { rank: 2457, reason: 'Swedish "gå dit" is hingehen morpheme-for-morpheme (hin+gehen = dit+gå)', set: { swedish: "gå dit" } },
  { rank: 4881, reason: 'Swedish "åka dit" is hinfahren morpheme-for-morpheme, same construction as hingehen→gå dit', set: { swedish: "åka dit" } },
  { rank: 2792, reason: 'dastehen spans literal standing-there and the figurative be-in-a-position its example uses (steht gut da = står sig bra), so the gloss carries both', set: { swedish: "stå där; stå sig" } },
  { rank: 2938, reason: 'Swedish "på andra sidan" pins drüben as the other-side word it literally is; "där borta" is spent on dort (139)', set: { swedish: "på andra sidan" } },
  { rank: 417, reason: 'Swedish "uppe, ovanpå" pins oben as the static "up there" — uppe/upp mirrors the same location/motion split as där/dit', set: { swedish: "uppe, ovanpå" } },

  // "Therefore" ×5. deshalb and deswegen are genuinely interchangeable in German,
  // so both lead with "därför" rather than inventing a distinction; the rest differ
  // by what they actually stress.
  { rank: 229, reason: 'Swedish "därför" pins deshalb as the plain default "therefore"', set: { swedish: "därför" } },
  { rank: 749, reason: 'deswegen is interchangeable with deshalb, so it also leads with "därför"; the parenthetical exposes wegen = orsak to tell the two cards apart', set: { swedish: "därför (av den orsaken)" } },
  { rank: 792, reason: 'Swedish "alltså, därmed" pins somit (consequently/thus), leading with alltså to keep it off damit→därmed (119)', set: { swedish: "alltså, därmed" } },
  { rank: 1227, reason: 'Swedish "följaktligen" pins demnach as the inferential "therefore" (Es gibt demnach nur zwei Möglichkeiten)', set: { swedish: "följaktligen" } },
  { rank: 1815, reason: 'Swedish "såtillvida, i den mån" pins insofern as "to that extent", its actual meaning behind the English "therefore"', set: { swedish: "såtillvida, i den mån" } },
  // The dienen family: German prefixes map onto Swedish prefixes one-for-one
  // (dienen/verdienen/bedienen = tjäna/förtjäna/betjäna). Two of the three cards
  // drill a sense the bare cognate no longer covers in modern Swedish, so those
  // glosses keep the cognate first and add the half the example actually tests.
  { rank: 684, reason: 'Swedish cognate "tjäna" pins dienen (to serve) — the root of the tjäna/förtjäna/betjäna set', set: { swedish: "tjäna" } },
  { rank: 835, reason: 'verdienen = förtjäna by prefix, but its example is earning money and Swedish says "tjäna pengar" (förtjäna has drifted to "deserve"), so the gloss carries both', set: { swedish: "förtjäna; tjäna (pengar)" } },
  { rank: 2179, reason: 'bedienen = betjäna by prefix, but its example is operating a machine and "betjäna en maskin" is not idiomatic Swedish — hence "sköta (maskin)" alongside', set: { swedish: "betjäna; sköta (maskin)" } },
  { rank: 1558, reason: 'Swedish cognate "tjänst" pins der Dienst (service/duty), the noun side of dienen→tjäna', set: { swedish: "tjänst" } },
  { rank: 2305, reason: 'Swedish "tjänst, service" pins die Dienstleistung (a service, commercial sense)', set: { swedish: "tjänst, service" } },
  { rank: 4476, reason: 'Swedish cognate "tjänare" pins der Diener (servant), completing the dien-/tjän- root family', set: { swedish: "tjänare" } },
  // The sehen/schauen "watch" family. The -sehen member takes "se på", the
  // -schauen member "titta på", following the ansehen (507) / anschauen (949)
  // precedent already in the table.
  { rank: 79, reason: 'Swedish cognate "se" pins sehen — the root of the whole ansehen/zusehen/Zuschauer family', set: { swedish: "se" } },
  { rank: 348, reason: 'Swedish "klocka" covers all three senses of die Uhr at once (clock, wristwatch, klockan 3 = um 3 Uhr) exactly as German does; only English needs three words', set: { swedish: "klocka" } },
  { rank: 4180, reason: 'Swedish "övervaka" is überwachen morpheme-for-morpheme (über+wachen = över+vaka) and is the live surveillance word its example uses', set: { swedish: "övervaka" } },
  { rank: 697, reason: 'Swedish "iaktta, observera" pins beobachten — beobachtet seine Kinder = iakttar sina barn', set: { swedish: "iaktta, observera" } },
  { rank: 2182, reason: 'what separates zusehen from ansehen is grammar, not the Swedish verb: dative + an activity, so the gloss spells out "se på (ngn göra ngt)"', set: { swedish: "se på (ngn göra ngt)" } },
  { rank: 3239, reason: 'zuschauen is the -schauen twin of zusehen, so it takes "titta på" like anschauen does, with the same dative-activity note', set: { swedish: "titta på (ngn göra ngt)" } },
  { rank: 1410, reason: 'Swedish "åskådare" pins der Zuschauer (spectator), the noun to zuschauen', set: { swedish: "åskådare" } },
  // The zusammen- family. German zusammen- maps to Swedish samman-/sam- in the
  // nouns and the abstract verbs, but everyday Swedish switches to "ihop" for the
  // physical ones (hålla ihop, sätta ihop) — zusammensetzen/Zusammensetzung shows
  // both halves on a single root.
  { rank: 533, reason: 'Swedish "tillsammans" pins zusammen (together), the root of the whole samman-/ihop family', set: { swedish: "tillsammans" } },
  { rank: 525, reason: 'Swedish cognate "sammanhang" pins der Zusammenhang and covers both its senses (connection and context) exactly as the German does', set: { swedish: "sammanhang" } },
  { rank: 1312, reason: 'Swedish cognate "samarbete" pins die Zusammenarbeit (cooperation)', set: { swedish: "samarbete" } },
  { rank: 2747, reason: 'Swedish cognate "samarbeta" pins zusammenarbeiten, the verb to Zusammenarbeit→samarbete', set: { swedish: "samarbeta" } },
  { rank: 1858, reason: 'Swedish "sammanfatta" is zusammenfassen morpheme-for-morpheme (zusammen+fassen = samman+fatta)', set: { swedish: "sammanfatta" } },
  { rank: 3001, reason: 'Swedish cognate "sammanfattning" pins die Zusammenfassung, the noun to zusammenfassen→sammanfatta', set: { swedish: "sammanfattning" } },
  { rank: 3110, reason: 'Swedish cognate "sammansättning" pins die Zusammensetzung — the noun keeps samman- where the verb (2881) goes to "sätta ihop"', set: { swedish: "sammansättning" } },
  { rank: 4956, reason: 'Swedish everyday "hålla ihop" pins zusammenhalten (the cognate "sammanhålla" is stiff), matching its stick-together-as-siblings example', set: { swedish: "hålla ihop" } },
  { rank: 2710, reason: 'Swedish everyday "hänga ihop (med)" pins zusammenhängen; "sammanhänga" exists but is not said', set: { swedish: "hänga ihop (med)" } },
  { rank: 2881, reason: 'Swedish "sätta ihop" pins zusammensetzen — the physical verb takes ihop even though its noun stays sammansättning (3110)', set: { swedish: "sätta ihop" } },
  { rank: 3633, reason: 'Swedish "samlas, träffas" pins zusammenkommen (to come together), matching its whole-family-at-Christmas example', set: { swedish: "samlas, träffas" } },
  { rank: 3648, reason: 'Swedish "leva tillsammans" pins zusammenleben, built straight off zusammen→tillsammans', set: { swedish: "leva tillsammans" } },
  { rank: 4730, reason: 'zusammenbrechen leads with "bryta samman" to keep the samman- pattern visible, plus "rasa" for the collapsing-bridge sense its example uses', set: { swedish: "bryta samman, rasa" } },
  // The -einander family. einander = varandra, and the preposition simply rides in
  // front in both languages (mit→med, von→av, zu→till, auf→på, neben→bredvid), so
  // one rule unlocks six cards. English hides it by flattening all of them to
  // "each other". The last four break the pattern, which is why they need glossing.
  { rank: 1821, reason: 'Swedish "varandra" pins einander — the root that makes every PREP+einander card readable', set: { swedish: "varandra" } },
  { rank: 716, reason: 'miteinander = med varandra, the preposition riding in front exactly as in German', set: { swedish: "med varandra" } },
  { rank: 1883, reason: 'voneinander = av varandra (viel voneinander lernen = lära sig mycket av varandra)', set: { swedish: "av varandra" } },
  { rank: 4085, reason: 'zueinander = till varandra (müssen zueinander passen = måste passa till varandra)', set: { swedish: "till varandra" } },
  { rank: 3269, reason: 'aufeinander = på varandra (leg die Bücher aufeinander = lägg böckerna på varandra)', set: { swedish: "på varandra" } },
  { rank: 4440, reason: 'nebeneinander = bredvid varandra, morpheme-for-morpheme (neben = bredvid)', set: { swedish: "bredvid varandra" } },
  { rank: 3295, reason: 'untereinander breaks the pattern: Swedish has the dedicated "sinsemellan", not "under varandra"', set: { swedish: "sinsemellan" } },
  { rank: 1755, reason: 'gegenseitig is the adjective, not a varandra phrase — Swedish "ömsesidig" matches its register', set: { swedish: "ömsesidig" } },
  { rank: 1841, reason: 'die Auseinandersetzung is aus-einander-setzen literally but means a quarrel; Swedish "gräl, dispyt" says so', set: { swedish: "gräl, dispyt" } },
  { rank: 3841, reason: 'Swedish "ta itu med, bearbeta" pins auseinandersetzen (to deal with), matching its therapy example; "sätta sig in i" is spent on nachvollziehen (3968)', set: { swedish: "ta itu med, bearbeta" } },
  // Exact morpheme cognates, each glossed together with the corpus card English
  // flattens onto the same word — so the pair teaches a distinction, not just a
  // translation (Zustand/Bedingung both "condition"; Vorlesung/Vortrag both "lecture").
  { rank: 736, reason: 'Swedish "tillstånd" is der Zustand morpheme-for-morpheme (zu+stand = till+stånd) — how something IS, vs. Bedingung→villkor', set: { swedish: "tillstånd" } },
  { rank: 673, reason: 'Swedish "villkor" pins die Bedingung as what is REQUIRED; English calls both this and Zustand a "condition", Swedish does not', set: { swedish: "villkor" } },
  { rank: 703, reason: 'Swedish "föreläsning" is die Vorlesung morpheme-for-morpheme (vor+lesung = före+läsning)', set: { swedish: "föreläsning" } },
  { rank: 2879, reason: 'Swedish "föredrag" is der Vortrag morpheme-for-morpheme (vor+trag = före+drag); English calls both this and Vorlesung a "lecture"', set: { swedish: "föredrag" } },
  { rank: 3690, reason: 'vorlesen is a false friend: Swedish "föreläsa" means to lecture, not to read aloud — hence "läsa högt (för)"', set: { swedish: "läsa högt (för)" } },
  { rank: 756, reason: 'Swedish "överallt" is überall morpheme-for-morpheme (über+all = över+allt)', set: { swedish: "överallt" } },
  { rank: 935, reason: 'Swedish "någonstans" pins irgendwo (somewhere), completing the överallt/någonstans/ingenstans row', set: { swedish: "någonstans" } },
  { rank: 3806, reason: 'Swedish "ingenstans" pins nirgendwo (nowhere); nirgends (4577) is a true synonym and is left unglossed rather than duplicated', set: { swedish: "ingenstans" } },
  { rank: 1823, reason: 'Swedish "undervisning" pins der Unterricht (instruction/classes)', set: { swedish: "undervisning" } },
  { rank: 2678, reason: 'Swedish "författning, grundlag" pins die Verfassung — ver+fassung = för+fattning, the same fassen/fatta root as zusammenfassen→sammanfatta', set: { swedish: "författning, grundlag" } },
  // The irgend- family. German marks indefiniteness twice (irgend- + the w-word)
  // where Swedish marks it once, so there is no morpheme mapping here — but the
  // family splits cleanly by word class: the ADVERBS are merely vague (någon-),
  // while the PRONOUNS carry the "at all" reading (alls / som helst). Compare
  // irgendwann→någon gång with jederzeit→när som helst (3162): English calls both
  // "sometime/anytime" and cannot tell them apart.
  { rank: 626, reason: 'irgendwie is the vague adverb: "på något sätt" (wie → sätt), no "alls" reading', set: { swedish: "på något sätt" } },
  { rank: 764, reason: 'irgendwann is vague "någon gång" (wann → gång), vs. the free-choice jederzeit→när som helst (3162)', set: { swedish: "någon gång" } },
  { rank: 1120, reason: 'irgendetwas is the pronoun, so it carries the at-all reading: Hast du irgendetwas gesagt? = Sa du någonting alls?', set: { swedish: "någonting alls" } },
  { rank: 1118, reason: 'irgendein carries the at-all/free-choice reading (irgendeinen Rat = något råd alls); "vilken" mirrors the determiner', set: { swedish: "något alls, vilken som helst" } },
  { rank: 1911, reason: 'irgendwelche is the plural of irgendein and Swedish pluralises identically (vilken → vilka)', set: { swedish: "några alls, vilka som helst" } },
  { rank: 4941, reason: 'irgendjemand takes "vem som helst" where irgendein takes "vilken som helst" — vem/vilken mirrors jemand/ein exactly', set: { swedish: "någon alls, vem som helst" } },
  { rank: 3619, reason: 'bare irgend is the fixed "irgend so ein" construction, not the productive prefix, so "någon sorts" is a rough fit rather than a clean one', set: { swedish: "någon sorts" } },

  // The plain indefinites the irgend- cards are built on — glossing irgendjemand
  // as "någon alls" only means something once jemand is pinned to "någon".
  { rank: 32, reason: 'Swedish "man" is the same word doing the same job as German man; English needs one/you/they for it', set: { swedish: "man" } },
  { rank: 87, reason: 'Swedish "varje" pins jede (every)', set: { swedish: "varje" } },
  { rank: 100, reason: 'etwas spans the pronoun and the adverbial "a little" its example tests (macht die Welt etwas besser = lite bättre), so the gloss carries both', set: { swedish: "något; lite (bättre)" } },
  { rank: 109, reason: 'Swedish "ingenting" pins nichts (nothing), the negative counterpart to etwas→något', set: { swedish: "ingenting" } },
  { rank: 174, reason: 'Swedish "några" pins einige (a few/some)', set: { swedish: "några" } },
  { rank: 330, reason: 'Swedish "någon" pins jemand (someone) — the plain form that makes irgendjemand→någon alls readable', set: { swedish: "någon" } },
  { rank: 362, reason: 'Swedish "ingen" pins niemand (nobody), the negative counterpart to jemand→någon', set: { swedish: "ingen" } },
  { rank: 433, reason: 'Swedish "somliga, vissa" pins manche (some people/many a), distinct from einige→några', set: { swedish: "somliga, vissa" } },
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
