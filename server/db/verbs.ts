// The global verb catalog (VERBS.md). Source of truth for the shared `verbs`
// table: authored here as readable TypeScript, seeded to both DB branches via a
// data migration (drizzle/), and re-seedable locally with `npm run db:seed:verbs`.
//
// Ordered by rough frequency (index + 1 = frequency_rank, the order new verbs are
// introduced). `regularity` reflects the PRESENT TENSE: 'irregular' = the present
// forms deviate from the regular pattern (modals, sein/haben/werden, stem-changers
// like e→i/ie and a→ä, wissen, nehmen); 'regular' = the standard endings apply
// (including strong verbs whose present is regular, e.g. kommen, gehen, singen).
// The tag is shown while drilling and drives the 3-irregular : 2-regular daily mix.

import { db } from "./client";
import { verbs } from "./schema";

export type VerbSeed = {
  infinitive: string;
  english: string;
  regularity: "regular" | "irregular";
  // Present tense. er = er/sie/es; sie = sie/Sie (plural + formal).
  ich: string;
  du: string;
  er: string;
  wir: string;
  ihr: string;
  sie: string;
};

// prettier-ignore
export const VERBS: VerbSeed[] = [
  { infinitive: "sein", english: "to be", regularity: "irregular", ich: "bin", du: "bist", er: "ist", wir: "sind", ihr: "seid", sie: "sind" },
  { infinitive: "haben", english: "to have", regularity: "irregular", ich: "habe", du: "hast", er: "hat", wir: "haben", ihr: "habt", sie: "haben" },
  { infinitive: "werden", english: "to become", regularity: "irregular", ich: "werde", du: "wirst", er: "wird", wir: "werden", ihr: "werdet", sie: "werden" },
  { infinitive: "können", english: "to be able to (can)", regularity: "irregular", ich: "kann", du: "kannst", er: "kann", wir: "können", ihr: "könnt", sie: "können" },
  { infinitive: "müssen", english: "to have to (must)", regularity: "irregular", ich: "muss", du: "musst", er: "muss", wir: "müssen", ihr: "müsst", sie: "müssen" },
  { infinitive: "sagen", english: "to say", regularity: "regular", ich: "sage", du: "sagst", er: "sagt", wir: "sagen", ihr: "sagt", sie: "sagen" },
  { infinitive: "machen", english: "to make / do", regularity: "regular", ich: "mache", du: "machst", er: "macht", wir: "machen", ihr: "macht", sie: "machen" },
  { infinitive: "geben", english: "to give", regularity: "irregular", ich: "gebe", du: "gibst", er: "gibt", wir: "geben", ihr: "gebt", sie: "geben" },
  { infinitive: "kommen", english: "to come", regularity: "regular", ich: "komme", du: "kommst", er: "kommt", wir: "kommen", ihr: "kommt", sie: "kommen" },
  { infinitive: "sollen", english: "should / ought to", regularity: "irregular", ich: "soll", du: "sollst", er: "soll", wir: "sollen", ihr: "sollt", sie: "sollen" },
  { infinitive: "wollen", english: "to want", regularity: "irregular", ich: "will", du: "willst", er: "will", wir: "wollen", ihr: "wollt", sie: "wollen" },
  { infinitive: "gehen", english: "to go", regularity: "regular", ich: "gehe", du: "gehst", er: "geht", wir: "gehen", ihr: "geht", sie: "gehen" },
  { infinitive: "wissen", english: "to know (a fact)", regularity: "irregular", ich: "weiß", du: "weißt", er: "weiß", wir: "wissen", ihr: "wisst", sie: "wissen" },
  { infinitive: "sehen", english: "to see", regularity: "irregular", ich: "sehe", du: "siehst", er: "sieht", wir: "sehen", ihr: "seht", sie: "sehen" },
  { infinitive: "lassen", english: "to let / leave", regularity: "irregular", ich: "lasse", du: "lässt", er: "lässt", wir: "lassen", ihr: "lasst", sie: "lassen" },
  { infinitive: "stehen", english: "to stand", regularity: "regular", ich: "stehe", du: "stehst", er: "steht", wir: "stehen", ihr: "steht", sie: "stehen" },
  { infinitive: "finden", english: "to find", regularity: "regular", ich: "finde", du: "findest", er: "findet", wir: "finden", ihr: "findet", sie: "finden" },
  { infinitive: "bleiben", english: "to stay", regularity: "regular", ich: "bleibe", du: "bleibst", er: "bleibt", wir: "bleiben", ihr: "bleibt", sie: "bleiben" },
  { infinitive: "liegen", english: "to lie (be located)", regularity: "regular", ich: "liege", du: "liegst", er: "liegt", wir: "liegen", ihr: "liegt", sie: "liegen" },
  { infinitive: "heißen", english: "to be called", regularity: "regular", ich: "heiße", du: "heißt", er: "heißt", wir: "heißen", ihr: "heißt", sie: "heißen" },
  { infinitive: "denken", english: "to think", regularity: "regular", ich: "denke", du: "denkst", er: "denkt", wir: "denken", ihr: "denkt", sie: "denken" },
  { infinitive: "nehmen", english: "to take", regularity: "irregular", ich: "nehme", du: "nimmst", er: "nimmt", wir: "nehmen", ihr: "nehmt", sie: "nehmen" },
  { infinitive: "tun", english: "to do", regularity: "irregular", ich: "tue", du: "tust", er: "tut", wir: "tun", ihr: "tut", sie: "tun" },
  { infinitive: "dürfen", english: "to be allowed to (may)", regularity: "irregular", ich: "darf", du: "darfst", er: "darf", wir: "dürfen", ihr: "dürft", sie: "dürfen" },
  { infinitive: "glauben", english: "to believe", regularity: "regular", ich: "glaube", du: "glaubst", er: "glaubt", wir: "glauben", ihr: "glaubt", sie: "glauben" },
  { infinitive: "halten", english: "to hold / stop", regularity: "irregular", ich: "halte", du: "hältst", er: "hält", wir: "halten", ihr: "haltet", sie: "halten" },
  { infinitive: "nennen", english: "to name / call", regularity: "regular", ich: "nenne", du: "nennst", er: "nennt", wir: "nennen", ihr: "nennt", sie: "nennen" },
  { infinitive: "mögen", english: "to like", regularity: "irregular", ich: "mag", du: "magst", er: "mag", wir: "mögen", ihr: "mögt", sie: "mögen" },
  { infinitive: "zeigen", english: "to show", regularity: "regular", ich: "zeige", du: "zeigst", er: "zeigt", wir: "zeigen", ihr: "zeigt", sie: "zeigen" },
  { infinitive: "führen", english: "to lead", regularity: "regular", ich: "führe", du: "führst", er: "führt", wir: "führen", ihr: "führt", sie: "führen" },
  { infinitive: "sprechen", english: "to speak", regularity: "irregular", ich: "spreche", du: "sprichst", er: "spricht", wir: "sprechen", ihr: "sprecht", sie: "sprechen" },
  { infinitive: "bringen", english: "to bring", regularity: "regular", ich: "bringe", du: "bringst", er: "bringt", wir: "bringen", ihr: "bringt", sie: "bringen" },
  { infinitive: "leben", english: "to live", regularity: "regular", ich: "lebe", du: "lebst", er: "lebt", wir: "leben", ihr: "lebt", sie: "leben" },
  { infinitive: "fahren", english: "to drive / go", regularity: "irregular", ich: "fahre", du: "fährst", er: "fährt", wir: "fahren", ihr: "fahrt", sie: "fahren" },
  { infinitive: "meinen", english: "to mean / think", regularity: "regular", ich: "meine", du: "meinst", er: "meint", wir: "meinen", ihr: "meint", sie: "meinen" },
  { infinitive: "fragen", english: "to ask", regularity: "regular", ich: "frage", du: "fragst", er: "fragt", wir: "fragen", ihr: "fragt", sie: "fragen" },
  { infinitive: "kennen", english: "to know (be acquainted)", regularity: "regular", ich: "kenne", du: "kennst", er: "kennt", wir: "kennen", ihr: "kennt", sie: "kennen" },
  { infinitive: "gelten", english: "to be valid / count", regularity: "irregular", ich: "gelte", du: "giltst", er: "gilt", wir: "gelten", ihr: "geltet", sie: "gelten" },
  { infinitive: "stellen", english: "to place / put", regularity: "regular", ich: "stelle", du: "stellst", er: "stellt", wir: "stellen", ihr: "stellt", sie: "stellen" },
  { infinitive: "spielen", english: "to play", regularity: "regular", ich: "spiele", du: "spielst", er: "spielt", wir: "spielen", ihr: "spielt", sie: "spielen" },
  { infinitive: "arbeiten", english: "to work", regularity: "regular", ich: "arbeite", du: "arbeitest", er: "arbeitet", wir: "arbeiten", ihr: "arbeitet", sie: "arbeiten" },
  { infinitive: "brauchen", english: "to need", regularity: "regular", ich: "brauche", du: "brauchst", er: "braucht", wir: "brauchen", ihr: "braucht", sie: "brauchen" },
  { infinitive: "folgen", english: "to follow", regularity: "regular", ich: "folge", du: "folgst", er: "folgt", wir: "folgen", ihr: "folgt", sie: "folgen" },
  { infinitive: "lernen", english: "to learn", regularity: "regular", ich: "lerne", du: "lernst", er: "lernt", wir: "lernen", ihr: "lernt", sie: "lernen" },
  { infinitive: "verstehen", english: "to understand", regularity: "regular", ich: "verstehe", du: "verstehst", er: "versteht", wir: "verstehen", ihr: "versteht", sie: "verstehen" },
  { infinitive: "setzen", english: "to set / put", regularity: "regular", ich: "setze", du: "setzt", er: "setzt", wir: "setzen", ihr: "setzt", sie: "setzen" },
  { infinitive: "bekommen", english: "to receive / get", regularity: "regular", ich: "bekomme", du: "bekommst", er: "bekommt", wir: "bekommen", ihr: "bekommt", sie: "bekommen" },
  { infinitive: "beginnen", english: "to begin", regularity: "regular", ich: "beginne", du: "beginnst", er: "beginnt", wir: "beginnen", ihr: "beginnt", sie: "beginnen" },
  { infinitive: "erzählen", english: "to tell / narrate", regularity: "regular", ich: "erzähle", du: "erzählst", er: "erzählt", wir: "erzählen", ihr: "erzählt", sie: "erzählen" },
  { infinitive: "versuchen", english: "to try", regularity: "regular", ich: "versuche", du: "versuchst", er: "versucht", wir: "versuchen", ihr: "versucht", sie: "versuchen" },
  { infinitive: "schreiben", english: "to write", regularity: "regular", ich: "schreibe", du: "schreibst", er: "schreibt", wir: "schreiben", ihr: "schreibt", sie: "schreiben" },
  { infinitive: "laufen", english: "to run / walk", regularity: "irregular", ich: "laufe", du: "läufst", er: "läuft", wir: "laufen", ihr: "lauft", sie: "laufen" },
  { infinitive: "essen", english: "to eat", regularity: "irregular", ich: "esse", du: "isst", er: "isst", wir: "essen", ihr: "esst", sie: "essen" },
  { infinitive: "trinken", english: "to drink", regularity: "regular", ich: "trinke", du: "trinkst", er: "trinkt", wir: "trinken", ihr: "trinkt", sie: "trinken" },
  { infinitive: "lesen", english: "to read", regularity: "irregular", ich: "lese", du: "liest", er: "liest", wir: "lesen", ihr: "lest", sie: "lesen" },
  { infinitive: "helfen", english: "to help", regularity: "irregular", ich: "helfe", du: "hilfst", er: "hilft", wir: "helfen", ihr: "helft", sie: "helfen" },
  { infinitive: "verlieren", english: "to lose", regularity: "regular", ich: "verliere", du: "verlierst", er: "verliert", wir: "verlieren", ihr: "verliert", sie: "verlieren" },
  { infinitive: "treffen", english: "to meet / hit", regularity: "irregular", ich: "treffe", du: "triffst", er: "trifft", wir: "treffen", ihr: "trefft", sie: "treffen" },
  { infinitive: "tragen", english: "to carry / wear", regularity: "irregular", ich: "trage", du: "trägst", er: "trägt", wir: "tragen", ihr: "tragt", sie: "tragen" },
  { infinitive: "scheinen", english: "to seem / shine", regularity: "regular", ich: "scheine", du: "scheinst", er: "scheint", wir: "scheinen", ihr: "scheint", sie: "scheinen" },
  { infinitive: "fallen", english: "to fall", regularity: "irregular", ich: "falle", du: "fällst", er: "fällt", wir: "fallen", ihr: "fallt", sie: "fallen" },
  { infinitive: "schlagen", english: "to hit / beat", regularity: "irregular", ich: "schlage", du: "schlägst", er: "schlägt", wir: "schlagen", ihr: "schlagt", sie: "schlagen" },
  { infinitive: "gewinnen", english: "to win", regularity: "regular", ich: "gewinne", du: "gewinnst", er: "gewinnt", wir: "gewinnen", ihr: "gewinnt", sie: "gewinnen" },
  { infinitive: "bieten", english: "to offer", regularity: "regular", ich: "biete", du: "bietest", er: "bietet", wir: "bieten", ihr: "bietet", sie: "bieten" },
  { infinitive: "schließen", english: "to close", regularity: "regular", ich: "schließe", du: "schließt", er: "schließt", wir: "schließen", ihr: "schließt", sie: "schließen" },
  { infinitive: "entscheiden", english: "to decide", regularity: "regular", ich: "entscheide", du: "entscheidest", er: "entscheidet", wir: "entscheiden", ihr: "entscheidet", sie: "entscheiden" },
  { infinitive: "warten", english: "to wait", regularity: "regular", ich: "warte", du: "wartest", er: "wartet", wir: "warten", ihr: "wartet", sie: "warten" },
  { infinitive: "erklären", english: "to explain", regularity: "regular", ich: "erkläre", du: "erklärst", er: "erklärt", wir: "erklären", ihr: "erklärt", sie: "erklären" },
  { infinitive: "schaffen", english: "to manage / create", regularity: "regular", ich: "schaffe", du: "schaffst", er: "schafft", wir: "schaffen", ihr: "schafft", sie: "schaffen" },
  { infinitive: "gehören", english: "to belong", regularity: "regular", ich: "gehöre", du: "gehörst", er: "gehört", wir: "gehören", ihr: "gehört", sie: "gehören" },
  { infinitive: "erreichen", english: "to reach / achieve", regularity: "regular", ich: "erreiche", du: "erreichst", er: "erreicht", wir: "erreichen", ihr: "erreicht", sie: "erreichen" },
  { infinitive: "vergessen", english: "to forget", regularity: "irregular", ich: "vergesse", du: "vergisst", er: "vergisst", wir: "vergessen", ihr: "vergesst", sie: "vergessen" },
  { infinitive: "wachsen", english: "to grow", regularity: "irregular", ich: "wachse", du: "wächst", er: "wächst", wir: "wachsen", ihr: "wachst", sie: "wachsen" },
  { infinitive: "gefallen", english: "to please / be liked", regularity: "irregular", ich: "gefalle", du: "gefällst", er: "gefällt", wir: "gefallen", ihr: "gefallt", sie: "gefallen" },
  { infinitive: "schlafen", english: "to sleep", regularity: "irregular", ich: "schlafe", du: "schläfst", er: "schläft", wir: "schlafen", ihr: "schlaft", sie: "schlafen" },
  { infinitive: "verbringen", english: "to spend (time)", regularity: "regular", ich: "verbringe", du: "verbringst", er: "verbringt", wir: "verbringen", ihr: "verbringt", sie: "verbringen" },
  { infinitive: "legen", english: "to lay / put down", regularity: "regular", ich: "lege", du: "legst", er: "legt", wir: "legen", ihr: "legt", sie: "legen" },
  { infinitive: "öffnen", english: "to open", regularity: "regular", ich: "öffne", du: "öffnest", er: "öffnet", wir: "öffnen", ihr: "öffnet", sie: "öffnen" },
  { infinitive: "kaufen", english: "to buy", regularity: "regular", ich: "kaufe", du: "kaufst", er: "kauft", wir: "kaufen", ihr: "kauft", sie: "kaufen" },
  { infinitive: "hören", english: "to hear", regularity: "regular", ich: "höre", du: "hörst", er: "hört", wir: "hören", ihr: "hört", sie: "hören" },
  { infinitive: "wohnen", english: "to live / reside", regularity: "regular", ich: "wohne", du: "wohnst", er: "wohnt", wir: "wohnen", ihr: "wohnt", sie: "wohnen" },
  { infinitive: "studieren", english: "to study", regularity: "regular", ich: "studiere", du: "studierst", er: "studiert", wir: "studieren", ihr: "studiert", sie: "studieren" },
  { infinitive: "lieben", english: "to love", regularity: "regular", ich: "liebe", du: "liebst", er: "liebt", wir: "lieben", ihr: "liebt", sie: "lieben" },
  { infinitive: "reisen", english: "to travel", regularity: "regular", ich: "reise", du: "reist", er: "reist", wir: "reisen", ihr: "reist", sie: "reisen" },
  { infinitive: "kochen", english: "to cook", regularity: "regular", ich: "koche", du: "kochst", er: "kocht", wir: "kochen", ihr: "kocht", sie: "kochen" },
  { infinitive: "singen", english: "to sing", regularity: "regular", ich: "singe", du: "singst", er: "singt", wir: "singen", ihr: "singt", sie: "singen" },
  { infinitive: "tanzen", english: "to dance", regularity: "regular", ich: "tanze", du: "tanzt", er: "tanzt", wir: "tanzen", ihr: "tanzt", sie: "tanzen" },
  { infinitive: "lachen", english: "to laugh", regularity: "regular", ich: "lache", du: "lachst", er: "lacht", wir: "lachen", ihr: "lacht", sie: "lachen" },
  { infinitive: "rufen", english: "to call / shout", regularity: "regular", ich: "rufe", du: "rufst", er: "ruft", wir: "rufen", ihr: "ruft", sie: "rufen" },
  { infinitive: "waschen", english: "to wash", regularity: "irregular", ich: "wasche", du: "wäschst", er: "wäscht", wir: "waschen", ihr: "wascht", sie: "waschen" },
  { infinitive: "ziehen", english: "to pull / move", regularity: "regular", ich: "ziehe", du: "ziehst", er: "zieht", wir: "ziehen", ihr: "zieht", sie: "ziehen" },
  { infinitive: "bezahlen", english: "to pay", regularity: "regular", ich: "bezahle", du: "bezahlst", er: "bezahlt", wir: "bezahlen", ihr: "bezahlt", sie: "bezahlen" },
  { infinitive: "verkaufen", english: "to sell", regularity: "regular", ich: "verkaufe", du: "verkaufst", er: "verkauft", wir: "verkaufen", ihr: "verkauft", sie: "verkaufen" },
  { infinitive: "antworten", english: "to answer", regularity: "regular", ich: "antworte", du: "antwortest", er: "antwortet", wir: "antworten", ihr: "antwortet", sie: "antworten" },
  { infinitive: "vergleichen", english: "to compare", regularity: "regular", ich: "vergleiche", du: "vergleichst", er: "vergleicht", wir: "vergleichen", ihr: "vergleicht", sie: "vergleichen" },
  { infinitive: "empfehlen", english: "to recommend", regularity: "irregular", ich: "empfehle", du: "empfiehlst", er: "empfiehlt", wir: "empfehlen", ihr: "empfehlt", sie: "empfehlen" },
  { infinitive: "sterben", english: "to die", regularity: "irregular", ich: "sterbe", du: "stirbst", er: "stirbt", wir: "sterben", ihr: "sterbt", sie: "sterben" },
  { infinitive: "werfen", english: "to throw", regularity: "irregular", ich: "werfe", du: "wirfst", er: "wirft", wir: "werfen", ihr: "werft", sie: "werfen" },
  { infinitive: "treten", english: "to step / kick", regularity: "irregular", ich: "trete", du: "trittst", er: "tritt", wir: "treten", ihr: "tretet", sie: "treten" },
];

// Rows ready for insert: frequency_rank = position, forms mapped to columns.
export function verbRows() {
  return VERBS.filter((v) => v.infinitive.trim() && v.ich).map((v, i) => ({
    infinitive: v.infinitive,
    english: v.english,
    regularity: v.regularity,
    frequencyRank: i + 1,
    formIch: v.ich,
    formDu: v.du,
    formEr: v.er,
    formWir: v.wir,
    formIhr: v.ihr,
    formSie: v.sie,
  }));
}

/**
 * Seed the global verb catalog. Idempotent: existing infinitives are left
 * untouched (ON CONFLICT DO NOTHING). Returns how many new rows were inserted.
 * Used by `npm run db:seed:verbs`; the initial load into prod is a data migration.
 */
export async function seedVerbs(): Promise<number> {
  const inserted = await db
    .insert(verbs)
    .values(verbRows())
    .onConflictDoNothing({ target: verbs.infinitive })
    .returning({ id: verbs.id });
  return inserted.length;
}
