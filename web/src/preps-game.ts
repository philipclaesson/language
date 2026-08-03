// Präposition Power: pure data + logic (UI in games.tsx). A 60-second blitz —
// a preposition flashes, you sort it: Dativ, Akkusativ or Wechsel (two-way).
// Score = correct sorts before the clock runs out; wrong answers cost you the
// correction-reading time. Validated by preps-game.test.ts.

export type PrepClass = "dativ" | "akkusativ" | "wechsel";
export const PREP_CLASSES: PrepClass[] = ["dativ", "akkusativ", "wechsel"];
export const PREP_CLASS_LABELS: Record<PrepClass, string> = {
  dativ: "Dativ",
  akkusativ: "Akkusativ",
  wechsel: "Wechsel",
};

export type PrepItem = {
  prep: string;
  klasse: PrepClass;
  example: string; // shown in the correction line on a wrong sort
};

export const PREP_GAME_SECONDS = 60;

export const PREPS: PrepItem[] = [
  // Always dative: aus bei mit nach seit von zu gegenüber
  { prep: "aus", klasse: "dativ", example: "aus der Schule" },
  { prep: "bei", klasse: "dativ", example: "bei der Arbeit" },
  { prep: "mit", klasse: "dativ", example: "mit dem Bus" },
  { prep: "nach", klasse: "dativ", example: "nach dem Essen" },
  { prep: "seit", klasse: "dativ", example: "seit dem Sommer" },
  { prep: "von", klasse: "dativ", example: "von der Tante" },
  { prep: "zu", klasse: "dativ", example: "zur Oma" },
  { prep: "gegenüber", klasse: "dativ", example: "gegenüber der Kirche" },
  // Always accusative: durch für gegen ohne um bis
  { prep: "durch", klasse: "akkusativ", example: "durch den Park" },
  { prep: "für", klasse: "akkusativ", example: "für die Familie" },
  { prep: "gegen", klasse: "akkusativ", example: "gegen den Baum" },
  { prep: "ohne", klasse: "akkusativ", example: "ohne die Brille" },
  { prep: "um", klasse: "akkusativ", example: "um den Tisch" },
  { prep: "bis", klasse: "akkusativ", example: "bis nächsten Montag" },
  // Two-way (Wechselpräpositionen): motion → Akk, location → Dativ
  { prep: "an", klasse: "wechsel", example: "an die Wand (wohin) / an der Wand (wo)" },
  { prep: "auf", klasse: "wechsel", example: "auf den Tisch (wohin) / auf dem Tisch (wo)" },
  { prep: "hinter", klasse: "wechsel", example: "hinter den Schrank / hinter dem Schrank" },
  { prep: "in", klasse: "wechsel", example: "in die Stadt (wohin) / in der Stadt (wo)" },
  { prep: "neben", klasse: "wechsel", example: "neben das Sofa / neben dem Sofa" },
  { prep: "über", klasse: "wechsel", example: "über den Tisch / über dem Tisch" },
  { prep: "unter", klasse: "wechsel", example: "unter das Bett / unter dem Bett" },
  { prep: "vor", klasse: "wechsel", example: "vor die Tür / vor der Tür" },
  { prep: "zwischen", klasse: "wechsel", example: "zwischen die Stühle / zwischen den Stühlen" },
];

// A shuffled pass over the whole catalog; the game deals a fresh deck each time
// one runs out, so long streaks never see the same prep twice in a row-ish.
export function prepDeck(): PrepItem[] {
  const deck = [...PREPS];
  for (let i = deck.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [deck[i], deck[j]] = [deck[j], deck[i]];
  }
  return deck;
}
