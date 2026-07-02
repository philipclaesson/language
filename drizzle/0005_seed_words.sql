-- Seed the global frequency word corpus. Generated from an Anki deck by
-- scripts/gen-words.ts; the cleaning rules live in server/db/words-parse.ts.
-- Creates ONE ownerless (global) deck + 3708 cards. The deck's null
-- owner_id makes it read-only to users and hidden from the tutor, while the
-- widened review queries surface its cards in every user's daily loop, ordered
-- by frequency_rank. Applied to dev via db:migrate and to prod by the CI migrate
-- job on push to main. Idempotent on the deck (guarded); migration tracking
-- keeps the cards from being inserted twice.

INSERT INTO "decks" ("id", "owner_id", "name", "source", "description")
SELECT 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid, NULL, 'German — Frequency 5000', 'seed', 'The ~3,700 most frequent German words, ordered by frequency.'
WHERE NOT EXISTS (SELECT 1 FROM "decks" WHERE "id" = 'b7c8e3a0-6d4f-4e2a-9c1b-000000005000'::uuid);

INSERT INTO "cards" ("deck_id", "prompt", "answer", "answer_alts", "part_of_speech", "article", "notes", "frequency_rank", "source") VALUES
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'all', 'all', ARRAY[]::text[], NULL, NULL, 'Wir sind alle fleißig.
We are all busy.', 42, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'whole, all the', 'ganz', ARRAY[]::text[], NULL, NULL, 'Die ganze Welt schaut auf diese Stadt.
The whole world is watching this city.', 66, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'high, tall', 'hoch', ARRAY[]::text[], NULL, NULL, 'Die Zugspitze ist ein hoher Berg.
The Zugspitz is a high mountain.', 129, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'both', 'beide', ARRAY[]::text[], NULL, NULL, 'Sie haben beide Recht.
They are both right.', 130, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '[over] there', 'dort', ARRAY[]::text[], NULL, NULL, 'Die Bushaltestelle ist dort drüben.
The bus stop is over there.', 134, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thereby, in doing so', 'dabei', ARRAY[]::text[], NULL, NULL, 'Ich lerne viel und kriege dabei gute Noten.
I study a lot and thereby get good grades.', 135, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be allowed, may', 'dürfen', ARRAY[]::text[], NULL, NULL, 'Darf ich noch ein Eis essen?
Can I eat another ice cream?', 142, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'such', 'solch', ARRAY[]::text[], NULL, NULL, 'Solche Pflanzen sind sehr selten.
Such plants are very rare.', 149, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in addition, furthermore, to that', 'dazu', ARRAY[]::text[], NULL, NULL, 'Was sagt ihr dazu?
What do you say to that?', 150, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'already', 'bereits', ARRAY[]::text[], NULL, NULL, 'Ich habe den Flug bereits gebucht.
I''ve already booked the flight.', 166, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'just, just now (not: straight)', 'gerade', ARRAY[]::text[], NULL, NULL, 'Ich habe gerade Besuch.
I just have visitors.', 176, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'admittedly, to be precise', 'zwar', ARRAY[]::text[], NULL, NULL, 'Er hat zwar Lust zu kommen, aber keine Zeit. Sie haben ein Kind, und zwar einen Sohn.
Admittedly he feels like coming, but doesn''t have time. They have one child and that happens to be a son.', 178, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'part', 'Teil', ARRAY[]::text[], 'noun', 'der', 'Im ersten Teil des Buches werden die Personen vorgestellt.
In the first part of the book, the people are being introduced.', 188, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'however', 'jedoch', ARRAY[]::text[], NULL, NULL, 'Er klingelte. Es machte ihm jedoch niemand die Tür auf.
He rang the bell. However, no one opened the door for him.', 191, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on it, to it', 'darauf', ARRAY['drauf']::text[], NULL, NULL, 'Er hat noch keine Antwort darauf bekommen.
He got no answer.', 193, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'whom, that', 'denen', ARRAY[]::text[], NULL, NULL, 'Wir haben fünf Computer, von denen zwei nicht funktionieren.
We have five computers, of which two do not work.', 198, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exist, insist, pass (an exam)', 'bestehen', ARRAY[]::text[], NULL, NULL, 'Die EU besteht seit 2004 aus 25 Staaten. Einige Firmen bestehen nur auf dem Papier.
The EU exists since 2004 and consists of 25 states. Some companies exist only on paper.', 210, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for it', 'dafür', ARRAY[]::text[], NULL, NULL, 'Ich interessiere mich dafür, wie die Demokratie funktioniert.
I''m interested in how the democracy works.', 213, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as well as, as soon as', 'sowie', ARRAY[]::text[], NULL, NULL, 'In diesem Hotel gibt es Sauna sowie Whirlpool.
This hotel has a sauna as well as a jacuzzi.', 214, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'side, page', 'Seite', ARRAY[]::text[], 'noun', 'die', 'Die Seite ist zerrissen.
The page is torn.', 217, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'just, simply', 'halt', ARRAY[]::text[], NULL, NULL, 'Ich habe halt keine Lust.
I am just not in the mood.', 219, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'though, indeed, certainly', 'allerdings', ARRAY[]::text[], NULL, NULL, 'Dieser Vertrag kommt allerdings mit einigen Bedingungen.
However, there are some conditions to this contract.', 221, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'well (not: probably)', 'wohl', ARRAY[]::text[], NULL, NULL, 'Ich fühle mich nicht wohl.
I am not feeling well.', 224, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'special, certain', 'bestimmt', ARRAY[]::text[], NULL, NULL, 'Ich suche eine bestimmte CD.
I am looking for a certain CD.', 226, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to set, place, put', 'setzen', ARRAY[]::text[], NULL, NULL, 'Wenn man die Daten zueinander in Beziehung setzt, kommt man zu interessanten Ergebnissen.
If you correlate the data, you get interesting results.', 228, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at all, generally', 'überhaupt', ARRAY[]::text[], NULL, NULL, 'Kleinkinder sollten überhaupt nicht in die direkte Sonne.
Small children should not be in the direct sun at all.', 229, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reason, basis', 'Grund', ARRAY[]::text[], 'noun', 'der', 'Du hast keinen Grund, böse zu sein.
You have no reason to be angry.', 230, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from it, about it, thereof', 'davon', ARRAY[]::text[], NULL, NULL, 'Wir haben davon gehört.
We have heard of it.', 238, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'especially', 'besonders', ARRAY[]::text[], NULL, NULL, 'Elefanten werden besonders alt.
Elephants especially get old.', 242, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thing', 'Sache', ARRAY[]::text[], 'noun', 'die', 'Die Sache hat sich erledigt.
The thing is done.', 251, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'type, kind', 'Art', ARRAY[]::text[], 'noun', 'die', 'Löwen sind eine Art Katzen.
Lions are a kind of cat.', 252, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to correspond', 'entsprechen', ARRAY[]::text[], NULL, NULL, 'Der Anzug entspricht nicht meinen Vorstellungen.
The suit does not meet my expectations.', 254, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'area, region', 'Bereich', ARRAY[]::text[], 'noun', 'der', 'In diesem Bereich ist Frau Bitter Expertin.
Mrs. Bitter is the expert in this area.', 257, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hardly', 'kaum', ARRAY[]::text[], NULL, NULL, 'Es gibt kaum noch gute Filme im Kino.
There are hardly any good movies in the cinema.', 259, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'individual', 'einzeln', ARRAY[]::text[], NULL, NULL, 'Die Geburtstagsgäste kamen alle einzeln.
The birthday guests all arrived individually.', 263, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for that reason', 'deshalb', ARRAY[]::text[], NULL, NULL, 'Es ist schon fast Mitternacht. Deshalb sollten wir jetzt nach Hause gehen.
It''s almost midnight. For that reason, we should go home now.', 264, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'whose', 'deren', ARRAY[]::text[], NULL, NULL, 'Die Frau, deren Mann im Koma liegt, ist tief betrübt.
The woman, whose husband is in a coma, is deeply saddened.', 265, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'or rather, more specifically', 'beziehungsweise', ARRAY['bzw.']::text[], NULL, NULL, 'Katzen beziehungsweise Kater markieren ihr Revier.
Cats, more specifically tomcats, mark their territory.', 268, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'even, in fact', 'sogar', ARRAY[]::text[], NULL, NULL, 'Morgen wird es sogar noch heißer als heute.
Tomorrow is going to be even hotter than today.', 269, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'then', 'damals', ARRAY[]::text[], NULL, NULL, 'Damals wohnten oft mehrere Familien in einer Wohnung.
Back then, several families often lived in one apartment .', 271, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'because of', 'wegen', ARRAY[]::text[], NULL, NULL, 'Das Flugzeug stürzte wegen eines technischen Defekts ab.
The plane crashed because of a technical defect.', 274, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'society, company', 'Gesellschaft', ARRAY[]::text[], 'noun', 'die', 'Eine multikulturelle Gesellschaft muss tolerant sein.
A multicultural society must be tolerant.', 275, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shine, seem, appear', 'scheinen', ARRAY[]::text[], NULL, NULL, 'Die Sonne scheint.
The sun is shining.', 276, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'above it, about it (not: fallen)', 'darüber', ARRAY['drüber']::text[], NULL, NULL, 'Danke für das Geld zum Geburtstag. Ich habe mich sehr darüber gefreut.
Thanks for the money for my birthday. I was very happy about it.', 277, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'head', 'Kopf', ARRAY[]::text[], 'noun', 'der', 'Mir tut der Kopf weh.
I have a headache.', 279, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to belong', 'gehören', ARRAY[]::text[], NULL, NULL, 'Der Koffer gehört mir.
The suitcase is mine.', 280, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arise, originate, develop', 'entstehen', ARRAY[]::text[], NULL, NULL, 'Falls Probleme entstehen, werden wir unseren Partnern behilflich sein.
If any problems arise, we will assist our partners.', 281, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'well-known', 'bekannt', ARRAY[]::text[], NULL, NULL, 'Heike Makatsch ist eine bekannte deutsche Schauspielerin.
Heike Makatsch is a well-known German actress.', 282, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to receive', 'erhalten', ARRAY[]::text[], NULL, NULL, 'Den Brief habe ich am Mittwoch erhalten.
I received the letter on Wednesday.', 283, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pair, couple', 'Paar', ARRAY[]::text[], 'noun', 'das', 'Agnes hat zwei Paar schöne Schuhe gekauft.
Agnes has bought two pairs of nice shoes.', 284, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'light, easy', 'leicht', ARRAY[]::text[], NULL, NULL, 'Kinder erziehen ist keine leichte Aufgabe.
Raising children is not an easy task.', 285, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'possibility', 'Möglichkeit', ARRAY[]::text[], 'noun', 'die', 'Nach der Konferenz haben Sie die Möglichkeit, essen zu gehen.
After the conference you will have the possibility to go eat.', 286, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to meet', 'treffen', ARRAY[]::text[], NULL, NULL, 'Wir treffen uns morgen Mittag auf dem Markt.
We will meet tomorrow at noon on the market.', 287, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'behind, in back of', 'hinter', ARRAY[]::text[], NULL, NULL, 'Der Besen steht hinter dem Schrank.
The broom is behind the cabinet.', 288, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'otherwise', 'sonst', ARRAY[]::text[], NULL, NULL, 'Theo trinkt kein Bier, sonst alles.
Theo does not drink beer, otherwise everything else.', 289, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on it', 'daran', ARRAY['dran']::text[], NULL, NULL, 'Siehst du den Baum da? Es hängen immer noch Blätter daran.
See that tree there? It still carries leaves.', 290, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'enterprise, company', 'Unternehmen', ARRAY[]::text[], 'noun', 'das', 'Das Unternehmen ging in Konkurs.
The company went into bankruptcy.', 291, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'further, to continue', 'weiter', ARRAY[]::text[], NULL, NULL, 'Die Arbeitslosigkeit nimmt weiter zu.
Unemployment continues to rise.', 292, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to search, look for', 'suchen', ARRAY[]::text[], NULL, NULL, 'Ich habe meine Sonnenbrille stundenlang gesucht.
I was looking for my sunglasses for hours.', 293, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'picture', 'Bild', ARRAY[]::text[], 'noun', 'das', 'Renates Büro hängt voller Bilder.
Renate''s office is full of pictures.', 294, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'book', 'Buch', ARRAY[]::text[], 'noun', 'das', 'Friedrich hat das Buch schon zweimal gelesen.
Frederick has read the book already twice.', 295, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lay, put', 'legen', ARRAY[]::text[], NULL, NULL, 'Die Mutter legt das Baby ins Bett.
The mother puts the baby to bed.', 296, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'water', 'Wasser', ARRAY[]::text[], 'noun', 'das', 'Das Wasser ist zu kalt zum Schwimmen.
The water is too cold for swimming.', 297, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'place', 'Stelle', ARRAY[]::text[], 'noun', 'die', 'Wir treffen uns an der gleichen Stelle wie letzte Woche.
We meet at the same place as last week.', 298, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to introduce, imagine', 'vorstellen', ARRAY[]::text[], NULL, NULL, 'Der Manager stellt das neue Konzept vor.
The manager introduces the new concept.', 299, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'form, shape', 'Form', ARRAY[]::text[], 'noun', 'die', 'Das Blatt hat die Form eines Herzens.
The leaf is shaped like a heart.', 300, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to deal / to act / to trade', 'handeln', ARRAY[]::text[], NULL, NULL, 'Der Roman handelt von einer modernen Familie. Wir müssen jetzt handeln, die Lage ist ernst. Unsere Produkte werden nun weltweit gehandelt.
The novel is about a modern family. We have to act now, the situation is serious. Our products are now traded worldwide.', 301, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'development', 'Entwicklung', ARRAY[]::text[], 'noun', 'die', 'Die Firma hat eine eigene Abteilung für Forschung und Entwicklung.
The company has it''s own department for research and development.', 303, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'month', 'Monat', ARRAY[]::text[], 'noun', 'der', 'Mit sechs Monaten bekommen Babys die ersten Zähne.
At six months babys get their first teeth.', 304, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to achieve, reach', 'erreichen', ARRAY[]::text[], NULL, NULL, 'Nach vier Stunden erreichten wir den Berggipfel.
After four hours we reached the mountain top.', 305, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'differently', 'anders', ARRAY[]::text[], NULL, NULL, 'Man kann das Problem auch anders lösen.
One can solve the problem differently.', 306, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in the end, finally (not: endlich)', 'schließlich', ARRAY[]::text[], NULL, NULL, 'Wir kamen schließlich in Regensburg an.
We finally arrived in Regensburg.', 307, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to carry, wear', 'tragen', ARRAY[]::text[], NULL, NULL, 'Sie trägt im Sommer gern Kleider.
She likes to wear dresses in the summer.', 308, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rather', 'eher', ARRAY[]::text[], NULL, NULL, 'Das neue Kleid, das ich mir gekauft habe, ist eher schlicht.
The new dress I bought is rather simple.', 309, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'family', 'Familie', ARRAY[]::text[], 'noun', 'die', 'Die ganze Familie wohnt in einem Dorf zusammen.
The whole family lives together in one village.', 310, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'morning', 'Morgen', ARRAY[]::text[], 'noun', 'der', 'Am Morgen scheint die Sonne ins Schlafzimmer.
In the morning the sun shines into the bedroom.', 311, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ever, each (not: the more)', 'je', ARRAY[]::text[], NULL, NULL, 'Er macht 20 Euro Gewinn je Aktie.
He makes 20 euros profit per share.', 312, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'evening', 'Abend', ARRAY[]::text[], 'noun', 'der', 'Im Winter wird es abends früh dunkel.
In winter it gets dark early in the evening.', 313, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in it, inside', 'darin', ARRAY['drin', 'drinnen']::text[], NULL, NULL, 'Darin sehe ich keinen Sinn.
I see no sense in it.', 315, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'round (not: approximately)', 'rund', ARRAY[]::text[], NULL, NULL, 'Das Rad ist nicht mehr ganz rund.
The wheel is not perfectly round anymore.', 316, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'task, assignment, job,', 'Aufgabe', ARRAY[]::text[], 'noun', 'die', 'Lösen Sie die folgenden Aufgaben!
Solve the following tasks!', 317, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'free', 'frei', ARRAY[]::text[], NULL, NULL, 'Der Platz neben mir ist noch frei.
The seat next to me is still free.', 318, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'university', 'Universität', ARRAY['Uni']::text[], 'noun', 'die', 'Die Universität ist 60 Jahre alt.
The University is 60 years old.', 319, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to manage, create', 'schaffen', ARRAY[]::text[], NULL, NULL, 'Ich schaffe meine Arbeit nicht.
I cannot manage my work.', 320, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sense, meaning', 'Sinn', ARRAY[]::text[], 'noun', 'der', 'Man soll das Leben mit allen Sinnen genießen.
One should enjoy life with all senses.', 321, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'early', 'früh', ARRAY[]::text[], NULL, NULL, 'Sechs Uhr morgens? Das ist aber sehr früh!
Six o''Clock in the morning? But this is very early!', 322, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to read', 'lesen', ARRAY[]::text[], NULL, NULL, 'Antina liest gern utopische Romane.
Antina likes to read utopian novels.', 323, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'state', 'Staat', ARRAY[]::text[], 'noun', 'der', 'Die Steuern bekommt der Staat.
The state gets the taxes.', 324, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'destination, goal', 'Ziel', ARRAY[]::text[], 'noun', 'das', 'Hamburg war das Ziel seiner Reise.
Hamburg was the destination of his journey.', 325, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opposite', 'gegenüber', ARRAY[]::text[], NULL, NULL, 'Daniel saß seiner Schwiegermutter gegenüber.
Daniel sat across from his mother in law.', 326, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'friend', 'Freund', ARRAY[]::text[], 'noun', 'der', 'Franziska wohnt mit ihrem Freund zusammen.
Franziska lives with her boyfriend.', 327, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'subject, topic, theme', 'Thema', ARRAY[]::text[], 'noun', 'das', 'Ich würde gern das Thema wechseln.
I would like to change the subject.', 328, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'different, variable', 'unterschiedlich', ARRAY[]::text[], NULL, NULL, 'Zum Bahnhof gelangt man mit unterschiedlichen Verkehrsmitteln.
The railway station can be reached by different means of transport.', 329, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from there, therefore', 'daher', ARRAY[]::text[], NULL, NULL, 'Deine Müdigkeit kommt daher, dass du abends so lange am Computer sitzt.
Your tiredness is from sitting at the computer in the evening so long.', 330, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'person', 'Person', ARRAY[]::text[], 'noun', 'die', 'Dieser Tisch ist ab 20 Uhr für acht Personen reserviert.
Starting at 8 o''clock, this table is reserved for a party of eight.', 331, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bad', 'schlecht', ARRAY[]::text[], NULL, NULL, 'Die Menschen sind schlecht, alle denken nur an sich.
People are bad, everyone only thinks of himself.', 332, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'euro (unit of currency)', 'Euro', ARRAY[]::text[], 'noun', 'der', 'Auf dem Oktoberfest kostet die Maß Bier sieben Euro.
At the Oktoberfest, the cost of a beer is seven euros.', 333, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'although', 'obwohl', ARRAY[]::text[], NULL, NULL, 'Der Zug kam eine halbe Stunde zu spät an, obwohl er ganz pünktlich losgefahren war.
The train was half an hour too late, although it departed on time.', 334, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'night', 'Nacht', ARRAY[]::text[], 'noun', 'die', 'Sie haben die ganze Nacht getanzt.
They danced all night.', 335, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lose', 'verlieren', ARRAY[]::text[], NULL, NULL, 'Die Kirche verliert an Einfluss.
The church is losing influence.', 336, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thing', 'Ding', ARRAY[]::text[], 'noun', 'das', 'Gib mir mal das Ding da!
Give me that thing!', 337, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clear', 'deutlich', ARRAY[]::text[], NULL, NULL, 'Kerstin hat eine deutliche Aussprache.
Kerstin has a clear pronunciation.', 338, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'general', 'allgemein', ARRAY[]::text[], NULL, NULL, 'Es ist allgemein bekannt, dass Paris in Frankreich liegt.
It is common knowledge that Paris is in France.', 339, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'room, space', 'Raum', ARRAY[]::text[], 'noun', 'der', 'Das Wohnzimmer ist der größte Raum in der Wohnung.
The living room is the largest room in the apartment.', 340, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'look, view, glance', 'Blick', ARRAY[]::text[], 'noun', 'der', 'Von der Turmspitze hat man einen schönen Blick über die ganze Stadt.
From the top of the tower you have a beautiful view of the etire city.', 341, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'only, single', 'einzig', ARRAY[]::text[], NULL, NULL, 'Gina ist das einzige Mädchen in der Klasse.
Gina is the only girl in the class.', 342, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to depict, portray', 'darstellen', ARRAY[]::text[], NULL, NULL, 'Das Bild stellt eine Winterlandschaft dar.
The image depicts a winter landscape.', 343, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'place, room, square, space', 'Platz', ARRAY[]::text[], 'noun', 'der', 'Ich habe nicht genug Platz.
I do not have enough space.', 344, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'number', 'Zahl', ARRAY[]::text[], 'noun', 'die', 'Eine große Zahl von Jugendlichen raucht.
A large number of young people are smoking.', 345, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'common, mutual', 'gemeinsam', ARRAY[]::text[], NULL, NULL, 'Ein gemeinsamer Feind stärkt die Gruppe.
A common enemy strengthens the group.', 346, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'near, close (not: near, close to)', 'nahe', ARRAY['nah']::text[], NULL, NULL, 'Weihnachten rückt immer näher.
Christmas is approaching.', 347, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'system', 'System', ARRAY[]::text[], 'noun', 'das', 'Neben der Demokratie gibt es noch andere politische Systeme.
In addition to democracy, there are other political systems.', 348, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clock, watch, o’clock', 'Uhr', ARRAY[]::text[], 'noun', 'die', 'Es ist genau zehn Uhr.
It is exactly ten o''clock.', 349, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'whose', 'dessen', ARRAY[]::text[], NULL, NULL, 'Der Mann, dessen Frau den Nobelpreis erhielt, ist sehr stolz.
The man, whose wife was awarded the Nobel Prize, is very proud.', 350, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'parents', 'Eltern', ARRAY[]::text[], 'noun', 'die', 'Die Eltern fahren an die Ostsee.
The parents are driving to the Baltic Sea.', 351, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to recognize, admit', 'erkennen', ARRAY[]::text[], NULL, NULL, 'Ich kann das nicht erkennen, ich sehe schlecht.
I can''t recognize it, my vision is bad.', 352, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to develop', 'entwickeln', ARRAY[]::text[], NULL, NULL, 'Schmetterlinge entwickeln sich aus Raupen.
Butterflies develop from caterpillars.', 353, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in former times, back then, in the past', 'früher', ARRAY[]::text[], NULL, NULL, 'Früher war alles besser.
Everything was better in the past.', 354, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'street', 'Straße', ARRAY[]::text[], 'noun', 'die', 'Die Straße wird neu gebaut.
The street is being reconstructed.', 355, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to talk', 'reden', ARRAY[]::text[], NULL, NULL, 'Ich möchte jetzt nicht darüber reden.
I do not want to talk about it now.', 356, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'full', 'voll', ARRAY[]::text[], NULL, NULL, 'Die Flasche ist noch ganz voll.
The bottle is still full.', 357, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to appear, look', 'aussehen', ARRAY[]::text[], NULL, NULL, 'Sie sieht aus wie ihre Großmutter.
She looks like her grandmother.', 358, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to appear', 'erscheinen', ARRAY[]::text[], NULL, NULL, 'Die ersten Sterne erscheinen am Himmel.
The first stars appear in the sky.', 359, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'several', 'mehrere', ARRAY[]::text[], NULL, NULL, 'Mehrere Autos waren bei dem Unfall ineinander gefahren.
Several cars drove into each other in the accident.', 360, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'minute', 'Minute', ARRAY[]::text[], 'noun', 'die', 'Der Kuchen muss zwanzig Minuten backen.
The cake needs to bake for twenty minutes.', 361, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'first, at first, for now (not: zuerst)', 'zunächst', ARRAY[]::text[], NULL, NULL, 'Zunächst stellt der Referent seine Gliederung vor.
At first the consultant introduces his plan.', 362, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'group', 'Gruppe', ARRAY[]::text[], 'noun', 'die', 'Zu den Workshops treffen wir uns in kleinen Gruppen.
At the workshops, we meet in small groups.', 363, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'value', 'Wert', ARRAY[]::text[], 'noun', 'der', 'Die Aktie hat an Wert verloren.
The stock has lost value.', 364, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'somehow', 'irgendwie', ARRAY[]::text[], NULL, NULL, 'Irgendwie fühle ich mich heute nicht besonders wohl.
Somehow I don''t feel very well today.', 366, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'language', 'Sprache', ARRAY[]::text[], 'noun', 'die', 'Die deutsche Sprache hat den Ruf, schwierig zu sein.
The German language has the reputation for being difficult.', 367, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to form, educate', 'bilden', ARRAY[]::text[], NULL, NULL, 'Eine statistische Analyse bildet die Basis des Berichts.
A statistical analysis forms the basis of the report.', 368, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'through it, as a result', 'dadurch', ARRAY[]::text[], NULL, NULL, 'Dreimal die Woche geht er joggen. Dadurch bleibt er in Form.
Three times a week he goes jogging. As a result, he stays in shape.', 369, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'direct, straight', 'direkt', ARRAY[]::text[], NULL, NULL, 'Wir gehen auf direktem Weg nach Hause.
We go straight home.', 370, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'international', 'international', ARRAY[]::text[], NULL, NULL, 'Die Universität hat einen internationalen Anspruch.
The University has an international claim.', 371, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'social', 'sozial', ARRAY[]::text[], NULL, NULL, 'Bei Spendenaktionen wird gern an das soziale Gewissen der Spender appelliert.
At fundraising events they like to appeal to the social conscience of the donors.', 372, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to begin', 'anfangen', ARRAY[]::text[], NULL, NULL, 'Das Theaterstück fängt gleich an.
The play is about to begin.', 373, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'best', 'beste', ARRAY['s)']::text[], NULL, NULL, 'Meine Mutter macht den besten Sauerbraten der Welt.
My mother makes the best braised beef in the world.', 374, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'until now', 'bisher', ARRAY[]::text[], NULL, NULL, 'Bisher habe ich nie viel vor Prüfungen gelernt.
Until now, I''ve never studied a lot prior to exams.', 375, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to expect', 'erwarten', ARRAY[]::text[], NULL, NULL, 'Unser Chef erwartet großes Engagement von seinen Mitarbeitern.
Our boss expects strong commitment from his employees.', 376, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'beginning', 'Anfang', ARRAY[]::text[], 'noun', 'der', 'Am Anfang war das Wort.
In the beginning was the Word.', 377, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'you see, namely', 'nämlich', ARRAY[]::text[], NULL, NULL, 'Ich habe nämlich doch Recht!
You see, I am right!', 378, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'that, those', 'jene', ARRAY['s)']::text[], NULL, NULL, 'Die Hilfe wird all jenen angeboten, die sie brauchen.
The help will be offered to all those who need it.', 379, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to live', 'wohnen', ARRAY[]::text[], NULL, NULL, 'Nazar wohnt schon dreizehn Jahre in Deutschland.
Nazar has lived in Germany for 13 years.', 380, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'red', 'rot', ARRAY[]::text[], NULL, NULL, 'Rote Socken passen nicht zu blauen Schuhen.
Red socks do not match the blue shoes.', 381, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'open', 'offen', ARRAY[]::text[], NULL, NULL, 'Die Flasche ist schon offen.
The bottle is already open.', 382, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'place, town, location', 'Ort', ARRAY[]::text[], 'noun', 'der', 'Kirchberg ist ein kleiner Ort in Oesterreich.
Kirchberg is a small town in Austria.', 383, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'oh well', 'naja', ARRAY[]::text[], NULL, NULL, 'Naja, ich würde das nicht so dramatisch sehen.
Oh well, I wouldn''t see this as dramatic.', 384, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'moment', 'Moment', ARRAY[]::text[], 'noun', 'der', 'Warte noch einen Moment!
Wait a moment.', 385, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to affect, concern', 'betreffen', ARRAY[]::text[], NULL, NULL, 'Das betrifft alle Abiturienten dieses Jahrgangs.
This affects all of this years graduates.', 386, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'most', 'meiste', ARRAY[]::text[], NULL, NULL, 'Am meisten hat mir Richard gefallen.
Most of all I liked Richard.', 387, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to wait', 'warten', ARRAY[]::text[], NULL, NULL, 'Die Kinder warten voller Ungeduld auf Weihnachten.
The children wait impatiently for Christmas.', 388, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'result, consequence (not: Ergebnis)', 'Folge', ARRAY[]::text[], 'noun', 'die', 'Die Folge davon war, dass er arbeitslos wurde.
The consequence was that he became unemployed.', 389, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from', 'ab', ARRAY[]::text[], NULL, NULL, 'Ab dem ersten Januar gilt das Gesetz.
From the first of January the law applies.', 390, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'special', 'besondere', ARRAY['s)']::text[], NULL, NULL, 'Barbara ist eine ganz besondere Frau.
Barbara is a very special woman.', 391, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'certain', 'gewiss', ARRAY[]::text[], NULL, NULL, 'Das hat ein gewisser Herr Müller gesagt.
That''s what a certain Mr. Mueller said.', 392, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interest', 'Interesse', ARRAY[]::text[], 'noun', 'das', 'Sind Studiengebühren im Interesse der Studenten?
Are tuition fees in the interest of the students?', 393, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sometimes', 'manchmal', ARRAY[]::text[], NULL, NULL, 'Bettina kocht manchmal Spaghetti für alle Kollegen.
Bettina sometimes cooks spaghetti for all colleagues.', 394, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'billion', 'Milliarde', ARRAY['Mrd.']::text[], 'noun', 'die', 'Die Weltbevölkerung beträgt 7,4 Milliarden.
The world population is 7.4 billion.', 395, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'roll, role', 'Rolle', ARRAY[]::text[], 'noun', 'die', 'Er verbrauchte die ganze Rolle Klebeband. Der Schauspieler hat viele Rollen gespielt.
He used up the whole roll of tape. The actor has played many roles.', 396, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'someone', 'jemand', ARRAY[]::text[], NULL, NULL, 'Es steht jemand vor der Tür.
Someone is at the door.', 397, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pass (time)', 'vergehen', ARRAY[]::text[], NULL, NULL, 'Wie die Zeit vergeht.
How time passes.', 398, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'public', 'öffentlich', ARRAY[]::text[], NULL, NULL, 'Die Sitzung des Parlaments ist öffentlich.
The Parliament session is public.', 399, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'door', 'Tür', ARRAY[]::text[], 'noun', 'die', 'Sein Name steht an der Tür.
His name is at the door.', 400, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pupil, student (USA)', 'Schüler', ARRAY[]::text[], 'noun', 'der', 'Alle Schüler treffen sich donnerstags in der Aula.
All students meet in the auditorium on Thursdays.', 401, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meaning, significance', 'Bedeutung', ARRAY[]::text[], 'noun', 'die', 'Ich muss oft die Bedeutung unbekannter Wörter nachschlagen.
I often have to look up the meaning of unfamiliar words.', 402, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'text', 'Text', ARRAY[]::text[], 'noun', 'der', 'Der Text ist zu lang.
The text is too long.', 403, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'result', 'Ergebnis', ARRAY[]::text[], 'noun', 'das', 'Die Projektgruppe stellt ihre Ergebnisse vor.
The project group presents their results.', 405, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to help', 'helfen', ARRAY[]::text[], NULL, NULL, 'Kinder sollten im Haushalt helfen.
Children should help with household chores.', 406, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'war', 'Krieg', ARRAY[]::text[], 'noun', 'der', 'Die Soldaten ziehen in den Krieg.
The soldiers go to war.', 407, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'no one, nobody', 'niemand', ARRAY[]::text[], NULL, NULL, 'Im Zimmer war niemand zu sehen.
There was no one in the room.', 409, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to win, gain', 'gewinnen', ARRAY[]::text[], NULL, NULL, 'Sie möchte eine Medaille gewinnen.
She wants to win a medal.', 410, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'half', 'halb', ARRAY[]::text[], NULL, NULL, 'Wir gehen halb eins essen.
We eat a half past twelve.', 411, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to close', 'schließen', ARRAY[]::text[], NULL, NULL, 'Schließen Sie jetzt bitte die Augen.
Now close your eyes.', 412, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'way, manner', 'Weise', ARRAY[]::text[], 'noun', 'die', 'Auf welche Weise lösen wir das Problem am schnellsten?
In which manner do we solve the problem the fastest?', 413, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rule, government', 'Regierung', ARRAY[]::text[], 'noun', 'die', 'Die Regierung sitzt in Berlin.
The government is in Berlin.', 414, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'probable', 'wahrscheinlich', ARRAY[]::text[], NULL, NULL, 'Es wird wahrscheinlich eine Stunde dauern.
It will probably take an hour.', 415, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'European', 'europäisch', ARRAY[]::text[], NULL, NULL, 'Die gemeinsame europäische Währung ist der Euro.
The common European currency is the euro.', 416, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'piece', 'Stück', ARRAY[]::text[], 'noun', 'das', 'Ich möchte noch ein Stück Kuchen.
I want another piece of cake.', 417, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'apartment, flat', 'Wohnung', ARRAY[]::text[], 'noun', 'die', 'Die Wohnung ist im dritten Stock.
The apartment is on the third floor.', 418, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to feel', 'fühlen', ARRAY[]::text[], NULL, NULL, 'Sie fühlt sich schlecht.
She feels bad.', 419, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conversation', 'Gespräch', ARRAY[]::text[], 'noun', 'das', 'Ein vernünftiges Gespräch war nicht mehr möglich.
A rational conversation was no longer possible.', 420, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to offer', 'bieten', ARRAY[]::text[], NULL, NULL, 'Nach dem Vortrag bietet sich die Gelegenheit zu einem Stadtrundgang.
After the lecture, the opportunity for a city tour arises.', 421, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to interest', 'interessieren', ARRAY[]::text[], NULL, NULL, 'Das fünfte Kapitel interessiert uns heute besonders.
The fifth chapter in particular interests us today.', 422, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'essential, fundamental (not: grundsätzlich)', 'wesentlich', ARRAY[]::text[], NULL, NULL, 'Das ist ein ganz wesentlicher Unterschied.
This is a very important/essential difference.', 423, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to remind', 'erinnern', ARRAY[]::text[], NULL, NULL, 'Ich werde dich daran erinnern.
I will remind you.', 424, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meter', 'Meter', ARRAY[]::text[], 'noun', 'der', 'Ein Meter sind 100 Zentimeter.
A meter is 100 centimeters.', 425, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from sth, as far as...is concerned', 'her', ARRAY[]::text[], NULL, NULL, 'Von den Noten her müsste sie sich eigentlich keine Sorgen machen.
According to the grades, there is actually no need to worry.', 426, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dot, point, period', 'Punkt', ARRAY[]::text[], 'noun', 'der', 'Der Minister trägt einen Schlips mit Punkten.
The minister wears a tie with dots.', 427, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'situation', 'Situation', ARRAY[]::text[], 'noun', 'die', 'Das ist eine komplizierte Situation.
That''s a complicated situation.', 428, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'similar', 'ähnlich', ARRAY[]::text[], NULL, NULL, 'Bernd sieht seinem Bruder ähnlich.
Bernd looks similar to his brother.', 429, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to result in,', 'ergeben', ARRAY[]::text[], NULL, NULL, 'Vier plus vier ergibt acht.
Four plus four is eight.', 430, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'against it, on the other hand', 'dagegen', ARRAY[]::text[], NULL, NULL, 'Mein Chef ist dagegen.
My boss is against it.', 431, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'frequent', 'häufig', ARRAY[]::text[], NULL, NULL, 'Hier werden häufige Wörter gesammelt.
Frequent words are collected here.', 432, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'teacher', 'Lehrer', ARRAY[]::text[], 'noun', 'der', 'Jakob mag seinen Lehrer.
Jacob likes his teacher.', 433, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to offer', 'anbieten', ARRAY[]::text[], NULL, NULL, 'Die Firma bietet einen Rabatt von 10% an.
The company offers a discount of 10%.', 434, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'just as, as much as, as well', 'ebenso', ARRAY[]::text[], NULL, NULL, 'Katjes Candy macht Kinder froh, und Erwachsene ebenso.
Katjes Candy makes children happy, and adults as well.', 435, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to study', 'studieren', ARRAY[]::text[], NULL, NULL, 'Nach ihrem Abitur will Melanie Psychologie studieren.
After graduating highschool, Melanie wants to study psychology.', 436, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'program, channel, schedule', 'Programm', ARRAY[]::text[], 'noun', 'das', 'Als nächstes steht eine Diskussion auf dem Programm.
Up next on the schedule is a discussion.', 464, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'low, small, minor', 'gering', ARRAY[]::text[], NULL, NULL, 'Das ist ein geringes Problem.
This is a minor problem.', 466, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'information (not: Auskunft)', 'Information', ARRAY[]::text[], 'noun', 'die', 'Ihm wurden Informationen vorenthalten.
His information has been withheld.', 467, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the art', 'Kunst', ARRAY[]::text[], 'noun', 'die', 'Schreiben ist eine Kunst.
Writing is an art.', 468, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'music', 'Musik', ARRAY[]::text[], 'noun', 'die', 'Musik verbindet die Menschen.
Music connects people.', 469, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to look', 'schauen', ARRAY[]::text[], NULL, NULL, 'Martin schaut aus dem Fenster.
Martin looks out the window.', 470, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'difficult', 'schwierig', ARRAY[]::text[], NULL, NULL, 'Bowling ist schwieriger, als ich dachte.
Bowling is more difficult than I thought.', 471, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'politics', 'Politik', ARRAY[]::text[], 'noun', 'die', 'Die Politik ist kein Wundermittel.
Politics is not a panacea.', 472, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to leave (specifically, to leave behind)', 'verlassen', ARRAY[]::text[], NULL, NULL, 'Wir verlassen das Haus um 8 Uhr.
We leave the house at 8 clock.', 473, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'some, many', 'manche', ARRAY['s)']::text[], NULL, NULL, 'Manche Kinder essen keinen Spinat.
Some children do not eat spinach.', 474, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'soon', 'bald', ARRAY[]::text[], NULL, NULL, 'Meine Tochter kommt bald in die Schule.
My daughter comes to school soon.', 475, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'put in, insert', 'einsetzen', ARRAY[]::text[], NULL, NULL, 'Setzen Sie das Wort hier ein!
Insert the word here!', 476, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'occupation, job, profession', 'Beruf', ARRAY[]::text[], 'noun', 'der', 'Er hasst seinen Beruf.
He hates his job.', 477, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'practical', 'praktisch', ARRAY[]::text[], NULL, NULL, 'Ich finde kein praktisches Beispiel.
I cannot find a practical example.', 478, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to change', 'ändern', ARRAY[]::text[], NULL, NULL, 'Sie änderten ihre Meinung.
They changed their minds.', 479, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'enough', 'genug', ARRAY[]::text[], NULL, NULL, 'Ich habe nicht genug Geld.
I do not have enough money.', 480, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'personal, personally', 'persönlich', ARRAY[]::text[], NULL, NULL, 'Ich persönlich fand den Film gar nicht so schlecht.
I personally found the movie not so bad.', 481, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grow', 'wachsen', ARRAY[]::text[], NULL, NULL, 'Gras wächst fast überall.
Grass is growing almost everywhere.', 482, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to run out / to assume', 'ausgehen', ARRAY[]::text[], NULL, NULL, 'Ich kaufe immer mehr Milch, bevor sie ausgeht. Ich gehe davon aus, dass du mitkommst.
I always buy more milk before it runs out. I assume that you are coming with me.', 483, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rule', 'Regel', ARRAY[]::text[], 'noun', 'die', 'Ausnahmen bestätigen die Regel.
Exceptions prove the rule.', 484, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'step', 'Schritt', ARRAY[]::text[], 'noun', 'der', 'Er wollte immer einen Schritt voraus sein.
He always wanted to stay one step ahead.', 485, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sales, paragraph, heel', 'Absatz', ARRAY['Abs.']::text[], 'noun', 'der', 'Lesen Sie bitte den ersten Absatz!
Please read the first paragraph!', 487, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to happen, occur', 'geschehen', ARRAY[]::text[], NULL, NULL, 'Was ist denn geschehen?
What happened?', 488, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'god', 'Gott', ARRAY[]::text[], 'noun', 'der', 'Ich glaube an Gott.
I believe in god.', 489, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'automobile, car', 'Auto', ARRAY[]::text[], 'noun', 'das', 'Mein Auto hat einen Totalschaden.
My car has a total loss.', 490, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to describe', 'beschreiben', ARRAY[]::text[], NULL, NULL, 'Beschreib mir doch mal deine Traumfrau!
Describe to me the woman of your dreams!', 491, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'relation, relationship', 'Beziehung', ARRAY[]::text[], 'noun', 'die', 'Welche Beziehung besteht zwischen Molekülen und Atomen?
What is the relation between molecules and atoms?', 492, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'experience', 'Erfahrung', ARRAY[]::text[], 'noun', 'die', 'Ich habe keine Erfahrung mit Mikrowellen.
I have no experience with microwaves.', 493, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'table', 'Tisch', ARRAY[]::text[], 'noun', 'der', 'Auf dem Tisch liegt eine Tischdecke.
On the table is a table cloth.', 494, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accept, assume', 'annehmen', ARRAY[]::text[], NULL, NULL, 'Sie hat die Einladung zum Konzert angenommen.
She accepted the invitation to the concert.', 495, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'eventually, at last', 'endlich', ARRAY[]::text[], NULL, NULL, 'Wir mussten warten, aber endlich kam der Bus.
We had to wait, but the bus eventually arrived.', 496, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get, receive', 'kriegen', ARRAY[]::text[], NULL, NULL, 'Du kriegst heute kein Abendbrot!
You''ll get no dinner today!', 497, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'future', 'Zukunft', ARRAY[]::text[], 'noun', 'die', 'In Zukunft werde ich weniger rauchen.
I will smoke less in the future.', 498, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to plan', 'planen', ARRAY[]::text[], NULL, NULL, 'Die Klasse plant einen Wandertag.
The class is planning a day of hiking.', 499, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'game', 'Spiel', ARRAY[]::text[], 'noun', 'das', 'Das Spiel ist aus.
The game is over.', 500, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to have an effect, to work', 'wirken', ARRAY[]::text[], NULL, NULL, 'Das Medikament wirkt schnell.
The drug works quickly.', 501, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'feeling', 'Gefühl', ARRAY[]::text[], 'noun', 'das', 'Ich habe kein gutes Gefühl dabei.
I don''t have a good feeling about it.', 502, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'light', 'Licht', ARRAY[]::text[], 'noun', 'das', 'Mach das Licht aus.
Turn off the light.', 503, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'modern', 'modern', ARRAY[]::text[], NULL, NULL, 'Moderne Autos haben Airbags.
Modern cars have airbags.', 504, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'president', 'Präsident', ARRAY[]::text[], 'noun', 'der', 'Der Präsident des Bundestags mahnte zur Ruhe.
The President of the Bundestag urged to silence.', 505, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'deep', 'tief', ARRAY[]::text[], NULL, NULL, 'Das Baby schläft so tief, dass es nichts hört.
The baby sleeps so deeply that it doesn''t hear anything.', 506, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to call, name (point out the name of)', 'bezeichnen', ARRAY[]::text[], NULL, NULL, 'Wie bezeichnet man den östlichen Teil einer Kirche?
How do you call the eastern part of a church?', 507, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'market', 'Markt', ARRAY[]::text[], 'noun', 'der', 'Es existiert zur Zeit kein Markt für Rollschuhe.
There is currently no market for roller skates.', 508, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'a) bank', 'Bank', ARRAY[]::text[], 'noun', 'die', 'Ich habe noch in der Bank zu tun.
I am still busy at the bank.', 509, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'within', 'innerhalb', ARRAY[]::text[], NULL, NULL, 'Innerhalb dieses Gebietes gibt es Landminen.
Within this area there are land mines.', 510, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'especially', 'insbesondere', ARRAY[]::text[], NULL, NULL, 'Insbesondere alte Menschen trinken zu wenig.
Especially old people drink too little.', 511, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(political) party', 'Partei', ARRAY[]::text[], 'noun', 'die', 'Die Kommunistische Partei erzielte einen Vorsprung von 12 Prozent.
The Communist Party scored a lead of 12 percent.', 512, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'real, actual', 'tatsächlich', ARRAY[]::text[], NULL, NULL, 'Er hat doch tatsächlich geheiratet!
He has actually gotten married!', 513, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'daughter', 'Tochter', ARRAY[]::text[], 'noun', 'die', 'Die Tochter des Bürgermeisters eröffnete den Ball.
The daughter of the mayor opened the ball.', 514, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be [located] (not: sein)', 'befinden', ARRAY[]::text[], NULL, NULL, 'Der Park befindet sich außerhalb der Innenstadt.
The park is located outside downtown.', 515, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take place, happen (not: geschehen)', 'passieren', ARRAY[]::text[], NULL, NULL, 'Auf dieser Straße passieren viele Unfälle.
Many accidents happen on this road.', 516, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'relationship', 'Verhältnis', ARRAY[]::text[], 'noun', 'das', 'Sie hatten ein schlechtes Verhältnis zueinander.
They had a bad relationship.', 517, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'additional', 'zusätzlich', ARRAY[]::text[], NULL, NULL, 'Zusätzlich zu seinem Studium absolvierte er noch drei freiwillige Praktika.
In addition to his studies, he completed three voluntary internships.', 518, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'church', 'Kirche', ARRAY[]::text[], 'noun', 'die', 'Die Kirche steht auf einem Hügel.
The church stands on a hill.', 519, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the basis of, because of', 'aufgrund', ARRAY[]::text[], NULL, NULL, 'Aufgrund einer Störung fiel der Strom für drei Stunden aus.
Due to an error, the power was shut off for three hours.', 520, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '[to] there', 'hin', ARRAY[]::text[], NULL, NULL, 'Ich möchte eine Fahrkarte hin und zurück.
I''d like a ticket there and back.', 521, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as well', 'ebenfalls', ARRAY[]::text[], NULL, NULL, 'Die Nachfrage nach DVD-Spielern ist ebenfalls gesunken.
The demand for DVD players has also declined.', 523, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'film, movie', 'Film', ARRAY[]::text[], 'noun', 'der', 'Ich habe mir den Film auf DVD gekauft.
I bought the movie on DVD.', 524, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'after', 'nachdem', ARRAY[]::text[], NULL, NULL, 'Nachdem sie geheiratet hatten, bekamen sie auch bald Kinder.
After they got married, they soon got children.', 525, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to call', 'rufen', ARRAY[]::text[], NULL, NULL, 'Der Verletzte ruft um Hilfe.
The injured is calling for help.', 526, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'economic, financial', 'wirtschaftlich', ARRAY[]::text[], NULL, NULL, 'Wirtschaftlich gesehen können wir uns das Unternehmen nicht leisten.
Economically, we can not afford the company.', 527, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to record, include', 'aufnehmen', ARRAY[]::text[], NULL, NULL, 'Ich nehme die Talkshow auf, um sie später auszuwerten.
I am recording the talk show, to evaluate it later.', 528, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thought', 'Gedanke', ARRAY[]::text[], 'noun', 'der', 'Mach dir keine Gedanken!
Do not worry!', 529, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'yesterday', 'gestern', ARRAY[]::text[], NULL, NULL, 'Gestern zerstörte ein Wirbelsturm zwei Wohnhäuser.
Yesterday, a tornado destroyed two houses.', 530, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interesting', 'interessant', ARRAY[]::text[], NULL, NULL, 'Interessante Diplomarbeiten sind selten.
Interesting degree dissertations are rare.', 531, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to increase, to gain', 'zunehmen', ARRAY[]::text[], NULL, NULL, 'In Deutschland nimmt die Ausländerzahl zu.
In Germany, the number of foreigners increases.', 532, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to decide, determine', 'bestimmen', ARRAY[]::text[], NULL, NULL, 'Musst du immer alles bestimmen?
Do you have to decide everything?', 533, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to demand, claim', 'fordern', ARRAY[]::text[], NULL, NULL, 'Sie forderten Gleichberechtigung.
They demanded equal rights.', 535, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to please, to like', 'gefallen', ARRAY[]::text[], NULL, NULL, 'Das Lied gefällt mir.
I like the song.', 536, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'girl', 'Mädchen', ARRAY[]::text[], 'noun', 'das', 'Mädchen sind oft die besseren Schüler.
Girls are often the better students.', 537, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to open', 'öffnen', ARRAY[]::text[], NULL, NULL, 'Jemand öffnete die Tür.
Someone opened the door.', 538, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hit, beat', 'schlagen', ARRAY[]::text[], NULL, NULL, 'Das Herz schlägt in der Brust.
The heart beats in the chest.', 539, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in spite of, despite', 'trotz', ARRAY[]::text[], NULL, NULL, 'Trotz der geringen Niederschläge erwarten wir eine gute Ernte.
Despite the low rainfall, we expect a good harvest.', 540, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'before', 'bevor', ARRAY[]::text[], NULL, NULL, 'Bevor ich zu dir komme, rufe ich dich an.
Before I come to you, I''ll call you.', 541, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'decision', 'Entscheidung', ARRAY[]::text[], 'noun', 'die', 'Wir müssen eine klare Entscheidung treffen.
We have to make a clear decision.', 542, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trial, process', 'Prozess', ARRAY[]::text[], 'noun', 'der', 'Das ist ein langwieriger Prozess.
This is a lengthy process.', 543, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'relative', 'relativ', ARRAY[]::text[], NULL, NULL, 'Meine Wohnung ist relativ klein.
My apartment is relatively small.', 544, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to step, to kick,', 'treten', ARRAY[]::text[], NULL, NULL, 'Der Schauspieler trat ins Rampenlicht.
The actor stepped into the spotlight.', 545, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'business, operation (not: Geschäft, Firma, Unternehmen)', 'Betrieb', ARRAY[]::text[], 'noun', 'der', 'Im Betrieb wird gestreikt.
There is a strike in the business.', 546, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'please', 'bitte', ARRAY[]::text[], NULL, NULL, 'Schau mich bitte nicht so an!
Please, do not look at me like that!', 547, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'simultaneous, at the same time', 'gleichzeitig', ARRAY[]::text[], NULL, NULL, 'Sie sprangen gleichzeitig von der Brücke.
They jumped from the bridge at the same time.', 548, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take over', 'übernehmen', ARRAY[]::text[], NULL, NULL, 'Können Sie diese Aufgabe übernehmen?
Can you take over the task?', 549, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to change', 'verändern', ARRAY[]::text[], NULL, NULL, 'Der Hubschrauber veränderte seine Flugrichtung.
The helicopter changed its flight direction.', 550, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'connection, context', 'Zusammenhang', ARRAY[]::text[], 'noun', 'der', 'Da besteht bestimmt ein Zusammenhang.
There is definitely a context.', 551, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'law', 'Gesetz', ARRAY[]::text[], 'noun', 'das', 'Er hat das Gesetz gebrochen.
He broke the law.', 552, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'together', 'zusammen', ARRAY[]::text[], NULL, NULL, 'Zusammen sind wir stark.
Together we are strong.', 553, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'arm', 'Arm', ARRAY[]::text[], 'noun', 'der', 'Ich habe mir meinen Arm gebrochen.
I''ve broken my arm.', 554, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'firm, company', 'Firma', ARRAY[]::text[], 'noun', 'die', 'Viele Firmen gehen an die Börse.
Many firms go to the stock market.', 555, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strength, power', 'Kraft', ARRAY[]::text[], 'noun', 'die', 'Ich habe keine Kraft.
I have no strength.', 558, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to laugh', 'lachen', ARRAY[]::text[], NULL, NULL, 'Lachen ist gesund.
Laughter is healthy.', 559, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'student', 'Student', ARRAY[]::text[], 'noun', 'der', 'In vielen Seminaren gibt es zu viele Studenten.
In many seminars there are too many students.', 561, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to use (to make use of) (not: benutzen)', 'verwenden', ARRAY[]::text[], NULL, NULL, 'Wie verwendet man eine Freisprechanlage?
How to use a hands-free device.', 562, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'white', 'weiß', ARRAY[]::text[], NULL, NULL, 'Schneewittchens Haut war weiß wie Schnee.
Snow White''s skin was white as snow.', 563, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to choose, elect, vote', 'wählen', ARRAY[]::text[], NULL, NULL, 'Ich habe am Sonntag nicht gewählt.
I did not vote on Sunday.', 564, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'home (not: Heim)', 'Zuhause', ARRAY[]::text[], 'noun', 'das', 'Struppi hat bei Möllers ein neues Zuhause gefunden.
Struppi has found a new home at Möllers.', 565, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chance', 'Chance', ARRAY[]::text[], 'noun', 'die', 'Ihm wurde keine zweite Chance gegeben.
He wasn''t given a second chance.', 566, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'where, which, whereas', 'wobei', ARRAY[]::text[], NULL, NULL, 'Wobei du nicht unbedingt Recht haben musst.
Whereas you aren''t necessarily right.', 567, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take place, occur (to follow)', 'erfolgen', ARRAY[]::text[], NULL, NULL, 'Die Lieferung erfolgt innerhalb von zwei Tagen.
Delivery will take place within two days.', 568, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'whole, entire (not: ganz)', 'gesamt', ARRAY[]::text[], NULL, NULL, 'Die gesamte Universität musste evakuiert werden.
The entire university had to be evacuated.', 569, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'special, specific (not: besonders)', 'speziell', ARRAY[]::text[], NULL, NULL, 'Das ist eine sehr spezielle Frage.
This is a very specific question.', 571, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'newspaper', 'Zeitung', ARRAY[]::text[], 'noun', 'die', 'Beim Frühstück lese ich immer die Zeitung.
I always read the newspaper at breakfast.', 572, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'only, simply, just (not: einfach)', 'bloß', ARRAY[]::text[], NULL, NULL, 'Mach mir bloß keine Probleme!
Just don''t give me any problems!', 573, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to contain', 'enthalten', ARRAY[]::text[], NULL, NULL, 'Die Creme enthält keine Konservierungsstoffe.
The cream contains no preservatives.', 574, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to look at, consider', 'betrachten', ARRAY[]::text[], NULL, NULL, 'Er betrachtet sich als einen großen Künstler.
He considers himself a great artist.', 575, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to decide', 'entscheiden', ARRAY[]::text[], NULL, NULL, 'Katja kann sich nicht zwischen Kai und Karsten entscheiden.
Katja can not decide between Kai and Karsten.', 576, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'success', 'Erfolg', ARRAY[]::text[], 'noun', 'der', 'Ich hatte mit meiner Bewerbung keinen Erfolg.
I have had no success with my application.', 577, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to succeed (to manage to succeed regarding something)', 'gelingen', ARRAY[]::text[], NULL, NULL, 'Ihr gelang ein großartiger Roman.
She succeeded in a great novel.', 578, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'border', 'Grenze', ARRAY[]::text[], 'noun', 'die', 'An der Grenze gibt es einen Zaun.
At the border there is a fence.', 579, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at a time', 'jeweils', ARRAY[]::text[], NULL, NULL, 'Ich kann mich nur auf jeweils eine Sache konzentrieren.
I can only focus on one thing at a time.', 580, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to buy', 'kaufen', ARRAY[]::text[], NULL, NULL, 'Kauf dir doch einen Schal, wenn es so kalt ist.
Buy yourself a scarf if it is so cold.', 581, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sentence', 'Satz', ARRAY[]::text[], 'noun', 'der', 'Sag das doch mal in einem Satz!
Say that in one sentence!', 582, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'when', 'wann', ARRAY[]::text[], NULL, NULL, 'Wann fährt die Straßenbahn?
When does the cablecar depart?', 583, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the offer', 'Angebot', ARRAY[]::text[], 'noun', 'das', 'Ihr Angebot gefällt mir.
I like your offer.', 584, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'around it, therefore, that''s why', 'darum', ARRAY[]::text[], NULL, NULL, 'Darum sind wir nicht gekommen.
That is why we did not come.', 585, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'decisive, crucial', 'entscheidend', ARRAY[]::text[], NULL, NULL, 'Der entscheidende Vorteil für die Investition lag in den Steuervergünstigungen.
The decisive advantage of the investment were the tax incentives.', 586, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to experience, find out', 'erfahren', ARRAY[]::text[], NULL, NULL, 'Er erfuhr davon aus dem Fernsehen.
He found out about it from television.', 587, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'internet', 'Internet', ARRAY[]::text[], 'noun', 'das', 'Im Internet findest du bestimmt viele Informationen.
On the Internet you certainly find lots of informations.', 588, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'down', 'unten', ARRAY[]::text[], NULL, NULL, 'Unten im Keller lagern noch 20 Weinflaschen.
20 wine bottles are stored down in the cellar.', 590, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'narrow, close', 'eng', ARRAY[]::text[], NULL, NULL, 'Er ist ein enger Verwandter.
He is a close relative.', 591, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in all, altogether', 'insgesamt', ARRAY[]::text[], NULL, NULL, 'In der Bibliothek stehen insgesamt 200.000 Bücher.
There are 200,000 books in all at the library.', 592, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'culture', 'Kultur', ARRAY[]::text[], 'noun', 'die', 'In der arabischen Kultur denkt man anders darüber.
In the Arab culture one thinks differently about it.', 593, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'technical', 'technisch', ARRAY[]::text[], NULL, NULL, 'Das ist ein technisches Problem.
This is a technical problem.', 594, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to forget', 'vergessen', ARRAY[]::text[], NULL, NULL, 'Ich vergesse immer, wie sie heißt.
I always forget her name.', 595, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'situation, location', 'Lage', ARRAY[]::text[], 'noun', 'die', 'Die Lage verschlechtert sich.
The situation is worsening.', 596, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'performance (not: Vorstellung)', 'Leistung', ARRAY[]::text[], 'noun', 'die', 'Leistung muss belohnt werden.
Performance must be rewarded.', 597, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'member', 'Mitglied', ARRAY[]::text[], 'noun', 'das', 'Alle Mitglieder treffen sich morgen Nachmittag.
All members meet tomorrow afternoon.', 598, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take place, occur (not: geschehen, passieren)', 'stattfinden', ARRAY[]::text[], NULL, NULL, 'Die Versammlung findet in der Aula statt.
The meeting takes place in the auditorium', 599, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'earlier, beforehand', 'vorher', ARRAY[]::text[], NULL, NULL, 'Vorher lese ich noch den Artikel zu Ende.
Beforehand, I''m reading the article until the end.', 600, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for example', 'beispielsweise', ARRAY[]::text[], NULL, NULL, 'Meine Mutter beispielsweise nimmt zum Braten Butter.
My mother, for example, uses butter for frying.', 601, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to move', 'bewegen', ARRAY[]::text[], NULL, NULL, 'Das Rad bewegt sich nicht mehr.
The wheel does not move anymore.', 602, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to establish, detect (to know with certainty)', 'feststellen', ARRAY[]::text[], NULL, NULL, 'Die Kommission konnte keine Unregelmäßigkeiten bei der Wahl feststellen.
The Commission couldn''t detect any irregularities in the election.', 603, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'slow', 'langsam', ARRAY[]::text[], NULL, NULL, 'Faultiere und Teenager bewegen sich sehr langsam.
Sloths and teenager move very slowly.', 604, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the project', 'Projekt', ARRAY[]::text[], 'noun', 'das', 'Wer finanziert das Projekt?
Who is funding the project?', 605, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to disappear', 'verschwinden', ARRAY[]::text[], NULL, NULL, 'Es verschwinden immer mehr Löffel aus der Mensa.
More and more spoons are disappearing from the cafeteria.', 606, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to serve', 'dienen', ARRAY[]::text[], NULL, NULL, 'Dieser Knopf dient zum Auslösen des Alarms.
This button serves to trigger the alarm.', 607, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to drink', 'trinken', ARRAY[]::text[], NULL, NULL, 'Ich habe nichts mehr zu trinken.
I have nothing to drink anymore.', 608, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'room', 'Zimmer', ARRAY[]::text[], 'noun', 'das', 'Sie hat ihr Zimmer rot gestrichen.
She has painted her room red.', 609, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'head, leader, boss', 'Chef', ARRAY[]::text[], 'noun', 'der', 'Mein Chef ist nie da.
My boss is never there.', 610, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mostly', 'meist', ARRAY[]::text[], NULL, NULL, 'Es regnet meist gegen Abend.
It mostly rains in the evening.', 611, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'constant', 'ständig', ARRAY[]::text[], NULL, NULL, 'Ich denke ständig an dich.
I think about you constantly.', 612, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'train', 'Zug', ARRAY[]::text[], 'noun', 'der', 'Der Zug aus Dresden hatte zehn Minuten Verspätung.
The train from Dresden was ten minutes late.', 613, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'physician, doctor', 'Arzt', ARRAY[]::text[], 'noun', 'der', 'Mein Arzt verschrieb mir eine Salbe.
My doctor prescribed an ointment.', 614, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to appear, occur', 'auftreten', ARRAY[]::text[], NULL, NULL, 'Es treten Schwierigkeiten auf.
Difficulties are occuring.', 615, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foot', 'Fuß', ARRAY[]::text[], 'noun', 'der', 'Er stolpert noch über seine eigenen Füße.
He still stumbles over his own feet.', 616, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'body', 'Körper', ARRAY[]::text[], 'noun', 'der', 'Der menschliche Körper besteht größtenteils aus Wasser.
The human body consists mostly of water.', 617, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'necessary (not: nötig)', 'notwendig', ARRAY[]::text[], NULL, NULL, 'Das ist jetzt nicht mehr notwendig.
That is no longer necessary.', 618, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'class, grade', 'Klasse', ARRAY[]::text[], 'noun', 'die', 'Sie geht in die zweite Klasse.
She goes to second grade.', 619, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'solution', 'Lösung', ARRAY[]::text[], 'noun', 'die', 'Die Lösung ist ganz einfach.
The solution is simple.', 620, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pure, clear, clean', 'rein', ARRAY[]::text[], NULL, NULL, 'Das ist ja reines Wasser!
That is clear water!', 621, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'both...and', 'sowohl ... als auch', ARRAY[]::text[], NULL, NULL, 'Das betrifft sowohl Männer als auch Frauen.
This applies to both men and women.', 622, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be correct, vote, tune', 'stimmen', ARRAY[]::text[], NULL, NULL, 'Das kann nicht stimmen!
This cannot be correct.', 623, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nevertheless, anyway, however', 'trotzdem', ARRAY[]::text[], NULL, NULL, 'Ich habe trotzdem Angst.
I''m nonetheless scared', 624, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to behave, react (how one handles oneself)', 'Verhalten verhalten', ARRAY[]::text[], 'noun', 'das', 'Er wurde für sein ausgezeichnetes Verhalten an der Schule beglückwünscht. Das Kind verhielt sich auf der Hochzeit wie ein Erwachsener.
He was congratulated for his excellent conduct at school. The child behaved like an adult during the wedding.', 625, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'furthermore, besides, in addition', 'zudem', ARRAY[]::text[], NULL, NULL, 'Zudem hat er jahrelang im Ausland gearbeitet.
Besides, he worked abroad for years.', 626, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to report', 'berichten', ARRAY[]::text[], NULL, NULL, 'Die Zeitungen berichten von der Wahl.
The newspapers report of the election.', 627, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'height, altitude', 'Höhe', ARRAY[]::text[], 'noun', 'die', 'Quito liegt auf einer Höhe von 2800 Metern.
Quito is located at an altitude of 2800 meters.', 629, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'boy', 'Junge', ARRAY[]::text[], 'noun', 'der', 'Die Jungen spielen Fußball.
The boys are playing soccer.', 630, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to calculate, do arithmetic', 'rechnen', ARRAY[]::text[], NULL, NULL, 'Rechnen lernt man in der Schule.
You learn to do arithmetic in school.', 631, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scientific, scholarly', 'wissenschaftlich', ARRAY[]::text[], NULL, NULL, 'Wissenschaftliche Aufsätze sind oft schwer zu lesen.
Scientific essays are often hard to read.', 632, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to observe, watch', 'beobachten', ARRAY[]::text[], NULL, NULL, 'Beobachten Sie die Löwen bei der Fütterung!
Watch the lions at feeding time!', 633, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'window', 'Fenster', ARRAY[]::text[], 'noun', 'das', 'Er öffnet das Fenster.
He opens the window.', 634, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'air', 'Luft', ARRAY[]::text[], 'noun', 'die', 'Die Luft ist verschmutzt.
The air is polluted.', 635, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opinion', 'Meinung', ARRAY[]::text[], 'noun', 'die', 'Meiner Meinung nach dürfen wir das nicht.
In my opinion we are not allowed.', 636, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to experience', 'erleben', ARRAY[]::text[], NULL, NULL, 'Gleich kannst du was erleben!
Soon you''ll experience something.', 637, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'false, wrong', 'falsch', ARRAY[]::text[], NULL, NULL, 'Irgendwas habe ich falsch gemacht.
I did something wrong.', 638, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foreign, strange', 'fremd', ARRAY[]::text[], NULL, NULL, 'Das ist mir vollkommen fremd.
This is completely foreign to me.', 639, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get, fetch', 'holen', ARRAY[]::text[], NULL, NULL, 'Gehst du heute Brot holen?
Are you going to get bread today?', 640, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'idea', 'Idee', ARRAY[]::text[], 'noun', 'die', 'Ideen müsste man haben!
Ideas one should have!', 641, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unfortunately', 'leider', ARRAY[]::text[], NULL, NULL, 'Wir können leider nicht mitkommen.
Unfortunately, we cannot come.', 642, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'product', 'Produkt', ARRAY[]::text[], 'noun', 'das', 'Haferflocken sind ein natürliches Produkt.
Oatmeal is a natural product.', 643, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'French', 'französisch', ARRAY[]::text[], NULL, NULL, 'Deutsche finden den französischen Akzent erotisch.
Germans find the French accent erotic.', 644, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at least', 'mindestens', ARRAY[]::text[], NULL, NULL, 'Für den Kuchen braucht man mindestens drei Eier.
For the cake you need at least three eggs.', 645, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rare, rarely', 'selten', ARRAY[]::text[], NULL, NULL, 'Jens schaut selten fern.
Jens rarely watches TV.', 646, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'study, studies', 'Studium', ARRAY[]::text[], 'noun', 'das', 'Ihr Studium dauert drei Jahre.
Her studies take three years.', 647, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comparison', 'Vergleich', ARRAY[]::text[], 'noun', 'der', 'Im Vergleich zu dir geht es mir noch gut.
Compared to you, I still feel fine.', 648, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'means, remedy', 'Mittel', ARRAY[]::text[], 'noun', 'das', 'Dagegen gibt es ein Mittel.
There is a remedy against it.', 649, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'model', 'Modell', ARRAY[]::text[], 'noun', 'das', 'Im Foyer steht ein Modell des Gebäudes.
There is a model of the building in the foyer.', 650, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'normal', 'normal', ARRAY[]::text[], NULL, NULL, 'Heute ist ein ganz normaler Tag.
Today is quite a normal day.', 651, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at least', 'zumindest', ARRAY[]::text[], NULL, NULL, 'Zumindest der Chef sollte davon wissen.
At least the boss should know about it.', 652, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nature', 'Natur', ARRAY[]::text[], 'noun', 'die', 'Im Frühjahr erwacht die Natur zu neuem Leben.
In spring nature awakens to new life.', 653, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bed', 'Bett', ARRAY[]::text[], 'noun', 'das', 'Das Bett steht im Schlafzimmer.
The bed is in the bedroom.', 654, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to eat', 'essen', ARRAY[]::text[], NULL, NULL, 'Kinder essen gern Spaghetti.
Children like to eat spaghetti.', 655, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'customer, client', 'Kunde', ARRAY[]::text[], 'noun', 'der', 'Der Kunde ist König.
The customer is king.', 656, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employee, co-worker', 'Mitarbeiter', ARRAY[]::text[], 'noun', 'der', 'Alle Mitarbeiter wurden entlassen.
All employees were laid off.', 657, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reach, be enough', 'reichen', ARRAY[]::text[], NULL, NULL, 'Jetzt reicht es aber!
That''s enough!', 658, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to die', 'sterben', ARRAY[]::text[], NULL, NULL, 'Goethe starb 1832.
Goethe died in 1832', 659, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'death', 'Tod', ARRAY[]::text[], 'noun', 'der', 'Nach dem Tod seiner Frau zog Reinhard zu seinem Sohn.
After the death of his wife, Reinhard moved to his son.', 660, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to distinguish', 'unterscheiden', ARRAY[]::text[], NULL, NULL, 'Man unterscheidet zwischen Zitronen und Limetten.
We distinguish between lemons and limes.', 661, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'true', 'wahr', ARRAY[]::text[], NULL, NULL, 'Das kann doch nicht wahr sein!
This cannot be true!', 662, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'business', 'Geschäft', ARRAY[]::text[], 'noun', 'das', 'Mein Geschäft läuft wieder besser.
My business is going better.', 663, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to achieve (not: erreichen)', 'leisten', ARRAY[]::text[], NULL, NULL, 'Sie hat in ihrem Leben viel geleistet.
She has achieved a lot in her life.', 664, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'private', 'privat', ARRAY[]::text[], NULL, NULL, 'Das ist meine private Telefonnummer.
This is my private home phone number.', 665, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fun', 'Spaß', ARRAY[]::text[], 'noun', 'der', 'Das macht keinen Spaß.
That''s no fun.', 666, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dead', 'tot', ARRAY[]::text[], NULL, NULL, 'Wagner ist seit 121 Jahren tot.
Wagner has been dead for 121 years', 667, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'economy, commerce', 'Wirtschaft', ARRAY[]::text[], 'noun', 'die', 'Die Wirtschaft nimmt Einfluss auf die Politik.
The economy has an influence on politics.', 668, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'somewhere', 'irgendwo', ARRAY[]::text[], NULL, NULL, 'Irgendwo habe ich den Schlüssel hingelegt.
I put the key somewhere.', 669, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'animal', 'Tier', ARRAY[]::text[], 'noun', 'das', 'Tiger sind wilde Tiere.
Tigers are wild animals.', 670, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to request, demand (not: fordern)', 'verlangen', ARRAY[]::text[], NULL, NULL, 'Ich verlange nichts Unmögliches.
I demand nothing impossible.', 671, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to throw', 'werfen', ARRAY[]::text[], NULL, NULL, 'Ruben wirft Sophie den Ball auf den Kopf.
Ruben throws the ball on Sophies head.', 672, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'movement, motion', 'Bewegung', ARRAY[]::text[], 'noun', 'die', 'Er ist ständig in Bewegung.
He is constantly in motion.', 673, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'firm, solid', 'fest', ARRAY[]::text[], NULL, NULL, 'Sie hat eine feste Meinung.
She has a firm opinion.', 674, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'guest', 'Gast', ARRAY[]::text[], 'noun', 'der', 'Er ist mein Gast.
He is my guest.', 675, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'security, safety', 'Sicherheit', ARRAY[]::text[], 'noun', 'die', 'Sicherheit ist wichtiger als Schnelligkeit.
Safety is more important than speed.', 676, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'use, application, deployment', 'Einsatz', ARRAY[]::text[], 'noun', 'der', 'Reinigen Sie das Gerät nach jedem Einsatz.
Clean the appliance after every use.', 677, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'region, area', 'Gebiet', ARRAY[]::text[], 'noun', 'das', 'Dieses Gebiet ist unbewohnt.
This territory is uninhabited.', 678, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be, exist, to be available', 'vorliegen', ARRAY[]::text[], NULL, NULL, 'Das Dokument liegt in drei verschiedenen Dateiformaten vor.
The document exists in three different file formats.', 679, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to count', 'zählen', ARRAY[]::text[], NULL, NULL, 'Er kann schon von 1 bis 10 zählen.
He can already count 1 till 10.', 680, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gratefulness, thanks,', 'Dank', ARRAY[]::text[], 'noun', 'der', 'Grossen Dank für deine Geschenke.
Big thanks for your gifts.', 681, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'village', 'Dorf', ARRAY[]::text[], 'noun', 'das', 'Das Dorf liegt in einem Tal.
The village lies in a valley.', 682, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'colleague', 'Kollege', ARRAY[]::text[], 'noun', 'der', 'Die Kollegen treffen sich in der Mittagspause in der Kantine.
Colleagues meet for lunch at the canteen.', 683, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to want, wish', 'wünschen', ARRAY[]::text[], NULL, NULL, 'Ich wünsche mir ein Buch zu Weihnachten.
I want a book for Christmas.', 684, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'indication, specification', 'Angabe', ARRAY[]::text[], 'noun', 'die', 'Auf einer Verpackung sollte eine Angabe über den Preis des Produkts stehen.
A package should contain an indication of the price of the product.', 685, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to build', 'bauen', ARRAY[]::text[], NULL, NULL, 'Hier baut die Bundesregierung eine Autobahn.
The federal government is building a highway here.', 686, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'brother', 'Bruder', ARRAY[]::text[], 'noun', 'der', 'Sie hat keine Brüder.
She has no brothers.', 687, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hang', 'hängen', ARRAY[]::text[], NULL, NULL, 'Das Bild hängt an der Wand.
The picture hangs on the wall.', 688, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hope', 'hoffen', ARRAY[]::text[], NULL, NULL, 'Ich hoffe, dir geht es gut.
I hope you are well.', 689, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'positive', 'positiv', ARRAY[]::text[], NULL, NULL, 'Sie gab ein positives Urteil ab.
She gave a positive verdict.', 690, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'except, apart from', 'außer', ARRAY[]::text[], NULL, NULL, 'Außer ihm hat keiner hier gute Noten.
No one has good grades here, except him', 691, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be happy, to please', 'freuen', ARRAY[]::text[], NULL, NULL, 'Das wird ihn freuen.
That will please him.', 692, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to divide, share', 'teilen', ARRAY[]::text[], NULL, NULL, 'Der Äquator teilt die Erde in Nord- und Südhalbkugel.
The equator divides the earth into northern and southern hemispheres.', 693, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'order, decree, disposal', 'Verfügung', ARRAY[]::text[], 'noun', 'die', 'Das Gericht hat eine Verfügung erlassen.
The court issued a decree.', 694, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pay', 'bezahlen', ARRAY[]::text[], NULL, NULL, 'Kann ich mit Kreditkarte bezahlen?
Can I pay by credit card?', 695, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to last, take (time)', 'dauern', ARRAY[]::text[], NULL, NULL, 'Die Vorstellung dauert zwei Stunden.
The show lasts two hours.', 696, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'compartment, subject', 'Fach', ARRAY[]::text[], 'noun', 'das', 'Welche Fächer studierst du? Der Spind hat ein Fach für persönliche Gegenstände.
What subjects do you study? The locker has a compartment for personal items.', 698, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'heart', 'Herz', ARRAY[]::text[], 'noun', 'das', 'Die Ärztin unternahm eine komplizierte Operation am Herzen.
The doctor attempted a complicated heart surgery.', 699, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'contact', 'Kontakt', ARRAY[]::text[], 'noun', 'der', 'Wir müssen den Kontakt herstellen.
We need to make contact.', 700, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quantity, amount', 'Menge', ARRAY[]::text[], 'noun', 'die', 'Der Preis hängt von der gekauften Menge ab. Die Medizin ist harmlos in kleinen Mengen.
The price depends on the quantity bought. The medicine is harmless in small quantities.', 701, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put, to plug', 'stecken', ARRAY[]::text[], NULL, NULL, 'Er zählte das Geld und steckte es in seine Geldbörse. Stecken Sie den Stecker in die Buchse, um das Gerät einzuschalten.
He counted the money and put it in his wallet. Plug the connector into the socket in order to switch on the device.', 702, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to visit', 'besuchen', ARRAY[]::text[], NULL, NULL, 'Morgen besuche ich meine Schwiegereltern.
I visit my in-laws tomorrow.', 703, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'summer', 'Sommer', ARRAY[]::text[], 'noun', 'der', 'Im Sommer habe ich Geburtstag.
My birthday is in the summer.', 704, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'difference', 'Unterschied', ARRAY[]::text[], 'noun', 'der', 'Es gibt große Unterschiede zwischen Europa und Asien.
There are big differences between Europe and Asia.', 705, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'central', 'zentral', ARRAY[]::text[], NULL, NULL, 'Das zentrale Problem sind die Kosten.
The central problem are the cost.', 706, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the claim, entitlement', 'Anspruch', ARRAY[]::text[], 'noun', 'der', 'Er hat keinen Anspruch auf das Haus.
He cannot claim the house.', 707, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'answer, reply', 'Antwort', ARRAY[]::text[], 'noun', 'die', 'Ich habe ihm noch keine Antwort gegeben.
I have not answered him yet.', 708, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to request, ask', 'bitten', ARRAY[]::text[], NULL, NULL, 'Ich bitte dich um einen kleinen Gefallen.
I ask you for a small favor.', 709, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to worry, take care', 'sorgen', ARRAY[]::text[], NULL, NULL, 'Ich sorge mich um meine Schwester.
I worry about my sister.', 710, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instead of', 'statt', ARRAY[]::text[], NULL, NULL, 'Das Buch kostet 9 statt 12 Euro.
The book costs 9 instead of 12 €.', 711, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'connection, link', 'Verbindung', ARRAY[]::text[], 'noun', 'die', 'Es gibt keine Verbindung zwischen hier und dort.
There is no connection between here and there.', 712, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'idea, introduction, performance', 'Vorstellung', ARRAY[]::text[], 'noun', 'die', 'Ich habe eine andere Vorstellung davon, was wir machen sollen.
I have a different idea of what to do.', 713, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arrive', 'ankommen', ARRAY[]::text[], NULL, NULL, 'Der Brief ist angekommen.
The letter has arrived.', 714, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'application, use', 'Anwendung', ARRAY[]::text[], 'noun', 'die', 'Dieses Computerprogramm kommt oft zur Anwendung.
This computer program is used often.', 715, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to refer, put, get', 'beziehen', ARRAY[]::text[], NULL, NULL, 'Ich beziehe mich darauf, was sie gesagt hat.
I am referring to what she said.', 716, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'finished, ready', 'fertig', ARRAY[]::text[], NULL, NULL, 'Das Essen ist fertig!
The food is ready!', 717, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sense, notice', 'spüren', ARRAY[]::text[], NULL, NULL, 'Pferde spüren ein nahendes Erdbeben.
Horses sense an approaching earthquake.', 718, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'neither...nor', 'weder...noch', ARRAY[]::text[], NULL, NULL, 'Nico isst weder Fisch noch Fleisch.
Nico eats neither fish nor meat.', 719, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'age', 'Alter', ARRAY[]::text[], 'noun', 'das', 'Sie starb im Alter von 75 Jahren.
She died at the age of 75.', 720, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fundamental, basically', 'grundsätzlich', ARRAY[]::text[], NULL, NULL, 'Ich bin grundsätzlich anderer Meinung.
I basically disagree.', 721, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'costs, expenses', 'Kosten', ARRAY[]::text[], 'noun', 'die', 'Die Kosten für die Reise übernimmt die Firma.
The company covers the costs of the trip.', 722, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the patient', 'Patient', ARRAY[]::text[], 'noun', 'der', 'Der Arzt untersucht einen Patienten.
The doctor examines a patient.', 723, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'police', 'Polizei', ARRAY[]::text[], 'noun', 'die', 'Die Polizei erreicht den Unfallort zuerst.
The police reaches the scene of the accident first.', 724, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'theatre', 'Theater', ARRAY[]::text[], 'noun', 'das', 'Das Theater ist eines der schönsten Gebäude der Stadt.
The theater is one of the most beautiful buildings in the city.', 725, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '[at] first', 'zuerst', ARRAY[]::text[], NULL, NULL, 'Zuerst studiere ich, dann mache ich ein Praktikum.
First I study, then I ''ll do an internship.', 726, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'training, development, apprenticeship', 'Ausbildung', ARRAY[]::text[], 'noun', 'die', 'Laura ist noch in der Ausbildung.
Laura is still in training.', 727, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wide, broad', 'breit', ARRAY[]::text[], NULL, NULL, 'Ein breiter Fluss trennt uns von unserem Ziel.
A broad river separates us from our destination.', 728, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to raise, increase', 'erhöhen', ARRAY[]::text[], NULL, NULL, 'Wir müssen unser Angebot erhöhen.
We have to increase our offer.', 729, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hard', 'hart', ARRAY[]::text[], NULL, NULL, 'Das Leben ist hart.
Life is hard.', 730, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'available, existing', 'vorhanden', ARRAY[]::text[], NULL, NULL, 'Es ist kein Papier mehr vorhanden.
There is no paper available.', 731, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'danger', 'Gefahr', ARRAY[]::text[], 'noun', 'die', 'Er war in großer Gefahr.
He was in great danger.', 732, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tool, piece of equipment, appliance, device', 'Gerät', ARRAY[]::text[], 'noun', 'das', 'Ein Thermometer ist ein Gerät zur Temparaturmessung.
A thermometer is a device for temperature measurements.', 733, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'internal', 'innere', ARRAY['s)']::text[], NULL, NULL, 'Das ist eine innere Angelegenheit.
This is an internal affair.', 734, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'kilometre', 'Kilometer', ARRAY[]::text[], 'noun', 'der', 'Von Leipzig nach München sind es etwa 430 Kilometer.
From Leipzig to Munich it is about 430 kilometers.', 735, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'absolutely', 'unbedingt', ARRAY[]::text[], NULL, NULL, 'Ich muss den Zug unbedingt kriegen.
I absolutely need to get the train.', 736, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'help', 'Hilfe', ARRAY[]::text[], 'noun', 'die', 'Wir hoffen auf eure Hilfe.
We are hoping for your help.', 737, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to report, register', 'melden', ARRAY[]::text[], NULL, NULL, 'Der Wetterbericht meldet Schnee für das Wochenende.
The weather reports snow for the weekend.', 738, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'computer', 'Computer', ARRAY[]::text[], 'noun', 'der', 'Ich arbeite jeden Tag am Computer.
I work at the computer every day.', 739, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dollar', 'Dollar', ARRAY[]::text[], 'noun', 'der', 'Der Dollar steht gut im Kurs.
The dollar does well at the exchange.', 740, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'out (not: furthermore, in addition)', '[darüber] hinaus', ARRAY[]::text[], NULL, NULL, 'Sie ging durch die Hintertür hinaus. Darüber hinaus gibt es nichts zu berichten.
She went out by the back door. In addition, there is nothing to report.', 741, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'future (as adjective)', 'künftig', ARRAY[]::text[], NULL, NULL, 'Auch künftige Generationen müssen auf dieser Welt noch leben können.
Future generations must be able to live in this world.', 742, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'method, process, technique', 'Verfahren', ARRAY[]::text[], 'noun', 'das', 'Dieses Verfahren ist am effektivsten.
This method is the most effective.', 743, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'contract', 'Vertrag', ARRAY[]::text[], 'noun', 'der', 'Der Vertrag gilt ab 1. Januar 2006.
The contract is valid from 1 January 2006.', 744, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to happen, occur, seem (to have come to be)', 'vorkommen', ARRAY[]::text[], NULL, NULL, 'Fälle von Korruption kommen auch im Bundestag vor.
Cases of corruption also occur in the Bundestag.', 745, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'last, in the end', 'zuletzt', ARRAY[]::text[], NULL, NULL, 'Zuletzt hat Bruno als Kellner gearbeitet.
In the end, Bruno has worked as a waiter.', 746, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to own, have', 'besitzen', ARRAY[]::text[], NULL, NULL, 'Diese Methode besitzt großes Potenzial.
This method has great potential.', 748, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stress, underline, highlight, emphasize', 'betonen', ARRAY[]::text[], NULL, NULL, 'Der Professor betont noch einmal, dass das Seminar Pflicht ist.
The professor emphasizes again, that the seminar is mandatory.', 749, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nevertheless', 'dennoch', ARRAY[]::text[], NULL, NULL, 'Gregor hat sich große Mühe gegeben, dennoch hat er die Prüfung nicht bestanden.
Gregory has been working very hard, nevertheless he has not passed the test.', 750, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grant, fulfil', 'erfüllen', ARRAY[]::text[], NULL, NULL, 'Alle Bedingungen müssen erfüllt werden.
All conditions have to be fulfilled.', 751, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'historical', 'historisch', ARRAY[]::text[], NULL, NULL, 'In jeder Generation kommt es zu historischen Ereignissen.
In every generation there are historical events.', 752, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scarce, slim, almost,', 'knapp', ARRAY[]::text[], NULL, NULL, 'Die Partei hat mit knapper Mehrheit gewonnen.
The party won by a slim majority.', 753, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rather', 'lieber', ARRAY[]::text[], NULL, NULL, 'Ich esse lieber Birnen als Äpfel.
I rather eat pears than apples.', 754, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'measure (the precaution)', 'Maßnahme', ARRAY[]::text[], 'noun', 'die', 'Jetzt müssen geeignete Maßnahmen zum Hochwasserschutz getroffen werden.
Now appropriate steps/measures have to be taken for flood protection.', 755, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'middle', 'Mitte', ARRAY[]::text[], 'noun', 'die', 'Kassel liegt in der Mitte Deutschlands.
Kassel is situated in the heart of Germany.', 756, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'October', 'Oktober', ARRAY[]::text[], 'noun', 'der', 'Im Oktober ist Erntedankfest.
Harvest festival is in October.', 757, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'order, tidiness', 'Ordnung', ARRAY[]::text[], 'noun', 'die', 'Ordnung ist das halbe Leben.
Order is half of life.', 758, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'so that', 'sodass', ARRAY[]::text[], NULL, NULL, 'Ich arbeite heute den ganzen Tag über, sodass ich am Abend Zeit für dich habe.
I work all day today, so that I have time for you in the evening.', 759, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'material, substance, fabric', 'Stoff', ARRAY[]::text[], 'noun', 'der', 'Samt ist ein sehr weicher Stoff.
Velvet is a very soft material.', 760, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'both, at the same time (not: gleichzeitig)', 'zugleich', ARRAY[]::text[], NULL, NULL, 'Es ist kalt, zugleich weht ein starker Wind aus Nord.
It is cold, at the same time a strong wind blows from the north.', 761, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'beginning (not: Anfang)', 'Beginn', ARRAY[]::text[], 'noun', 'der', 'Der Beginn der Sommerzeit ist Ende März.
The start of daylight saving time is in late March.', 762, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'luck, fortune', 'Glück', ARRAY[]::text[], 'noun', 'das', 'Alles Gute und viel Glück zum Geburtstag!
Happy Birthday and good luck!', 763, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'weekend', 'Wochenende', ARRAY[]::text[], 'noun', 'das', 'Am Wochenende fahren wir aufs Land.
On weekends we go to the country.', 764, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'professor', 'Professor', ARRAY[]::text[], 'noun', 'der', 'Der Professor betreut viele Studierende.
The professor supervises many students.', 765, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'row, line', 'Reihe', ARRAY[]::text[], 'noun', 'die', 'Stellt euch bitte in einer Reihe auf!
Please line up in a row.', 766, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'west', 'Westen', ARRAY['West']::text[], 'noun', 'der', 'Im Westen ist die Arbeitslosigkeit niedriger als im Osten.
In the West, the unemployment rate is lower than in the East.', 767, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to participate, take part in,', '[sich] beteiligen', ARRAY[]::text[], NULL, NULL, 'Viele Studenten beteiligten sich an der Demonstration.
Many students took part in the demonstration.', 768, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'population, people', 'Bevölkerung', ARRAY[]::text[], 'noun', 'die', 'Die Bevölkerung verlangt Reformen.
The population is demandanding reforms.', 769, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'while, by', 'indem', ARRAY[]::text[], NULL, NULL, 'Tim hält sich gesund, indem er viel Sport treibt.
Tim keeps healthy by exercising a lot.', 770, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'institute', 'Institut', ARRAY[]::text[], 'noun', 'das', 'Am Institut für Linguistik lehrt ein Gastprofessor aus den USA.
A professor from the United States is teaching at the Institute of Linguistics.', 771, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to notice to remember', 'etw merken sichetwasmerken', ARRAY[]::text[], NULL, NULL, 'Ich muss mir das Rezept für den leckeren Kuchen merken.
I have to remember the recipe for the delicious cake.', 772, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'again', 'nochmal', ARRAY[]::text[], NULL, NULL, 'Ich habe den Film nochmal gesehen.
I saw the movie again.', 773, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'east', 'Osten', ARRAY['Ost']::text[], 'noun', 'der', 'Im Osten geht die Sonne auf.
The sun rises in the east.', 774, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fit', 'passen', ARRAY[]::text[], NULL, NULL, 'Der Deckel passt nicht auf den Topf.
The lid does not fit the pot.', 775, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'current (not: jetzig)', 'aktuell', ARRAY[]::text[], NULL, NULL, 'Die aktuellsten Daten findet man im Internet.
The current information can be found on the Internet.', 777, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thanks', 'danke', ARRAY[]::text[], NULL, NULL, 'Danke für deine Hilfe!
Thank you for your help!', 778, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at the moment,currently', 'derzeit', ARRAY[]::text[], NULL, NULL, 'Derzeit wiederholt das Fernsehen eine Serie aus den 80er Jahren.
Currently, the television repeats a series from the 80s.', 779, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be suitable', 'eignen', ARRAY[]::text[], NULL, NULL, 'Dieses Messer eignet sich sehr gut zum Brotschneiden.
This knife is suitable for cutting bread.', 780, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'earth, ground, soil', 'Erde', ARRAY[]::text[], 'noun', 'die', 'Die Erde bewegt sich um die Sonne.
The Earth moves around the sun.', 781, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comform, comply, follow', 'richten', ARRAY[]::text[], NULL, NULL, 'Ich richte mich nicht nach deinen Wünschen. Ich richtete die Kamera auf meinen Freund und machte das Foto.
I don''t follow your wishes. I pointed the camera at my friend and took the photo.', 782, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to include, consist of', 'umfassen', ARRAY[]::text[], NULL, NULL, 'Das Menü umfasst fünf Gänge.
The menu includes five courses.', 783, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plane, level', 'Ebene', ARRAY[]::text[], 'noun', 'die', 'Dieses Problem muss man auf verschiedenen Ebenen betrachten.
This problem must be considered at different levels.', 784, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'something, anything', 'irgendetwas', ARRAY['irgendwas']::text[], NULL, NULL, 'Irgendwas hier riecht verbrannt.
Something smells burnt.', 785, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'journey, trip', 'Reise', ARRAY[]::text[], 'noun', 'die', 'Anschließend unternahm er eine Reise nach Italien.
Afterwards he went on a trip to Italy.', 786, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sleep', 'schlafen', ARRAY[]::text[], NULL, NULL, 'Ich schlafe acht Stunden pro Tag.
I sleep eight hours a day.', 787, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'remaining, left', 'übrig', ARRAY[]::text[], NULL, NULL, 'Es ist nichts mehr von der Suppe übrig.
There''s nothing left of the soup.', 788, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to support', 'unterstützen', ARRAY[]::text[], NULL, NULL, 'Die Eltern unterstützen ihre Tochter während ihres Studiums finanziell.
The parents support their daughter financially while studying.', 789, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'before', 'zuvor', ARRAY[]::text[], NULL, NULL, 'Ich habe gleich ein Seminar, zuvor muss ich noch etwas kopieren.
I have a seminar shortly, but before, I have to make a copy.', 790, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unity, unit', 'Einheit', ARRAY[]::text[], 'noun', 'die', 'Die Deutsche Einheit kam für viele überraschend.
German unity came as a surprise to many.', 791, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hair', 'Haar', ARRAY[]::text[], 'noun', 'das', 'Ich lasse mir heute meine Haare schneiden.
I am getting a hair cut today.', 792, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to smile', 'lächeln', ARRAY[]::text[], NULL, NULL, 'Bitte lächeln Sie in die Kamera!
Please smile into the camera!', 793, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Monday', 'Montag', ARRAY[]::text[], 'noun', 'der', 'Am Montag beginnt die Arbeitswoche.
The work week begins on Monday.', 794, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'vicinity, proximity', 'Nähe', ARRAY[]::text[], 'noun', 'die', 'Die Nähe zur Innenstadt macht die Wohnung attraktiv.
The proximity to downtown makes the apartment attractive.', 795, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'principle', 'Prinzip', ARRAY[]::text[], 'noun', 'das', 'Ich esse aus Prinzip kein Fleisch.
I do not eat meat as a matter of principle.', 796, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bad, serious', 'schlimm', ARRAY[]::text[], NULL, NULL, 'Am nächsten Tag bekam er eine schlimme Nachricht.
He got bad news the following day.', 797, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'partly', 'teilweise', ARRAY[]::text[], NULL, NULL, 'Diabetes ist teilweise genetisch bedingt.
Diabetes is partly genetic.', 798, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'advantage', 'Vorteil', ARRAY[]::text[], 'noun', 'der', 'Der Vorteil dieser Methode ist offensichtlich.
The advantage of this method is obvious.', 799, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to employ, be busy, deal with (busy oneself with)', 'beschäftigen', ARRAY[]::text[], NULL, NULL, 'Mit solchen Sachen beschäftige ich mich nicht. Unsere Firma beschäftigt Spezialisten aus aller Welt.
I don''t deal with things like those. Our company employs experts from all over the world.', 800, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hence, from it', 'daraus', ARRAY[]::text[], NULL, NULL, 'Das ist mein Glas, wer hat daraus getrunken? Daraus ist zu ersehen, dass Vorsicht am Platze ist
That''s my glass, who drank from it? Hence it can be seen that caution is in place', 801, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to solve, loosen', 'lösen', ARRAY[]::text[], NULL, NULL, 'Probleme löst man am besten gemeinsam.
It is best to solve problems together.', 802, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'structure', 'Struktur', ARRAY[]::text[], 'noun', 'die', 'An der föderalen Struktur Deutschlands sollte nicht gerüttelt werden.
The federal structure of Germany should not be shaken.', 803, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to answer', 'antworten', ARRAY[]::text[], NULL, NULL, 'Anna antwortet auf die Frage ihrer Lehrerin.
Anna answers the teacher''s question.', 804, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'author', 'Autor', ARRAY[]::text[], 'noun', 'der', 'Thomas Brussig ist ein zeitgenössischer deutscher Autor.
Thomas Brussig is a contemporary German author.', 805, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'condition', 'Bedingung', ARRAY[]::text[], 'noun', 'die', 'Unter solchen Bedingungen kann ich nicht arbeiten. Die Bedingungen fürs Segeln sind heute ideal.
Under such conditions, I cannot work. Conditions are ideal for sailing today.', 806, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dear, kind', 'lieb', ARRAY[]::text[], NULL, NULL, 'Alina ist ein liebes Kind.
Alina is a kind kid.', 807, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'with each other, together', 'miteinander', ARRAY[]::text[], NULL, NULL, 'Die Kinder spielen miteinander im Sandkasten.
The children play together in the sandbox.', 808, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'risk', 'Risiko', ARRAY[]::text[], 'noun', 'das', 'Das Risiko, vom Rauchen Lungenkrebs zu bekommen, ist sehr hoch.
The risk of getting lung cancer from smoking is very high.', 809, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to separate', 'trennen', ARRAY[]::text[], NULL, NULL, 'Die Mauer trennte die beiden deutschen Staaten.
The wall separated the two German states.', 810, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'choice, election', 'Wahl', ARRAY[]::text[], 'noun', 'die', 'Wer die Wahl hat, hat die Qual.
Who has the choice, has the agony', 811, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'effect (not: das Ergebnis)', 'Wirkung', ARRAY[]::text[], 'noun', 'die', 'Alkohol hat keine große Wirkung auf mich.
Alcohol has no big effect on me.', 812, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'letter', 'Brief', ARRAY[]::text[], 'noun', 'der', 'Ein Brief kostet 55 Cent Porto.
A letter costs 55 cents in postage.', 813, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to adjust, employ, stop', 'einstellen', ARRAY[]::text[], NULL, NULL, 'Ich kann mich gut auf Veränderungen einstellen.
I can adjust well to changes.', 814, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'size, height', 'Größe', ARRAY[]::text[], 'noun', 'die', 'Die Miete hängt von der Größe der Wohnung ab.
The rent depends on the size of the apartment.', 815, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to love', 'lieben', ARRAY[]::text[], NULL, NULL, 'Ich liebe Picknicks im Park.
I love picnics in the park.', 816, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'media', 'Medien', ARRAY[]::text[], 'noun', 'die', 'In den Medien wird über den neuen Bestseller berichtet.
The media reports on the new bestseller.', 817, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Sunday', 'Sonntag', ARRAY[]::text[], 'noun', 'der', 'Am Sonntag haben die Läden geschlossen.
The shops are closed on Sunday.', 818, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dark', 'dunkel', ARRAY[]::text[], NULL, NULL, 'Draußen wird es schon dunkel.
Outside it''s getting dark already.', 819, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'absolutely, by all means', 'durchaus', ARRAY[]::text[], NULL, NULL, 'Ich bin durchaus deiner Meinung, würde aber gerne noch etwas warten mit der Entscheidung. Das ist durchaus eine gute Frage.
I absolutely agree with your opinion, but would like to wait a bit with the decision. This is by all means a good question.', 820, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to carry out, hold', 'durchführen', ARRAY[]::text[], NULL, NULL, 'Wir führen in diesem Monat keine Kurse mehr durch.
We don''t carry out any more classes this month.', 821, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be sufficient, enough', 'genügen', ARRAY[]::text[], NULL, NULL, 'Eine Tasse Kaffee pro Tag genügt mir.
A cup of coffee a day is enough for me.', 822, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'according to', 'laut', ARRAY[]::text[], NULL, NULL, 'Laut Fahrplan müsste der Zug jeden Moment kommen.
According to the schedule the train should be coming any moment.', 823, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'power, strength', 'Macht', ARRAY[]::text[], 'noun', 'die', 'Die Presse ist die vierte Macht im Staate.
The press is the fourth power in the state.', 824, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mostly, usually', 'meistens', ARRAY[]::text[], NULL, NULL, 'Meistens fahre ich mit dem Rad zur Uni.
I usually ride the bike to the university.', 825, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'obvious', 'offenbar', ARRAY[]::text[], NULL, NULL, 'Hier handelt es sich offenbar um einen Fehler.
There is obviously a mistake.', 826, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'right', 'rechte', ARRAY['s)']::text[], NULL, NULL, 'In Deutschland fährt man auf der rechten Straßenseite.
In Germany we drive on the right side of the road.', 827, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'examination, investigation', 'Untersuchung', ARRAY[]::text[], 'noun', 'die', 'Die Untersuchung findet am Montag statt.
The investigation takes place on Monday.', 828, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'change', 'Veränderung', ARRAY[]::text[], 'noun', 'die', 'Ich kann mich schwer auf Veränderungen einstellen.
I seriously cannot adapt to changes.', 829, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to build up', 'aufbauen', ARRAY[]::text[], NULL, NULL, 'Die Bürger bauen die Kirche nach der Zerstörung wieder auf.
The citizens are rebuilding the church after the destruction.', 830, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to confirm, endorse', 'bestätigen', ARRAY[]::text[], NULL, NULL, 'Das Gericht bestätigt seine Unschuld.
The court confirmed his innocence.', 831, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'data', 'Daten', ARRAY[]::text[], 'noun', 'die', 'Derzeit liegen uns keine Daten zu diesem Fall vor.
Currently we have no data for this case.', 832, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'therefore, that’s why (not: deshalb)', 'deswegen', ARRAY[]::text[], NULL, NULL, 'Ich habe keine Zeit zu lernen, deswegen verschiebe ich die Prüfung.
I don''t have time to study, that''s why I am moving the test.', 833, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'influence', 'Einfluss', ARRAY[]::text[], 'noun', 'der', 'Der Einfluss der extremen Parteien nimmt zu.
The influence of extreme parties is increasing.', 834, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'method', 'Methode', ARRAY[]::text[], 'noun', 'die', 'Spazierengehen ist eine gute Methode, um sich zu entspannen.
Walking is a great method to relax.', 835, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'organization', 'Organisation', ARRAY[]::text[], 'noun', 'die', 'Die Organisation der Olympischen Spiele dauerte länger als gedacht.
The organization of the Olympic Games took longer than expected.', 836, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'everywhere', 'überall', ARRAY[]::text[], NULL, NULL, 'Überall freuen sich die Kinder auf die Ferien.
Everywhere the children are excited for the vacation.', 837, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to examine', 'untersuchen', ARRAY[]::text[], NULL, NULL, 'Der Biologe untersucht Pflanzen und Tiere.
The biologist examines plants and animals.', 838, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'numerous', 'zahlreich', ARRAY[]::text[], NULL, NULL, 'Zahlreiche Touristen verlassen das Land.
Numerous tourists are leaving the country.', 839, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the other hand', 'einerseits', ARRAY['andererseits']::text[], NULL, NULL, 'Er ist einerseits sehr erfolgreich, andererseits aber auch sehr unglücklich.
On one hand he is very successful, but on the other hand also very unhappy.', 840, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'successful', 'erfolgreich', ARRAY[]::text[], NULL, NULL, 'Er hat eine erfolgreiche Managerlaufbahn hinter sich.
He has a successful management career behind him.', 841, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'concrete, precise', 'konkret', ARRAY[]::text[], NULL, NULL, 'Nächste Woche ist keine sehr konkrete Zeitangabe.
Next week is not a very precise time specification.', 842, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'love', 'Liebe', ARRAY[]::text[], 'noun', 'die', 'Seine Liebe zur Musik ist grenzenlos.
His love for music is unlimited.', 843, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'speech, talk, monologue', 'Rede', ARRAY[]::text[], 'noun', 'die', 'Der Direktor hielt zum Ende des Schuljahres eine Rede.
The principal gave a speech at the term''s end.', 844, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sport', 'Sport', ARRAY[]::text[], 'noun', 'der', 'Sport ist gesund.
Sport is healthy.', 845, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sell', 'verkaufen', ARRAY[]::text[], NULL, NULL, 'Ich muss einige Bücher verkaufen, weil ich Geld brauche.
I have to sell some books, because I need the money.', 846, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'world-wide', 'weltweit', ARRAY[]::text[], NULL, NULL, 'Weltweit steigt die Gefahr einer Klimakatastrophe.
The risk of climate catastrophe increases worldwide.', 847, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'moment', 'Augenblick', ARRAY[]::text[], 'noun', 'der', 'Genieße den Augenblick!
Enjoy the moment!', 848, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to look (not: schauen, kucken)', 'blicken', ARRAY[]::text[], NULL, NULL, 'Rainer blickt immer nach vorne.
Rainer is always looking forward.', 849, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'discussion, debate', 'Diskussion', ARRAY[]::text[], 'noun', 'die', 'Die Diskussion dauerte bis zum späten Abend.
The discussion lasted until late evening.', 850, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to press, push', 'drücken', ARRAY[]::text[], NULL, NULL, 'Sie müssen diesen Knopf hier drücken!
You have to push this button here!', 851, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take, to form', 'eingehen', ARRAY[]::text[], NULL, NULL, 'Er hat eine Bereitschaft gezeigt, Risiken einzugehen. Die Firmen gingen eine Allianz ein, um den Handel zu fördern.
He has shown a disposition to take risks. The companies formed an alliance to boost trade.', 852, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to allow, permit (not: dürfen)', 'erlauben', ARRAY[]::text[], NULL, NULL, 'Die Eltern erlauben ihren Kindern, bis um neun draußen zu bleiben.
The parents allow their children to stay outside until nine.', 853, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'demand, claim meet the demands', 'Forderung', ARRAY['Forderungen nachkommen']::text[], 'noun', 'die', 'Der Chef kommt den Forderungen zur Gehaltserhöhung nicht nach.
The boss is not meeting the demand for a salary increase.', 854, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'born', 'geboren', ARRAY[]::text[], NULL, NULL, 'Meine Mutter wurde 1953 geboren.
My mother was born in 1953.', 855, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'circle, district,', 'Kreis', ARRAY[]::text[], 'noun', 'der', 'Ein Kreis ist rund.
A circle is round.', 856, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'human', 'menschlich', ARRAY[]::text[], NULL, NULL, 'Irren ist menschlich.
To err is human.', 857, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'regular', 'regelmäßig', ARRAY[]::text[], NULL, NULL, 'Ich nehme regelmäßig an Fachtagungen teil.
I attend conferences regularly.', 858, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'technology, technique', 'Technik', ARRAY[]::text[], 'noun', 'die', 'Die neue Technik ist effektiver als die alte.
The new technique is more effective than the old one.', 859, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attempt, experiment', 'Versuch', ARRAY[]::text[], 'noun', 'der', 'Ihr erster Versuch, die Prüfung zu bestehen, scheiterte.
Her first attempt to pass the test failed.', 860, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'active', 'aktiv', ARRAY[]::text[], NULL, NULL, 'Wir treiben in unserer Freizeit aktiv Sport.
We perform active exercises in our spare time.', 861, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be sufficient, to be enough (not: genügen)', 'ausreichen', ARRAY[]::text[], NULL, NULL, 'Sein Lohn reicht oft nicht aus.
His salary is often not enough.', 862, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to remain silent', 'schweigen', ARRAY[]::text[], NULL, NULL, 'Der Bundeskanzler schweigt über diverse Probleme.
The Chancellor remains silent on several issues.', 863, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to treat', 'behandeln', ARRAY[]::text[], NULL, NULL, 'Der Artikel behandelt das Thema der interkulturellen Kommunikation.
The article treats the topic of intercultural communication.', 864, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'illness, disease', 'Krankheit', ARRAY[]::text[], 'noun', 'die', 'Vielen Krankheiten kann man mit Penicillin begegnen.
Many diseases can be treated with penicillin.', 865, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'difficulty', 'Schwierigkeit', ARRAY[]::text[], 'noun', 'die', 'Die Schwierigkeiten bestehen in der Übersetzung einiger Fachwörter.
The difficulties are in the translation of some technical terms.', 866, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'state, government, national', 'staatlich', ARRAY[]::text[], NULL, NULL, 'Studenten erhalten eine staatliche Förderung.
Students receive state support.', 867, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'activity', 'Tätigkeit', ARRAY[]::text[], 'noun', 'die', 'Er geht keiner geregelten Tätigkeit nach.
He does not pursue any regulated activity.', 868, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to drive, pursue, to float', 'treiben', ARRAY[]::text[], NULL, NULL, 'Die Nachfrage treibt die Preise in die Höhe. Holz treibt im Wasser
The demand drives up the prices. Wood floats on water.', 869, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to convince', 'überzeugen', ARRAY[]::text[], NULL, NULL, 'Ich muss meinen Freund noch von meinen Plänen überzeugen.
I have yet to convince my friend with my plans.', 870, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'condition, requirement (not: Bedingung)', 'Voraussetzung', ARRAY[]::text[], 'noun', 'die', 'Der Vertrag ist nur unter bestimmten Voraussetzungen gültig.
The contract is only valid under certain conditions.', 871, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to use', 'benutzen', ARRAY[]::text[], NULL, NULL, 'Ich benutze nur biologisch abbaubares Waschmittel.
I only use biodegradable detergents.', 872, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to threaten, lurk, impend', 'drohen', ARRAY[]::text[], NULL, NULL, 'Der Sturm droht die Ernte zu vernichten.
The storm threatens to destroy the crops.', 873, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'former', 'ehemalig', ARRAY[]::text[], NULL, NULL, 'Auf einem Klassentreffen treffen sich ehemalige Mitschüler.
Former classmates meet at a class reunion.', 874, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cold', 'kalt', ARRAY[]::text[], NULL, NULL, 'Mir ist kalt.
I''m cold.', 875, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fight, struggle', 'Kampf', ARRAY[]::text[], 'noun', 'der', 'Der Kampf zwischen Arbeitgebern und Arbeitnehmern geht weiter.
The struggle between employers and employees continues.', 876, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'long since, a long time ago, already', 'längst', ARRAY[]::text[], NULL, NULL, 'Mein Sohn kann längst Fahrrad fahren.
My son can already ride a bike.', 878, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'region', 'Region', ARRAY[]::text[], 'noun', 'die', 'In der Region ist die Infrastruktur mangelhaft.
The region''s infrastructure is poor.', 879, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'always (not: immer)', 'stets', ARRAY[]::text[], NULL, NULL, 'Das Kinoprogramm findet man stets aktuell im Internet.
The theater schedule can always be found on the internet.', 880, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to promise', 'versprechen', ARRAY[]::text[], NULL, NULL, 'Sie verspricht ihm, nicht mehr zu rauchen.
She promises him to stop smoking.', 881, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'impression', 'Eindruck', ARRAY[]::text[], 'noun', 'der', 'Ich habe den Eindruck, dass er ein schlechtes Gedächtnis hat.
I have the impression that he has a bad memory.', 883, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to discover', 'entdecken', ARRAY[]::text[], NULL, NULL, 'Forscher haben eine neue Affenart entdeckt.
Researchers have discovered a new species of ape.', 884, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'particular, respective', 'jeweilig', ARRAY[]::text[], NULL, NULL, 'Die Schüler gehen nach der Pause in ihre jeweiligen Zimmer zurück.
After the break the students go back to their particular rooms.', 885, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sound', 'klingen', ARRAY[]::text[], NULL, NULL, 'Deine Ausrede klingt nicht sehr überzeugend.
Your excuse does not sound very convincing.', 886, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to react', 'reagieren', ARRAY[]::text[], NULL, NULL, 'Auf manche Leute reagiert mein Hund aggressiv.
My dog reacts aggressive to some people.', 887, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reaction', 'Reaktion', ARRAY[]::text[], 'noun', 'die', 'Ich kann seine Reaktion verstehen.
I can understand his reaction.', 888, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'contribution', 'Beitrag', ARRAY[]::text[], 'noun', 'der', 'Die Mitglieder zahlen einen monatlichen Beitrag.
Members pay a monthly fee.', 889, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'under it, beneath / among them', 'darunter', ARRAY[]::text[], NULL, NULL, 'Es waren viele Gäste da, darunter ein paar Kinder. Um zu sehen, was sich darunter befindet, muss man die Abdeckung hochheben.
There were many guests, among them a few children. To see what is beneath, you need to lift the cover.', 890, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'required, necessary (not: nötig)', 'erforderlich', ARRAY[]::text[], NULL, NULL, 'Für ein Studium in Deutschland sind gute Deutschkenntnisse erforderlich.
To study in Germany a good knowledge of German is required.', 891, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'present-day, today’s', 'heutig', ARRAY[]::text[], NULL, NULL, 'Die heutige Situation ist völlig anders als die damalige.
Today''s situation is completely different than the former.', 892, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'draft, plan, concept (not: Entwurf)', 'Konzept', ARRAY[]::text[], 'noun', 'das', 'Das Konzept für den neuen Studiengang ist noch nicht fertig.
The concept for the new course of studies is not finished yet.', 893, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cost', 'kosten', ARRAY[]::text[], NULL, NULL, 'Im Restaurant kostet das Bier etwa viermal so viel wie im Laden.
A beer at a restaurant costs about four times as much as a beer at the store.', 894, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cultural', 'kulturell', ARRAY[]::text[], NULL, NULL, 'Viele kulturelle Vereine haben kaum Geld.
Many cultural clubs have little money.', 895, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'merely, only', 'lediglich', ARRAY[]::text[], NULL, NULL, 'Lediglich 30% der Bevölkerung beteiligten sich an der Wahl.
Only 30% of the population participated in the election.', 896, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'line', 'Linie', ARRAY[]::text[], 'noun', 'die', 'Die Linie 4 fährt nach Gohlis.
Line 4 runs to Gohlis.', 897, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mouth', 'Mund', ARRAY[]::text[], 'noun', 'der', 'Ramona kann nie den Mund halten.
Ramona can not keep her mouth shut.', 898, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Swiss', 'Schweizer', ARRAY[]::text[], NULL, NULL, 'Ich liebe Schweizer Schokolade.
I love Swiss chocolate.', 899, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'independent', 'unabhängig', ARRAY[]::text[], NULL, NULL, 'Die Temperatur ist unabhängig von der Masse einer Flüssigkeit.
The temperature is independent of the mass of a liquid.', 900, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to earn, deserve', 'verdienen', ARRAY[]::text[], NULL, NULL, 'Ich habe mir meinen Urlaub verdient.
I''ve earned my vacation.', 901, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wish', 'Wunsch', ARRAY[]::text[], 'noun', 'der', 'Du hast einen Wunsch frei.
You have one wish.', 902, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'article', 'Artikel', ARRAY[]::text[], 'noun', 'der', 'Artikel eins des Grundgesetzes lautet: Die Würde des Menschen ist unantastbar.
Article One of the constitution reads: Human dignity is inviolable.', 903, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to turn, to rotate', 'drehen', ARRAY[]::text[], NULL, NULL, 'Der Wind dreht. Nun, ich kann es im Uhrzeigersinn um eine Dritteldrehung drehen, oder ein Drittel im Gegenuhrzeigersinn.
The wind is turning. Well, I can rotate by a third of a turn clockwise or a third of a turn anticlockwise.', 904, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quiet, calm (not: really)', 'ruhig', ARRAY[]::text[], NULL, NULL, 'In einer ruhigen Umgebung lernt man besser.
You study better in a quiet environment.', 905, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consequently, therefore', 'somit', ARRAY[]::text[], NULL, NULL, 'A ist größer als B, und C ist größer als A. Somit ist C auch größer als B.
A is greater than B, and C is greater than A. Therefore C is also greater than B.', 906, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'immediate, direct', 'unmittelbar', ARRAY[]::text[], NULL, NULL, 'Unmittelbar vor dem Haus führt die Buslinie entlang.
The bus route runs directly in front of the house.', 907, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conscious, being aware', 'bewusst', ARRAY[]::text[], NULL, NULL, 'Ich bin mir der Gefahr durchaus bewusst.
I am quite aware of the danger.', 908, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'financial', 'finanziell', ARRAY[]::text[], NULL, NULL, 'Finanziell gesehen geht es dem Unternehmen gut.
The company is doing well financially.', 909, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opposite, contrast, unlike', 'Gegensatz', ARRAY[]::text[], 'noun', 'der', 'Im Gegensatz zu meinen Geschwistern wohne ich in der Stadt.
Unlike my siblings, I live in the city.', 910, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chapter', 'Kapitel', ARRAY[]::text[], 'noun', 'das', 'Das vierte Kapitel des Buches ist besonders spannend.
The fourth chapter of the book is especially exciting.', 911, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'classical', 'klassisch', ARRAY[]::text[], NULL, NULL, 'Klassische Musik ist sehr anspruchsvoll.
Classical music is very demanding.', 912, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'literature', 'Literatur', ARRAY[]::text[], 'noun', 'die', 'Literatur recherchiert man im Internet.
You research literature on the internet.', 913, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'back', 'Rücken', ARRAY[]::text[], 'noun', 'der', 'Ich liege auf dem Rücken und schaue den Wolken zu.
I lie on my back and watch the clouds.', 914, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'still, furthermore', 'weiterhin', ARRAY[]::text[], NULL, NULL, 'Georg arbeitet auch weiterhin in unserer Firma.
George still works at our company.', 915, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cell', 'Zelle', ARRAY[]::text[], 'noun', 'die', 'Menschliche Zellen bestehen zu einem Großteil aus Wasser.
Large parts of the human cells consist of water.', 916, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'statement', 'Aussage', ARRAY[]::text[], 'noun', 'die', 'Seine Aussagen widersprechen sich.
His statements are contradicting.', 917, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'citizen', 'Bürger', ARRAY[]::text[], 'noun', 'der', 'Die Bürger der Stadt versammeln sich auf dem Markt, um zu demonstrieren.
The citizens of the town gather at the market, to demonstrate.', 919, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hot', 'heiß', ARRAY[]::text[], NULL, NULL, 'Bei Erkältungen hilft heißer Zitronensaft.
Hot lemon juice helps with colds.', 920, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sky, heaven', 'Himmel', ARRAY[]::text[], 'noun', 'der', 'Heute ist keine Wolke am Himmel.
There is not a cloud in the sky today.', 921, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at least', 'immerhin', ARRAY[]::text[], NULL, NULL, 'Immerhin müssen wir keine Studiengebühren zahlen.
At least we don''t have to pay any tuition fees.', 922, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'contents, plot', 'Inhalt', ARRAY[]::text[], 'noun', 'der', 'Die Zuschauer unterhalten sich über den Inhalt des Films.
Viewers talk about the film''s content.', 923, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to surprise', 'überraschen', ARRAY[]::text[], NULL, NULL, 'Er überraschte seine Frau mit einem Opernbesuch.
He surprised his wife with a trip to the opera.', 924, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wall', 'Wand', ARRAY[]::text[], 'noun', 'die', 'Die Wände in unserer Wohnung sind zu dünn, man kann alles hören.
The walls in our apartment are too thin, you can hear everything.', 925, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'operate, run,', 'betreiben', ARRAY[]::text[], NULL, NULL, 'Mein Nachbar betreibt ein kleines Lokal.
My neighbor runs a small restaurant.', 926, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'library', 'Bibliothek', ARRAY[]::text[], 'noun', 'die', 'Die Bibliothek hat 12 Stunden am Tag geöffnet.
The library is open 12 hours a day.', 927, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'genuine, real', 'echt', ARRAY[]::text[], NULL, NULL, 'Die Arbeit ist eine echte Herausforderung.
The work is a real challenge.', 928, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'color', 'Farbe', ARRAY[]::text[], 'noun', 'die', 'Manche Fische können ihre Farbe der Umgebung anpassen.
Some fish can match their color to the environment.', 929, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fly', 'fliegen', ARRAY[]::text[], NULL, NULL, 'Der Hubschrauber fliegt in Richtung Berge.
The helicopter is flying towards the mountains.', 930, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lift, raise', 'heben', ARRAY[]::text[], NULL, NULL, 'Sonnenschein hebt die Stimmung.
Sunshine lifts the mood.', 931, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'adolescent', 'Jugendliche', ARRAY[]::text[], 'noun', NULL, 'Jugendliche ab 18 Jahren dürfen Alkohol kaufen.
Adolecents aged 18 and over are allowed to buy alcohol.', 932, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'measure', 'Maß', ARRAY[]::text[], 'noun', 'das', 'Der Mensch ist das Maß aller Dinge.
A human is the measure of all things.', 933, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bump, push', 'stoßen', ARRAY[]::text[], NULL, NULL, 'Dann hat sie ihn aus dem Bus gestoßen.
Then she pushed him off the bus.', 935, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expensive', 'teuer', ARRAY[]::text[], NULL, NULL, '25 Euro für eine CD ist zu teuer.
€ 25 for a CD is too expensive.', 936, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to represent', 'vertreten', ARRAY[]::text[], NULL, NULL, 'Nicht alle Minderheiten sind im Parlament vertreten.
Not all minorities are represented in Parliament.', 937, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'approach, estimate (not: Versuch, Verfahren)', 'Ansatz', ARRAY[]::text[], 'noun', 'der', 'Wir haben das alte Problem mit einem neuen Ansatz gelöst. Die wirklichen Kosten sind höher als der Ansatz.
We resolved the old problem with a new approach. The actual cost is higher than the estimate.', 938, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'aspect', 'Aspekt', ARRAY[]::text[], 'noun', 'der', 'In der Vorlesung lernen wir verschiedene Aspekte von Sprache kennen.
We learn different aspects of language in the lecture.', 939, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'memory', 'Erinnerung', ARRAY[]::text[], 'noun', 'die', 'Sie hat nur positive Erinnerungen an ihre Kindheit.
She only has positive memories of her childhood.', 941, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to enable (not: dürfen, erlauben)', 'ermöglichen', ARRAY[]::text[], NULL, NULL, 'Der neue Computer ermöglicht einen schnelleren Internetzugang.
The new computer enables faster internet access.', 942, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'just as', 'genauso', ARRAY[]::text[], NULL, NULL, 'Mit dem Auto zu fahren dauert genauso lange wie mit dem Zug.
To travel by car takes just as long as by train.', 943, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to produce (not: produzieren)', 'herstellen', ARRAY[]::text[], NULL, NULL, 'Unsere Fabrik stellt Geschirr her.
Our factory produces crockery.', 944, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'some, any', 'irgendein', ARRAY[]::text[], NULL, NULL, 'Irgendeine Frau war gestern da und hat nach dir gefragt.
Some woman was here yesterday and was asking about you.', 946, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'knowledge', 'Kenntnis', ARRAY[]::text[], 'noun', 'die', 'Ich habe das zur Kenntnis genommen.
I have taken this to knowledge.', 947, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'course, exchange rate', 'Kurs', ARRAY[]::text[], 'noun', 'der', 'Mein Kurs an der Uni ist vorbei.
My course at the university is over.', 948, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to suffer', 'leiden', ARRAY[]::text[], NULL, NULL, 'Im Krieg leiden vor allem die Kinder.
Especially the children suffer in war.', 949, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'paper', 'Papier', ARRAY[]::text[], 'noun', 'das', 'Wir verwenden lieber chlorfrei gebleichtes Papier.
We prefer to use chlorine-free bleached paper.', 950, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to send', 'schicken', ARRAY[]::text[], NULL, NULL, 'Schicken Sie mir morgen die neuen Unterlagen.
Send me the new documents tomorrow.', 951, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'second', 'Sekunde', ARRAY[]::text[], 'noun', 'die', 'Eine Minute hat 60 Sekunden.
A minute has 60 seconds.', 952, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sun', 'Sonne', ARRAY[]::text[], 'noun', 'die', 'Die Sonne scheint.
The sun is shining.', 953, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'circumstance (not: Bedingung)', 'Umstand', ARRAY[]::text[], 'noun', 'der', 'Unter diesen Umständen muss ich leider absagen.
Unfortunaltely, under these circumstances I have to cancel.', 954, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at the front', 'vorne', ARRAY['vorn']::text[], NULL, NULL, 'Vorne am Haus sind die Balkone.
At the front of the house are the balconies.', 955, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to change to', 'wechseln zu', ARRAY[]::text[], NULL, NULL, 'Der Fußballer wechselt zu einem anderen Verein.
The soccer player changes to another club.', 956, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gone, vanished', 'weg', ARRAY[]::text[], NULL, NULL, 'Ich bin gleich weg, soll ich noch etwas mitbringen?
I am almost gone, should I bring anything?', 957, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'science', 'Wissenschaft', ARRAY[]::text[], 'noun', 'die', 'Biologie ist die Wissenschaft vom Leben.
Biology is the science of life.', 958, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'garden', 'Garten', ARRAY[]::text[], 'noun', 'der', 'Im Garten stehen sechs Apfelbäume.
There are six apple trees in the garden.', 959, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'kitchen, cuisine', 'Küche', ARRAY[]::text[], 'noun', 'die', 'Die Küche duftet es nach Gewürzen.
The kitchen smells like spices.', 960, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to deliver, supply', 'liefern', ARRAY[]::text[], NULL, NULL, 'Die Post liefert Briefe und Pakete.
The post office delivers letters and packages.', 961, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'necessary', 'nötig', ARRAY[]::text[], NULL, NULL, 'Wir werden die nötigen Vorkehrungen treffen.
We will take the necessary precautions.', 962, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'great, terrific', 'toll', ARRAY[]::text[], NULL, NULL, 'Das Essen schmeckt toll.
The food tastes great.', 963, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reality', 'Wirklichkeit', ARRAY[]::text[], 'noun', 'die', 'Die Wirklichkeit sieht anders aus.
The reality looks different.', 964, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pay', 'zahlen', ARRAY[]::text[], NULL, NULL, 'Viele Leute zahlen nur noch mit Kreditkarte.
Many people only pay by credit card.', 965, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to require', 'benötigen', ARRAY[]::text[], NULL, NULL, 'Der Kranke benötigt Ruhe.
The patient requires rest.', 966, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pressure, printing', 'Druck', ARRAY[]::text[], 'noun', 'der', 'Die Wirtschaft übt großen Druck auf die Regierung aus.
The economy puts big pressure on the government.', 967, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'food, meal', 'Essen', ARRAY[]::text[], 'noun', 'das', 'Das Essen steht auf dem Tisch.
The food is on the table.', 968, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'basis', 'Grundlage', ARRAY[]::text[], 'noun', 'die', 'Mathematik ist die Grundlage für viele andere Wissenschaften.
Mathematics is the basis for many other sciences.', 969, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come (from), descend', 'stammen', ARRAY[]::text[], NULL, NULL, 'Die Idee für das Projekt stammt nicht vom Chef, sondern von den Mitarbeitern.
The idea for the project does not come from the boss, but from the staff.', 970, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prevent', 'verhindern', ARRAY[]::text[], NULL, NULL, 'Der Unfall konnte nicht verhindert werden.
The accident could not be prevented.', 971, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at the moment, currently', 'zurzeit', ARRAY[]::text[], NULL, NULL, 'Zurzeit sind keine Winterstiefel vorrätig.
Currently there are no winter boots in stock.', 972, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'condition, state', 'Zustand', ARRAY[]::text[], 'noun', 'der', 'Die Straßen hier sind in einem sehr schlechten Zustand.
The roads here are in very poor condition.', 973, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lock, conclude', 'abschließen', ARRAY[]::text[], NULL, NULL, 'Ich schließe mein Studium im Sommer ab.
I am concluding my studies in the summer.', 974, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'again, once again (not: nochmal)', 'erneut', ARRAY[]::text[], NULL, NULL, 'Im Atomkraftwerk gab es erneut eine Störung.
There was a dysfunction at the nuclear power plant again.', 975, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'half', 'Hälfte', ARRAY[]::text[], 'noun', 'die', 'Die Hälfte der Bevölkerung ist täglich online.
Half the population is online every day.', 976, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sea, ocean', 'Meer', ARRAY[]::text[], 'noun', 'das', 'Das Leben im Meer ist noch weitgehend unerforscht.
The sea life is still largely unexplored.', 977, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to travel', 'reisen', ARRAY[]::text[], NULL, NULL, 'Johanna reist in den Ferien nach Bulgarien.
Joan travels to Bulgaria during her vacation.', 978, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sing', 'singen', ARRAY[]::text[], NULL, NULL, 'Anja singt seit vielen Jahren im Chor.
Anya sings in the choir for many years.', 979, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to consider, think about', 'überlegen', ARRAY[]::text[], NULL, NULL, 'Ich überlege, wann ich Urlaub nehme.
I am thinking about when to take vacation.', 980, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at least', 'wenigstens', ARRAY[]::text[], NULL, NULL, 'Marcus will wenigstens noch das Buch zu Ende lesen, bevor er schlafen geht.
At least Marcus wants to finish reading the book, before he goes to sleep.', 981, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'service, duty', 'Dienst', ARRAY[]::text[], 'noun', 'der', 'Der Verkäufer steht im Dienst seiner Kunden.
The seller is at the service of his customers', 982, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to mention', 'erwähnen', ARRAY[]::text[], NULL, NULL, 'Im Lebenslauf kann man seine Hobbys und Interessen erwähnen.
Hobbies and interests can be mentioned in the resume.', 983, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'object, item, thing', 'Gegenstand', ARRAY[]::text[], 'noun', 'der', 'Kleine Kinder verschlucken oft Gegenstände.
Small children often swallow objects.', 984, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take hold of, reach', 'greifen', ARRAY[]::text[], NULL, NULL, 'Wir greifen nach den Sternen.
We reach for the stars.', 985, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in the meantime, since then,meanwhile', 'mittlerweile', ARRAY[]::text[], NULL, NULL, 'Mittlerweile kann man auf Handys sogar Bilder und Videos empfangen.
Meanwhile you can even receive pictures and videos on mobile phones.', 986, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plan', 'Plan', ARRAY[]::text[], 'noun', 'der', 'Der ursprüngliche Plan sah anders aus.
The original plan looked different.', 987, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'daily', 'täglich', ARRAY[]::text[], NULL, NULL, 'Das Fernsehen strahlt täglich unzählige Serien aus.
The television broadcasts countless of series daily.', 988, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'usual, common', 'üblich', ARRAY[]::text[], NULL, NULL, 'In Deutschland ist es üblich, sich zur Begrüßung die Hand zu reichen.
In Germany it is common to shake hand in a greeting.', 989, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to do without, resign', 'verzichten', ARRAY[]::text[], NULL, NULL, 'Herr Funke verzichtet auf alle Vorteile als Geschäftsführer.
As a manager Mr. Funke resigns all benefits.', 990, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'moment, (point in) time, date', 'Zeitpunkt', ARRAY[]::text[], 'noun', 'der', 'Wir werden die Versammlung auf einen späteren Zeitpunkt verschieben.
We will postpone the meeting to a later date.', 991, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'approximately, about (not: ungefähr)', 'zirka', ARRAY['ca.']::text[], NULL, NULL, 'Zirka ein Drittel aller Schüler besucht das Gymnasium.
About one-third of all students attend grammar school.', 992, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'absolute', 'absolut', ARRAY[]::text[], NULL, NULL, 'Die Partei erhielt die absolute Mehrheit.
The party won the absolute majority.', 993, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to give up', 'aufgeben', ARRAY[]::text[], NULL, NULL, 'Uwe gibt die Arbeit bei seiner alten Firma auf.
Uwe is giving up his job at his old company.', 994, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instructions, assignment, job', 'Auftrag', ARRAY[]::text[], 'noun', 'der', 'Der Auftrag muss diese Woche noch erledigt werden.
The job has to be done this week.', 995, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tree', 'Baum', ARRAY[]::text[], 'noun', 'der', 'Familie Ittner pflanzt jedes Jahr einen Baum.
Each year the Ittner family plants a tree.', 996, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to amount, average', 'betragen', ARRAY[]::text[], NULL, NULL, 'Der Zuschuss beträgt etwa 30 Euro. Die Entfernung beträgt vier Meilen.
The subsidy averages about 30 €. The distance is four miles.', 997, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'joy', 'Freude', ARRAY[]::text[], 'noun', 'die', 'Ihre Freude war sehr groß, als sie hörte, dass sie die Prüfung bestanden hatte.
Her joy was great when she heard that she had passed the test.', 999, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'community, municipality', 'Gemeinde', ARRAY[]::text[], 'noun', 'die', 'Die Gemeinde hat keine finanziellen Mittel mehr übrig.
The municipality has no funds left.', 1000, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'social', 'gesellschaftlich', ARRAY[]::text[], NULL, NULL, 'Vereine übernehmen eine große gesellschaftliche Verantwortung. Der Schauspieler hatte viele gesellschaftliche Verpflichtungen.
Associations take an important social responsibility. The actor had many social obligations.', 1001, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clue, hint', 'Hinweis', ARRAY[]::text[], 'noun', 'der', 'Ein Zeuge gab der Polizei den entscheidenden Hinweis.
A witness gave the police the vital clue.', 1002, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'individual', 'individuell', ARRAY[]::text[], NULL, NULL, 'Die Absage an die Firma ist meine individuelle Entscheidung.
The rejection of the firm is my individual decision.', 1003, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'some, any', 'irgendwelche', ARRAY['s)']::text[], NULL, NULL, 'Seid ihr auf irgendwelche Probleme gestoßen?
Have you encountered any problems?', 1004, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cook', 'kochen', ARRAY[]::text[], NULL, NULL, 'Paula kocht gern italienisch.
Paula likes to cook Italian.', 1005, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'empty', 'leer', ARRAY[]::text[], NULL, NULL, 'Die Flasche Wein ist schon leer.
The wine bottle is already empty.', 1006, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'national', 'national', ARRAY[]::text[], NULL, NULL, 'Die nationale Einheit Deutschlands wurde 1990 wiederhergestellt.
The national unity of Germany was restored in 1990.', 1007, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'net, network', 'Netz', ARRAY[]::text[], 'noun', 'das', 'Die Fischer holen ihre Netze ein.
The Fishermen are hauling their nets.', 1008, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'November', 'November', ARRAY[]::text[], 'noun', 'der', 'Im November fällt oft der erste Schnee.
In November, often the first snow falls.', 1009, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'position', 'Position', ARRAY[]::text[], 'noun', 'die', 'In seiner Position als Stellvertreter des Präsidenten hat er zu wenig Einfluss auf die Politik.
In his position as deputy president, he has too little influence over policy.', 1010, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'end, conclusion', 'Schluss', ARRAY[]::text[], 'noun', 'der', 'Am Schluss der Veranstaltung wurde noch viel diskutiert.
At the end of the event there were a lot of discussions.', 1011, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'approximately', 'ungefähr', ARRAY[]::text[], NULL, NULL, 'Von Leipzig nach Erfurt sind es ungefähr 120 Kilometer.
From Leipzig to Erfurt, there are approximately 120 kilometers.', 1012, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in turn, again, on the other hand', 'wiederum', ARRAY[]::text[], NULL, NULL, 'Sie mochte die Idee. Ihr Bruder wiederum war dagegen.
She liked the idea. Her brother, in turn, was against it.', 1013, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to justify', 'begründen', ARRAY[]::text[], NULL, NULL, 'Begründe bitte deine Meinung!
Justify your opinion please!', 1015, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'blue', 'blau', ARRAY[]::text[], NULL, NULL, 'Das blaue Meer glitzert in der Abendsonne.
The blue sea is glistening in the evening sun.', 1016, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Federal Republic', 'Bundesrepublik', ARRAY[]::text[], 'noun', 'die', 'Die Bundesrepublik Deutschland wurde 1949 gegründet.
The Federal Republic of Germany was founded in 1949.', 1017, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to furnish', 'einrichten', ARRAY[]::text[], NULL, NULL, 'Die Wohnung ist bis jetzt nur provisorisch eingerichtet.
The apartment is until now only provisionally furnished.', 1018, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hold on to, detain (to hold securely)', 'festhalten', ARRAY[]::text[], NULL, NULL, 'Die Verdächtigte wurde zur weiteren Befragung festgehalten.
The suspect was held for further questioning.', 1019, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get into', 'geraten', ARRAY[]::text[], NULL, NULL, 'Ich bin in einen Stau geraten.
I got into a traffic jam.', 1021, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'glass', 'Glas', ARRAY[]::text[], 'noun', 'das', 'Ein Glas Rotwein verschönert uns den Abend.
A glass of red wine embellishes the evening for us.', 1022, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'skin', 'Haut', ARRAY[]::text[], 'noun', 'die', 'Sie hat eine schöne Haut.
She has a beautiful skin.', 1023, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'practice, doctor’s office', 'Praxis', ARRAY[]::text[], 'noun', 'die', 'Theorie und Praxis klaffen oft auseinander.
Theory and practice often gape apart .', 1024, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quick (not: bald)', 'rasch', ARRAY[]::text[], NULL, NULL, 'Hier ist ein rascher Entschluss nötig.
Here a quick decision is needed.', 1025, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'certainly', 'sicherlich', ARRAY[]::text[], NULL, NULL, 'Sie haben sicherlich schon davon gehört.
You have certainly heard about it.', 1026, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as far as', 'soweit', ARRAY[]::text[], NULL, NULL, 'Soweit ich weiß, läuft alles wie geplant.
As far as I know, everything goes as planned.', 1027, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to order, decree, rule', 'verfügen', ARRAY[]::text[], NULL, NULL, 'Der Präsident verfügte den Rückzug der Soldaten.
The president ordered the retreat of the troops.', 1028, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'forest, woods', 'Wald', ARRAY[]::text[], 'noun', 'der', 'Ich gehe gern im Wald spazieren.
I like to go walking in the forest.', 1029, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'term, expression', 'Ausdruck', ARRAY[]::text[], 'noun', 'der', 'Er hat einen unpassenden Ausdruck verwendet.
He has used an inappropriate term.', 1031, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'outside', 'draußen', ARRAY[]::text[], NULL, NULL, 'Ich habe draußen im Garten zu tun.
I have to work outside in the garden.', 1033, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'finger', 'Finger', ARRAY[]::text[], 'noun', 'der', 'Marsmenschen haben sieben Finger an jeder Hand.
Martians have seven fingers on each hand.', 1034, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'friend', 'Freundin', ARRAY[]::text[], 'noun', 'die', 'Meine Freundin Christina heiratet in zwei Monaten.
My friend Christina is going to get married in two months.', 1035, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'novel', 'Roman', ARRAY[]::text[], 'noun', 'der', 'Anke liest einen Roman von Thomas
Anke is reading a novel by Thomas', 1036, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Russian', 'russisch', ARRAY[]::text[], NULL, NULL, 'Die russische Sprache hat sechs Fälle.
The Russian language has six cases.', 1037, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to protect', 'schützen', ARRAY[]::text[], NULL, NULL, 'Man muss die Umwelt schützen.
You have to protect the environment.', 1038, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'view, visibility', 'Sicht', ARRAY[]::text[], 'noun', 'die', 'Sie hatten eine schöne Sicht auf die Stadt.
They had a nice view of the city.', 1039, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'theory', 'Theorie', ARRAY[]::text[], 'noun', 'die', 'Seine Theorie war falsch.
His theory was wrong.', 1040, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'environment', 'Umwelt', ARRAY[]::text[], 'noun', 'die', 'Autoabgase schaden der Umwelt.
Exhaust gases harm the environment.', 1041, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rather (not: eher)', '[sondern] vielmehr', ARRAY[]::text[], NULL, NULL, 'Die Wände sind nicht weiß, sie sind vielmehr beige. Hier liegt kein finanzielles, sondern vielmehr ein organisatorisches Problem vor.
The walls are not white, but rather beige. This is not a financial, but rather an organizational problem.', 1042, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prepare', 'vorbereiten', ARRAY[]::text[], NULL, NULL, 'Agnes bereitet ihr Seminar vor.
Agnes prepares for her seminar.', 1043, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to repeat', 'wiederholen', ARRAY[]::text[], NULL, NULL, 'Ich habe meine Frage schon zweimal wiederholt.
I already repeated my question twice.', 1044, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'household, budget', 'Haushalt', ARRAY[]::text[], 'noun', 'der', 'Die Kinder helfen im Haushalt.
The children help with household chores.', 1045, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dog', 'Hund', ARRAY[]::text[], 'noun', 'der', 'Das ist ein dicker Hund.
This is a fat dog.', 1046, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'machine', 'Maschine', ARRAY[]::text[], 'noun', 'die', 'Welche Maschine ist kaputt?
Which machine is broken?', 1047, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'number', 'Nummer', ARRAY[]::text[], 'noun', 'die', 'Ziehen Sie eine Nummer und warten Sie
Draw a number and wait', 1048, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'politician', 'Politiker', ARRAY[]::text[], 'noun', 'der', 'Viele Politiker sind Lehrer.
Many politicians are teachers.', 1049, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to disturb, bother', 'stören', ARRAY[]::text[], NULL, NULL, 'Bitte nicht stören!
Do not disturb!', 1050, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'team', 'Team', ARRAY[]::text[], 'noun', 'das', 'Wir sind ein gutes Team.
We are a good team.', 1051, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'title', 'Titel', ARRAY[]::text[], 'noun', 'der', 'Wie lautet der Titel des Spielfilms?
What is the title of the movie?', 1052, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'responsible', 'verantwortlich', ARRAY[]::text[], NULL, NULL, 'Wer ist für die Buchführung verantwortlich?
Who is responsible for accounting?', 1053, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'association, club', 'Verein', ARRAY[]::text[], 'noun', 'der', 'Er ist Mitglied in einem Verein.
He is a member of a club.', 1054, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'appropriate, responsible (not: verantwortlich)', 'zuständig', ARRAY[]::text[], NULL, NULL, 'Der Produktmanager ist für diesen Bereich zuständig.
The product manager is responsible for this division.', 1055, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'up to now (not: soweit, der Zeit, bisherig, zurzeit)', 'bislang', ARRAY[]::text[], NULL, NULL, 'Bislang haben wir geschwiegen, aber jetzt werden wir uns einmischen.
Up to now we have been silent, but now we will get involved.', 1056, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'considerable', 'erheblich', ARRAY[]::text[], NULL, NULL, 'Das Hochwasser richtete erheblichen Schaden an.
The flood caused considerable damage.', 1057, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'serious', 'ernst', ARRAY[]::text[], NULL, NULL, 'Es handelt sich um eine ernste Angelegenheit.
It is a serious matter.', 1058, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to celebrate', 'feiern', ARRAY[]::text[], NULL, NULL, 'Silvester feiern wir bei Freunden in Berlin.
New Year''s Eve we celebrate with friends in Berlin.', 1059, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'television', 'Fernsehen', ARRAY[]::text[], 'noun', 'das', 'Was kommt heute im Fernsehen?
What''s on TV today?', 1060, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sometime', 'irgendwann', ARRAY[]::text[], NULL, NULL, 'Irgendwann werden wir uns wiedersehen.
Sometime we''ll meet again.', 1061, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shoulder', 'Schulter', ARRAY[]::text[], 'noun', 'die', 'Meine linke Schulter tut weh.
My left shoulder hurts.', 1063, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the support', 'Unterstützung', ARRAY[]::text[], 'noun', 'die', 'Ohne staatliche Unterstützung könnten sie gar nicht leben.
Without government support, they could not live at all.', 1064, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arrange, find sth for sb', 'vermitteln', ARRAY[]::text[], NULL, NULL, 'Sie hat ihm einen guten Job vermittelt.
She found him a good job.', 1065, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sign (not: Signal)', 'Zeichen', ARRAY[]::text[], 'noun', 'das', 'Ein Regenbogen ist ein gutes Zeichen.
A rainbow is a good sign.', 1066, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to consider (concerned with carrying) (not: betrachten)', 'berücksichtigen', ARRAY[]::text[], NULL, NULL, 'Wir sollten die Wünsche anderer berücksichtigen.
We should consider the wishes of others.', 1067, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'material', 'Material', ARRAY[]::text[], 'noun', 'das', 'Aus welchem Material sind diese Strümpfe?
Of which material are these socks?', 1068, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'production', 'Produktion', ARRAY[]::text[], 'noun', 'die', 'Die Produktion von Autos ist um 25% gestiegen.
The production of cars has increased by 25%.', 1069, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rest, remains', 'Rest', ARRAY[]::text[], 'noun', 'der', 'Magst du noch den Rest des Kuchens?
Would you like the rest of the cake?', 1070, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'silence, peace', 'Ruhe', ARRAY[]::text[], 'noun', 'die', 'Junge Eltern brauchen Ruhe und Erholung.
Young parents need silence and relaxation.', 1071, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'damage', 'Schaden', ARRAY[]::text[], 'noun', 'der', 'Der Schaden war groß.
The damage was great.', 1072, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'soldier', 'Soldat', ARRAY[]::text[], 'noun', 'der', 'In seiner Jugend war er Soldat.
In his youth he was a soldier.', 1073, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'worry', 'Sorge', ARRAY[]::text[], 'noun', 'die', 'Mach dir keine Sorgen!
Don''t worry!', 1074, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fact', 'Tatsache', ARRAY[]::text[], 'noun', 'die', 'Ich habe mich mit dieser Tatsache abgefunden.
I''ve come to terms with this fact.', 1075, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'typical', 'typisch', ARRAY[]::text[], NULL, NULL, 'Das ist typisch für dich!
This is typical for you!', 1076, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'surroundings', 'Umgebung', ARRAY[]::text[], 'noun', 'die', 'Sie suchen eine Arbeit in der Umgebung von Hamburg.
They are looking for a job in the surroundings of Hamburg.', 1077, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'people', 'Volk', ARRAY[]::text[], 'noun', 'das', 'Wir sind das Volk!
We are the people!', 1078, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'car, carriage', 'Wagen', ARRAY[]::text[], 'noun', 'der', 'Wo haben wir den Wagen geparkt?
Where did we park the car?', 1079, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wind', 'Wind', ARRAY[]::text[], 'noun', 'der', 'Das Flugzeug startet trotz des starken Windes.
The plane takes off, despite the strong wind.', 1080, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'purpose', 'Zweck', ARRAY[]::text[], 'noun', 'der', 'Zu welchem Zweck sind wir hier versammelt?
For what purpose are we gathered here?', 1081, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attack', 'Angriff', ARRAY[]::text[], 'noun', 'der', 'Das ist ein Angriff auf den Präsidenten.
This is an attack on the president.', 1082, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'application [form]', 'Antrag', ARRAY[]::text[], 'noun', 'der', 'Sie müssen diesen Antrag ausfüllen.
You must complete this application.', 1083, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exclude, rule out', 'ausschließen', ARRAY[]::text[], NULL, NULL, 'Die Polizei schließt ein Verbrechen aus.
The Police rules out a crime.', 1084, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to discuss', 'diskutieren', ARRAY[]::text[], NULL, NULL, 'Wir sollten das noch einmal diskutieren.
We should discuss that once again.', 1085, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to function, work', 'funktionieren', ARRAY[]::text[], NULL, NULL, 'Wie funktioniert dieses Programm?
How does this program function?', 1086, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'degree', 'Grad', ARRAY[]::text[], 'noun', NULL, 'In Deutschland wird die Temperatur in Grad Celsius gemessen.
In Germany, the temperature is measured in degrees Celsius.', 1087, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to establish, found', 'gründen', ARRAY[]::text[], NULL, NULL, 'Sie gründete ein Unternehmen.
She founded a company', 1088, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rule', 'herrschen', ARRAY[]::text[], NULL, NULL, 'Im Land herrscht Unruhe. Der König herrschte über ein großes Königreich.
Unrest is ruling the country. The king ruled over a great kingdom.', 1089, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'job', 'Job', ARRAY[]::text[], 'noun', 'der', 'Der Job scheint sehr lukrativ zu sein.
The job seems to be very lucrative.', 1090, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Wednesday', 'Mittwoch', ARRAY[]::text[], 'noun', 'der', 'Am Mittwoch arbeitet sie nur bis mittags.
On Wednesday she will only work until noon.', 1091, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the public', 'Öffentlichkeit', ARRAY[]::text[], 'noun', 'die', 'Jan Hus wurde in aller Öffentlichkeit hingerichtet. Journalisten informieren die Öffentlichkeit.
Jan Hus was executed in public. Journalists provide information to the public.', 1092, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to push/nudge (not: bewegen, stoßen)', 'schieben', ARRAY[]::text[], NULL, NULL, 'Schieb den Sessel ein wenig zur Seite!
Push the chair a little to the side!', 1093, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'protection', 'Schutz', ARRAY[]::text[], 'noun', 'der', 'Du stehst unter meinem Schutz.
You are under my protection.', 1094, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'by the way', 'übrigens', ARRAY[]::text[], NULL, NULL, 'Ich komme übrigens auch mit nach Köln. Mir gefällt übrigens dein neuer Haarschnitt.
By the way, I''m also coming to Cologne. By the way, I like your new haircut.', 1095, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'satisfied', 'zufrieden', ARRAY[]::text[], NULL, NULL, 'Mit deinen Noten kannst du zufrieden sein.
With your grades you can be satisfied.', 1096, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'share, portion', 'Anteil', ARRAY[]::text[], 'noun', 'der', 'Der größte Anteil gehört seiner Schwester.
The largest share belongs to his sister.', 1097, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to claim', 'behaupten', ARRAY[]::text[], NULL, NULL, 'Das, was du behauptest, musst du auch beweisen.
What you claim, you must prove.', 1098, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employee (not: Mitarbeiter, Angesteller, Arbeitnehmer)', 'Beschäftigte', ARRAY[]::text[], 'noun', NULL, 'Die Beschäftigten streiken schon seit Wochen.
The employees have been on strike for weeks.', 1099, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'visit', 'Besuch', ARRAY[]::text[], 'noun', 'der', 'Wir bekommen am Sonntag Besuch.
On Sunday we''re going to receive a visit.', 1100, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'energy', 'Energie', ARRAY[]::text[], 'noun', 'die', 'Aus Wind kann Energie gewonnen werden.
From wind energy can be made.', 1101, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to raise', 'erheben', ARRAY[]::text[], NULL, NULL, 'Er erhob sein Glas und sagte: "Prost!"
He raised his glass and said, "Cheers!"', 1102, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'explanation', 'Erklärung', ARRAY[]::text[], 'noun', 'die', 'Ich verlange eine Erklärung von dir.
I demand an explanation from you.', 1103, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'corridor, aisle, course', 'Gang', ARRAY[]::text[], 'noun', 'der', 'Der ganze Gang steht voller Arbeitsloser.
The whole corridor is full of unemployed people.', 1104, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sick, ill', 'krank', ARRAY[]::text[], NULL, NULL, 'Wenn du krank bist, musst du im Bett bleiben.
When you''re sick, you must stay in bed.', 1105, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'course, rune, race', 'Lauf', ARRAY[]::text[], 'noun', 'der', 'Üblicherweise stoppe ich meine Läufe.
I usually time my runs.', 1106, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instruction, classes (not: Vorlesung, Klasse)', 'Unterricht', ARRAY[]::text[], 'noun', 'der', 'Der Unterricht endet am späten Nachmittag.
Classes end in the late afternoon.', 1107, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pursue', 'verfolgen', ARRAY[]::text[], NULL, NULL, 'Sie verfolgt ihr Ziel hartnäckig.
She is pursuing her goal persistently.', 1108, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'warm', 'warm', ARRAY[]::text[], NULL, NULL, 'Mir ist warm.
I am warm.', 1109, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'centre', 'Zentrum', ARRAY[]::text[], 'noun', 'das', 'Im Zentrum unserer Überlegungen sollten die Bedürfnisse von Kindern stehen.
In the center of our considerations should be the needs of children.', 1110, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to return', 'zurückkommen', ARRAY[]::text[], NULL, NULL, 'Herr Helbig kommt am Montag von seiner Reise zurück.
Mr. Helbig comes back from his trip on Monday.', 1111, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to force', 'zwingen', ARRAY[]::text[], NULL, NULL, 'Wir sind gezwungen, schärfere Kontrollen durchzuführen.
We are forced to implement stricter controls.', 1112, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to refuse, reject, turn down', 'ablehnen', ARRAY[]::text[], NULL, NULL, 'Die Behörde lehnt seinen Antrag auf ein Visum ab.
The Authority rejected his application for a visa.', 1113, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'office, department, function', 'Amt', ARRAY[]::text[], 'noun', 'das', 'Sie nimmt in ihrer Partei ein hohes Amt ein.
She is holding a high office in her party.', 1114, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attack (not: der Angriff)', 'Anschlag', ARRAY[]::text[], 'noun', 'der', 'Am Montag Abend ereignete sich ein Anschlag auf die Russische Botschaft.
On Monday evening, an attack took place at the Russian Embassy.', 1115, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to apply, employ', 'anwenden', ARRAY[]::text[], NULL, NULL, 'Sie wenden einen einfachen Trick an.
They apply a simple trick.', 1116, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to surface, appear', 'auftauchen', ARRAY[]::text[], NULL, NULL, 'Aus dem Nebel tauchte eine Gestalt auf.
Out of the fog appeared a figure.', 1117, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'abroad, foreign countries', 'Ausland', ARRAY[]::text[], 'noun', 'das', 'Er möchte ein Jahr lang im Ausland studieren.
He wants to study in a foreign country for a year.', 1118, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'outside ()', 'außerhalb', ARRAY[]::text[], NULL, NULL, 'Wir wohnen außerhalb der Stadt.
We live outside the city.', 1119, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to influence', 'beeinflussen', ARRAY[]::text[], NULL, NULL, 'Die Motivation beeinflusst den Erfolg.
The motivation influences the success.', 1120, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'treatment (not: Verhandlung)', 'Behandlung', ARRAY[]::text[], 'noun', 'die', 'Für diese Krankheit gibt es eine neue Behandlung.
For this disease there is a new treatment.', 1121, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thick, fat', 'dick', ARRAY[]::text[], NULL, NULL, 'Sie trug einen dicken Pulli.
She wore a thick sweater.', 1122, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to occur, remind, collapse', 'einfallen', ARRAY[]::text[], NULL, NULL, 'Das Wort ist mir einfach nicht eingefallen.
The word did simply not occur to me.', 1123, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'institution, furnishings', 'Einrichtung', ARRAY[]::text[], 'noun', 'die', 'Die Einrichtung eures Wohnzimmers gefällt mir.
I like the furnishings of your living room.', 1124, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exist', 'existieren', ARRAY[]::text[], NULL, NULL, 'Diese Person existiert nur in deiner Fantasie.
This person exists only in your imagination.', 1125, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'field', 'Feld', ARRAY[]::text[], 'noun', 'das', 'Auf diesem Feld wird Mais angebaut.
In this field, maize is grown.', 1126, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to promote, support', 'fördern', ARRAY[]::text[], NULL, NULL, 'Durch Stipendien werden besonders leistungsstarke Studenten gefördert.
Through scholarships especially well-performing students get supported.', 1127, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'public, audience', 'Publikum', ARRAY[]::text[], 'noun', 'das', 'Das Publikum applaudierte sehr lange.
The audience applauded for a long time.', 1130, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'weak', 'schwach', ARRAY[]::text[], NULL, NULL, 'Die Klasse erzielt nur schwache Leistungen.
The class achieved only weak performance.', 1131, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'study', 'Studie', ARRAY[]::text[], 'noun', 'die', 'Eine andere wissenschaftliche Studie zeigt das genaue Gegenteil.
Another scientific study shows the exact opposite.', 1132, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chair person', 'Vorsitzende', ARRAY[]::text[], 'noun', NULL, 'Frau Schulz ist die Vorsitzende der Arbeiterpartei.
Mrs. Schulz is the chair person of the Workers Party.', 1133, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'analysis', 'Analyse', ARRAY[]::text[], 'noun', 'die', 'Die Analyse der Ergebnisse wird uns noch lange beschäftigen.
The analysis of the results will keep us busy for a long time.', 1134, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to address, speak', 'ansprechen', ARRAY[]::text[], NULL, NULL, 'Plötzlich sprach sie mich an, und ich wusste nicht, was ich sagen sollte.
Suddenly she spoke to me, and I did not know what to say.', 1135, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pay attention, observe', 'beachten', ARRAY[]::text[], NULL, NULL, 'In letzter Zeit beachtet Franz seinen Freund Ferdinand gar nicht mehr.
Recently, Franz is no longer paying attention to his friend Ferdinand.', 1136, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to feel (not: füllen)', 'empfinden', ARRAY[]::text[], NULL, NULL, 'Sie empfinden sehr viel füreinander.
They feel very much for each other.', 1137, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to remove, leave', 'entfernen', ARRAY[]::text[], NULL, NULL, 'Ich entfernte den Fleck mit Seife und Wasser.
I removed the stain with soap and water.', 1138, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'left', 'linke', ARRAY['s)']::text[], NULL, NULL, 'Andra schreibt mit der linken Hand.
Andra writes with the left hand.', 1139, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'low, base', 'niedrig', ARRAY[]::text[], NULL, NULL, 'Vorsicht, dieses Zimmer ist sehr niedrig!
Careful, this room is very low!', 1140, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cut', 'schneiden', ARRAY[]::text[], NULL, NULL, 'Ich habe mir meine Haare selbst geschnitten.
I cut my hair on my own.', 1141, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to secure, safeguard', 'sichern', ARRAY[]::text[], NULL, NULL, 'Sichern Sie Ihren Arbeitsplatz!
Secure your work place!', 1142, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'track, lane (not: Linie, Gleis)', 'Spur', ARRAY[]::text[], 'noun', 'die', 'Die Spuren verliefen sich im Sand.
The traces vanished in the sand.', 1143, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'traditional', 'traditionell', ARRAY[]::text[], NULL, NULL, 'Er hat eine sehr traditionelle Meinung.
He has a very traditional view.', 1144, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to turn', 'wenden', ARRAY[]::text[], NULL, NULL, 'Das Blatt wendet sich.
The tide is turning.', 1145, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in view of (given) (on account of)', 'angesichts', ARRAY[]::text[], NULL, NULL, 'Angesichts der schlechten Straßenverhältnisse beschlossen wir, den Zug zu nehmen.
Given the poor road conditions, we decided to take the train.', 1146, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ready', 'bereit', ARRAY[]::text[], NULL, NULL, 'Ich bin bereit, wir können gehen!
I am ready, we can go!', 1147, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hill, mountain', 'Berg', ARRAY[]::text[], 'noun', 'der', 'Die Hütte steht auf einem hohen Berg.
The cabin is on a high mountain.', 1148, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'realization, discovery', 'Erkenntnis', ARRAY[]::text[], 'noun', 'die', 'Neue wissenschaftliche Erkenntnisse gibt es fast jeden Tag.
There are new scientific findings, almost every day.', 1149, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'factor', 'Faktor', ARRAY[]::text[], 'noun', 'der', 'Das ist der entscheidende Faktor.
This is the crucial factor.', 1150, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grasp, hold', 'fassen', ARRAY[]::text[], NULL, NULL, 'Sie fasste seine Hand.
She held his hand.', 1151, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mistake, error', 'Fehler', ARRAY[]::text[], 'noun', 'der', 'Begehen Sie keinen Fehler!
Don''t commit a mistake!', 1152, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'freedom', 'Freiheit', ARRAY[]::text[], 'noun', 'die', 'Jeder Mensch hat das Recht auf Freiheit.
Everyone has the right to freedom.', 1153, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'spare time', 'Freizeit', ARRAY[]::text[], 'noun', 'die', 'Womit verbringst du deine Freizeit?
How do you spend your free time?', 1154, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'area, region (not: der Bereich, das Gebiet)', 'Gegend', ARRAY[]::text[], 'noun', 'die', 'Familie Fetzer lebt in einer waldreichen Gegend.
The Fetzer family lives in a well wooded area.', 1155, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'legal', 'gesetzlich', ARRAY[]::text[], NULL, NULL, 'Auf eine gesetzliche Regelung müssen wir noch warten.
We still have to wait for a legal provision.', 1156, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to inform', 'informieren', ARRAY[]::text[], NULL, NULL, 'Die Tagesschau informiert über die aktuellen Geschehnisse.
The evening news informes about current events.', 1157, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'criticism, review', 'Kritik', ARRAY[]::text[], 'noun', 'die', 'Deine Kritik ist etwas überzogen.
Your criticism is a bit excessive.', 1158, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take care of, be concerned', 'kümmern', ARRAY[]::text[], NULL, NULL, 'Marius kümmert sich liebevoll um seinen kleinen Sohn.
Marius lovingly takes care of his little son.', 1159, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quiet, soft', 'leise', ARRAY[]::text[], NULL, NULL, 'Sprich leise, Maria schläft!
Speak softly, Mary is asleep!', 1160, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'negative', 'negativ', ARRAY[]::text[], NULL, NULL, 'Leider kann ich dir nur eine negative Antwort geben.
Unfortunately, I can only give you a negative answer.', 1161, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to nod', 'nicken', ARRAY[]::text[], NULL, NULL, 'Sie nickte mit dem Kopf.
She nodded her head.', 1162, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to organize', 'organisieren', ARRAY[]::text[], NULL, NULL, 'Eine Hochzeit zu organisieren, ist nicht einfach.
Organizing a wedding is not easy.', 1163, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'partner', 'Partner', ARRAY[]::text[], 'noun', 'der', 'Für den Tangokurs suche ich noch einen Partner.
I''m still looking for a partner for the tango class.', 1164, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'by way of, per', 'per', ARRAY[]::text[], NULL, NULL, 'Die Güter wurden per Schiff transportiert. Wir werden Sie unverzüglich per E-Mail kontaktieren.
The goods were transported by ship. We will contact you promptly via e-mail.', 1165, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shape, mint', 'prägen', ARRAY[]::text[], NULL, NULL, 'Dieses Erlebnis wird ihn prägen. Die Entscheidung, die wir heute getroffen haben, wird unsere Zukunft prägen.
This experience will shape him. The decision we have made today will shape our future.', 1166, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lake', 'See', ARRAY[]::text[], 'noun', 'der', 'Vor uns lag ein kalter, tiefer See.
In front of us was a cold, deep lake.', 1167, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sink', 'sinken', ARRAY[]::text[], NULL, NULL, 'Die Titanic ist im Atlantik gesunken.
The Titanic sank in the Atlantic.', 1168, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'anyway', 'sowieso', ARRAY[]::text[], NULL, NULL, 'Ich werde bleiben; ich habe den letzten Bus sowieso verpasst. Ich muss sowieso zur Bank, ich begleite dich ein Stück.
I will stay; I have missed the last bus anyway. I need to go the bank anyway, I will accompany you part of the way.', 1169, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'type', 'Typ', ARRAY[]::text[], 'noun', 'der', 'Was für ein Typ Mensch bist du?
What type of a person are you?', 1170, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to avoid', 'vermeiden', ARRAY[]::text[], NULL, NULL, 'Vermeiden Sie Autounfälle, halten Sie genug Abstand!
Avoid car accidents, keep a safe distance!', 1171, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to announce', 'ankündigen', ARRAY[]::text[], NULL, NULL, 'Der Direktor kündigt Veränderungen an.
The Director announces changes.', 1172, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'subsequent, afterwards', 'anschließend', ARRAY[]::text[], NULL, NULL, 'Sie gingen ins Kino und anschließend noch etwas essen.
They went to the movies and afterwards they went to a restaurant.', 1173, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stand up, get up', 'aufstehen', ARRAY[]::text[], NULL, NULL, 'Am Wochenende müssen wir nicht so früh aufstehen.
On weekends we don''t have to get up so early.', 1174, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'event', 'Ereignis', ARRAY[]::text[], 'noun', 'das', 'Die Geburt eines Kindes ist immer ein erfreuliches Ereignis.
The birth of a child is always an enjoyable event.', 1175, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'limited liability company, Ltd', 'GmbH', ARRAY[]::text[], 'noun', 'die', 'Für die Gründung einer GmbH braucht man Eigenkapital.
For the establishment of a limited company you need equity.', 1176, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'inspection', 'Kontrolle', ARRAY[]::text[], 'noun', 'die', 'In der Straßenbahn gibt es regelmäßig Kontrollen.
On the tram, there are regular inspections.', 1177, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'object', 'Objekt', ARRAY[]::text[], 'noun', 'das', 'In der Ausstellung kann man 200 Objekte von verschiedenen Künstlern sehen.
In the exhibition you can see 200 objects from various artists.', 1178, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sacrifice, victim', 'Opfer', ARRAY[]::text[], 'noun', 'das', 'Herr Trautmann wurde Opfer einer Intrige.
Mr. Trautmann became victim of an intrigue.', 1179, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Austrian', 'österreichisch', ARRAY[]::text[], NULL, NULL, 'Das Eierpecken ist eine alte österreichische Tradition zu Ostern.
The Eierpecken is an old Austrian tradition at Easter.', 1180, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'speaker', 'Sprecher', ARRAY[]::text[], 'noun', 'der', 'Heute hält der Sprecher des StudentInnenrates eine Rede.
Today the speaker of the College Council is holding a speech.', 1181, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to strengthen, reinforce', 'verstärken', ARRAY[]::text[], NULL, NULL, 'Die Sicherheitskontrollen an internationalen Flughäfen werden verstärkt.
The security checks at international airports are going to be strengthened.', 1182, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to plan, provide for', 'vorsehen', ARRAY[]::text[], NULL, NULL, 'Der Studiengang sieht ein obligatorisches Praktikumssemester vor.
The program provides for a mandatory internship semester.', 1183, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'workplace, job', 'Arbeitsplatz', ARRAY[]::text[], 'noun', 'der', 'Er befindet sich auf der Suche nach einem neuen Arbeitsplatz.
He is looking for a new job.', 1184, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reception, recording, snapshot', 'Aufnahme', ARRAY[]::text[], 'noun', 'die', 'Auf der CD ist eine historische Aufnahme einer Rede Willy Brandts zu hören.
On the CD you can hear a historical recording of one of Willy Brandt''s speeches.', 1185, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to restrict, to confine', 'beschränken', ARRAY[]::text[], NULL, NULL, 'Ihr Einflussbereich ist auf das Bundesland Sachsen beschränkt.
Their sphere of influence is restricted to the state of Saxony.', 1186, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the one hand', 'einerseits', ARRAY[]::text[], NULL, NULL, 'Einerseits liebe ich ihn, aber andererseits möchte ich mich nicht binden.
On the one hand, I love him, but on the other hand I don''t want to commit.', 1187, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ability, capability', 'Fähigkeit', ARRAY[]::text[], 'noun', 'die', 'Die intellektuellen Fähigkeiten von Menschen sind oft sehr unterschiedlich.
The intellectual abilities of people are often very different.', 1188, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'happy, fortunate', 'glücklich', ARRAY[]::text[], NULL, NULL, 'Leonie und Max sind ein glückliches Paar.
Leonie and Max are a happy couple.', 1189, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'out', 'heraus', ARRAY[]::text[], NULL, NULL, 'Die Kinder sind schon aus dem Gröbsten heraus.
The children are already out of the woods.', 1190, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'card, ticket, menu', 'Karte', ARRAY[]::text[], 'noun', 'die', 'Wieviel kostet eine Karte für das Konzert heute abend?
How much is a ticket for tonight''s concert?', 1191, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'vacation, holiday', 'Urlaub', ARRAY[]::text[], 'noun', 'der', 'Unser Amerikaurlaub im letzten Jahr war ein sehr teurer Urlaub.
Our holiday in America last year was a very expensive vacation.', 1192, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'responsibility', 'Verantwortung', ARRAY[]::text[], 'noun', 'die', 'Eltern tragen Verantwortung für ihre Kinder.
Parents are responsible for their children.', 1193, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to injure', 'verletzen', ARRAY[]::text[], NULL, NULL, 'Ich habe mich beim Joggen am Fuß verletzt.
I injured my foot while jogging.', 1194, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'truth', 'Wahrheit', ARRAY[]::text[], 'noun', 'die', 'Sie verschweigt ihm die Wahrheit.
She conceals the truth from him.', 1195, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to understand, grasp', 'begreifen', ARRAY[]::text[], NULL, NULL, 'Wir begreifen einfach nicht, wie so etwas möglich ist.
We just don''t understand how such a thing is possible.', 1196, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'professional', 'beruflich', ARRAY[]::text[], NULL, NULL, 'Mit ihrem Zeugnis hat sie sehr gute berufliche Perspektiven.
With her reports she has very good career prospects.', 1197, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to invite, load', 'einladen', ARRAY[]::text[], NULL, NULL, 'Tante Lotte lädt jeden Samstag ihre Freundinnen zum Kaffee ein.
Aunt Lotte invites her friends for coffee every Saturday.', 1198, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to recommend', 'empfehlen', ARRAY[]::text[], NULL, NULL, 'Der Chefkoch empfiehlt heute die Fischsuppe.
Today the chef recommends the fish soup.', 1199, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to open, start', 'eröffnen', ARRAY[]::text[], NULL, NULL, 'Morgen eröffnet das neue Kaufhaus am Markt.
Tomorrow the new department store at the market is going to open.', 1200, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'building', 'Gebäude', ARRAY[]::text[], 'noun', 'das', 'In diesem Gebäude befindet sich die Stadtverwaltung.
This building houses the city administration.', 1201, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'associate, shareholder', 'Gesellschafter', ARRAY[]::text[], 'noun', 'der', 'Sie haben gegen alle Gesellschafter des Unternehmens geklagt.
They have filed suit against all shareholders of the company.', 1202, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'decade', 'Jahrzehnt', ARRAY[]::text[], 'noun', 'das', 'Das letzte Jahrzehnt des 20. Jahrhunderts war relativ friedlich.
The last decade of the 20th Century was relatively peaceful.', 1203, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'north', 'Norden', ARRAY['Nord']::text[], 'noun', 'der', 'Im Norden der Stadt liegt der Zoo.
In the north of the town is the zoo.', 1204, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ear', 'Ohr', ARRAY[]::text[], 'noun', 'das', 'Ich bin auf dem linken Ohr etwas taub.
I''m somewhat deaf in the left ear.', 1205, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'examination, test', 'Prüfung', ARRAY[]::text[], 'noun', 'die', 'Mindestens die Hälfte der Teilnehmer hat die Prüfung nicht bestanden.
At least half of the participants did not pass the exam.', 1206, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'regulation, settlement', 'Regelung', ARRAY[]::text[], 'noun', 'die', 'Die Politiker haben eine neue Regelung getroffen.
The politicians have made a new regulation.', 1207, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ship', 'Schiff', ARRAY[]::text[], 'noun', 'das', 'Sein Traum ist es, mit dem Schiff nach Südamerika zu fahren.
His dream is to travel by ship to South America.', 1208, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'obvious (not: offenbar, natuerlich, klar)', 'selbstverständlich', ARRAY[]::text[], NULL, NULL, 'Das ist doch selbstverständlich.
That goes without saying.', 1209, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to depend', 'abhängen', ARRAY[]::text[], NULL, NULL, 'Das Klima hängt von Relief und Meeresnähe ab.
The climate depends on surface topographie and proximity to the ocean.', 1210, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put on, invest (not: investieren)', 'anlegen', ARRAY[]::text[], NULL, NULL, 'Sie hat ihr ganzes Geld in Aktien angelegt.
She invested all her money in stocks.', 1211, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exhibition', 'Ausstellung', ARRAY[]::text[], 'noun', 'die', 'Es handelt sich hier um eine Ausstellung zeitgenössischer Maler.
This is an exhibition of contemporary painters.', 1212, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to make an effort (strive)', 'bemühen', ARRAY[]::text[], NULL, NULL, 'Wir bemühen uns um ein besseres Betriebsklima.
We strive for a better working atmosphere.', 1213, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to decide (not: entscheiden)', 'beschließen', ARRAY[]::text[], NULL, NULL, 'Die Regierung beschließt, die Entscheidung zu vertagen.
The government decided to postpone the decision.', 1214, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reference, cover', 'Bezug', ARRAY[]::text[], 'noun', 'der', 'Ich sehe hier keinen Bezug zu unserer Problemstellung.
I see no reference to our problem here.', 1215, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'request (not: das Anliegen)', 'Bitte', ARRAY[]::text[], 'noun', 'die', 'Ich habe eine Bitte an dich.
I have a question for you.', 1216, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hope', 'Hoffnung', ARRAY[]::text[], 'noun', 'die', 'Trotz seiner Krankheit ist er voller Hoffnung.
Despite his illness, he is full of hope.', 1217, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to concentrate', 'konzentrieren', ARRAY[]::text[], NULL, NULL, 'Versuch, dich auf das Wesentliche zu konzentrieren!
Try to focus on the essentials!', 1218, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lead (not: führen)', 'leiten', ARRAY[]::text[], NULL, NULL, 'Professor Schmidt wird die Konferenz leiten.
Professor Schmidt will lead the conference.', 1219, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'official', 'offiziell', ARRAY[]::text[], NULL, NULL, 'Sie erhielt ein offizielles Schreiben.
She received an official letter.', 1220, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to examine, check', 'prüfen', ARRAY[]::text[], NULL, NULL, 'Wir müssen noch den Ölstand des Autos prüfen.
We still need to check the oil level of the car.', 1221, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to estimate, value', 'schätzen', ARRAY[]::text[], NULL, NULL, 'Ich schätze ihren Rat sehr.
I value her advice very much.', 1222, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'so to speak', 'sozusagen', ARRAY[]::text[], NULL, NULL, 'Wir haben kein Interesse an Ihrem Angebot, es ist sozusagen besser, wenn Sie gehen.
We are not interested in your offer, so to speak it is better that you leave.', 1223, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strict', 'streng', ARRAY[]::text[], NULL, NULL, 'Herr Ludwig ist ein sehr strenger Lehrer.
Mr. Ludwig is a very strict teacher.', 1224, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to amuse oneself, chat', 'unterhalten', ARRAY[]::text[], NULL, NULL, 'Die Freunde unterhalten sich bis tief in die Nacht.
The friends are chatting till far into the night.', 1225, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to obligate, commit', 'verpflichten', ARRAY[]::text[], NULL, NULL, 'Er ist verpflichtet, regelmäßig Unterhalt für sein Kind zu zahlen.
He is obligated to regularly pay alimony for his child.', 1226, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go on', 'weitergehen', ARRAY[]::text[], NULL, NULL, 'Wir gehen jetzt weiter.
We are going on now.', 1227, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to return (not: zurückkommen)', 'zurückkehren', ARRAY[]::text[], NULL, NULL, 'Nach drei Jahren kehrt Michael von seinem Asienaufenthalt zurück.
After three years, Michael returns from his stay in Asia.', 1228, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'volume, tome', 'Band', ARRAY[]::text[], 'noun', 'der', 'Bald erscheint der sechste Band der Enzyklopädie.
Soon the sixth volume of the encyclopedia will come out.', 1229, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to contribute', 'beitragen', ARRAY[]::text[], NULL, NULL, 'Das Verbrennen von fossilen Rohstoffen trägt zur Umweltverschmutzung bei.
The burning of fossil fuels contributes to pollution.', 1230, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the report', 'Bericht', ARRAY[]::text[], 'noun', 'der', 'Im Fernsehen lief ein Bericht über China.
On television was shown a report about China.', 1231, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to break', 'brechen', ARRAY[]::text[], NULL, NULL, 'Dünnes Eis bricht sehr schnell.
Thin ice breaks very quickly.', 1232, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '[to] there', 'dahin', ARRAY[]::text[], NULL, NULL, 'Dahin bin ich noch nie gefahren.
I have never driven [to] there.', 1233, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to define', 'definieren', ARRAY[]::text[], NULL, NULL, 'Dieses Phänomen lässt sich nicht eindeutig definieren.
This phenomenon can not be clearly defined.', 1234, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attitude, employment', 'Einstellung', ARRAY[]::text[], 'noun', 'die', 'Sie hat eine positive Einstellung gegenüber ihren Schwiegereltern.
She has a positive attitude towards their parents in law.', 1235, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fine', 'fein', ARRAY[]::text[], NULL, NULL, 'Das ist ein feiner Unterschied.
That is a fine distinction.', 1236, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fix, lay down', 'festlegen', ARRAY[]::text[], NULL, NULL, 'Wir sollten uns auf eine Strategie festlegen.
We should fix a strategy.', 1237, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'court, dish', 'Gericht', ARRAY[]::text[], 'noun', 'das', 'Das Gericht ist zu einer Entscheidung gekommen.
The court has come to a decision.', 1238, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'profit', 'Gewinn', ARRAY[]::text[], 'noun', 'der', 'Das Unternehmen erzielte dieses Jahr nur minimalen Gewinn.
The company achieved this year only minimal profit.', 1239, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'complex', 'komplex', ARRAY[]::text[], NULL, NULL, 'Das Aufgabenfeld ist sehr komplex.
The task field is very complex.', 1240, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'king', 'König', ARRAY[]::text[], 'noun', 'der', 'Wer ist König von Spanien?
Who is the King of Spain?', 1241, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'May', 'Mai', ARRAY[]::text[], 'noun', 'der', 'Im Mai fangen die Blumen an zu blühen.
In May, the flowers begin to bloom.', 1242, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'upper', 'obere', ARRAY['s)']::text[], NULL, NULL, 'Die oberen Fenster sind schon lange nicht mehr geputzt worden.
The upper windows have not been cleaned for a long time.', 1243, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to orient', 'orientieren', ARRAY[]::text[], NULL, NULL, 'Orientiere dich einfach an der Kirchturmspitze!
Orient yourself simply towards the church spire!', 1244, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cry out, scream', 'schreien', ARRAY[]::text[], NULL, NULL, 'Sie hat im Schlaf geschrieen.
She cried out in her sleep.', 1245, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'victory', 'Sieg', ARRAY[]::text[], 'noun', 'der', 'Sie errangen erneut einen unerwarteten Sieg.
They won an unexpected victory again.', 1246, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'deed', 'Tat', ARRAY[]::text[], 'noun', 'die', 'Sie beging eine grausame Tat.
She committed a cruel deed.', 1247, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the dream', 'Traum', ARRAY[]::text[], 'noun', 'der', 'Heinz hatte einen schlimmen Traum.
Heinz had a bad dream.', 1248, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'union', 'Union', ARRAY[]::text[], 'noun', 'die', 'Die Europäische Union wurde im Mai 2004 um zehn Länder erweitert.
The European Union was expanded in May 2004 by ten countries.', 1249, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'American', 'Amerikaner', ARRAY[]::text[], 'noun', 'der', 'Der Verstorbene war Amerikaner.
The deceased was an American.', 1250, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foreign', 'ausländisch', ARRAY[]::text[], NULL, NULL, 'Er spricht mit einem ausländischen Akzent.
He speaks with a foreign accent.', 1251, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exclusively', 'ausschließlich', ARRAY[]::text[], NULL, NULL, 'Diese Spenden dienen ausschließlich gemeinnützigen Zwecken.
These donations are used exclusively for charitable purposes.', 1252, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'visitor', 'Besucher', ARRAY[]::text[], 'noun', 'der', 'Bereits in der ersten Woche sahen Tausende von Besuchern die Ausstellung.
Already in the first week thousands of visitors saw the exhibition.', 1253, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'so far (not: so weit)', 'bisherig', ARRAY[]::text[], NULL, NULL, 'Ihre bisherigen Leistungen sind zufrieden stellend.
So far their achievements are satisfactory.', 1254, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the bond, association, alliance', 'Bund', ARRAY[]::text[], 'noun', 'der', 'Sie gehen den Bund der Ehe ein.
They enter into marriage.', 1255, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'director, headmaster', 'Direktor', ARRAY[]::text[], 'noun', 'der', 'Etwas später wurde Herr Schwab Direktor des Gymnasiums.
A little bit later, Mr. Schwab became director of the Gymnasium.', 1256, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take (up, in)', 'einnehmen', ARRAY[]::text[], NULL, NULL, 'Bei der Spendenaktion wurden 2500 Euro eingenommen.
At the fundraiser 2500 euros were taken in.', 1257, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for the first time', 'erstmals', ARRAY[]::text[], NULL, NULL, 'Erstmals hatten sie keine Angst mehr, nicht satt zu werden.
For the first time they weren''t afraid anymore of not getting sated.', 1258, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'geography', 'Geographie', ARRAY[]::text[], 'noun', 'die', 'Kenntnisse in Geographie sind oft sehr nützlich.
Knowledge of geography is often very useful.', 1259, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'background', 'Hintergrund', ARRAY[]::text[], 'noun', 'der', 'Halte dich bitte unauffällig im Hintergrund!
Please remain unobtrusively in the background!', 1260, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as far as that goes', 'insofern', ARRAY[]::text[], NULL, NULL, 'Mit dem dritten Platz habe ich nicht gerechnet, insofern bin ich mehr als zufrieden.
I didn''t expect to rank 3rd, as far as that goes I''m more than satisfied.', 1261, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'loud', 'laut', ARRAY[]::text[], NULL, NULL, 'Im Volkshaus ist es mir zu laut.
In the Volkshaus it''s too loud for me.', 1262, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to present', 'präsentieren', ARRAY[]::text[], NULL, NULL, 'Die Kinder präsentieren einen Zaubertrick.
The children are presenting a magic trick.', 1263, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quality', 'Qualität', ARRAY[]::text[], 'noun', 'die', 'Diese Seife ist von höchster Qualität.
This soap is of the highest quality.', 1264, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'edge', 'Rand', ARRAY[]::text[], 'noun', 'der', 'Wir standen am Rand der Schlucht und schauten in die Tiefe.
We stood at the edge of the canyon and looked into the depths.', 1265, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sensible, meaningful', 'sinnvoll', ARRAY[]::text[], NULL, NULL, 'Das ist keine sinnvolle Frage.
This is not a meaningful question.', 1266, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'active', 'tätig', ARRAY[]::text[], NULL, NULL, 'Er ist im Bereich Sprachlehrforschung tätig.
He works in the field of language teaching research.', 1267, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to transfer', 'übertragen', ARRAY[]::text[], NULL, NULL, 'Der Erreger kann durch den geringsten Kontakt übertragen werden.
The pathogen can be transferred by the slightest contact.', 1268, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'original (nicht original)', 'ursprünglich', ARRAY[]::text[], NULL, NULL, 'Unser ursprüngliches Vorgehen erwies sich als ineffektiv.
Our original approach proved to be ineffective.', 1269, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'past', 'Vergangenheit', ARRAY[]::text[], 'noun', 'die', 'Kleopatra hatte eine dunkle Vergangenheit.
Cleopatra had a dark past.', 1270, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'portion, section', 'Abschnitt', ARRAY[]::text[], 'noun', 'der', 'Besonders der dritte Abschnitt des Textes ist sehr interessant.
Especially the third section of the text is very interesting.', 1271, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'incorporated company, inc.', 'Aktiengesellschaft', ARRAY['AG']::text[], 'noun', 'die', 'Die Aktiengesellschaft wählt einen neuen Aufsichtsrat.
The corporated company is electing a new board.', 1272, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to look at, watch', 'anschauen', ARRAY[]::text[], NULL, NULL, 'Du musst dir diesen Film unbedingt anschauen.
You have to watch this film absolutely.', 1273, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'farmer', 'Bauer', ARRAY[]::text[], 'noun', 'der', 'Seine Eltern waren Bauern in Schlesien.
His parents were farmers in Silesia.', 1274, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to notice', 'bemerken', ARRAY[]::text[], NULL, NULL, 'Die Krankenschwester bemerkte nicht, wie der Patient nach ihr klingelte.
The nurse did not notice as the patient rang for her.', 1275, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'marriage', 'Ehe', ARRAY[]::text[], 'noun', 'die', 'Sie verbrachten eine glückliche Ehe.
They spent a happy marriage.', 1276, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fill', 'füllen', ARRAY[]::text[], NULL, NULL, 'Er füllt den Eimer mit Wasser.
He fills the bucket with water.', 1278, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intellectual, mental', 'geistig', ARRAY[]::text[], NULL, NULL, 'Geistig ist sie noch völlig gesund, aber körperlich nicht.
Mentally she still is completely healthy, but physically she isn''t.', 1279, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'by contrast, on the other hand', 'hingegen', ARRAY[]::text[], NULL, NULL, 'Er hat Interesse daran zu arbeiten, du hingegen bist faul.
He is interested in working, you, on the other hand, are lazy.', 1280, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'annual', 'jährlich', ARRAY[]::text[], NULL, NULL, 'Sie einigten sich auf ein jährliches Treffen.
They agreed upon an annual meeting.', 1281, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'with the aid', 'mithilfe', ARRAY[]::text[], NULL, NULL, 'Mithilfe eines Wörterbuchs kann man den Text besser verstehen.
With the aid of a dictionary, you can understand the text better.', 1282, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the way', 'unterwegs', ARRAY[]::text[], NULL, NULL, 'Als Julian anrief, war Fabian schon unterwegs nach Hause.
When Julian called, Fabian had already been on his way home.', 1283, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cause', 'Ursache', ARRAY[]::text[], 'noun', 'die', 'Die Ursache für den Brand ist noch nicht bekannt.
The cause of the fire is still unknown.', 1284, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'loss', 'Verlust', ARRAY[]::text[], 'noun', 'der', 'Das Unternehmen machte letztes Jahr keinen Gewinn, sondern einen hohen Verlust.
The company didn''t make a profit last year, but a heavy loss.', 1285, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to distribute', 'verteilen', ARRAY[]::text[], NULL, NULL, 'Vertreter von Greenpeace verteilen Broschüren.
Representatives of Greenpeace are distributing brochures.', 1286, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to plan (not vorstellen or planen or planieren)', 'vornehmen', ARRAY[]::text[], NULL, NULL, 'Rainer nimmt sich vor, seiner Angela endlich einen Heiratsantrag zu machen.
Rainer is planning to finally propose to his Angela.', 1287, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'winter', 'Winter', ARRAY[]::text[], 'noun', 'der', 'Der letzte Winter war kalt und schneereich.
The last winter was cold and snowy.', 1288, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'spectator', 'Zuschauer', ARRAY[]::text[], 'noun', 'der', 'Die Zuschauer beginnen, sich zu langweilen.
The spectators are beginning to get bored.', 1289, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to give, hand in, submit', 'abgeben', ARRAY[]::text[], NULL, NULL, 'Andreas hat seine Hausarbeit nicht rechtzeitig abgegeben.
Andreas has not submitted his homework on time.', 1290, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to decrease, reduce', 'abnehmen', ARRAY[]::text[], NULL, NULL, 'Um abzunehmen, hat schon jede zweite Frau eine Diät ausprobiert.
To reduce weight, every second woman has already tried making a diet.', 1291, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'number', 'Anzahl', ARRAY[]::text[], 'noun', 'die', 'Eine hohe Anzahl von Jugendlichen sieht pessimistisch in die Zukunft.
A high number of young people are looking pessimistic towards the future.', 1292, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to show, exhibit, contain (not: aufzeichnen)', 'aufweisen', ARRAY[]::text[], NULL, NULL, 'Die Krankheit weist verschiedene Symptome auf.
The disease shows different symptoms.', 1293, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bad, mad', 'böse', ARRAY[]::text[], NULL, NULL, 'Da kam ihm ein richtig böser Gedanke.
A really bad thought occured to him.', 1294, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the same (one, ones)', 'derselbe', ARRAY['dieselbe', 'dasselbe']::text[], NULL, NULL, 'Das ist derselbe Mann, der gestern schon da war.
This is the same man who was there yesterday.', 1295, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'this time', 'diesmal', ARRAY[]::text[], NULL, NULL, 'Diesmal werde ich daran denken.
This time I''ll remember it.', 1296, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fresh', 'frisch', ARRAY[]::text[], NULL, NULL, 'Ein frischer Wind kam aus Nordwest.
A fresh wind blew from the northwest.', 1297, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to marry', 'heiraten', ARRAY[]::text[], NULL, NULL, 'Willst du mich heiraten?
Will you marry me?', 1298, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'island', 'Insel', ARRAY[]::text[], 'noun', 'die', 'Rügen ist die größte deutsche Insel.
Rügen is the largest German island.', 1299, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instrument', 'Instrument', ARRAY[]::text[], 'noun', 'das', 'Spielen Sie ein Instrument?
Do you play an instrument?', 1300, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'January', 'Januar', ARRAY[]::text[], 'noun', 'der', 'Im Januar habe ich ein Vorstellungsgespräch in Bonn.
In January, I''m going to have an interview in Bonn.', 1301, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to measure', 'messen', ARRAY[]::text[], NULL, NULL, 'Es ist wichtig, regelmäßig den Blutdruck zu messen.
It is important to measure the blood pressure regularly.', 1302, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to think about, reflect', 'nachdenken', ARRAY[]::text[], NULL, NULL, 'Astrid denkt gerade über einen Auslandsaufenthalt nach.
Astrid is just thinking about a stay abroad.', 1303, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'news, message', 'Nachricht', ARRAY[]::text[], 'noun', 'die', 'Deine Nachricht kam völlig unerwartet.
Your message came completely unexpected.', 1304, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plant', 'Pflanze', ARRAY[]::text[], 'noun', 'die', 'Zwei meiner Pflanzen sind eingegangen.
Two of my plants died.', 1305, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Saturday', 'Samstag', ARRAY[]::text[], 'noun', 'der', 'Am Samstag hat die Bibliothek bis 17 Uhr geöffnet.
On Saturday, the library is open till 5 pm.', 1306, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'disturbance, interruption', 'Störung', ARRAY[]::text[], 'noun', 'die', 'Die Störung im Atomkraftwerk verunsicherte die Bevölkerung.
The disorder in the atomic power plant unsettled the population.', 1307, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to improve, correct', 'verbessern', ARRAY[]::text[], NULL, NULL, 'Wir haben unseren Service verbessert.
We have improved our service.', 1308, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'representative', 'Vertreter', ARRAY[]::text[], 'noun', 'der', 'Ein Vertreter der Jugendinitiative ergriff das Wort.
A representative of the Youth Initiative rose to speak.', 1309, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'advice, suggestion, proposal', 'Vorschlag', ARRAY[]::text[], 'noun', 'der', 'Wir nehmen Ihren Vorschlag an.
We accept your proposal.', 1310, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extensive, extensively (not: umfangreich)', 'weitgehend', ARRAY[]::text[], NULL, NULL, 'Die Bauarbeiten sind weitgehend abgeschlossen.
The construction works are extensively completed.', 1311, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'centimetre, cm', 'Zentimeter', ARRAY['cm']::text[], 'noun', 'der', 'Ein A4-Blatt misst etwa 30cm.
An A4 sheet measures about 30cm.', 1312, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distance', 'Abstand', ARRAY[]::text[], 'noun', 'der', 'Viele Autounfälle entstehen dadurch, dass nicht genügend Abstand gehalten wird.
Many car accidents are caused by the fact that not enough distance is kept.', 1313, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'education', 'Bildung', ARRAY[]::text[], 'noun', 'die', 'Sie hat eine hohe Bildung genossen.
She has enjoyed a high level of education.', 1314, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the one (who, that)', 'derjenige', ARRAY['diejenige', 'dasjenige']::text[], NULL, NULL, 'Derjenige, der zuerst eine Sechs würfelt, darf anfangen.
The one who first throws a six, can start.', 1315, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quality (not: die Qualität)', 'Eigenschaft', ARRAY[]::text[], 'noun', 'die', 'Claudia hat eine Menge guter Eigenschaften.
Claudia has a lot of good qualities.', 1316, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to achieve, reach [a goal]', 'erzielen', ARRAY[]::text[], NULL, NULL, 'Es wurden nicht die erhofften Ergebnisse erzielt.
The expected results were not achieved.', 1317, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'generation', 'Generation', ARRAY[]::text[], 'noun', 'die', 'Ihnen gehört das Haus bereits in der dritten Generation.
They own the house already in the third generation.', 1318, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come in', 'hereinkommen', ARRAY['reinkommen']::text[], NULL, NULL, 'Kommen Sie doch herein!
Come on in!', 1319, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intensive', 'intensiv', ARRAY[]::text[], NULL, NULL, 'Das verlangt nach einer intensiven Behandlung.
This requires intensive treatment.', 1320, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'leader', 'Leiter', ARRAY[]::text[], 'noun', 'der', 'Max war der Leiter seiner Gruppe.
Max was the leader of his group.', 1321, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rid of, going on', 'los', ARRAY[]::text[], NULL, NULL, 'Was ist denn hier los?
What''s going on here?', 1322, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'afterwards', 'nachher', ARRAY[]::text[], NULL, NULL, 'Nachher treffe ich mich mit einer Freundin zum Mittagessen.
Afterwards I''m going to meet a friend for lunch.', 1323, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to collect, gather', 'sammeln', ARRAY[]::text[], NULL, NULL, 'Thomas sammelt Briefmarken.
Thomas collects stamps.', 1324, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as long as', 'solange', ARRAY[]::text[], NULL, NULL, 'Solange es regnet, putze ich die Fenster nicht.
As long as it rains, I won''t clean the windows.', 1325, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'end, conclusion', 'Abschluss', ARRAY[]::text[], 'noun', 'der', 'Der Abschluss des Studiums zog sich immer weiter hinaus.
The end of the university program dragged on and on.', 1326, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to set off, provoke', 'auslösen', ARRAY[]::text[], NULL, NULL, 'Die Wahl des Präsidenten löste einen Bürgerkrieg aus.
The election of the president sparked a civil war.', 1327, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'outside', 'außen', ARRAY[]::text[], NULL, NULL, 'Außen am Haus ist eine Leiter befestigt.
On the outside of the house a ladder is attached.', 1328, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'automatic', 'automatisch', ARRAY[]::text[], NULL, NULL, 'Die Anmeldung erfolgt automatisch.
The registration is done automatically.', 1329, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sheet, leaf', 'Blatt', ARRAY[]::text[], 'noun', 'das', 'Vor ihr lag ein leeres Blatt Papier.
In front of her was a blank sheet of paper.', 1330, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'December', 'Dezember', ARRAY[]::text[], 'noun', 'der', 'Im Dezember gibt es Ferien.
In December, there are holidays.', 1331, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Thursday', 'Donnerstag', ARRAY[]::text[], 'noun', 'der', 'Am Donnerstag Abend gehe ich ins Kabarett.
On Thursday night I''ll go to the cabaret.', 1332, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prevail, carry through, enforce', 'durchsetzen', ARRAY[]::text[], NULL, NULL, 'Vater kann sich nicht gegen Mutter durchsetzen.
Father can not prevail against mother.', 1333, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to replace, reimburse', 'ersetzen', ARRAY[]::text[], NULL, NULL, 'Ihre Geldkarte wird Ihnen selbstverständlich umgehend ersetzt.
Your debit card will of course be replaced promptly.', 1334, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to formulate', 'formulieren', ARRAY[]::text[], NULL, NULL, 'Die Rede war gut formuliert.
The speech was well formulated.', 1335, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dangerous', 'gefährlich', ARRAY[]::text[], NULL, NULL, 'Sie führen eine gefährliche Aktion aus.
They perform a dangerous action.', 1336, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mind, spirit', 'Geist', ARRAY[]::text[], 'noun', 'der', 'Marie Curie hatte einen wachen Geist.
Marie Curie had an alert mind.', 1337, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'heavy, violent', 'heftig', ARRAY[]::text[], NULL, NULL, 'Sie gerieten in einen heftigen Sturm.
They were caught in a violent storm.', 1338, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interview', 'Interview', ARRAY[]::text[], 'noun', 'das', 'Es wurden viele Interviews geführt.
Many interviews were conducted.', 1339, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fight', 'kämpfen', ARRAY[]::text[], NULL, NULL, 'Die Studierenden kämpfen um bessere Studienbedingungen.
Students fight for better conditions of study.', 1340, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'militarily', 'militärisch', ARRAY[]::text[], NULL, NULL, 'Der Staat sieht keine andere Möglichkeit, als militärisch in den Konflikt einzugreifen.
The government sees no other option but to intervene militarily in the conflict.', 1341, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'semester', 'Semester', ARRAY[]::text[], 'noun', 'das', 'Das Semester beginnt im Oktober und endet im März.
The semester begins in October and ends in March.', 1342, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stand, stage (not: die Bühne)', 'Stand', ARRAY[]::text[], 'noun', 'der', 'Sie war auf dem neuesten Stand der Entwicklungen.
She was state-of-the-art of developments.', 1343, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tradition', 'Tradition', ARRAY[]::text[], 'noun', 'die', 'Das Eierwerfen ist eine alte sächsische Tradition.
The egg throwing is an old Saxon tradition.', 1344, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'complete (or fully ready)', 'vollständig', ARRAY[]::text[], NULL, NULL, 'Ihre Bewerbung ist vollständig.
Your application is complete.', 1345, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'passt, over', 'vorbei', ARRAY[]::text[], NULL, NULL, 'Die Vorstellung ist vorbei, die Zuschauer verlassen das Theater.
The show is over, the audience is leaving the theater.', 1346, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to warn', 'warnen', ARRAY[]::text[], NULL, NULL, 'Die Regierung warnt vor voreiligen Entschlüssen.
The government warns against hasty decisions.', 1347, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(sports) complex, investment, attachment', 'Anlage', ARRAY[]::text[], 'noun', 'die', 'Für den Erhalt dieser Anlage wurde viel Geld gespendet.
To obtain this complex much money was donated.', 1348, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'department, authorities', 'Behörde', ARRAY[]::text[], 'noun', 'die', 'Wenden Sie sich bitte an die zuständigen Behörden.
Please refer to the appropriate authorities.', 1349, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stage', 'Bühne', ARRAY[]::text[], 'noun', 'die', 'Die Sängerin tritt auf die Bühne.
The singer enters the stage.', 1350, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lady', 'Dame', ARRAY[]::text[], 'noun', 'die', 'Die Dame des Hauses ist leider nicht da.
The lady of the house is not here, unfortunately.', 1351, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to push, insist', 'drängen', ARRAY[]::text[], NULL, NULL, 'Sie drängte darauf, dass er mitkommt.
She insisted that he comes along.', 1352, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clear (not: klar, offenbar)', 'eindeutig', ARRAY[]::text[], NULL, NULL, 'Die Wahl ergab ein eindeutiges Ergebnis.
The election yielded a clear result.', 1353, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'element', 'Element', ARRAY[]::text[], 'noun', 'das', 'Kennst du den Film „Das siebte Element“?
Do you know the movie "The Seventh Element"?', 1354, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in case, if', 'falls', ARRAY[]::text[], NULL, NULL, 'Falls du es dir anders überlegst, kannst du mich jederzeit anrufen.
In case you change your mind, you can call me anytime.', 1355, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opportunity', 'Gelegenheit', ARRAY[]::text[], 'noun', 'die', 'Plötzlich bot sich ihr eine sehr gute Gelegenheit für ihren Plan.
Suddenly a good opportunity for her plan arose.', 1356, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'courtyard, yard', 'Hof', ARRAY[]::text[], 'noun', 'der', 'Die Kinder spielen im Hof.
The children are playing in the yard.', 1357, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'communication', 'Kommunikation', ARRAY[]::text[], 'noun', 'die', 'Das Telefon ist ein beliebtes Mittel zur Kommunikation.
The phone is a popular tool of communication.', 1358, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mamma', 'Mama', ARRAY[]::text[], 'noun', 'die', 'Wo ist deine Mama?
Where is your mom?', 1359, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'museum', 'Museum', ARRAY[]::text[], 'noun', 'das', 'In Leipzig hat ein neues Museum eröffnet.
In Leipzig, a new museum has opened.', 1360, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'use', 'Nutzung', ARRAY[]::text[], 'noun', 'die', 'Die Nutzung dieses Gerätes außerhalb der Dienstzeiten ist streng untersagt.
The use of this equipment outside office hours is strictly prohibited.', 1361, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'obvious (not: offenbar, natürlich)', 'offensichtlich', ARRAY[]::text[], NULL, NULL, 'Offensichtlich hast du mit dem Thema mehr Probleme, als du zugeben willst.
Obviously you have more problems with this subject than you want to admit.', 1362, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sharp', 'scharf', ARRAY[]::text[], NULL, NULL, 'Dieses Messer ist scharf.
This knife is sharp.', 1363, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'theoretical', 'theoretisch', ARRAY[]::text[], NULL, NULL, 'Er ist ein Mensch, der sehr theoretisch denkt.
He is a person who thinks in a very theoretical way.', 1364, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to spend (time)', 'verbringen', ARRAY[]::text[], NULL, NULL, 'Sie verbringen den Sommer immer in Südfrankreich.
They spend their summers always in southern France.', 1365, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'why (not: warum, weshalb)', 'wieso', ARRAY[]::text[], NULL, NULL, 'Wieso bist du nicht hier?
Why are you here?', 1366, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put out, agree', 'ausmachen', ARRAY[]::text[], NULL, NULL, 'Wir müssen einen Treffpunkt ausmachen.
We need to agree on a meeting point.', 1367, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'basis', 'Basis', ARRAY[]::text[], 'noun', 'die', 'Mit einer guten Ausbildung schafft man sich eine solide Basis für die Zukunft.
With a good education you build a solid foundation for the future.', 1368, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'famous', 'berühmt', ARRAY[]::text[], NULL, NULL, 'Das berühmteste Bauwerk Berlins ist das Brandenburger Tor.
The most famous building is Berlin is the Brandenburg Gate.', 1369, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tie, bind', 'binden', ARRAY[]::text[], NULL, NULL, 'Soll ich deine Krawatte binden?
Should I tie your tie?', 1370, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'corner', 'Ecke', ARRAY[]::text[], 'noun', 'die', 'Früher mussten unartige Schüler in der Ecke stehen.
In former times naughty students had to stand in the corner.', 1371, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grasp/to cover/bring together in summary (not: greifen)', 'erfassen', ARRAY[]::text[], NULL, NULL, 'Das Thema wurde in ihrem Referat gut erfasst.
The topic was well covered in her presentation.', 1373, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shape, design', 'gestalten', ARRAY[]::text[], NULL, NULL, 'Die Schüler gestalten eine Wandzeitung.
The students are creating a wall newspaper.', 1374, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'autumn', 'Herbst', ARRAY[]::text[], 'noun', 'der', 'Dieses Jahr war der Herbst sehr regnerisch.
This year autumn was very rainy.', 1376, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to point to, refer (to clue into)', 'hinweisen', ARRAY[]::text[], NULL, NULL, 'Wir weisen Sie darauf hin, dass Sie hier nicht parken dürfen.
We remind you that you are not allowed to park here.', 1377, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Jew', 'Jude', ARRAY[]::text[], 'noun', 'der', 'Jesus war Jude.
Jesus was a Jew.', 1378, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'criterion', 'Kriterium', ARRAY[]::text[], 'noun', 'das', 'Wir haben ein wichtiges Kriterium außer Acht gelassen.
We disregarded an important criterion.', 1379, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to control, put in order (through regulation or rules)', 'regeln', ARRAY[]::text[], NULL, NULL, 'Der Straßenverkehr wird durch Ampeln geregelt.
Traffic is controlled by traffic lights.', 1380, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'terror', 'Terror', ARRAY[]::text[], 'noun', 'der', 'Der Anfang des 21. Jahrhunderts stand ganz im Zeichen des Terrors.
The beginning of the 21st Century was marked by terror.', 1381, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'understanding', 'Verständnis', ARRAY[]::text[], 'noun', 'das', 'Die Eltern haben für die Probleme ihrer Tochter viel Verständnis.
The parents have a lot of understanding for their daughter''s problems.', 1382, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to allow, admit (to allow to come in or be added)', 'zulassen', ARRAY[]::text[], NULL, NULL, 'Das Institut lässt pro Semester nur 30 Studenten zum Studium zu.
The Institute only allows 30 students per semester to take the program.', 1383, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cooperation', 'Zusammenarbeit', ARRAY[]::text[], 'noun', 'die', 'Trinken wir auf eine erfolgreiche Zusammenarbeit!
Let''s drink to a successful cooperation!', 1384, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the (+ superlative)', 'am', ARRAY[]::text[], NULL, NULL, 'Markus lief am schnellsten.
Mark ran the fastest.', 1385, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to call', 'anrufen', ARRAY[]::text[], NULL, NULL, 'Ich rufe dich später an.
I''ll call you later.', 1386, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opinion, view', 'Ansicht', ARRAY[]::text[], 'noun', 'die', 'Das ist deine Ansicht, nicht meine!
That''s your opinion, not mine!', 1387, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to attract, put on, dress', 'anziehen', ARRAY[]::text[], NULL, NULL, 'Wenn es sehr kalt ist, sollte man eine dicke Jacke anziehen.
If it is very cold, you should put on a thick jacket.', 1388, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'apart', 'auseinander', ARRAY[]::text[], NULL, NULL, 'Ich kann Christianes vier Kinder nicht auseinander halten.
I can''t keep Christiane''s four children apart.', 1389, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'a fall out (with a friend)', 'Auseinandersetzung', ARRAY[]::text[], 'noun', 'die', 'Sie hatten eine kleine Auseinandersetzung.
They had a little argument.', 1390, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'train, railway, way', 'Bahn', ARRAY[]::text[], 'noun', 'die', 'Ich fahre morgen mit der Bahn nach Weimar.
Tomorrow I''m going to go by train to Weimar.', 1391, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to end', 'beenden', ARRAY[]::text[], NULL, NULL, 'Die Konferenz wurde erst nach Mitternacht beendet.
The conference endet only after midnight.', 1392, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mayor', 'Bürgermeister', ARRAY[]::text[], 'noun', 'der', 'Der Leipziger Bürgermeister heißt Wolfgang Tiefensee.
The Leipzig Mayor is called Wolfgang Tiefensee.', 1393, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'definition', 'Definition', ARRAY[]::text[], 'noun', 'die', 'Das ist eine Frage der Definition.
This is a question of definition.', 1394, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'aeroplane', 'Flugzeug', ARRAY[]::text[], 'noun', 'das', 'Wann landet dein Flugzeug in Hamburg?
When is your plane going to land in Hamburg?', 1395, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'photograph', 'Foto', ARRAY[]::text[], 'noun', 'das', 'Hanna schenkte ihrer Liebsten ein schönes Foto von sich.
Hanna gave her lover a nice photo of herself.', 1396, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'light, bright', 'hell', ARRAY[]::text[], NULL, NULL, 'Die Straßen sind hell erleuchtet.
The streets are brightly lit.', 1397, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at the back', 'hinten', ARRAY[]::text[], NULL, NULL, 'Die Kinder sitzen hinten im Auto.
The children are sitting in the back of the car.', 1398, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mass, crowd', 'Masse', ARRAY[]::text[], 'noun', 'die', 'Das Gesetz von der Erhaltung der Masse wird im Physikunterricht gelehrt.
The law of conservation of mass is taught in physics classes.', 1399, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nation', 'Nation', ARRAY[]::text[], 'noun', 'die', 'In Deutschland leben viele verschiedene Nationen.
Germany is home to many different nations.', 1400, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'phase', 'Phase', ARRAY[]::text[], 'noun', 'die', 'Die Pubertät ist eine schwierige Phase im Leben.
Adolescence is a difficult phase in life.', 1401, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reduce, decrease', 'reduzieren', ARRAY[]::text[], NULL, NULL, 'Sie sollten ihren Alkoholkonsum reduzieren!
You should reduce your alcohol consumption!', 1402, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fail, break down (to go shitty)', 'scheitern', ARRAY[]::text[], NULL, NULL, 'Unser Plan ist gescheitert.
Our plan has failed.', 1403, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rock, stone', 'Stein', ARRAY[]::text[], 'noun', 'der', 'Susanne sammelt Steine, die sie im Urlaub findet.
Susanne collects the stones, which she finds on vacation.', 1404, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'still, quiet', 'still', ARRAY[]::text[], NULL, NULL, 'Robert ist ein stiller Mensch.
Robert is a quiet person.', 1405, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take part', 'teilnehmen', ARRAY[]::text[], NULL, NULL, 'Unser bester Sportler kann nicht an den Olympischen Spielen teilnehmen.
Our best athlete can not take part in the Olympics.', 1406, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sound, tone, clay', 'Ton', ARRAY[]::text[], 'noun', 'der', 'Meine Gitarre macht komische Töne.
My guitar makes funny sounds.', 1407, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'event (not: Ereignis)', 'Veranstaltung', ARRAY[]::text[], 'noun', 'die', 'Es findet eine festliche Veranstaltung zu seinen Ehren statt.
A festive event is held in his honor.', 1408, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the change', 'Änderung', ARRAY[]::text[], 'noun', 'die', 'Man hat mich über diese Änderung nicht informiert.
No one informed me about this change.', 1409, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to concern, go on', 'angehen', ARRAY[]::text[], NULL, NULL, 'Das Ganze geht mich nichts an.
The whole thing is not my concern.', 1410, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stop', 'aufhören', ARRAY[]::text[], NULL, NULL, 'Hör endlich auf zu reden, du nervst!
Stop talking finally, you are getting on my nerves!', 1411, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exception', 'Ausnahme', ARRAY[]::text[], 'noun', 'die', 'Wir können bei Ihnen leider keine Ausnahme machen.
We can not make an exception for you, unfortunately.', 1412, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to express, voice', 'äußern', ARRAY[]::text[], NULL, NULL, 'Sie äußert ihre Unzufriedenheit ganz ungeniert.
She expressed her dissatisfaction quite openly.', 1413, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'construction, building', 'Bau', ARRAY[]::text[], 'noun', 'der', 'Der Bau der Autobahn verzögert sich um 3 Monate.
The construction of the highway is delayed by 3 months.', 1414, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'British', 'britisch', ARRAY[]::text[], NULL, NULL, 'Chris spricht britisches Englisch.
Chris speaks British English.', 1415, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to introduce, import', 'einführen', ARRAY[]::text[], NULL, NULL, 'Lebensmittel dürfen nicht eingeführt werden.
Food may not be imported.', 1416, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'eleven', 'elf', ARRAY[]::text[], NULL, NULL, 'Als ich elf war, zogen wir nach Köln.
When I was eleven, we moved to Cologne.', 1417, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'happy', 'froh', ARRAY[]::text[], NULL, NULL, 'Wir wünschen Ihnen ein frohes neues Jahr!
We wish you a happy new year!', 1418, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hobby', 'Hobby', ARRAY[]::text[], 'noun', 'das', 'Was für Hobbys hast du?
Which hobbies do you have?', 1419, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coffee', 'Kaffee', ARRAY[]::text[], 'noun', 'der', 'Im Büro trinken wir oft Kaffee und essen Kuchen.
In the office we often drink coffee and eat cake.', 1420, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conflict', 'Konflikt', ARRAY[]::text[], 'noun', 'der', 'Der Konflikt wurde friedlich gelöst.
The conflict was resolved peacefully.', 1421, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'critical', 'kritisch', ARRAY[]::text[], NULL, NULL, 'Der Journalist schrieb einen sehr kritischen Artikel.
The journalist wrote a very critical article.', 1422, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'management, leadership, pipe (not: die Führung)', 'Leitung', ARRAY[]::text[], 'noun', 'die', 'Katharina hat die Leitung des Projektes übernommen.
Catherine has taken over the management of the project.', 1423, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the desire', 'Lust', ARRAY[]::text[], 'noun', 'die', 'Ich habe Lust auf ein Bier.
I desire a beer.', 1424, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'majority', 'Mehrheit', ARRAY[]::text[], 'noun', 'die', 'Er muss die absolute Mehrheit erreichen, um im Amt zu bleiben.
He must achieve an absolute majority to remain in office.', 1425, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'afternoon', 'Nachmittag', ARRAY[]::text[], 'noun', 'der', 'Kommst du am Nachmittag zu mir?
Are you coming to me in the afternoon?', 1426, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to care, cultivate', 'pflegen', ARRAY[]::text[], NULL, NULL, 'Kakteen muss man wenig pflegen.
Cacti need only a little bit of care.', 1427, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bill, calculation', 'Rechnung', ARRAY[]::text[], 'noun', 'die', 'Du hast die Rechnung immer noch nicht bezahlt.
You have still not paid the bill.', 1428, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'castle, lock', 'Schloss', ARRAY[]::text[], 'noun', 'das', 'Auf dem Schloss lebten ein König und eine Königin.
In the castle lived a king and a queen.', 1429, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to insure, assert', 'versichern', ARRAY[]::text[], NULL, NULL, 'Sie versicherte, dass sie sich darum kümmern würde.
She assured that she would take care of it.', 1430, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'activity', 'Aktivität', ARRAY[]::text[], 'noun', 'die', 'Der Verein bietet viele sportliche Aktivitäten an.
The club offers many sporting activities.', 1431, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accompany', 'begleiten', ARRAY[]::text[], NULL, NULL, 'Darf ich Sie nach Hause begleiten?
May I accompany you home?', 1432, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to limit, restrict', 'begrenzen', ARRAY[]::text[], NULL, NULL, 'Wir haben nur ein begrenztes Budget.
We only have a limited budget.', 1433, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to occupy, fill', 'besetzen', ARRAY[]::text[], NULL, NULL, 'Das Rheinland war lange Zeit besetzt.
The Rhineland was occupied for a long time.', 1434, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'civil code', 'BGB', ARRAY[]::text[], 'noun', 'das', 'Ein Jurist muss das BGB kennen.
A lawyer needs to know the Civil Code.', 1435, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'roof', 'Dach', ARRAY[]::text[], 'noun', 'das', 'Das Dach ist eingestürzt.
The roof has collapsed.', 1436, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'festival, celebration', 'Fest', ARRAY[]::text[], 'noun', 'das', 'Weihnachten ist das Fest der Familie.
Christmas is the celebration of the family.', 1437, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(Swiss) franc', 'Franken', ARRAY['fr.']::text[], 'noun', 'der', 'In der Schweiz bezahlt man mit Franken.
In Switzerland you pay with CHF.', 1438, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reach (not: erreichen, reichen, leisten)', 'gelangen', ARRAY[]::text[], NULL, NULL, 'Nach einer langen Wanderung gelangten sie ans Ziel.
After a long journey they reached their destination.', 1439, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Italian', 'italienisch', ARRAY[]::text[], NULL, NULL, 'Wollen wir heute Abend italienisch kochen?
Shall we cook Italien this evening?', 1440, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'candidate', 'Kandidat', ARRAY[]::text[], 'noun', 'der', 'Fünf Kandidaten treten gegeneinander an.
Five candidates compete against each other.', 1441, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'landscape, countryside', 'Landschaft', ARRAY[]::text[], 'noun', 'die', 'Chile hat wunderschöne Landschaften.
Chile has beautiful landscapes.', 1442, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the left, to the left', 'links', ARRAY[]::text[], NULL, NULL, 'Links sehen sie das Gewandhaus, rechts die Oper.
On the left you see the Gewandhaus, on the right the opera.', 1443, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'crew, team', 'Mannschaft', ARRAY[]::text[], 'noun', 'die', 'Heute spielt die deutsche Mannschaft gegen die tschechische.
Today, the German team played against the Czech team.', 1444, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wall, muro', 'Mauer', ARRAY[]::text[], 'noun', 'die', 'Die Berliner Mauer fiel am 9. November 1989.
The Berlin Wall fell on November 9th, 1989.', 1445, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the right, to the right', 'rechts', ARRAY[]::text[], NULL, NULL, 'Er hat nicht nach rechts geguckt.
He has not looked to the right.', 1446, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rich, abundant', 'reich', ARRAY[]::text[], NULL, NULL, 'Dieses Land ist reich an Bodenschätzen.
This country is rich in mineral resources.', 1447, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tear', 'reißen', ARRAY[]::text[], NULL, NULL, 'Hella reißt das Blatt in zwei Stücke.
Hella tears the paper into two pieces.', 1448, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'enormous', 'riesig', ARRAY[]::text[], NULL, NULL, 'Das ist ein riesiger Unterschied.
This is an enormous difference.', 1449, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the round', 'Runde', ARRAY[]::text[], 'noun', 'die', 'Spielen wir eine Runde Schach?
Can we play a round of chess?', 1450, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'star', 'Stern', ARRAY[]::text[], 'noun', 'der', 'Heute sieht man viele Sterne.
Today you can see many stars.', 1451, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to refer (not: beziehen)', 'verweisen', ARRAY[]::text[], NULL, NULL, 'Im Text wird auf eine weitere Quelle verwiesen.
In the text reference is made to another source.', 1452, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accept', 'akzeptieren', ARRAY[]::text[], NULL, NULL, 'Du musst meine Entscheidung akzeptieren.
You have to accept my decision.', 1453, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to order, reserve', 'bestellen', ARRAY[]::text[], NULL, NULL, 'Ich habe einen Cocktail bestellt.
I ordered a cocktail.', 1454, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thick, dense', 'dicht', ARRAY[]::text[], NULL, NULL, 'Der Wald ist hier sehr dicht.
The forest is very dense here.', 1455, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prove (similar to beweisen)', 'erweisen', ARRAY[]::text[], NULL, NULL, 'Seine Verdächtigungen erwiesen sich als falsch.
His suspicions proved to be false.', 1457, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to widen, expand, extend', 'erweitern', ARRAY[]::text[], NULL, NULL, 'Unser Angebot wurde kürzlich erweitert.
Our offer was recently extended.', 1458, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expert', 'Experte', ARRAY[]::text[], 'noun', 'der', 'Er ist Experte auf dem Gebiet der Biochemie.
He is an expert in the field of biochemistry.', 1459, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fear', 'fürchten', ARRAY[]::text[], NULL, NULL, 'Der Autor fürchtet einen Misserfolg.
The author fears a failure.', 1460, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shape, form, figure', 'Gestalt', ARRAY[]::text[], 'noun', 'die', 'Es handelt sich um eine etwas seltsame Gestalt.
It is a somewhat strange figure.', 1461, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'favourable, good (also cheap)', 'günstig', ARRAY[]::text[], NULL, NULL, 'Wir haben ihr ein günstiges Angebot gemacht.
We have made her an attractive offer.', 1462, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'main', 'hauptsächlich', ARRAY[]::text[], NULL, NULL, 'Was sind deine hauptsächlichen Gründe dagegen?
What are your main reasons against it?', 1463, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shop', 'Laden', ARRAY[]::text[], 'noun', 'der', 'Der Laden an der Ecke musste schließen.
The shop at the corner was forced to close.', 1464, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'master', 'Meister', ARRAY[]::text[], 'noun', 'der', 'Er ist ein Meister seines Fachs.
He is a master of his craft.', 1465, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'possibly', 'möglicherweise', ARRAY[]::text[], NULL, NULL, 'Möglicherweise schaffen wir es doch noch bis zum vereinbarten Termin.
Possibly we can still make it to the agreed date, though.', 1466, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to produce', 'produzieren', ARRAY[]::text[], NULL, NULL, 'In Meißen wird Porzellan produziert.
In Meissen porcelain is produced.', 1467, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to jump', 'springen', ARRAY[]::text[], NULL, NULL, 'Hier darf man nicht ins Wasser springen.
Here you are not allowed to jump into the water.', 1468, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to start', 'starten', ARRAY[]::text[], NULL, NULL, 'Wann startet das Rennen?
When is the race going to start?', 1469, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'position, standing', 'Stellung', ARRAY[]::text[], 'noun', 'die', 'Er hat eine gute Stellung in dieser Firma.
He has a good position in this company.', 1470, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to check', 'überprüfen', ARRAY[]::text[], NULL, NULL, 'Wir werden Ihre Papiere überprüfen.
We will check your papers.', 1471, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'access', 'Zugang', ARRAY[]::text[], 'noun', 'der', 'Hast du dort Zugang zum Internet?
Do you have internet access there?', 1472, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'otherwise', 'ansonsten', ARRAY[]::text[], NULL, NULL, 'Bewerben Sie sich bis zum 20. November, ansonsten kann ihre Bewerbung nicht berücksichtigt werden.
Apply to the 20th November, otherwise your application may not be considered.', 1473, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put up, draw up', 'aufstellen', ARRAY[]::text[], NULL, NULL, 'Am Bahnhof wurden neue Fahrradständer aufgestellt.
At the train station new bike racks were put up.', 1474, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sector, line of business (not: der Sektor)', 'Branche', ARRAY[]::text[], 'noun', 'die', 'Stefan ist schon seit langem in dieser Branche tätig.
Stefan has been working for a long time in this sector.', 1475, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to find out, investigate', 'ermitteln', ARRAY[]::text[], NULL, NULL, 'Die Polizei ermittelt bereits in diesem Fall.
The police is already investigating this case.', 1476, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'figure', 'Figur', ARRAY[]::text[], 'noun', 'die', 'Andreas hat eine sportliche Figur.
Andreas has an athletic figure.', 1477, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'peace', 'Frieden', ARRAY[]::text[], 'noun', 'der', 'Frieden ist möglich.
Peace is possible.', 1478, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'present', 'gegenwärtig', ARRAY[]::text[], NULL, NULL, 'Die gegenwärtige Situation ist nicht zufriedenstellend.
The present situation is not satisfactory.', 1479, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'industry', 'Industrie', ARRAY[]::text[], 'noun', 'die', 'Die Industrie will mehr Mitsprache in der Wirtschaftspolitik.
The industry wants a greater say in economic policy.', 1480, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to criticize', 'kritisieren', ARRAY[]::text[], NULL, NULL, 'Viele Menschen kritisieren die jetzige Regierung.
Many people are criticizing the current government.', 1481, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'middle, average', 'mittlere', ARRAY['s)']::text[], NULL, NULL, 'Das Mittlere Erzgebirge ist als Weihnachtsland bekannt.
The Middle Ore is known as Christmas Land.', 1482, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nice', 'nett', ARRAY[]::text[], NULL, NULL, 'Sie macht einen netten Eindruck.
She makes a nice impression.', 1483, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'never', 'niemals', ARRAY[]::text[], NULL, NULL, 'Das habe ich niemals gesagt!
I have never said that!', 1484, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dealings, contact', 'Umgang', ARRAY[]::text[], 'noun', 'der', 'Leute wie Ernst August sind für dich kein Umgang.
People like Ernst August are not good contacts for you.', 1485, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'occurrence', 'Vorgang', ARRAY[]::text[], 'noun', 'der', 'Ich habe den Vorgang genau beobachtet.
I have closely observed the occurrence.', 1486, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'growth', 'Wachstum', ARRAY[]::text[], 'noun', 'das', 'Das wirtschaftliche Wachstum lässt nach.
The economic growth is slowing down.', 1487, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in time', 'zeitlich', ARRAY[]::text[], NULL, NULL, 'Glaubst du, dass du es zeitlich schaffen wirst?
Do you think you''ll make it in time?', 1488, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to destroy', 'zerstören', ARRAY[]::text[], NULL, NULL, 'FCKW zerstört die Ozonschicht.
CFCs destroy the ozone layer.', 1489, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to run out, expire', 'ablaufen', ARRAY[]::text[], NULL, NULL, 'Die Frist läuft nächste Woche ab.
The deadline is next week.', 1490, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to calculate, charge', 'berechnen', ARRAY[]::text[], NULL, NULL, 'Wie wird der Umfang eines Kreises berechnet?
How do you calculate the circumference of a circle?', 1491, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'office', 'Büro', ARRAY[]::text[], 'noun', 'das', 'Im Büro herrscht gute Stimmung.
In the office there is a good atmosphere.', 1492, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'presentation, description', 'Darstellung', ARRAY[]::text[], 'noun', 'die', 'Ihre Darstellung der Ereignisse war detailliert und umfangreich.
Their description of the events was detailed and extensive.', 1493, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to enter, join, occur', 'eintreten', ARRAY[]::text[], NULL, NULL, 'Der schlimmste Fall ist nun eingetreten. Wir haben keinen Strom und kein Wasser mehr.
The worst case has now occured. We have no electricity and no water anymore.', 1494, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to add, complete', 'ergänzen', ARRAY[]::text[], NULL, NULL, 'Sie sollten Ihre Nahrung durch Vitamintabletten ergänzen.
You should add vitamin pills to your diet.', 1495, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to acquire, purchase', 'erwerben', ARRAY[]::text[], NULL, NULL, 'In ihren späten Jahren erwarb sie ein Stück Land und baute sich darauf ein Haus.
In her later years she acquired some land and built a house on it.', 1496, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'soccer, football', 'Fußball', ARRAY[]::text[], 'noun', 'der', 'Fußball spielt man auf der ganzen Welt.
Soccer is played all over the world.', 1497, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'violence, force', 'Gewalt', ARRAY[]::text[], 'noun', 'die', 'Die Gewalt unter Jugendlichen nimmt immer mehr zu.
Violence among young people continues to increase.', 1498, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'institution', 'Institution', ARRAY[]::text[], 'noun', 'die', 'An welcher Institution findet der Sprachkurs statt?
At which institution will the language course be held?', 1499, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cat', 'Katze', ARRAY[]::text[], 'noun', 'die', 'Hunde und Katzen vertragen sich normalerweise nicht.
Dogs and cats usually don''t get along with each other.', 1500, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(business) group', 'Konzern', ARRAY[]::text[], 'noun', 'der', 'VW ist ein weltweit erfolgreicher Konzern.
VW is a globally successful company.', 1501, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'camp, storeroom', 'Lager', ARRAY[]::text[], 'noun', 'das', 'Bitte hol neue Zeitschriften aus dem Lager.
Please get new magazines from the storeroom.', 1502, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'apprenticeship, lesson, doctrine (not: das Praktikum)', 'Lehre', ARRAY[]::text[], 'noun', 'die', 'Gerhard macht eine Lehre als Maurer.
Gerhard is taking an apprenticeship as a bricklayer.', 1503, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'horse', 'Pferd', ARRAY[]::text[], 'noun', 'das', 'Viele kleine Kinder wollen ein Pferd besitzen.
Many young children want to own a horse.', 1505, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'advice', 'Rat', ARRAY[]::text[], 'noun', 'der', 'Professor Udolph holt sich in dieser Frage Rat bei einem Kollegen.
Professor Udolph is asking for advice on this issue from a colleague.', 1506, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shadow, shade', 'Schatten', ARRAY[]::text[], 'noun', 'der', 'Die Sonne warf einen langen Schatten.
The sun cast a long shadow.', 1507, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'specific (not: bestimmt)', 'spezifisch', ARRAY[]::text[], NULL, NULL, 'Ihre Fragen waren nicht sehr spezifisch.
Her questions were not very specific.', 1508, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'point, top, peak', 'Spitze', ARRAY[]::text[], 'noun', 'die', 'Nach jahrelangen Anstrengungen hatte sie es geschafft, auch international an der Spitze zu stehen.
After years of effort she also made it to the top of international ranks.', 1509, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distance, route (not: der Abstand)', 'Strecke', ARRAY[]::text[], 'noun', 'die', 'Wir fuhren eine Strecke von 200 Kilometern.
We drove a distance of 200 kilometers.', 1510, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scene', 'Szene', ARRAY[]::text[], 'noun', 'die', 'Wir spielen eine Szene aus „Faust“.
We''re performing a scene from "Faust."', 1511, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to practise', 'üben', ARRAY[]::text[], NULL, NULL, 'Üben wir noch ein paar französische Konjugationen?
Are we going to practise some more French conjugations?', 1512, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'world championship', 'Weltmeisterschaft', ARRAY['WM']::text[], 'noun', 'die', 'Für die Weltmeisterschaft im Skispringen gibt es noch Eintrittskarten.
There are still tickets available for the World Cup of ski jumping.', 1513, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go back, decrease', 'zurückgehen', ARRAY[]::text[], NULL, NULL, 'Die Zahl der Autodiebstähle geht zurück.
The number of car thefts is decreasing.', 1514, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to join, chain to, connect', 'anschließen', ARRAY[]::text[], NULL, NULL, 'Sie schloss ihr Fahrrad an der Laterne an.
She chained her bicycle to the street lamp.', 1515, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to express', 'ausdrücken', ARRAY[]::text[], NULL, NULL, 'In dem Gedicht drückt der Dichter seine Gefühle aus.
In the poem, the poet expresses his feelings.', 1516, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'blood', 'Blut', ARRAY[]::text[], 'noun', 'das', 'Blut ist rot.
Blood is red.', 1517, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'length (of time)', 'Dauer', ARRAY[]::text[], 'noun', 'die', 'Die Dauer der Versammlung ist nicht festgelegt.
The duration of the gathering is not fixed.', 1518, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'electric', 'elektrisch', ARRAY[]::text[], NULL, NULL, 'Als Kind hatte er eine elektrische Eisenbahn.
As a child he had an electric train.', 1519, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'along', 'entlang', ARRAY[]::text[], NULL, NULL, 'Man kann mit dem Rad die Donau entlang fahren.
You can go along the Danube by bike.', 1520, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fire', 'Feuer', ARRAY[]::text[], 'noun', 'das', 'Petra macht Feuer im Kamin.
Petra is making fire in the fireplace.', 1522, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'of course (not: natürlich, offenbar)', 'freilich', ARRAY[]::text[], NULL, NULL, 'Freilich bist du Schuld gewesen, gib es endlich zu!
Of course it was your fault, admit it finally!', 1523, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in accordance with', 'gemäß', ARRAY[]::text[], NULL, NULL, 'Er verhielt sich den Anweisungen gemäß.
He acted in accordance with the instructions.', 1524, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'healthy', 'gesund', ARRAY[]::text[], NULL, NULL, 'Hoffentlich wirst du bald wieder gesund.
Hopefully you will recover soon.', 1525, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'secondary school', 'Gymnasium', ARRAY[]::text[], 'noun', 'das', 'Das Gymnasium beschließt man mit dem Abitur.
You end the Highschool program with the Abitur.', 1527, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'July', 'Juli', ARRAY[]::text[], 'noun', 'der', 'Der 14. Juli ist der französische Nationalfeiertag.
July 14th is the French national holiday.', 1528, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consequence (not: Ergebnis)', 'Konsequenz', ARRAY[]::text[], 'noun', 'die', 'Diese Entscheidung hat weitreichende Konsequenzen.
This decision has far-reaching consequences.', 1529, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nose', 'Nase', ARRAY[]::text[], 'noun', 'die', 'Rudolf, das Rentier, hat eine rote Nase.
Rudolph, the reindeer has a red nose.', 1530, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shoot', 'schießen', ARRAY[]::text[], NULL, NULL, 'Der Jäger schießt auf den Hirsch.
The hunter is shooting the deer.', 1531, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to paint, cancel', 'streichen', ARRAY[]::text[], NULL, NULL, 'Laura hat ihr Zimmer grün gestrichen.
Laura has painted her room in green.', 1532, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chair', 'Stuhl', ARRAY[]::text[], 'noun', 'der', 'Wie viele Stühle fehlen noch?
How many chairs are still missing?', 1533, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'south', 'Süden', ARRAY['Süd']::text[], 'noun', 'der', 'Im Süden Deutschlands liegen die Alpen.
In the south of Germany are the Alps.', 1534, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gate, goal', 'Tor', ARRAY[]::text[], 'noun', 'das', 'Schließ bitte doch das Tor zu!
Please lock the gate!', 1535, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'association, bandage', 'Verband', ARRAY[]::text[], 'noun', 'der', 'Er hat einen Verband um den Fuß.
He has a bandage on the foot.', 1536, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'westerly', 'westlich', ARRAY[]::text[], NULL, NULL, 'Claudia wohnt in einem westlichen Stadtteil von Leipzig.
Claudia lives in a western city district of Leipzig.', 1537, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the share', 'Aktie', ARRAY[]::text[], 'noun', 'die', 'Sie spekuliert mit Aktien an der Börse.
She speculates in shares at the stock market.', 1538, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'action, campaign', 'Aktion', ARRAY[]::text[], 'noun', 'die', 'Es ist wieder eine Aktion gegen Studiengebühren geplant.
There''s a campaign against tuition fees planned again.', 1539, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'occasion, cause', 'Anlass', ARRAY[]::text[], 'noun', 'der', 'Gibt es einen Anlass zum Feiern?
Is there an occasion to celebrate?', 1540, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distribution, edition, expenses', 'Ausgabe', ARRAY[]::text[], 'noun', 'die', 'Das Wörterbuch erscheint in einer neuen Ausgabe.
The dictionary is published in a new edition.', 1541, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foreigner', 'Ausländer', ARRAY[]::text[], 'noun', 'der', 'Jeder Mensch ist irgendwo ein Ausländer.
Every person is a foreigner somewhere.', 1542, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to require (not: benötigen)', 'bedürfen', ARRAY[]::text[], NULL, NULL, 'Hierfür bedarf es einer Menge Geduld.
This requires a lot of patience.', 1543, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to keep', 'behalten', ARRAY[]::text[], NULL, NULL, 'Alexander behält seine Süßigkeiten immer für sich.
Alexander always keeps his candy for himself.', 1544, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to register, prove, cover', 'belegen', ARRAY[]::text[], NULL, NULL, 'Im nächsten Semester belege ich ein anderes Fach.
Next semester I''ll register for a different subject.', 1545, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'state, province', 'Bundesland', ARRAY[]::text[], 'noun', 'das', 'Deutschland besteht aus 16 Bundesländern.
Germany consists of 16 states.', 1546, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '[adj] chemical', 'chemisch', ARRAY[]::text[], NULL, NULL, 'Chemische Reaktionen sind oft nicht vorherzusehen.
Chemical reactions are often not predictable.', 1547, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'club (not: der Verein)', 'Club', ARRAY[]::text[], 'noun', 'der', 'Im Club nebenan ist heute ein Livekonzert.
At the club next door is a live concert today.', 1548, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(it’s all) the same / whatever', 'egal', ARRAY[]::text[], NULL, NULL, 'Das ist mir egal!
I don''t care!', 1549, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extreme', 'extrem', ARRAY[]::text[], NULL, NULL, 'Die Preise für Öl sind extrem hoch.
The prices for oil are extremely high.', 1550, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'river', 'Fluss', ARRAY[]::text[], 'noun', 'der', 'Durch das Erdbeben ist die Brücke in den Fluss eingestürzt.
Due to the earthquake, the bridge at the river collapsed.', 1551, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'friendly', 'freundlich', ARRAY[]::text[], NULL, NULL, 'Das war aber ein freundlicher Verkäufer!
This was a very friendly shop assisstant!', 1552, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'management, command, leadership', 'Führung', ARRAY[]::text[], 'noun', 'die', 'Die Führung übernimmt ein Kollege aus Köln.
A colleague from Cologne is taking over the leadership.', 1553, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'speed', 'Geschwindigkeit', ARRAY[]::text[], 'noun', 'die', 'Bei dieser Geschwindigkeit kann man nicht mehr rechtzeitig bremsen.
At this speed, you can not brake in time.', 1554, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'estate, good(s)', 'Gut', ARRAY[]::text[], 'noun', 'das', 'Toleranz und Meinungsfreiheit sind wichtige Güter einer Demokratie.
Tolerance and freedom are important goods of a democracy.', 1555, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come out', 'herauskommen', ARRAY['rauskommen']::text[], NULL, NULL, 'Was wird bei der Untersuchung herauskommen?
What will come out of the investigation?', 1556, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hear', 'hören', ARRAY[]::text[], NULL, NULL, 'Wir hören Stimmen von draußen.
We''re hearing voices from outside.', 1557, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be (answer)', 'lauten', ARRAY[]::text[], NULL, NULL, 'Meine Antwort lautet: Nein!
My answer is: No!', 1558, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in the end (not: schließlich, endlich)', 'letztlich', ARRAY[]::text[], NULL, NULL, 'Letztlich hat er doch zugestimmt.
In the end he agreed.', 1559, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'medicine', 'Medizin', ARRAY[]::text[], 'noun', 'die', 'Die Medizin kann leider nicht allen Menschen helfen.
Medicine can not help everyone, unfortunately.', 1560, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'neighbour', 'Nachbar', ARRAY[]::text[], 'noun', 'der', 'Mein Nachbar gießt im Urlaub meine Blumen.
My neighbor waters my plants when I''m on vacation.', 1561, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'software', 'Software', ARRAY[]::text[], 'noun', 'die', 'Man ist gerade dabei, diese Software zu optimieren.
We are just in the process of optimizing this software.', 1562, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'step, level', 'Stufe', ARRAY[]::text[], 'noun', 'die', 'Zum Hauseingang führen drei Stufen.
Three steps lead to the entrance of the house.', 1563, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fall, stumble', 'stürzen', ARRAY[]::text[], NULL, NULL, 'Der Eisregen machte die Straßen so glatt, dass ich mehrmals fast gestürzt wäre.
The freezing rain made the roads so slippery that I almost fell several times.', 1564, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'telephone', 'Telefon', ARRAY[]::text[], 'noun', 'das', 'Manche Leute haben gar kein Telefon mehr, sondern nur noch ein Handy.
Some people don''t even have a telephone anymore, just a cell phone.', 1565, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'terrorism', 'Terrorismus', ARRAY[]::text[], 'noun', 'der', 'Der Terrorismus fordert immer mehr zivile Opfer.
Terrorism claims more and more civilian victims.', 1566, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'total, complete', 'total', ARRAY[]::text[], NULL, NULL, 'Ich bin total müde nach dem langen Tag.
I''m totally tired after this long day.', 1567, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coach', 'Trainer', ARRAY[]::text[], 'noun', 'der', 'Der Trainer kritisiert dauernd seine Sportler.
The coach is constantly criticizing his athletes.', 1568, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to treat, handle (not: handeln, behandeln, verhandeln, etc.)', 'umgehen', ARRAY[]::text[], NULL, NULL, 'Viele Chefs gehen mit ihren Angestellten sehr locker um.
Many bosses treat their employees very relaxedly.', 1569, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to proceed, get lost', 'verlaufen', ARRAY[]::text[], NULL, NULL, 'Wie ist die Sitzung verlaufen?
How did the session proceed?', 1570, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to suspect, assume', 'vermuten', ARRAY[]::text[], NULL, NULL, 'Ich vermute, der Zug kommt zu spät.
I assume the train is late.', 1571, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come towards, be in store', 'zukommen', ARRAY[]::text[], NULL, NULL, 'Es wird noch einiges auf uns zukommen.
There is still a lot ahead of us.', 1572, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'doubt', 'Zweifel', ARRAY[]::text[], 'noun', 'der', 'Daran besteht kein Zweifel.
There''s no doubt about it.', 1573, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to foresee, be in sight', 'absehen', ARRAY[]::text[], NULL, NULL, 'Es ist kein Ende abzusehen.
There is no end in sight.', 1574, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'request, demand, standard (not: die Nachfrage)', 'Anforderung', ARRAY[]::text[], 'noun', 'die', 'Silke stellt an ihren Mann sehr hohe Anforderungen.
Silke makes high demands on her husband.', 1575, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stand out, notice', 'auffallen', ARRAY[]::text[], NULL, NULL, 'Rote Autos fallen im Straßenverkehr am meisten auf.
In the streets red cars are standing out the most.', 1576, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bath, bathroom, spa', 'Bad', ARRAY[]::text[], 'noun', 'das', 'Abends nehme ich gern ein Bad.
In the evenings I like to take a bath.', 1577, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'load, strain (not: die Last)', 'Belastung', ARRAY[]::text[], 'noun', 'die', 'Der Autoverkehr stellt eine große Belastung für die Umwelt dar.
Car traffic is a major strain for the environment.', 1578, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prove', 'beweisen', ARRAY[]::text[], NULL, NULL, 'Die Reformen müssen ihre Wirkung noch beweisen.
The reforms still have to prove their impact.', 1579, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bus', 'Bus', ARRAY[]::text[], 'noun', 'der', 'Aufs Land fährt nur zweimal täglich ein Bus.
To the countryside the bus only goes twice a day.', 1580, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'effect (not: das Ergebnis, die Wirkung)', 'Effekt', ARRAY[]::text[], 'noun', 'der', 'Man kann auch mit wenigen Mitteln einen großen Effekt erzielen.
One can also achieve a great effect with few resources.', 1581, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(trade) fair, mass', 'Messe', ARRAY[]::text[], 'noun', 'die', 'Die Messe findet auf dem neuen Gelände außerhalb der Stadt statt.
The fair takes place at the new site outside the city.', 1582, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'anyway', 'ohnehin', ARRAY[]::text[], NULL, NULL, 'Wir sind ohnehin zu spät, da können wir uns jetzt auch Zeit lassen.
We are too late anyway, so we can take up time now.', 1583, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'proud', 'stolz', ARRAY[]::text[], NULL, NULL, 'Frau Wunderlich ist stolz auf ihren Sohn, denn er hat einem Freund das Leben gerettet.
Mrs. Wunderlich is proud of her son, because he has saved a friend''s life.', 1584, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to survive', 'überleben', ARRAY[]::text[], NULL, NULL, 'Nur wenige Tiere überlebten den furchtbaren Sturm.
Only a few animals survived the terrible storm.', 1585, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'circumference, size, extent', 'Umfang', ARRAY[]::text[], 'noun', 'der', 'Die Erde hat einen Umfang von über 40 000 Kilometern.
The earth has a circumference of more than 40 000 kilometers.', 1586, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unknown', 'unbekannt', ARRAY[]::text[], NULL, NULL, 'Der Täter ist bislang unbekannt.
The perpetrator is still unknown.', 1587, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instruction, regulation', 'Vorschrift', ARRAY[]::text[], 'noun', 'die', 'Laut Vorschrift darf man hier nicht parken.
According to the regulations you are not allowed to park here.', 1588, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extremely (nicht extrem)', 'äußerst', ARRAY[]::text[], NULL, NULL, 'Das neue Gerät ist äußerst empfindlich gegenüber Erschütterungen.
The new device is extremely sensitive to vibrations.', 1589, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to practise, exercise, exert', 'ausüben', ARRAY[]::text[], NULL, NULL, 'Frau Busse übt ihre Tätigkeit als Lektorin schon seit über sechs Jahren aus.
Mrs. Busse exercices her activity as an editor of for over six years.', 1590, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to enter, walk into, onto', 'betreten', ARRAY[]::text[], NULL, NULL, 'Der Schauspieler betritt die Bühne und verneigt sich.
The actor enters the stage and bows.', 1591, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'once, at one time, one day', 'einst', ARRAY[]::text[], NULL, NULL, 'In Amerika lebten einst viel mehr Völker als heute.
In America, once lived a lot more peoples than today.', 1592, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'electronic', 'elektronisch', ARRAY[]::text[], NULL, NULL, 'Im Internet gibt es gute elektronische Wörterbücher.
The Internet provides good electronic dictionaries.', 1593, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'final', 'endgültig', ARRAY[]::text[], NULL, NULL, 'Ich kann keine endgültige Entscheidung treffen, ohne vorher meinen Chef zu fragen.
I can not make a final decision, without asking my boss.', 1594, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to produce, generate (not: produzieren)', 'erzeugen', ARRAY[]::text[], NULL, NULL, 'Energie kann man nicht nur aus Kohle und Öl erzeugen, sondern auch aus Wasser und Wind.
Energy can not only be generated from coal and oil, but also from water and wind.', 1595, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bicycle', 'Fahrrad', ARRAY[]::text[], 'noun', 'das', 'Wenn ich kann, fahre ich mit dem Fahrrad zur Uni.
If I can, I ride by bicycle to the university.', 1596, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'commission, committee', 'Kommission', ARRAY[]::text[], 'noun', 'die', 'Eine Kommission entscheidet über die Zulassung zum Studium.
A commission decides on the admission to the course of studies.', 1597, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hospital', 'Krankenhaus', ARRAY[]::text[], 'noun', 'das', 'Die Stadt hat vier Krankenhäuser.
The city has four hospitals.', 1598, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'artistic', 'künstlerisch', ARRAY[]::text[], NULL, NULL, 'Die Veranstaltung wird von einem künstlerischen Programm umrahmt.
The event will be framed by an artistic program.', 1599, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to land', 'landen', ARRAY[]::text[], NULL, NULL, 'Das Flugzeug aus München landet um 10 Uhr auf dem Flughafen Halle-Leipzig.
The plane from Munich is going to land at 10 o''clock at the airport Leipzig-Halle.', 1600, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lack, shortage, defect', 'Mangel', ARRAY[]::text[], 'noun', 'der', 'Der Mangel an qualifizierten Arbeitskräften belastet die regionale Wirtschaft.
The lack of qualified human resources burdens the regional economy.', 1601, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to realize, bring about', 'realisieren', ARRAY[]::text[], NULL, NULL, 'Das Projekt wird durch Gelder aus der Stadtkasse realisiert.
The project is realized by funds from the city treasury.', 1602, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to save, rescue', 'retten', ARRAY[]::text[], NULL, NULL, 'Sabrina rettete ihre Katze aus dem Fluss.
Sabrina saved her cat from the river.', 1603, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'judge', 'Richter', ARRAY[]::text[], 'noun', 'der', 'Der Richter verliest die Anklage.
The judge reads the charges.', 1604, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'visible', 'sichtbar', ARRAY[]::text[], NULL, NULL, 'Es gibt sichtbare und unsichtbare Lichtwellen.
There are visible and invisible light waves.', 1605, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as soon as', 'sobald', ARRAY[]::text[], NULL, NULL, 'Sobald ich Bescheid weiß, rufe ich dich an.
As soon as I know, I''ll call you.', 1606, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thousand', 'tausend', ARRAY[]::text[], NULL, NULL, 'Ungefähr tausend Bürger nahmen an der Demonstration teil.
About one thousand people attended the demonstration.', 1607, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'terrorist', 'Terrorist', ARRAY[]::text[], 'noun', 'der', 'Terroristen agieren meist unerwartet.
Terrorists operate mostly without warning.', 1608, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sentence, judgement', 'Urteil', ARRAY[]::text[], 'noun', 'das', 'Das Urteil über den Einbrecher wird am Montag gesprochen.
The judgment of the burglar is going to be pronounced on Monday.', 1609, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hide, conceal (not: verstecken)', 'verbergen', ARRAY[]::text[], NULL, NULL, 'Hinter jedem einzelnen Namen verbirgt sich ein ganz persönliches Schicksal.
Behind each name lies a very personal story.', 1610, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to spread', 'verbreiten', ARRAY[]::text[], NULL, NULL, 'Nachrichten verbreiten sich sehr schnell über das Internet.
News spread quickly over the Internet.', 1611, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Viennese', 'Wiener', ARRAY[]::text[], NULL, NULL, 'Die Wiener Kaffeehäuser sind weltweit bekannt und beliebt.
The Viennese coffee houses are famous and popular worldwide.', 1612, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dependent', 'abhängig', ARRAY[]::text[], NULL, NULL, 'Das Klima ist von der Nähe zum Meer abhängig.
The climate is dependent on the proximity to the sea.', 1613, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'all too', 'allzu', ARRAY[]::text[], NULL, NULL, 'Allzu viele Jugendliche rauchen.
All too many young people smoke.', 1614, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'supplier', 'Anbieter', ARRAY[]::text[], 'noun', 'der', 'Der Anbieter kann erst in drei Tagen liefern.
The supplier can only deliver in three days from now.', 1615, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to meet, come across', 'begegnen', ARRAY[]::text[], NULL, NULL, 'Auf der Fahrt in meine Heimatstadt begegneten mir viele alte Bekannte.
On the trip to my hometown, I met many old acquaintances.', 1616, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'biological', 'biologisch', ARRAY[]::text[], NULL, NULL, 'Die biologische Vielfalt auf der Erde nimmt durch die Umweltverschmutzung ab.
The biological diversity on earth is degraded by pollution.', 1617, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to burn', 'brennen', ARRAY[]::text[], NULL, NULL, 'Ein Feuer brennt so lange, bis es keinen Sauerstoff mehr hat.
A fire burns until it gets no oxygen anymore.', 1618, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ceiling, blanket', 'Decke', ARRAY[]::text[], 'noun', 'die', 'Fliegen können an der Decke laufen.
Flies can walk on the ceiling.', 1619, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'double', 'doppelt', ARRAY[]::text[], NULL, NULL, 'Heute gibt es doppelt so viele Arbeitslose wie vor 20 Jahren.
Today there are twice as many unemployed people than 20 years ago.', 1620, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to require, demand (not: benötigen)', 'erfordern', ARRAY[]::text[], NULL, NULL, 'Diese Arbeit erfordert spezielle Kenntnisse in Physik.
This work requires specialized knowledge in physics.', 1621, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to frighten, be startled', 'erschrecken', ARRAY[]::text[], NULL, NULL, 'Wer die Wahrheit sucht, darf nicht erschrecken, wenn er sie findet.
Who seeks the truth must not be startled when he finds it.', 1622, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fish', 'Fisch', ARRAY[]::text[], 'noun', 'der', 'Heute Mittag gibt es Fisch mit Gemüse.
Today there''s fish with vegetables for lunch.', 1623, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meat, flesh', 'Fleisch', ARRAY[]::text[], 'noun', 'das', 'In der Mensa gibt es jeden Tag Fleisch.
In the cafeteria there is meat every day.', 1624, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Jewish', 'jüdisch', ARRAY[]::text[], NULL, NULL, 'Die jüdische Gemeinschaft in Leipzig will ein neues Zentrum errichten.
The Jewish Community in Leipzig wants to build a new center.', 1626, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'youth', 'Jugend', ARRAY[]::text[], 'noun', 'die', 'Die Jugend von heute ist sehr mit sich selber beschäftigt.
The youth of today is very self-absorbed.', 1627, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'June', 'Juni', ARRAY[]::text[], 'noun', 'der', 'Im Juni beginnen die Prüfungen.
The exams are going to begin in June.', 1628, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pack, grab', 'packen', ARRAY[]::text[], NULL, NULL, 'Jan packt seinen Rucksack, er fährt nach Norwegen in den Urlaub.
Jan is packing his backpack, he is going to go to Norway on holiday.', 1629, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'all (not: alle)', 'sämtlich', ARRAY[]::text[], NULL, NULL, 'In dem Verlag erscheinen sämtliche Werke von Hermann Hesse.
This publisher publishes all works of Hermann Hesse.', 1630, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to give (as a present)', 'schenken', ARRAY[]::text[], NULL, NULL, 'Zu Weihnachten schenken sich alle Familienmitglieder etwas.
At Christmas all members of the family give presents to each other.', 1631, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pain, grief', 'Schmerz', ARRAY[]::text[], 'noun', 'der', 'Durch das lange Sitzen bekomme ich Schmerzen in der Schulter.
Due to the long time sitting I get pain in the shoulder.', 1632, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'guilt', 'Schuld', ARRAY[]::text[], 'noun', 'die', 'Herrn Meier trifft keine Schuld.
It''s not Mr. Meier''s fault.', 1633, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shake', 'schütteln', ARRAY[]::text[], NULL, NULL, 'Sie schüttelte nur den Kopf und ging.
She just shook her head and walked away.', 1634, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'independent, self-employed', 'selbstständig', ARRAY[]::text[], NULL, NULL, 'Im Studium muss man selbstständig arbeiten können.
For studying at university, you must be able to work independently.', 1635, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sink, lower, decrease', 'senken', ARRAY[]::text[], NULL, NULL, 'Die Regierung senkt die Steuern noch dieses Jahr.
The government is going to lower the taxes this year.', 1636, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mood, atmosphere', 'Stimmung', ARRAY[]::text[], 'noun', 'die', 'Die Stimmung im Team ist sehr gut.
The mood within the team is very good.', 1637, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pocket, bag', 'Tasche', ARRAY[]::text[], 'noun', 'die', 'Ich muss nochmal zurück, ich habe meine Tasche im Café liegen lassen.
I must return again, I left my bag at the coffee place.', 1638, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reversed, contrary, the other way around', 'umgekehrt', ARRAY[]::text[], NULL, NULL, 'Es ist genau umgekehrt.
It is exactly the other way around.', 1639, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wine', 'Wein', ARRAY[]::text[], 'noun', 'der', 'Französische und italienische Weine sind immer noch am beliebtesten.
French and Italian wines are still the most popular ones.', 1640, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wave', 'Welle', ARRAY[]::text[], 'noun', 'die', 'Das Seebeben sandte eine riesige Welle quer über den Ozean.
The seaquake sent a huge wave across the ocean.', 1641, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'competition [the actual competitive event] (not: die Konkurrenz)', 'Wettbewerb', ARRAY[]::text[], 'noun', 'der', 'An dem Wettbewerb nehmen Menschen aus allen Altersgruppen teil.
People of all age groups are taking part in the competition.', 1642, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'weather', 'Wetter', ARRAY[]::text[], 'noun', 'das', 'Lena geht auch bei schlechtem Wetter gern spazieren.
Lena also goes for walks when the weather is bad.', 1643, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to withdraw', 'zurückziehen', ARRAY[]::text[], NULL, NULL, 'Er zieht sich aus dem öffentlichen Leben zurück.
He withdraws from public life.', 1644, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'alternative', 'Alternative', ARRAY[]::text[], 'noun', 'die', 'Die Alternative zur Verkleinerung ist die Schließung der Fabrik.
The alternative to downsizing is the closure of the factory.', 1645, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to recognize, accept', 'anerkennen', ARRAY[]::text[], NULL, NULL, 'Kinder erkennen die Autorität der Eltern oft nicht an.
Children often don''t accept the authority of the parents.', 1646, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unemployed', 'arbeitslos', ARRAY[]::text[], NULL, NULL, 'Wenn mir mein Chef kündigt, werde ich arbeitslos.
If my boss fires me, I will be unemployed.', 1647, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'effect', 'Auswirkung', ARRAY[]::text[], 'noun', 'die', 'Die Katastrophe wird noch jahrelange Auswirkungen haben.
The disaster will have effects for years.', 1648, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'need, necessity, anticipation [for / to]', 'Bedürfnis', ARRAY[]::text[], 'noun', 'das', 'Das Bedürfnis nach Urlaub wächst mit jedem Arbeitstag.
The need for vacation is increasing with every work day.', 1649, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to assess, judge', 'beurteilen', ARRAY[]::text[], NULL, NULL, 'Ein unerfahrener Mitarbeiter kann die Sachlage nicht richtig beurteilen.
An inexperienced employee can not properly assess the situation.', 1650, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to relieve, make easier', 'erleichtern', ARRAY[]::text[], NULL, NULL, 'Die Mikrowelle erleichtert vielen Menschen das Kochen.
The microwave makes cooking easier for many people.', 1651, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to enjoy, relish', 'genießen', ARRAY[]::text[], NULL, NULL, 'Bettina genießt ihr neues Leben in Karlsruhe.
Bettina is enjoying her new life in Karlsruhe.', 1652, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'posture, attitude (not: Einstellung)', 'Haltung', ARRAY[]::text[], 'noun', 'die', 'Seine ablehnende Haltung gegenüber Ausländern ist uns allen schon aufgefallen.
We''ve all already noticed his negative attitude towards foreigners.', 1653, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reader', 'Leser', ARRAY[]::text[], 'noun', 'der', 'Leser einer Tageszeitung sind immer gut informiert.
Readers of a newspaper are always well informed.', 1654, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'powerful', 'mächtig', ARRAY[]::text[], NULL, NULL, 'Mächtigen Worten folgen meist keine Taten.
Powerful words are usually not followed by actions.', 1655, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'economic (not: wirtschaftlich)', 'ökonomisch', ARRAY[]::text[], NULL, NULL, 'Eine familienfreundliche Politik bietet auch ökonomische Vorteile.
A family-friendly policy also offers economic advantages.', 1656, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'legal (not: gesetzlich)', 'rechtlich', ARRAY[]::text[], NULL, NULL, 'Rechtlich gesehen gibt es ein Problem.
Legally, there is a problem.', 1657, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'religious', 'religiös', ARRAY[]::text[], NULL, NULL, 'Religiöse Anschauungen sollten aus der Schule fern gehalten werden.
Religious beliefs should be kept away from school.', 1658, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'written', 'schriftlich', ARRAY[]::text[], NULL, NULL, 'Am nächsten Tag erhielt sie eine schriftliche Benachrichtigung.
The next day she received a written notification.', 1659, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'aunt', 'Tante', ARRAY[]::text[], 'noun', 'die', 'Die Schwester meiner Mutter ist meine Tante.
My mother''s sister is my aunt.', 1660, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'temperature', 'Temperatur', ARRAY[]::text[], 'noun', 'die', 'Wasser gefriert bei einer Temperatur von null Grad Celsius.
Water freezes at a temperature of zero degrees Celsius.', 1661, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dar clase', 'unterrichten', ARRAY[]::text[], NULL, NULL, 'Ein Lehrer aus Frankreich unterrichtet Französisch.
A teacher from France is teaching French.', 1662, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'probably (not: wahrscheinlich)', 'vermutlich', ARRAY[]::text[], NULL, NULL, 'Richard hat vermutlich Recht mit dem, was er sagt.
Richard is probably right with what he says.', 1663, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'weapon', 'Waffe', ARRAY[]::text[], 'noun', 'die', 'Waffen unterliegen in Deutschland strengen Gesetzen.
Weapons are subject to strict laws in Germany.', 1664, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to perceive, detect', 'wahrnehmen', ARRAY[]::text[], NULL, NULL, 'Kaum ein Passant nimmt die Obdachlosen in der Innenstadt wahr.
Hardly any pedestrian perceives the homeless in the city center.', 1665, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'goods', 'Ware', ARRAY[]::text[], 'noun', 'die', 'Auf dem Markt bekommt man immer frische Ware.
At the market you always get fresh goods.', 1666, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'twice', 'zweimal', ARRAY[]::text[], NULL, NULL, 'Zwieback ist zweimal gebackenes trockenes Brot.
Zwieback is twice baked dry bread.', 1667, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'suspicion, idea', 'Ahnung', ARRAY[]::text[], 'noun', 'die', 'Mein Vater hat keine Ahnung, wie es mir geht.
My father has no idea how I am.', 1668, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'alleged', 'angeblich', ARRAY[]::text[], NULL, NULL, 'Angeblich plant die Regierung die Einführung von Studiengebühren in Deutschland.
The government is allegedly planning to introduce tuition fees in Germany.', 1669, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the basis of, with the aid of (not: mithilfe)', 'anhand', ARRAY[]::text[], NULL, NULL, 'Anhand von Beispielen kann man eine Regel finden.
With the aid of examples you can find a rule.', 1670, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to load, burden', 'belasten', ARRAY[]::text[], NULL, NULL, 'Diese Vorwürfe belasten mich schwer.
These accusations burden me heavily.', 1671, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cheap', 'billig', ARRAY[]::text[], NULL, NULL, 'Wer billig kauft, kauft zweimal.
Who buys cheap, buys twice.', 1672, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'breast, chest', 'Brust', ARRAY[]::text[], 'noun', 'die', 'Bei starkem Husten hat man oft Schmerzen in der Brust.
During severe cough you often feel pain in the chest.', 1673, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at that time', 'damalig', ARRAY[]::text[], NULL, NULL, 'Die damaligen Verhältnisse waren viel schwieriger als heute.
The conditions at that time were much harder than the ones today.', 1674, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'beside it, next to it', 'daneben', ARRAY[]::text[], NULL, NULL, 'Wir haben ein Haus mit einem Garten, daneben beginnt gleich der Wald.
We have a house with a garden, the forest begins right next to it.', 1675, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'introduction', 'Einführung', ARRAY[]::text[], 'noun', 'die', 'Zu Beginn des Semesters gibt es eine Einführung ins Studium.
At the beginning of the semester there is an introduction to the program.', 1676, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'drive, trip', 'Fahrt', ARRAY[]::text[], 'noun', 'die', 'Die Fahrt von Hamburg nach Köln mit dem Zug dauert etwa 4 Stunden.
The drive by train from Hamburg to Cologne takes about 4 hours.', 1677, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to flow', 'fließen', ARRAY[]::text[], NULL, NULL, 'Die Elbe fließt in die Nordsee.
The Elbe flows into the North Sea.', 1678, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'support, sponsorship (not: Unterstützung)', 'Förderung', ARRAY[]::text[], 'noun', 'die', 'Familien erhalten staatliche Förderung.
Families receive state support.', 1679, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'geographic', 'geographisch', ARRAY[]::text[], NULL, NULL, 'Längen- und Breitengrade markieren die geographische Lage.
Longitude and latitude mark geographic locations.', 1680, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dress', 'Kleid', ARRAY[]::text[], 'noun', 'das', 'Jana sieht sehr gut aus in ihrem neuen Kleid.
Jana looks great in her new dress.', 1681, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coalition', 'Koalition', ARRAY[]::text[], 'noun', 'die', 'Die Koalition besteht aus drei Parteien.
The coalition consists of three parties.', 1682, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to check, control', 'kontrollieren', ARRAY[]::text[], NULL, NULL, 'Papa kontrolliert jeden Abend, ob die Kinder die Hausaufgaben gemacht haben.
Dad checks every night if the children have done their homework.', 1683, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strong (not: stark)', 'kräftig', ARRAY[]::text[], NULL, NULL, 'Der Euro verzeichnet seit zwei Monaten ein kräftiges Wachstum.
The euro is recording a strong growth for two months now.', 1684, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'length', 'Länge', ARRAY[]::text[], 'noun', 'die', 'Eine Schlange von 3 Metern Länge ist aus dem Zoo verschwunden.
A snake of 3 meters length has disappeared from the zoo.', 1685, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hole', 'Loch', ARRAY[]::text[], 'noun', 'das', 'Meine Hose hat ein Loch.
My pants have a hole.', 1686, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'manager', 'Manager', ARRAY[]::text[], 'noun', 'der', 'Ein erfolgreicher Manager leitet das Unternehmen.
A successful manager is leading the company.', 1687, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prove (nicht beweisen)', 'nachweisen', ARRAY[]::text[], NULL, NULL, 'Ein Reisepass weist die Identität des Besitzers nach.
A passport proves the identity of the owner.', 1688, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'source, spring', 'Quelle', ARRAY[]::text[], 'noun', 'die', 'In einer wissenschaftlichen Arbeit müssen Quellen exakt angegeben werden.
In a scientific work the exact sources must be quoted.', 1689, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rain', 'Regen', ARRAY[]::text[], 'noun', 'der', 'Am Wochenende erwartet uns ein Mix aus Regen und Sonnenschein.
On the weekend we can expect a mix of rain and sunshine.', 1690, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'religion', 'Religion', ARRAY[]::text[], 'noun', 'die', 'Religion ist eine private Angelegenheit.
Religion is a private matter.', 1691, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'player', 'Spieler', ARRAY[]::text[], 'noun', 'der', 'Der Spieler wechselt in der nächsten Saison in einen anderen Verein.
Next season the player is going change to a different team.', 1692, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stream, current, electricity', 'Strom', ARRAY[]::text[], 'noun', 'der', 'Wir haben seit einer Stunde keinen Strom und kein Licht mehr.
For one hour now we have no electricity no light anymore.', 1693, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sum', 'Summe', ARRAY[]::text[], 'noun', 'die', 'Die Summe aus zwölf plus drei ist fünfzehn.
The sum of twelve plus three is fifteen.', 1694, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'appointment, date', 'Termin', ARRAY[]::text[], 'noun', 'der', 'Bis zu dem vereinbarten Termin muss die Arbeit fertig sein.
Until the agreed date the work needs to be done.', 1695, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'test (not: Prüfung)', 'Test', ARRAY[]::text[], 'noun', 'der', 'Im letzten Test fielen drei Studenten durch.
In the last test three students failed.', 1696, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tourist', 'Tourist', ARRAY[]::text[], 'noun', 'der', 'Touristen sind oft nicht sehr beliebt bei den Einheimischen.
Tourists are often not very popular with the locals.', 1697, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'turnover, sales', 'Umsatz', ARRAY[]::text[], 'noun', 'der', 'Der Umsatz im Bereich Sportartikel steigt jedes Jahr.
Sales in the sporting goods sector are increasing every year.', 1698, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to interrupt', 'unterbrechen', ARRAY[]::text[], NULL, NULL, 'Ich wollte gerade eine Frage stellen, aber Hannes hat mich unterbrochen.
I''ve just wanted to ask a question, but Hannes interrupted me.', 1699, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to trust', 'vertrauen', ARRAY[]::text[], NULL, NULL, 'Der Käufer vertraut auf die Qualität des Produkts.
The buyer trusts the quality of the product.', 1700, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cause', 'verursachen', ARRAY[]::text[], NULL, NULL, 'Der Unfall verursachte einen Stau von 12 Kilometern.
The accident caused a traffic jam of 12 kilometers.', 1701, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the use', 'Verwendung', ARRAY[]::text[], 'noun', 'die', 'Über die Verwendung der Steuergelder entscheidet die Regierung.
About the use of tax money decides the government.', 1702, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to suggest/propose (not: empfehlen)', 'vorschlagen', ARRAY[]::text[], NULL, NULL, 'Das Gericht schlägt einen Vergleich vor.
The Court suggests a comparison.', 1703, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reproach, accusation', 'Vorwurf', ARRAY[]::text[], 'noun', 'der', 'Herr Faber macht seinen Mitarbeitern ständig Vorwürfe wegen der Verzögerung des Projekts.
Mr. Faber is constantly reproaching his staff for the delay of the project.', 1704, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wild', 'wild', ARRAY[]::text[], NULL, NULL, 'Bären und Füchse sind wilde Tiere.
Bears and foxes are wild animals.', 1705, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scholar, scientist', 'Wissenschaftler', ARRAY[]::text[], 'noun', 'der', 'Wissenschaftler aus verschiedenen Fachrichtungen nehmen an der Tagung teil.
Scientists from various disciplines will participate in the meeting.', 1706, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from where, how', 'woher', ARRAY[]::text[], NULL, NULL, 'Woher weißt du, dass Ingrid ihren Mann verlassen hat?
How do you know that Ingrid has left her husband?', 1707, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'back', 'zurück', ARRAY[]::text[], NULL, NULL, 'Das liegt schon zwanzig Jahre zurück.
This dates back to twenty years ago.', 1708, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'April', 'April', ARRAY[]::text[], 'noun', 'der', 'Im April macht das Wetter, was es will.
In April, the weather does whatever it wants.', 1709, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pronounce, express', 'aussprechen', ARRAY[]::text[], NULL, NULL, 'Du musst deine Zweifel aussprechen.
You must express your doubts.', 1710, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to serve, operate', 'bedienen', ARRAY[]::text[], NULL, NULL, 'Den Fernseher bedient man mit einer Fernbedienung.
The television is operated with a remote control.', 1711, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to control, have mastered', 'beherrschen', ARRAY[]::text[], NULL, NULL, 'Susann beherrscht gut Karate.
Susann has mastered Karate well.', 1712, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'beer', 'Bier', ARRAY[]::text[], 'noun', 'das', 'Sowohl Deutsche als auch Amerikaner trinken gerne Bier.
Both Germans and Americans like to drink beer.', 1713, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'federal government', 'Bundesregierung', ARRAY[]::text[], 'noun', 'die', 'Die Bundesregierung fordert alle Parteien zu mehr Geschlossenheit im Kampf gegen rechte Organisationen auf.
The Federal Government demands all parties to be more united in the fight against right-wing organizations.', 1714, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'colourful', 'bunt', ARRAY[]::text[], NULL, NULL, 'Kinder malen gern mit bunten Farben.
Children love to paint with colourful colors.', 1715, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'urgent', 'dringend', ARRAY[]::text[], NULL, NULL, 'Es muss dringend jemand die Wasserleitung reparieren, sie ist defekt.
Someone urgently needs to repair the water line, it is broken.', 1716, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to restrict, reduce', 'einschränken', ARRAY[]::text[], NULL, NULL, 'Das neue Gesetz schränkt die Rechte von Verbrechern ein.
The new law restricts the rights of criminals.', 1717, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'voluntary', 'freiwillig', ARRAY[]::text[], NULL, NULL, 'Viele junge Männer melden sich freiwillig zum Militär.
Many young men volunteer for military service.', 1718, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'holy', 'heilig', ARRAY[]::text[], NULL, NULL, 'Nichts ist ihm heilig.
Nothing is holy to him.', 1719, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ideal', 'ideal', ARRAY[]::text[], NULL, NULL, 'Im idealen Fall kommt das Päckchen schon am Montag an, im schlimmsten Fall erst Freitag.
Ideally, the package will already arrive on Monday, in the worst case on Friday.', 1720, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'concert', 'Konzert', ARRAY[]::text[], 'noun', 'das', 'Im Sommer gibt es im Park klassische Konzerte unter freiem Himmel.
In the summer there are open air concerts of classical music in the park.', 1721, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'crisis', 'Krise', ARRAY[]::text[], 'noun', 'die', 'Die Leiterin des Instituts meistert die Krise.
The director of the Institute is mastering the crisis.', 1722, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agriculture', 'Landwirtschaft', ARRAY[]::text[], 'noun', 'die', 'Die deutsche Landwirtschaft kann nicht mehr so vielen Menschen Arbeit geben wie noch vor 40 Jahren.
The German agriculture today can not give as many people work as 40 years ago.', 1723, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sorrow, grief', 'Leid', ARRAY[]::text[], 'noun', 'das', 'Im Fernsehen sieht man das Leid der Menschen in der dritten Welt.
On television you see the suffering of people in the Third World.', 1724, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shine, glow', 'leuchten', ARRAY[]::text[], NULL, NULL, 'In der Weihnachtszeit leuchten in den meisten Wohnzimmern Weihnachtsbäume.
During the Christmas season Christmas trees are shining in most living rooms.', 1725, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'song', 'Lied', ARRAY[]::text[], 'noun', 'das', 'Lieder können beim Sprachenlernen helfen.
Songs can help in language learning.', 1726, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'March', 'März', ARRAY[]::text[], 'noun', 'der', 'Im März beginnt der Frühling.
Spring begins in March.', 1727, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'feature', 'Merkmal', ARRAY[]::text[], 'noun', 'das', 'Ein typischer Tisch hat folgende Merkmale: Er hat vier Beine und oben eine Tischplatte.
A typical table has the following features: It has four legs and a table top.', 1728, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take (along)', 'mitnehmen', ARRAY[]::text[], NULL, NULL, 'Katharina nimmt immer ihre Handtasche mit, wenn sie aus dem Haus geht.
Catherine always takes along her purse, when she leaves the house.', 1729, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'by means of', 'mittels', ARRAY[]::text[], NULL, NULL, 'Mittels neuester Technologien kann man jetzt auch vom Handy aus E-Mails schreiben.
By means of the latest technologies we can now write e-mails from cell phones.', 1730, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in the middle', 'mitten', ARRAY[]::text[], NULL, NULL, 'Mitten im Wald steht eine kleine Hütte.
In the middle of the forest stands a small cabin.', 1731, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'parliament', 'Parlament', ARRAY[]::text[], 'noun', 'das', 'Im Parlament wird über Gesetze abgestimmt.
The Parliament votes on laws.', 1732, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pause, break', 'Pause', ARRAY[]::text[], 'noun', 'die', 'In der Pause esse ich mein belegtes Brötchen.
During the break, I eat my sandwich.', 1733, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'perspective, prospects', 'Perspektive', ARRAY[]::text[], 'noun', 'die', 'Die Schule hat keine Perspektive, weil es zu wenige Schüler gibt.
The school has no perspective because there are too few students.', 1734, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'phenomenon', 'Phänomen', ARRAY[]::text[], 'noun', 'das', 'Gewitter ist ein Phänomen, das auftritt, wenn sich zwei unterschiedlich warme Luftmassen treffen.
Thunderstorm is a phenomenon that occurs when two various warm air masses meet .', 1735, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reality', 'Realität', ARRAY[]::text[], 'noun', 'die', 'Die Realität sieht oft anders aus, als man denkt.
Reality is often different than you think.', 1736, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'regional', 'regional', ARRAY[]::text[], NULL, NULL, 'Wir beziehen unser Gemüse aus der regionalen Landwirtschaft.
We source our vegetables from the region''s agriculture.', 1737, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to move (not: bewegen)', 'rücken', ARRAY[]::text[], NULL, NULL, 'Das Problem rückte immer mehr in den Mittelpunkt der Diskussion.
The problem moved increasingly in the focus of the discussion.', 1738, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the search', 'Suche', ARRAY[]::text[], 'noun', 'die', 'Die Suche nach dem entflohenen Krokodil war erfolgreich.
The search for the escaped crocodile was successful.', 1739, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to kill', 'töten', ARRAY[]::text[], NULL, NULL, 'Du sollst nicht töten!
Thou shalt not kill!', 1740, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'predominant', 'überwiegend', ARRAY[]::text[], NULL, NULL, 'Der überwiegende Teil der Erstsemester fährt am Wochenende nach Hause.
The majority of the freshmen drives home for the weekend.', 1741, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'impossible', 'unmöglich', ARRAY[]::text[], NULL, NULL, 'Nichts ist unmöglich.
Nothing is impossible.', 1742, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to say goodbye, pass', 'verabschieden', ARRAY[]::text[], NULL, NULL, 'Karl und Till verabschiedeten sich am Bahnhof.
Charles and Till said goodbye at the station.', 1743, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to forbid, prohibit', 'verbieten', ARRAY[]::text[], NULL, NULL, 'Die Lehrerin verbietet ihren Schülern zu reden.
The teacher forbids her students to talk.', 1744, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to present, provide, produce', 'vorlegen', ARRAY[]::text[], NULL, NULL, 'Der Absolvent hat eine exzellente Arbeit vorgelegt.
The graduate has submitted an excellent work.', 1745, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'world war', 'Weltkrieg', ARRAY[]::text[], 'noun', 'der', 'Der Zweite Weltkrieg endete 1945.
The Second World War ended in 1945.', 1746, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to summarize', 'zusammenfassen', ARRAY[]::text[], NULL, NULL, 'Ich fasse die Ergebnisse noch mal zusammen.
I''ll summarize the results once again.', 1747, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pleasant/convenient', 'angenehm', ARRAY[]::text[], NULL, NULL, 'Das ist eine angenehme Überraschung.
This is a pleasant surprise.', 1748, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employer', 'Arbeitgeber', ARRAY[]::text[], 'noun', 'der', 'Der Arbeitgeber verweigert seinen Angestellten seit Monaten den Urlaub.
The employer is denying his employees holiday for months now.', 1749, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'construction, structure', 'Aufbau', ARRAY[]::text[], 'noun', 'der', 'Die Arbeit hat einen logischen Aufbau.
The work has a logical structure.', 1750, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'August', 'August', ARRAY[]::text[], 'noun', 'der', 'Im August habe ich Geburtstag.
In August is my birthday.', 1751, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tell, align, line up (inform)', 'ausrichten', ARRAY[]::text[], NULL, NULL, 'Richte ihm bitte aus, dass ich erst etwas später komme.
Please tell him that I''ll come a little bit later.', 1752, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'important, meaningful, eminent', 'bedeutend', ARRAY[]::text[], NULL, NULL, 'Schiller ist ein bedeutender deutscher Dichter.
Schiller is an eminent German poet.', 1753, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cause', 'bedingen', ARRAY[]::text[], NULL, NULL, 'Manche Krankheiten sind erblich bedingt.
Some diseases are hereditary caused.', 1754, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'regulation, purpose, fate', 'Bestimmung', ARRAY[]::text[], 'noun', 'die', 'Die Bestimmungen sind gesetzlich festgelegt.
The regulations are established by law.', 1755, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'message, embassy', 'Botschaft', ARRAY[]::text[], 'noun', 'die', 'Die Menschen erwarten eine positive Botschaft von ihrem Präsidenten.
People expect a positive message from their president.', 1756, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bread', 'Brot', ARRAY[]::text[], 'noun', 'das', 'Brot ist ein Grundnahrungsmittel.
Bread is a staple food.', 1757, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Christian', 'christlich', ARRAY[]::text[], NULL, NULL, 'Die christliche Gemeinde von Köln hat eine neue Homepage.
The Christian community of Cologne has a new homepage.', 1758, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'before it', 'davor', ARRAY[]::text[], NULL, NULL, 'Hinter dem Haus ist ein Teich, davor ein schöner Garten.
Behind the house is a pond, before it a beautiful garden.', 1759, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'over there', 'drüben', ARRAY[]::text[], NULL, NULL, 'Da drüben steht die Polizei, fahr lieber langsam!
Over there is the police, rather drive slowly!', 1760, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'possible, possibly (not: möglich)', 'eventuell', ARRAY[]::text[], NULL, NULL, 'Nächste Woche gibt es in dem Werk eventuell einen Streik.
Next week there could possibly be a strike at the plant.', 1761, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bottle', 'Flasche', ARRAY[]::text[], 'noun', 'die', 'Zum Abendessen gab es eine gute Flasche Rotwein.
For dinner we had a good bottle of red wine.', 1762, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'formula', 'Formel', ARRAY[]::text[], 'noun', 'die', 'Welche chemische Formel hat Wasser?
What is the chemical formula of water?', 1763, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'progress', 'Fortschritt', ARRAY[]::text[], 'noun', 'der', 'Meine Tochter hat große Fortschritte gemacht, sie kann schon bis hundert zählen.
My daughter has made great progress, she can already count to a hundred.', 1764, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to continue, resume (not: weiterhin)', 'fortsetzen', ARRAY[]::text[], NULL, NULL, 'Das Seminar wird nächste Woche fortgesetzt.
The seminar will be continued next week.', 1765, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'birthday', 'Geburtstag', ARRAY[]::text[], 'noun', 'der', 'Anna feiert ihren vierten Geburtstag im Kindergarten.
Anna is celebrating her fourth birthday in kindergarden.', 1766, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'present', 'Gegenwart', ARRAY[]::text[], 'noun', 'die', 'Wer Geschichte lernt, erfährt viel über die Gegenwart.
Those who learn history, learn a lot about the present.', 1767, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'capital city', 'Hauptstadt', ARRAY[]::text[], 'noun', 'die', 'Dresden ist die Hauptstadt von Sachsen.
Dresden is the capital of Saxony.', 1768, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to integrate', 'integrieren', ARRAY[]::text[], NULL, NULL, 'Unser Englischlehrer integriert die neuesten Medien in den Unterricht.
Our English teacher integrates the latest media into his lessons.', 1769, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fold, go as planned, work out', 'klappen', ARRAY[]::text[], NULL, NULL, 'Ich habe es lange versucht, aber es klappt einfach nicht.
I have tried it for a long time, but it just does not work.', 1770, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'physical', 'körperlich', ARRAY[]::text[], NULL, NULL, 'Mehr körperliche Betätigung würde dir gut tun.
More physical exercise would do you good.', 1771, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'medical', 'medizinisch', ARRAY[]::text[], NULL, NULL, 'Die Praxis ist medizinisch auf dem neuesten Stand.
The practice is medically up to date.', 1772, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'effort, trouble', 'Mühe', ARRAY[]::text[], 'noun', 'die', 'Meine Mutter macht sich immer viel Mühe mit dem Mittagessen.
My mother is always putting a lot of effort in making lunch.', 1773, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'demand', 'Nachfrage', ARRAY[]::text[], 'noun', 'die', 'Die Nachfrage nach Rohöl steigt von Jahr zu Jahr.
The demand for crude oil is rising from year to year.', 1774, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'duty', 'Pflicht', ARRAY[]::text[], 'noun', 'die', 'Wer Pflichten hat, der hat auch Rechte.
Who has duties, also has rights.', 1775, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'three-dimensional, spatial', 'räumlich', ARRAY[]::text[], NULL, NULL, 'Die Fragen testen das räumliche Vorstellungsvermögen.
The questions test your spatial imagination.', 1776, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stare', 'starren', ARRAY[]::text[], NULL, NULL, 'Dietmar starrt ins Leere, er denkt nach.
Dietmar is staring into space, he is contemplating.', 1777, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'course of study', 'Studiengang', ARRAY[]::text[], 'noun', 'der', 'Viele Studiengänge sind mit Studenten überfüllt.
Many courses are overcrowded with students.', 1778, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'participant', 'Teilnehmer', ARRAY[]::text[], 'noun', 'der', 'Die Teilnehmer am Marathon treffen am späten Nachmittag im Stadion ein.
The participants of the marathon are going to arrive in the late afternoon at the stadium.', 1779, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to wash', 'waschen', ARRAY[]::text[], NULL, NULL, 'Nach die Scheiße, vor dem Essen, Hände waschen nichts vergessen!
After shit, before we eat, don''t forget! your hands must be clean', 1780, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'will', 'Wille', ARRAY[]::text[], 'noun', 'der', 'Sandra schafft das, sie hat einen starken Willen.
Sandra can make it, she has a strong will.', 1781, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'appropriate', 'angemessen', ARRAY[]::text[], NULL, NULL, 'Zu einem Opernball sollte man in angemessener Bekleidung erscheinen.
At an opera ball you should show up in approriate clothing.', 1782, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stop, last (to hold on or to hold)', 'anhalten', ARRAY[]::text[], NULL, NULL, 'Der Erholungseffekt hielt auch nach dem Urlaub noch an.
The relaxation effect lasted even after the holiday.', 1783, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attentive, attentively', 'aufmerksam', ARRAY[]::text[], NULL, NULL, 'Die Schüler hören ihrem Lehrer aufmerksam zu.
The students are listening attentively to their teacher.', 1784, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to train, instruct, educate', 'ausbilden', ARRAY[]::text[], NULL, NULL, 'Der Betrieb bildet in diesem Jahr zehn Lehrlinge aus.
The company is training ten apprentices this year.', 1785, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to answer', 'beantworten', ARRAY[]::text[], NULL, NULL, 'Der Angeklagte beantwortet die Frage des Richters mit Ja.
The defendant answered the question of the judge with Yes.', 1786, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'debate', 'Debatte', ARRAY[]::text[], 'noun', 'die', 'Die Debatte im Senat dauerte über vier Stunden.
The debate in the Senate lasted more than four hours.', 1787, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thin', 'dünn', ARRAY[]::text[], NULL, NULL, 'Lebkuchen haben oft eine dünne Schokoladenschicht.
Gingerbread cookies often have a thin layer of chocolate.', 1788, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shop', 'einkaufen', ARRAY[]::text[], NULL, NULL, 'Gestern habe ich Geschenke eingekauft.
Yesterday I shopped for gifts.', 1789, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to explain (not: erzählen, erklären)', 'erläutern', ARRAY[]::text[], NULL, NULL, 'Erläutern Sie bitte den Unterschied zwischen physisch und physikalisch!
Please explain the difference between physical and physically!', 1790, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foreign language', 'Fremdsprache', ARRAY[]::text[], 'noun', 'die', 'Frau Wotjak ist Professorin für Deutsch als Fremdsprache.
Mrs. Wotjak is a professor of German as a foreign language.', 1791, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opponent, competitor, enemy', 'Gegner', ARRAY[]::text[], 'noun', 'der', 'David ist ein Gegner von Atomkraftwerken.
David is an opponent of nuclear power plants.', 1792, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'global', 'global', ARRAY[]::text[], NULL, NULL, 'Die globale Erwärmung beunruhigt nicht nur Wissenschaftler.
Global warming is not only a concern for scientists.', 1793, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to look', 'gucken', ARRAY['kucken']::text[], NULL, NULL, 'Was guckst du so komisch?
Why are you looking so strangely?', 1794, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'respect (in that respect...)', 'Hinsicht', ARRAY[]::text[], 'noun', 'die', 'In beruflicher Hinsicht geht es ihr sehr gut.
In professional respects, she is very well.', 1795, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'buyer', 'Käufer', ARRAY[]::text[], 'noun', 'der', 'Der Käufer hat das Recht, die Ware innerhalb von 14 Tagen umzutauschen.
The buyer has the right to exchange the merchandise within 14 days.', 1796, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'by no means, not at all', 'keineswegs', ARRAY[]::text[], NULL, NULL, 'Erfolg ist keineswegs nur eine Frage der Begabung.
Success is not at all just a question of talent.', 1797, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'kilogram', 'Kilogramm', ARRAY['kg']::text[], 'noun', 'das', 'Ein Kilogramm sind tausend Gramm.
A kilogram are a thousand grams.', 1798, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bring', 'mitbringen', ARRAY[]::text[], NULL, NULL, 'Wir haben Geschenke mitgebracht.
We have brought presents.', 1799, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'other (not: andere)', 'sonstig', ARRAY[]::text[], NULL, NULL, 'Bücher zu sonstigen Themen finden Sie im Obergeschoss.
Books on other topics can be found upstairs.', 1800, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'linguistic', 'sprachlich', ARRAY[]::text[], NULL, NULL, 'Lieder und Reime fördern die sprachliche Entwicklung von Kindern.
Songs and rhymes promote the linguistic development of children.', 1801, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to do, go on, take steps', 'unternehmen', ARRAY[]::text[], NULL, NULL, 'Am Ostersonntag unternehmen wir mit der Familie einen Ausflug in die Berge.
On Easter Sunday we are going to go on a trip with the family to the mountains.', 1802, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tell a secret, give away, betray', 'verraten', ARRAY[]::text[], NULL, NULL, 'Meine Freundin hat mir ein Geheimnis verraten.
My friend told me a secret.', 1803, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hide', 'verstecken', ARRAY[]::text[], NULL, NULL, 'Zu Ostern versteckt man in Deutschland bunte Eier und Süßigkeiten, die die Kinder suchen müssen.
At Easter in Germany we hide colored eggs and candy which the children must find.', 1804, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'administration', 'Verwaltung', ARRAY[]::text[], 'noun', 'die', 'Die Verwaltung der Universität befindet sich in einem extra Gebäude.
The administration of the university is located in a separate building.', 1805, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cautious', 'vorsichtig', ARRAY[]::text[], NULL, NULL, 'Bei Schnee und Eis muss man vorsichtig fahren.
In snow and ice you have to drive cautiously.', 1806, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(a) while', 'Weile', ARRAY[]::text[], 'noun', 'die', 'Frau Hellmann betrachtet das Gemälde eine Weile und geht dann weiter zum nächsten.
Mrs. Hellmann is looking at the painting for a while and then moves on to the next.', 1807, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to draw', 'zeichnen', ARRAY[]::text[], NULL, NULL, 'Aileen zeichnet gern Comics.
Aileen likes drawing comics.', 1808, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'address', 'Adresse', ARRAY[]::text[], 'noun', 'die', 'Die Adresse des Empfängers kommt auf die Vorderseite des Briefes.
The address of the recipient has to be on the front side of the letter.', 1809, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to aim at, strive', 'anstreben', ARRAY[]::text[], NULL, NULL, 'Jule strebt einen höheren Abschluss an.
Jule is aiming for a higher degree.', 1810, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to disolve', 'auflösen', ARRAY[]::text[], NULL, NULL, 'Die Tablette löst sich im Wasser auf.
The tablet dissolves in water.', 1811, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to carry out', 'ausführen', ARRAY[]::text[], NULL, NULL, 'Sie hat nur eine Anweisung ausgeführt.
She has only carried out an instruction.', 1812, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to calm (to ''make quiet'') (not: entspannen)', 'beruhigen', ARRAY[]::text[], NULL, NULL, 'Karen beruhigt ihr Kind mit einem Keks.
Karen is calming her child with a biscuit.', 1813, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'amount (of money)', 'Betrag', ARRAY[]::text[], 'noun', 'der', 'Von meinem Konto wurde ein größerer Betrag abgebucht.
A larger amount was debited from my account.', 1814, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'such, like that', 'derartig', ARRAY[]::text[], NULL, NULL, 'Derartige Probleme hatten wir hier noch nie.
Such problems we''ve never had here before.', 1815, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'honest', 'ehrlich', ARRAY[]::text[], NULL, NULL, 'Ich möchte deine ehrliche Meinung dazu hören.
I would like to hear your honest opinion about it.', 1816, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distant', 'entfernt', ARRAY[]::text[], NULL, NULL, 'Unser Nachbarplanet Mars ist ganz schön weit von uns entfernt.
Our neighbor planet Mars is pretty far distant from us.', 1817, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to add, submit (as when submitting to something greater)', 'sich fügen', ARRAY[]::text[], NULL, NULL, 'Letztendlich muss sich jeder in sein Schicksal fügen.
Ultimately, everyone must submit to their fate.', 1818, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'yellow', 'gelb', ARRAY[]::text[], NULL, NULL, 'Bananen und Zitronen sehen gelb aus.
Bananas and lemons look yellow.', 1819, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'neck, throat', 'Hals', ARRAY[]::text[], 'noun', 'der', 'Die Dame trägt eine edle Perlenkette um den Hals.
The lady is wearing an elegant pearl necklace around her neck.', 1820, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'home, homeland (not: Heim)', 'Heimat', ARRAY[]::text[], 'noun', 'die', 'Die Heimat ist da, wo man sich wohl fühlt.
Home is where you feel comfortable.', 1821, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'up, upwards', 'hinauf', ARRAY[]::text[], NULL, NULL, 'Den Berg hinauf geht es immer langsamer als hinunter.
Upwards the mountain is always slower than downwards.', 1822, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go (there)', 'hingehen', ARRAY[]::text[], NULL, NULL, 'Gehst du morgen hin?
Are you going to go there tomorrow?', 1823, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the purchase', 'Kauf', ARRAY[]::text[], 'noun', 'der', 'Das Öffnen der Packung verpflichtet nicht zum Kauf der Ware.
Opening the package doesn''t obligate to purchase the product.', 1824, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cinema, movie theatre', 'Kino', ARRAY[]::text[], 'noun', 'das', 'Das alternative Kino zeigt auch ältere und unbekannte Filme.
The alternative cinema also shows older and unknown movies.', 1825, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'competition', 'Konkurrenz', ARRAY[]::text[], 'noun', 'die', 'Die Konkurrenz schläft nicht.
Competition never sleeps.', 1826, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mathematics', 'Mathematik', ARRAY[]::text[], 'noun', 'die', 'Mathematik ist eine Hilfswissenschaft für alle Naturwissenschaften.
Mathematics is an auxiliary science for all nature sciences.', 1827, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to inform (nicht informieren)', 'mitteilen', ARRAY[]::text[], NULL, NULL, 'Das Ministerium teilt mit, dass Versicherungen bis zum Ende des Jahres steuerfrei sind.
The Ministry informed that insurances are tax-free until the end of the year.', 1828, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'layer, class', 'Schicht', ARRAY[]::text[], 'noun', 'die', 'Auf den Möbeln liegt eine dicke Schicht Staub.
On the furniture is a thick layer of dust.', 1829, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'narrow, slender', 'schmal', ARRAY[]::text[], NULL, NULL, 'Zwischen den Fahrbahnen ist ein schmales Stück Rasen.
Between the lanes is a narrow piece of turf.', 1830, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'main emphasis, center of gravity', 'Schwerpunkt', ARRAY[]::text[], 'noun', 'der', 'Der Schwerpunkt der Untersuchung liegt auf der Synthese verschiedener Theorien.
The study''s main emphasis is the synthesis of various theories.', 1831, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to swim', 'schwimmen', ARRAY[]::text[], NULL, NULL, 'Es muss auch Leute geben, die gegen den Strom schwimmen.
There must be some people who swim against the tide.', 1832, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'argument, fight (nicht die Auseinandersetzung)', 'Streit', ARRAY[]::text[], 'noun', 'der', 'Der Streit um die Löhne geht weiter.
The argument over the wages continues.', 1833, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to agree', 'vereinbaren', ARRAY[]::text[], NULL, NULL, 'Die Regierung vereinbarte mit den Rebellen eine Waffenruhe.
The government agreed with the rebels on a ceasefire.', 1834, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'negotiation', 'Verhandlung', ARRAY[]::text[], 'noun', 'die', 'Die Verhandlungen mit der Gewerkschaft verlaufen positiv.
The negotiations with the union are going well.', 1835, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'soft', 'weich', ARRAY[]::text[], NULL, NULL, 'Kinder mögen weiche Spielsachen wie Stofftiere.
Children like soft toys like stuffed animals.', 1836, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'where', 'wohin', ARRAY[]::text[], NULL, NULL, 'Wohin gehen wir heute Abend?
Where are we going to go tonight?', 1837, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expiry, action (the going out)', 'Ablauf', ARRAY[]::text[], 'noun', 'der', 'Herr Lothar plant den Ablauf seiner Silberhochzeit.
Lothar is planning the procedure of his silver wedding.', 1838, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Arabian, Arabic', 'arabisch', ARRAY[]::text[], NULL, NULL, 'Arabischer Kaffee wird mit Gewürzen gekocht.
Arabic coffee is brewed with spices.', 1839, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employee', 'Arbeitnehmer', ARRAY[]::text[], 'noun', 'der', 'Die Arbeitnehmer haben einen Betriebsrat gewählt.
The employees have elected a council.', 1840, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to inspire, be enthusiastic', 'begeistern', ARRAY[]::text[], NULL, NULL, 'Robert begeistert sich für das Ballett.
Robert is enthusiastic about ballet.', 1841, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to look after, take care', 'betreuen', ARRAY[]::text[], NULL, NULL, 'Angela betreut ihre kranke Großmutter.
Angela is taking care of her sick grandmother.', 1842, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to indicate, interpret', 'deuten', ARRAY[]::text[], NULL, NULL, 'Ich deute dein Schweigen als Zeichen deiner Zustimmung.
I interpret your silence as a sign of your approval.', 1843, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'third', 'Drittel', ARRAY[]::text[], 'noun', 'das', 'Ein Drittel ist dasselbe wie zwei Sechstel.
A third is the same as two sixth.', 1844, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'empirical', 'empirisch', ARRAY[]::text[], NULL, NULL, 'Die gesammelten empirischen Daten unterstützen die Hypothese.
The collected empirical data supports the hypothesis.', 1845, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to end', 'enden', ARRAY[]::text[], NULL, NULL, 'Der Artikel endet mit einem Aufruf an die Leser.
The article ends with a call on the readers.', 1846, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'adult, grown-up', 'Erwachsene', ARRAY[]::text[], 'noun', NULL, 'Ab 18 gilt man als Erwachsener.
From age 18 on you are considered as an adult.', 1847, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'eternal', 'ewig', ARRAY[]::text[], NULL, NULL, 'Der Sommer dauert nicht ewig.
The summer does not last eternally.', 1848, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'driver', 'Fahrer', ARRAY[]::text[], 'noun', 'der', 'Der Fahrer des PKW war betrunken, als er den Unfall verursachte.
The driver of the car was drunk when he caused the accident.', 1849, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opposite', 'Gegenteil', ARRAY[]::text[], 'noun', 'das', 'Das Gegenteil von lang ist kurz.
The opposite of long is short.', 1850, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'community', 'Gemeinschaft', ARRAY[]::text[], 'noun', 'die', 'Die jüdische Gemeinschaft in Leipzig will ein neues Zentrum errichten.
The Jewish Community in Leipzig wants to build a new center.', 1851, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trade union', 'Gewerkschaft', ARRAY[]::text[], 'noun', 'die', 'Gewerkschaften setzen sich für die Arbeitnehmer ein.
Trade unions stand up for workers.', 1852, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trade', 'Handel', ARRAY[]::text[], 'noun', 'der', 'Der Handel mit China boomt.
The trade with China is booming.', 1853, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at most', 'höchstens', ARRAY[]::text[], NULL, NULL, 'Wir haben höchstens noch zwei Flaschen Wasser da, wir müssen welches kaufen.
We have at most only of two bottles of water here, we need to buy some more.', 1854, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chancellor', 'Kanzler', ARRAY[]::text[], 'noun', 'der', 'Der Kanzler hält eine Rede zur Lage der Nation.
The Chancellor is holding a speech on the situation of the nation.', 1855, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to paint', 'malen', ARRAY[]::text[], NULL, NULL, 'Hilde malt gern Hasen und Hühner.
Hilde likes to paint bunnies and chickens.', 1856, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'management', 'Management', ARRAY[]::text[], 'noun', 'das', 'Der Betrieb ist durch schlechtes Management in Konkurs gegangen.
The business has gone bankrupt due to bad management.', 1857, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'millimetre', 'Millimeter', ARRAY['mm']::text[], 'noun', 'der', 'Das Haar wächst jede Woche etwa drei Millimeter.
Hair is growing about three millimeters each week.', 1858, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'minister', 'Minister', ARRAY[]::text[], 'noun', 'der', 'In der Regierung sind sieben Minister und drei Ministerinnen.
In the government, there are seven male ministers and three female ministers.', 1859, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'disadvantage', 'Nachteil', ARRAY[]::text[], 'noun', 'der', 'Schuluniformen haben Vor- und Nachteile.
School uniforms have advantages and disadvantages.', 1860, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'disk, record, plate', 'Platte', ARRAY[]::text[], 'noun', 'die', 'Florian kauft sich ständig neue Platten, er liebt Musik.
Florian is constantly buying new records, he loves music.', 1861, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to try', 'probieren', ARRAY['kosten']::text[], NULL, NULL, 'Kann ich mal deinen Kakao probieren?
Can I try some of your cocoa?', 1862, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'since then', 'seitdem', ARRAY[]::text[], NULL, NULL, 'Vor einem Jahr hatte ich einen Unfall. Seitdem habe ich Angst beim Autofahren.
A year ago I had an accident. Since then, I''m afraid while driving.', 1863, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'seat, headquarters', 'Sitz', ARRAY[]::text[], 'noun', 'der', 'Der Sitz der Vereinten Nationen ist in New York.
The United Nations Headquarters are in New York.', 1864, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to save', 'sparen', ARRAY[]::text[], NULL, NULL, 'Die Schüler sparen Geld für ihre Klassenfahrt.
Students save money for their class trip.', 1866, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the start, take-off, launch', 'Start', ARRAY[]::text[], 'noun', 'der', 'Start und Landung sind beim Fliegen besonders kritisch.
Take-off and landing are especially critical when flying.', 1867, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to steer, control', 'steuern', ARRAY[]::text[], NULL, NULL, 'Ein Chip steuert die Funktionen des Computers.
A chip controls the functions of the computer.', 1868, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'table, chart', 'Tabelle', ARRAY[]::text[], 'noun', 'die', 'Die Tabelle gibt eine Übersicht über Einnahmen und Ausgaben.
The table gives an overview of revenues and expenditures.', 1869, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tourism', 'Tourismus', ARRAY[]::text[], 'noun', 'der', 'Der Tourismus ist in Österreich ein wichtiger Wirtschaftszweig.
Tourism is an important branch of the economy in Austria.', 1870, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sad', 'traurig', ARRAY[]::text[], NULL, NULL, 'Claudia ist traurig, weil ihr Hund gestorben ist.
Claudia is sad because her dog died.', 1871, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dry', 'trocken', ARRAY[]::text[], NULL, NULL, 'Es hat lange nicht geregnet, die Erde ist ganz trocken.
It has not rained for a long time, the soil is quite dry.', 1872, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to translate', 'übersetzen', ARRAY[]::text[], NULL, NULL, 'Im Russischunterricht müssen die Schüler Zeitungsartikel übersetzen.
In Russian class the students have to translate newspaper articles.', 1873, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to move, to put (into practice)', 'umsetzen', ARRAY[]::text[], NULL, NULL, 'Die Idee wurde sofort in die Tat umgesetzt.
The idea was immediately put into practice.', 1874, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'eerie, scary, incredible', 'unheimlich', ARRAY[]::text[], NULL, NULL, 'Nachts im Wald ist es unheimlich.
At night in the woods, it''s scary.', 1875, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'suspicion', 'Verdacht', ARRAY[]::text[], 'noun', 'der', 'Der Mann steht unter Verdacht, eine Bank ausgeraubt zu haben.
The man is under suspicion of having robbed a bank.', 1876, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diverse, varied (not: unterschiedlich)', 'vielfältig', ARRAY[]::text[], NULL, NULL, 'Den Ozean bewohnen vielfältige Lebensformen.
Diverse forms of life are inhabiting the ocean.', 1877, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bird', 'Vogel', ARRAY[]::text[], 'noun', 'der', 'Viele Vögel fliegen im Winter in den Süden.
In Winter, many birds fly to the South.', 1878, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dare, risk', 'wagen', ARRAY[]::text[], NULL, NULL, 'Ich wage mich nicht, es ihr zu sagen.
I don''t dare to tell her.', 1879, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cry, weep', 'weinen', ARRAY[]::text[], NULL, NULL, 'Tiere können nicht weinen.
Animals can not cry.', 1880, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'why (not: warum)', 'weshalb', ARRAY[]::text[], NULL, NULL, 'Weshalb fällt ein Apfel vom Baum zum Boden und nicht in den Himmel?
Why does an apple fall from the tree to the ground and not to the sky?', 1881, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'resistance, opposition', 'Widerstand', ARRAY[]::text[], 'noun', 'der', 'Die Ureinwohner leisteten lange Zeit Widerstand gegen die Kolonialisten.
The natives put up resistance against the colonists for a long time.', 1882, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wonderful', 'wunderbar', ARRAY[]::text[], NULL, NULL, 'Die Torte schmeckt wunderbar.
The cake tastes great.', 1883, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to report, sue, indicate', 'anzeigen', ARRAY[]::text[], NULL, NULL, 'Ich habe den Einbrecher angezeigt.
I reported the burglar.', 1884, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'poor', 'arm', ARRAY[]::text[], NULL, NULL, 'Sie stammt aus armen Verhältnissen.
She comes from a poor background.', 1885, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to ask, request', 'auffordern', ARRAY[]::text[], NULL, NULL, 'Sie fordern die Gäste zum Bleiben auf.
They ask the guests to stay.', 1886, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to choose, select', 'auswählen', ARRAY[]::text[], NULL, NULL, 'Die Kommission wählt nur einen Kandidaten aus.
The Commission selects only one candidate.', 1887, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'official, civil servant', 'Beamte', ARRAY[]::text[], 'noun', NULL, 'Die meisten Beamten werden gut bezahlt.
Most civil servants are well paid.', 1888, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to greet', 'begrüßen', ARRAY[]::text[], NULL, NULL, 'Der Conferencier begrüßt seine Gäste.
The Conferencier greets his guests.', 1889, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Lower House (of Parliament)', 'Bundestag', ARRAY[]::text[], 'noun', 'der', 'Der Bundestag wird diesem Gesetz nicht zustimmen.
The Lower House of Parliament won''t approve this law.', 1890, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to enter, record, register', 'eintragen', ARRAY[]::text[], NULL, NULL, 'Bei einer Petition muss man seinen Namen in eine Liste eintragen.
For a petition you must register your name on a list.', 1891, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'according to, accordingly', 'entsprechend', ARRAY[]::text[], NULL, NULL, 'Die Mitarbeiter werden entsprechend ihren Fähigkeiten eingesetzt.
The employees are put in positions according to their abilities.', 1892, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to disappoint', 'enttäuschen', ARRAY[]::text[], NULL, NULL, 'Stefan enttäuschte seine Eltern sehr, als er sein Medizinstudium abbrach.
Stefan disappointed his parents very much when he discontinued his medical studies.', 1893, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mutual, each other (not: einander)', 'gegenseitig', ARRAY[]::text[], NULL, NULL, 'Die Geschwister helfen sich gegenseitig bei den Hausaufgaben.
The siblings help each other with their homework.', 1894, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'violent, powerful', 'gewaltig', ARRAY[]::text[], NULL, NULL, 'Ein gewaltiges Erdbeben zerstörte die ganze Stadt.
An enormous earthquake destroyed the whole city.', 1895, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'basic, fundamental', 'grundlegend', ARRAY[]::text[], NULL, NULL, 'Im Januar gibt es grundlegende Veränderungen in der Steuerpolitik.
In January, there will be fundamental changes in tax policy.', 1896, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'investment', 'Investition', ARRAY[]::text[], 'noun', 'die', 'Kinder sind eine Investition in die Zukunft.
Children are an investment in the future.', 1897, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'normally', 'normalerweise', ARRAY[]::text[], NULL, NULL, 'Normalerweise putze ich mir nach dem Frühstück die Zähne.
Normally I brush my teeth after breakfast.', 1898, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'planning, plan', 'Planung', ARRAY[]::text[], 'noun', 'die', 'Alle sind mit der Planung der Exkursion beschäftigt.
Everyone is busy with the planning of the excursion.', 1899, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'policeman', 'Polizist', ARRAY[]::text[], 'noun', 'der', 'Polizisten leben relativ gefährlich.
Police officers live relatively dangerous.', 1900, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'writer', 'Schriftsteller', ARRAY[]::text[], 'noun', 'der', 'Schriftsteller denken meist nicht zuerst an den Erfolg beim Publikum.
Writers tend not to think primarily of success with their audience.', 1901, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'athletic (not: athletisch)', 'sportlich', ARRAY['athletisch']::text[], NULL, NULL, 'Von den deutschen Teilnehmern erwartet man zu den Olympischen Spielen sportliche Höchstleistungen.
Of the German participants athletic excellence is expected for the Olympic Games.', 1902, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strength', 'Stärke', ARRAY[]::text[], 'noun', 'die', 'Die Stärke der Mannschaft besteht in ihrem Teamgeist.
The strength of the team is their team spirit.', 1903, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tax', 'Steuer', ARRAY[]::text[], 'noun', 'die', 'Die Autobahn wird aus Steuern finanziert.
The highway is financed by taxes.', 1904, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to support, base on (not: beruhen, basieren)', 'stützen von etwas', ARRAY[]::text[], NULL, NULL, 'Seine wilden Theorien werden von den Tatsachen nicht gestützt.
His wild theories are not supported by the facts.', 1905, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'therapy', 'Therapie', ARRAY[]::text[], 'noun', 'die', 'Die Therapie hilft vor allem jüngeren Patienten.
The therapy helps foremost younger patients.', 1906, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dream', 'träumen', ARRAY[]::text[], NULL, NULL, 'Die meisten Menschen träumen im Schlaf, wissen am Morgen aber nichts mehr davon.
Most people dream during sleep, but don''t know of it in the morning anymore.', 1907, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Turkish', 'türkisch', ARRAY[]::text[], NULL, NULL, 'In unserer Straße gibt es einen türkischen Imbiss.
In our street there is a Turkish restaurant.', 1908, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thought, thinking', 'Überlegung', ARRAY[]::text[], 'noun', 'die', 'Meine Überlegungen gehen dahin, dass ich bald umziehen muss.
My thoughts go in the direction that I have to move soon.', 1909, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to turn over, turn round', 'umdrehen', ARRAY[]::text[], NULL, NULL, 'Holger hat sich einfach umgedreht und ist gegangen.
Holger just turned around and left.', 1910, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'married', 'verheiratet', ARRAY[]::text[], NULL, NULL, 'Verheiratete Paare haben mehr gesetzliche Vorteile als unverheiratete.
Married couples have more legal benefits than unmarried ones.', 1911, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'traffic', 'Verkehr', ARRAY[]::text[], 'noun', 'der', 'Der Verkehr stand durch die Demonstranten eine Stunde lang still.
Traffic stood still for one hour due to the demonstrators.', 1912, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'injury', 'Verletzung', ARRAY[]::text[], 'noun', 'die', 'Bei dem Sturz zog er sich eine schwere Verletzung zu.
From the fall he suffered a serious injury.', 1913, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to publish', 'veröffentlichen', ARRAY[]::text[], NULL, NULL, 'Der Verlag veröffentlicht vor allem unbekannte junge Autorinnen und Autoren.
The publisher publishes mainly unknown young authors.', 1914, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'presuppose, take for granted (to be expect without 2nd thought)', 'voraussetzen', ARRAY[]::text[], NULL, NULL, 'Sehr gute Englischkenntnisse werden vorausgesetzt.
Very good English skills are presupposed.', 1915, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to admit', 'zugeben', ARRAY[]::text[], NULL, NULL, 'Du kannst den Fehler ruhig zugeben.
You can admit the mistake.', 1916, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'member of parliament, congress', 'Abgeordnete', ARRAY[]::text[], 'noun', NULL, 'Die Abgeordnete verlässt den Plenarsaal.
The member of parliament left the Chamber.', 1917, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to respect, pay attention', 'achten', ARRAY[]::text[], NULL, NULL, 'Urgroßvater wird von allen Familienmitgliedern hoch geachtet.
Great-grandfather is highly respected by all family members.', 1918, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'connection (not: Verbindung)', 'Anschluss', ARRAY[]::text[], 'noun', 'der', 'Leider habe ich meinen Anschluss nach Zürich verpasst. Jetzt muss ich zwei Stunden warten.
Unfortunately, I missed my connection to Zurich. Now I have to wait for two hours.', 1919, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to position, estimate, fix', 'ansetzen', ARRAY[]::text[], NULL, NULL, 'Für welche Uhrzeit sollen wir den Termin ansetzen?
For what time should we position the meeting?', 1920, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'army', 'Armee', ARRAY[]::text[], 'noun', 'die', 'Die Armee marschiert in das besetzte Gebiet ein.
The Army marches into the occupied territory.', 1921, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'atmosphere', 'Atmosphäre', ARRAY[]::text[], 'noun', 'die', 'Die Atmosphäre schützt die Erde vor den Strahlen der Sonne.
The atmosphere protects the earth from the sun''s rays.', 1922, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'choice, selection', 'Auswahl', ARRAY[]::text[], 'noun', 'die', 'Im Weingeschäft neben der Post gibt es eine große Auswahl an leckeren deutschen Weinen.
In the wine shop next to the post office there is a wide selection of delicious German wines.', 1923, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fear', 'befürchten', ARRAY[]::text[], NULL, NULL, 'Viele Arbeiter befürchten nun, dass ihnen gekündigt wird.
Many workers fear now that they will be terminated.', 1924, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'description', 'Beschreibung', ARRAY[]::text[], 'noun', 'die', 'Die Beschreibung trifft auf den gesuchten Mann zu.
The description applies to the requested man.', 1925, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consciousness', 'Bewusstsein', ARRAY[]::text[], 'noun', 'das', 'Nach dem Sturz verlor sie das Bewusstsein.
After the fall she lost consciousness.', 1926, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'boat', 'Boot', ARRAY[]::text[], 'noun', 'das', 'Ein Boot mit Flüchtlingen ging in der Nacht an Land.
A boat with refugees went ashore at night.', 1927, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'revenue, income, receipts', 'Einnahme', ARRAY[]::text[], 'noun', 'die', 'Die Einnahmen des heutigen Abends decken nicht die Ausgaben.
The revenues of this evening do not cover the expenses.', 1928, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'illness, disease (not: Krankheit)', 'Erkrankung', ARRAY[]::text[], 'noun', 'die', 'Ältere Menschen leiden oft an Erkrankungen des Herzens und der Nieren.
Older people often suffer from diseases of the heart and the kidneys.', 1929, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'area, surface', 'Fläche', ARRAY[]::text[], 'noun', 'die', 'Das Werksgelände erstreckt sich auf einer Fläche von 3 Quadratkilometern.
The factory site covers an area of 3 square kilometers.', 1931, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'airport', 'Flughafen', ARRAY[]::text[], 'noun', 'der', 'Auf dem Flughafen gab es einen Brand.
At the airport there was a fire.', 1932, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'brain', 'Gehirn', ARRAY[]::text[], 'noun', 'das', 'Das Gehirn des Menschen besteht aus zwei Hälften.
The human brain consists of two halves.', 1933, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'health', 'Gesundheit', ARRAY[]::text[], 'noun', 'die', 'Rauchen gefährdet die Gesundheit.
Smoking damages your health.', 1934, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Catholic', 'katholisch', ARRAY[]::text[], NULL, NULL, 'Die katholische Kirche modernisiert sich nur langsam.
The Catholic Church is only modernizing slowly.', 1935, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'long-term', 'langfristig', ARRAY[]::text[], NULL, NULL, 'Die Regierung muss langfristige Entscheidungen treffen.
The government has to make long-term decisions.', 1936, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'neat, proper, orderly', 'ordentlich', ARRAY[]::text[], NULL, NULL, 'Dein Schreibtisch ist immer so ordentlich, du hast wohl keine Arbeit.
Your desk is always so neat, you''re probably not having any work.', 1937, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'park', 'Park', ARRAY[]::text[], 'noun', 'der', 'Durch Leipzig zieht sich ein riesiger Park.
Through Leipzig runs a huge park.', 1938, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'physics', 'Physik', ARRAY[]::text[], 'noun', 'die', 'Die Physik beschäftigt sich mit Vorgängen in der Natur.
Physics deals with processes in nature.', 1940, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mail, post office', 'Post', ARRAY[]::text[], 'noun', 'die', 'Hol doch bitte die Post herein.
Please bring the mail inside.', 1941, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'season', 'Saison', ARRAY[]::text[], 'noun', 'die', 'Außerhalb der Saison sind die Hotels viel billiger.
In the off-season the hotels are much cheaper.', 1942, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'forehead', 'Stirn', ARRAY[]::text[], 'noun', 'die', 'Ihre Haare hängen tief in die Stirn.
Her hair hung down over her forehead.', 1943, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strategy', 'Strategie', ARRAY[]::text[], 'noun', 'die', 'Der Detektiv änderte seine Strategie und war erfolgreich.
The detective changed his strategy and was successful.', 1944, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the change', 'Wechsel', ARRAY[]::text[], 'noun', 'der', 'Mit dem Wechsel der Körperfarbe kann sich ein Chamäleon tarnen.
With the change of body color a chameleon can camouflage.', 1945, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to listen', 'zuhören', ARRAY[]::text[], NULL, NULL, 'Die Kinder hören gespannt zu.
The children are listening anxiously.', 1946, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'particularly, especially', 'zumal', ARRAY[]::text[], NULL, NULL, 'Er konnte das Angebot nicht mehr annehmen, zumal er bereits allen erzählt hatte, dass es nicht gut sei.
He couldn''t accept the offer anymore, especially since he had already told everyone that it was not good.', 1947, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be connected', 'zusammenhängen', ARRAY[]::text[], NULL, NULL, 'Umweltverschmutzung und Klimaerwärmung hängen zusammen.
Pollution and global warming are connected.', 1948, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'workday, daily routine', 'Alltag', ARRAY[]::text[], 'noun', 'der', 'Man muss immer wieder versuchen, dem Alltag zu entfliehen.
You have to try time and again to escape the daily grind.', 1949, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'appearance, entrance', 'Auftritt', ARRAY[]::text[], 'noun', 'der', 'Der Auftritt der Band verzögert sich um eine halbe Stunde.
The appearance of the band is delayed by half an hour.', 1950, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grow up', 'aufwachsen', ARRAY[]::text[], NULL, NULL, 'Meine Tochter wächst unter den besten Bedingungen auf.
My daughter is growing up under the best conditions.', 1951, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'outer, external', 'äußere', ARRAY['s)']::text[], NULL, NULL, 'Die äußeren Umstände verlangen eine Änderung der Taktik.
The external circumstances require a change of tactics.', 1952, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(railway) station', 'Bahnhof', ARRAY[]::text[], 'noun', 'der', 'Am Bahnhof fahren Züge in alle Richtungen ab.
At the station trains are going to all directions.', 1953, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'almost, nearly (not: fast)', 'beinahe', ARRAY[]::text[], NULL, NULL, 'Beinahe wären wir jetzt zusammengestoßen.
We nearly collided now.', 1954, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prefer', 'bevorzugen', ARRAY[]::text[], NULL, NULL, 'Die Firma bevorzugt bei der Stellenbesetzung Bewerber mit guten Französischkenntnissen.
The company prefers for recruitment applicants with good knowledge of French.', 1955, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'federal chancellor', 'Bundeskanzler', ARRAY[]::text[], 'noun', 'der', 'Der Bundeskanzler hält jedes Jahr eine Neujahrsansprache.
The Chancellor holds an annual New Year''s address.', 1956, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'democracy', 'Demokratie', ARRAY[]::text[], 'noun', 'die', 'Demokratie kann man nicht erzwingen.
Democracy can not be forced.', 1957, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'democratic', 'demokratisch', ARRAY[]::text[], NULL, NULL, 'In vielen Ländern gibt es immer noch keine demokratischen Wahlen.
In many countries there are still no democratic elections.', 1958, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the more', 'desto', ARRAY[]::text[], NULL, NULL, 'Je länger man Gemüse kocht, desto weniger Vitamine bleiben darin.
The longer you cook vegetables, the less vitamins remain in it.', 1959, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'each other', 'einander', ARRAY[]::text[], NULL, NULL, 'Die beiden haben einander sehr lieb.
The two love each other very much.', 1960, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expectation', 'Erwartung', ARRAY[]::text[], 'noun', 'die', 'Das Publikum stellt hohe Erwartungen an den neuen Film von Roman Polanski.
The public has high expectations for the new film by Roman Polanski.', 1961, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exact', 'exakt', ARRAY[]::text[], NULL, NULL, 'Bei einer technischen Zeichnung müssen exakte Längenangaben gemacht werden.
For a technical drawing exact length specifications have to be made.', 1962, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'vehicle', 'Fahrzeug', ARRAY[]::text[], 'noun', 'das', 'Fahrzeuge, die im Parkverbot stehen, werden abgeschleppt.
Vehicles that are parked illegally will be towed.', 1963, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'photography', 'Fotografie', ARRAY[]::text[], 'noun', 'die', 'Die Fotografie ist ihre große Leidenschaft.
Photography is her great passion.', 1964, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'manufacturer, producer', 'Hersteller', ARRAY[]::text[], 'noun', 'der', 'Der Hersteller gibt eine Garantie von zwei Jahren.
The manufacturer gives a warranty of two years.', 1966, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'around', 'herum', ARRAY[]::text[], NULL, NULL, 'Die Kinder sitzen um das Feuer herum.
The children are sitting around the fire.', 1967, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'with regard to', 'hinsichtlich', ARRAY[]::text[], NULL, NULL, 'Hinsichtlich der Sicherheit von Zügen gibt es neue Bestimmungen.
With regard to the safety of trains, there are new provisions.', 1968, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wood', 'Holz', ARRAY[]::text[], 'noun', 'das', 'Immer mehr Menschen heizen mit Holz.
More and more people heat with wood.', 1969, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in terms of content', 'inhaltlich', ARRAY[]::text[], NULL, NULL, 'Wegen großer inhaltlicher Mängel bekommt der Aufsatz eine schlechte Note.
Because of deficiencies in terms of content the essay gets a bad grade.', 1970, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to characterize, mark', 'kennzeichnen', ARRAY[]::text[], NULL, NULL, 'Der Wechsel der Jahreszeiten kennzeichnet das Klima in der gemäßigten Zone.
The change of seasons characterizes the climate of the temperate climate zone.', 1971, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'knee', 'Knie', ARRAY[]::text[], 'noun', 'das', 'Viele Fußballer und Skifahrer haben Probleme mit den Knien.
Many soccer players and skiers are having problems with their knees.', 1972, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'combination', 'Kombination', ARRAY[]::text[], 'noun', 'die', 'Eine Kombination von dummen Zufällen hat zu dieser Katastrophe geführt.
A combination of stupid coincidences has led to this disaster.', 1973, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'artificial', 'künstlich', ARRAY[]::text[], NULL, NULL, 'Ich werde mir demnächst eine künstliche Hüfte einsetzen lassen.
I will soon get an artificial hip replacement.', 1974, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'list', 'Liste', ARRAY[]::text[], 'noun', 'die', 'Die Kriminalpolizei erstellt eine Liste der möglichen Täter.
The Criminal Investigation Department created a list of possible perpetrators.', 1975, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'level, standard', 'Niveau', ARRAY[]::text[], 'noun', 'das', 'Nach zehn Jahren aktiven Spielens kann der Fußballer sein Niveau nicht mehr halten.
After ten years of active play, the soccer player isn''t able to keep his level.', 1976, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'perfect', 'perfekt', ARRAY[]::text[], NULL, NULL, 'Niemand ist perfekt.
No one is perfect.', 1977, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pastor', 'Pfarrer', ARRAY[]::text[], 'noun', 'der', 'Der Pfarrer hält eine Predigt vor seiner Gemeinde.
The pastor holds a sermon to his congregation.', 1978, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clean', 'sauber', ARRAY[]::text[], NULL, NULL, 'Chirurgen müssen beim Operieren saubere Geräte benutzen.
Surgeons must use clean equipment when operating.', 1979, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fate', 'Schicksal', ARRAY[]::text[], 'noun', 'das', 'Viele Menschen glauben nicht an das Schicksal.
Many people do not believe in fate.', 1980, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'script, handwriting', 'Schrift', ARRAY[]::text[], 'noun', 'die', 'Die Erfindung der Schrift ist eine der größten menschlichen Errungenschaften.
The invention of writing is one of the greatest human achievements.', 1981, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'provided that, if, so far', 'sofern', ARRAY[]::text[], NULL, NULL, 'Sofern es meine Zeit zulässt, komme ich gern zu der Auktion.
If my time permits, I''m happy to come to the auction.', 1982, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'site, location', 'Standort', ARRAY[]::text[], 'noun', 'der', 'Für den Regierungssitz gibt es keinen besseren Standort als den in Berlin.
For the government there is no better location than the one in Berlin.', 1983, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'publishing company', 'Verlag', ARRAY[]::text[], 'noun', 'der', 'In diesem Verlag werden vor allem Sachbücher veröffentlicht.
This publishing company is publishing mainly non-fiction books.', 1984, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'period of time', 'Zeitraum', ARRAY[]::text[], 'noun', 'der', 'In einem Zeitraum von einer Woche muss Paul aus seiner Wohnung ausziehen.
Over a period of one week Paul has to move out of his apartment.', 1985, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to quote', 'zitieren', ARRAY[]::text[], NULL, NULL, 'Die Autorin zitiert in ihrer Arbeit einen umstrittenen Forscher.
The author cites in her work a controversial researcher.', 1986, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'department', 'Abteilung', ARRAY[]::text[], 'noun', 'die', 'Die Abteilung für kulturelle Zusammenarbeit wird zum Ende des Jahres geschlossen.
The Department of Cultural Cooperation is going to be closed by the end of the year.', 1987, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Bavarian', 'bayrisch', ARRAY[]::text[], NULL, NULL, 'Bayrisches Bier ist nicht nur in Deutschland sehr beliebt.
Bavarian beer is not only in Germany very popular.', 1989, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'proof, evidence', 'Beweis', ARRAY[]::text[], 'noun', 'der', 'Der Beweis seiner Unschuld muss noch erbracht werden.
The proof of his innocence must still be established.', 1990, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'behind it', 'dahinter', ARRAY[]::text[], NULL, NULL, 'Dahinter versteckt sich sicher wieder die Mafia.
Behind it there is surely hiding again the mafia.', 1991, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'detail', 'Detail', ARRAY[]::text[], 'noun', 'das', 'Details sind oft nicht so wichtig wie das große Ganze.
Details are often not as important as the big picture.', 1992, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dimension', 'Dimension', ARRAY[]::text[], 'noun', 'die', 'Die Verwüstungen traten in einer unerwarteten Dimension auf.
The devastation occurred in an unexpected dimension.', 1993, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to excuse, apologize', 'entschuldigen', ARRAY[]::text[], NULL, NULL, 'Entschuldigen Sie bitte meine Verspätung!
Please excuse my delay!', 1994, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to settle, take care', 'erledigen', ARRAY[]::text[], NULL, NULL, 'Ich erledige meine Hausarbeiten am Wochenende.
I do my housework on the weekend.', 1995, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'researcher', 'Forscher', ARRAY[]::text[], 'noun', 'der', 'Japanische Forscher untersuchen die Zusammensetzung einer neuen Substanz.
Japanese researchers are studying the composition of a new substance.', 1996, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to endanger', 'gefährden', ARRAY[]::text[], NULL, NULL, 'Betrunkene Autofahrer gefährden auch die Sicherheit der anderen Verkehrsteilnehmer.
Drunk drivers also endanger the safety of other road users.', 1997, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'occasionally', 'gelegentlich', ARRAY[]::text[], NULL, NULL, 'In diesem Kino finden gelegentlich auch Konzerte statt.
In this cinema occasionally also concerts take place.', 1998, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'usual', 'gewohnt', ARRAY[]::text[], NULL, NULL, 'Er ist frühes Aufstehen nicht gewohnt.
He is not used to getting up early.', 1999, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coarse, rude, gross', 'grob', ARRAY[]::text[], NULL, NULL, 'Unser Vorgesetzter hat sich einen groben Fehler erlaubt.
Our boss has allowed himself a gross error.', 2000, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'integration', 'Integration', ARRAY[]::text[], 'noun', 'die', 'Die Integration von Ausländern ist in allen modernen Gesellschaften sehr wichtig.
The integration of foreigners is very important in all modern societies.', 2002, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cash register, checkout', 'Kasse', ARRAY[]::text[], 'noun', 'die', 'Bitte bezahlen Sie die Ware an der Kasse!
Please pay for the goods at the checkout!', 2003, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'category', 'Kategorie', ARRAY[]::text[], 'noun', 'die', 'A und B gehören zwei verschiedenen Kategorien an.
A and B belong to two different categories.', 2004, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'literary', 'literarisch', ARRAY[]::text[], NULL, NULL, 'Dieser Roman ist eine literarische Meisterleistung.
This novel is a literary masterpiece.', 2005, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'maximum', 'maximal', ARRAY[]::text[], NULL, NULL, 'Krokodile erreichen eine maximale Körperlänge von 7 Metern.
Crocodiles reach a maximum body length of 7 meters.', 2006, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'organism', 'Organismus', ARRAY[]::text[], 'noun', 'der', 'Am Grunde des Ozeans leben noch viele unerforschte Organismen.
At the bottom of the ocean live many unexplored organisms.', 2007, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'parallel', 'parallel', ARRAY[]::text[], NULL, NULL, 'Wenn zwei Geraden parallel liegen, berühren sie sich nie.
If two lines are parallel, they never touch.', 2008, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'radio', 'Radio', ARRAY[]::text[], 'noun', 'das', 'Das Radio bringt alle halbe Stunde Nachrichten.
The radio brings news every half hour.', 2009, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at the latest', 'spätestens', ARRAY[]::text[], NULL, NULL, 'Der Antrag muss bis spätestens morgen beim Finanzamt vorliegen.
The application must be available no later than tomorrow at the tax office.', 2010, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dance', 'tanzen', ARRAY[]::text[], NULL, NULL, 'Meine Eltern tanzen gerne Walzer.
My parents love to waltz.', 2011, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'accident', 'Unfall', ARRAY[]::text[], 'noun', 'der', 'Auf dieser Straße passieren zu viele Unfälle.
On this road there happen too many accidents.', 2012, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lower', 'untere', ARRAY['s)']::text[], NULL, NULL, 'Die untere Etage bewohnen meine Schwiegereltern, die obere wir.
My parents in law live on the lower floor, we live on the upper one.', 2013, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'improvement', 'Verbesserung', ARRAY[]::text[], 'noun', 'die', 'Das neue System stellt eine deutliche Verbesserung gegenüber dem alten dar.
The new system is a significant improvement compared to the older one.', 2014, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comparable', 'vergleichbar', ARRAY[]::text[], NULL, NULL, 'In diesem Semester kann das Institut kein vergleichbares Seminar anbieten.
This semester, the Institute cannot offer a similar seminar.', 2015, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'commitment, obligation', 'Verpflichtung', ARRAY[]::text[], 'noun', 'die', 'Hiermit gehen Sie die Verpflichtung ein, sich jede Woche bei uns zu melden.
You hereby agree to the obligation to report to us every week.', 2016, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to (go on a) walk or hike, migrate', 'wandern', ARRAY[]::text[], NULL, NULL, 'Wandern ist ein gesunder Sport.
Walking is a healthy sport.', 2017, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'school leaving exam, A levels', 'Abitur', ARRAY[]::text[], 'noun', 'das', 'Für den Zugang zu einer deutschen Hochschule wird das Abitur verlangt.
For access to a German university, A levels are required.', 2018, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to adjust, adapt', 'anpassen', ARRAY[]::text[], NULL, NULL, 'Das Chamäleon passt sich an seine Umwelt an.
The chameleon adapts to its environment.', 2019, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to spend', 'ausgeben', ARRAY[]::text[], NULL, NULL, 'Gib nicht so viel Geld aus!
Do not spend so much money!', 2020, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to abandon', 'aussetzen', ARRAY[]::text[], NULL, NULL, 'Der Hund wurde ausgesetzt.
The dog has been abandoned.', 2021, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'need, demand', 'Bedarf', ARRAY[]::text[], 'noun', 'der', 'Der Bedarf an Fernsehgeräten ist gedeckt.
The demand for television sets is covered.', 2022, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to impress', 'beeindrucken', ARRAY[]::text[], NULL, NULL, 'Marlene Dietrich beeindruckt die Menschen noch lange nach ihrem Tod.
Marlene Dietrich still impresses people long after her death.', 2023, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to advise, discuss', 'beraten', ARRAY[]::text[], NULL, NULL, 'Das sollten wir in der Kommission beraten.
We should discuss this within the commission.', 2024, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'advice, discussion, consultation', 'Beratung', ARRAY[]::text[], 'noun', 'die', 'Die Mitglieder trafen sich zu einer Beratung.
The members met for a discussion.', 2025, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employment, job, activity, occupation', 'Beschäftigung', ARRAY[]::text[], 'noun', 'die', 'Im Moment habe ich keine Beschäftigung.
I currently have no job.', 2026, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'contemplation, examination', 'Betrachtung', ARRAY[]::text[], 'noun', 'die', 'Bei der Betrachtung des Mondes fallen einem immer wieder neue Krater und Täler auf.
When examining the moon one discovers new craters and valleys every time.', 2027, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Upper House of Parliament', 'Bundesrat', ARRAY[]::text[], 'noun', 'der', 'Der Bundesrat muss über alle Gesetze, die aus dem Bundestag kommen, beraten.
The Upper House of Parliament has to discuss about every law that comes from the Federal Council.', 2028, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'enormous', 'enorm', ARRAY[]::text[], NULL, NULL, 'Nur mit enormen Anstrengungen konnte die Kirche wiederaufgebaut werden.
Only with enormous effort, the church could be rebuilt.', 2029, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to build, draw up, produce', 'erstellen', ARRAY[]::text[], NULL, NULL, 'Die Bundesagentur für Arbeit erstellt jedes Jahr einen Bericht zur Arbeitslosigkeit.
The Federal Employment Agency each year prepares a report on unemployment.', 2030, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'February', 'Februar', ARRAY[]::text[], 'noun', 'der', 'Im Februar blühen die ersten Blumen.
In February, the first flowers bloom.', 2031, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'flat, low, shallow', 'flach', ARRAY[]::text[], NULL, NULL, 'Die Erde ist keine flache Scheibe, sondern eine Kugel.
The earth is not a flat disk, but a ball.', 2032, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'spring', 'Frühjahr', ARRAY[]::text[], 'noun', 'das', 'Im Frühjahr blühen viele Blumen.
In spring many flowers bloom.', 2033, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grant, give', 'gewähren', ARRAY[]::text[], NULL, NULL, 'Wir können Ihnen gerne auch noch einen kleinen Rabatt gewähren.
We can also gladly provide a small discount.', 2034, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'weight', 'Gewicht', ARRAY[]::text[], 'noun', 'das', 'Das Gewicht eines Päckchens darf zwei Kilogramm betragen.
The weight of a parcel may not exceed two kilograms.', 2035, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'journalist', 'Journalist', ARRAY[]::text[], 'noun', 'der', 'Journalisten umlagern den Politiker und stellen ihm Fragen.
Journalists surround the politician and ask him questions.', 2036, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to clear up, clarify', 'klären', ARRAY[]::text[], NULL, NULL, 'Den Streit können wir sicher bei einem Gespräch klären.
We can certainly clarify the dispute in a conversation.', 2037, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'competence, authority', 'Kompetenz', ARRAY[]::text[], 'noun', 'die', 'Felix muss seine Kompetenz unter Beweis stellen.
Felix needs to prove his competence.', 2038, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'complicated', 'kompliziert', ARRAY[]::text[], NULL, NULL, 'Quantenphysik ist sehr kompliziert.
Quantum physics is very complicated.', 2039, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at short notice', 'kurzfristig', ARRAY[]::text[], NULL, NULL, 'Es hat sich eine kurzfristige Änderung ergeben.
There has been a change at short notice.', 2040, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'food (not: das Essen)', 'Lebensmittel', ARRAY[]::text[], 'noun', 'das', 'In welchen Lebensmitteln ist besonders viel Kalzium?
What food is particularly rich in calcium?', 2041, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'solid, massive, severe', 'massiv', ARRAY[]::text[], NULL, NULL, 'Arbeitslose müssen dieses Jahr mit massiven Einschnitten rechnen.
Unemployed people have to expect massive cuts this year.', 2042, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'midpoint, centre of focus', 'Mittelpunkt', ARRAY[]::text[], 'noun', 'der', 'Sie steht gern im Mittelpunkt.
She likes to be the centre of focus.', 2043, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'best possible, optimum', 'optimal', ARRAY[]::text[], NULL, NULL, 'Maria bringt optimale Voraussetzungen für den Job mit.
Mary has the best possible prequisits for the job.', 2044, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to store, save', 'speichern', ARRAY[]::text[], NULL, NULL, 'Bevor Sie den Computer ausschalten, sollten Sie die Datei speichern.
Before turning off the computer, you should save the file.', 2045, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mirror', 'Spiegel', ARRAY[]::text[], 'noun', 'der', 'Wir haben einen neuen Spiegel gekauft.
We have bought a new mirror.', 2046, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'beach', 'Strand', ARRAY[]::text[], 'noun', 'der', 'Am Strand der Ostsee findet man viele Muscheln und Steine.
On the beach of the Baltic Sea there are lots of shells and stones.', 2047, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stairs', 'Treppe', ARRAY[]::text[], 'noun', 'die', 'Die Kinder sitzen auf der Treppe und warten, bis ihnen jemand aufschließt.
The children sit on the stairs and wait until someone unlocks the door.', 2048, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'assets, fortune, ability', 'Vermögen', ARRAY[]::text[], 'noun', 'das', 'Er hat ein Vermögen für den Hauskauf ausgegeben.
He has spent a fortune on buying a home.', 2049, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'being, creature, nature (of sth)', 'Wesen', ARRAY[]::text[], 'noun', 'das', 'Forscher gehen dem Wesen einer Sache auf den Grund.
Researchers get to the bottom of the nature of something.', 2050, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to assign, classify', 'zuordnen', ARRAY[]::text[], NULL, NULL, 'Das Werk lässt sich der Epoche der Romantik zuordnen.
The work can be assigned to the Romantic era.', 2051, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gradual', 'allmählich', ARRAY[]::text[], NULL, NULL, 'Der Wetterbericht sagt ein allmähliches Ansteigen der Temperaturen voraus.
The weather forecast predicts a gradual rise in temperatures.', 2052, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unemployment', 'Arbeitslosigkeit', ARRAY[]::text[], 'noun', 'die', 'Die Arbeitslosigkeit ist in Brandenburg besonders hoch.
Unemployment is particularly high in Brandenburg.', 2053, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pick up, keep, lift', 'aufheben', ARRAY[]::text[], NULL, NULL, 'Heb die Quittung gut auf!
Keep your receipt in a save place!', 2054, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to deal', 'befassen', ARRAY[]::text[], NULL, NULL, 'Wir müssen uns mit diesem Problem bald befassen.
We have to deal with this problem soon.', 2055, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to ask, question', 'befragen', ARRAY[]::text[], NULL, NULL, 'Fünfzig Menschen wurden befragt.
Fifty people were asked.', 2056, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'observation', 'Beobachtung', ARRAY[]::text[], 'noun', 'die', 'Das war eine wichtige Beobachtung.
This was an important observation.', 2057, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'component', 'Bestandteil', ARRAY[]::text[], 'noun', 'der', 'Zwei Praktika sind obligatorische Bestandteile dieses Studiums.
Two internships are mandatory components of this study.', 2058, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'participation', 'Beteiligung', ARRAY[]::text[], 'noun', 'die', 'Die Beteiligung an der Wahl war gering.
The participation in the election was low.', 2059, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'assessment, rating', 'Bewertung', ARRAY[]::text[], 'noun', 'die', 'Die Bewertung erfolgt unter unterschiedlichen Aspekten.
The assessment is carried out under different aspects.', 2060, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'name, term', 'Bezeichnung', ARRAY[]::text[], 'noun', 'die', 'Wie ist die lateinische Bezeichnung für diese Pflanze?
What is the Latin name for this plant?', 2061, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bridge', 'Brücke', ARRAY[]::text[], 'noun', 'die', 'Dresden hat viele schöne Brücken.
Dresden has many beautiful bridges.', 2062, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to commit (engage with heavily)', 'sich engagieren', ARRAY[]::text[], NULL, NULL, 'Sie engagiert sich bei Greenpeace.
She is committed to Greenpeace.', 2064, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to decide (this version is like "creating the close")', 'entschließen', ARRAY[]::text[], NULL, NULL, 'Wir haben uns entschlossen umzuziehen.
We have decided to move.', 2065, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to guarantee', 'garantieren', ARRAY[]::text[], NULL, NULL, 'Wir können nur 45 Arbeitsplätze garantieren.
We can only guarantee 45 jobs.', 2066, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the use', 'Gebrauch', ARRAY[]::text[], 'noun', 'der', 'Vor Gebrauch schütteln!
Shake well before use!', 2067, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'if necessary', 'gegebenenfalls', ARRAY[]::text[], NULL, NULL, 'Gegebenenfalls müssen wir präventive Maßnahmen ergreifen.
If necessary we may need to take preventive measures.', 2068, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'just, fair', 'gerecht', ARRAY[]::text[], NULL, NULL, 'Wir erwarten ein gerechtes Urteil.
We expect a fair judgment.', 2069, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'manager (not: der Manager)', 'Geschäftsführer', ARRAY[]::text[], 'noun', 'der', 'Der Geschäftsführer des Unternehmens war noch sehr jung.
The manager of the company was still very young.', 2070, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to teach', 'lehren', ARRAY[]::text[], NULL, NULL, 'Sie lehrt Deutsch im Goethe-Institut.
She teaches German at the Goethe-Institut.', 2071, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lip', 'Lippe', ARRAY[]::text[], 'noun', 'die', 'Rote Lippen soll man küssen.
Red lips should be kissed.', 2072, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'governor, minister president', 'Ministerpräsident', ARRAY[]::text[], 'noun', 'der', 'Georg Milbradt ist der Ministerpräsident von Sachsen.
Georg Milbradt is the minister president of Saxony.', 2073, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tired', 'müde', ARRAY[]::text[], NULL, NULL, 'Er ist immer müde.
He is always tired.', 2074, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nearly', 'nahezu', ARRAY[]::text[], NULL, NULL, 'Sie hat nahezu ihr ganzes Geld verspielt.
She has nearly squandered all her money.', 2075, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'benefit, profit, use', 'Nutzen', ARRAY[]::text[], 'noun', 'der', 'Der Kopierer bringt keinen großen Nutzen, er ist ständig kaputt.
The copier does not bring great benefits, it is constantly broken.', 2076, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reputation, call', 'Ruf', ARRAY[]::text[], 'noun', 'der', 'Die Stadt hat einen guten Ruf.
The city has a good reputation.', 2077, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Russian', 'Russe', ARRAY[]::text[], 'noun', 'der', 'Puschkin war Russe.
Pushkin was a Russian.', 2078, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'signal', 'Signal', ARRAY[]::text[], 'noun', 'das', 'Wir warten auf das vereinbarte Signal.
We are waiting for the prearranged signal.', 2079, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'standard', 'Standard', ARRAY[]::text[], 'noun', 'der', 'Die Firma hat einen hohen technischen Standard.
The company has a high technical standard.', 2080, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'star, starling', 'Star', ARRAY[]::text[], 'noun', 'der', 'Die Fans bewunderten ihren Star.
The fans admired their star.', 2081, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to increase, raise', 'steigern', ARRAY[]::text[], NULL, NULL, 'Wir müssen den Umsatz steigern.
We need to increase the income.', 2082, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strategic', 'strategisch', ARRAY[]::text[], NULL, NULL, 'Wir sollten uns eine strategische Vorgehensweise überlegen.
We should consider a strategic approach.', 2083, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'substance', 'Substanz', ARRAY[]::text[], 'noun', 'die', 'Dieses Heilmittel wurde aus verschiedenen Substanzen hergestellt.
This remedy is made from various substances.', 2084, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'key, button', 'Taste', ARRAY[]::text[], 'noun', 'die', 'Ich habe aus Versehen die falsche Taste gedrückt.
I accidentally pressed the wrong button.', 2085, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'particle', 'Teilchen', ARRAY[]::text[], 'noun', 'das', 'Ein Atom besteht aus verschiedenen Teilchen.
An atom consists of different particles.', 2086, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extensive', 'umfangreich', ARRAY[]::text[], NULL, NULL, 'Sie verfügt über ein sehr umfangreiches Wissen.
She has a very extensive knowledge.', 2087, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'insurance, assurance', 'Versicherung', ARRAY[]::text[], 'noun', 'die', 'Hast du eine gute Versicherung für dein Haus?
Do you have a good insurance for your house?', 2088, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to supply, look after', 'versorgen', ARRAY[]::text[], NULL, NULL, 'Das Rote Kreuz versorgt die Krisenregionen mit Lebensmitteln.
The Red Cross supplies the crisis regions with food.', 2089, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'preparation', 'Vorbereitung', ARRAY[]::text[], 'noun', 'die', 'Alle waren mit den Vorbereitungen auf das Fest beschäftigt.
All were busy with preparations for the party.', 2090, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foreground', 'Vordergrund', ARRAY[]::text[], 'noun', 'der', 'Im Vordergrund des Gemäldes sehen Sie eine Hochzeitsgesellschaft.
In the foreground of the painting you see a wedding party.', 2091, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attorney, lawyer', 'Anwalt', ARRAY[]::text[], 'noun', 'der', 'Lars ist ein guter Anwalt.
Lars is a good lawyer.', 2092, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to entitle', 'berechtigen', ARRAY[]::text[], NULL, NULL, 'Die Krankenschwester ist nicht dazu berechtigt, Auskünfte zu geben.
The nurse is not entitled to give information.', 2093, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'digital', 'digital', ARRAY[]::text[], NULL, NULL, 'Die digitale Fotografie ist noch nicht sehr alt.
Digital photography is not very old.', 2094, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'experiment', 'Experiment', ARRAY[]::text[], 'noun', 'das', 'Sie nahm an einem psycholinguistischen Experiment teil.
She took part in a psycholinguistic experiment.', 2095, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'general', 'generell', ARRAY[]::text[], NULL, NULL, 'Wir suchen generell immer Aushilfskräfte.
We are generally always looking for temporary workers.', 2096, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'faith, belief', 'Glauben', ARRAY[]::text[], 'noun', 'der', 'Der christliche Glauben ist 2000 Jahre alt.
The Christian faith is 2000 years old.', 2097, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'principle (not: Prinzip)', 'Grundsatz', ARRAY[]::text[], 'noun', 'der', 'Hier gilt der Grundsatz der Gleichbehandlung.
Here the principle of equal treatment counts.', 2098, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'here', 'hierher', ARRAY[]::text[], NULL, NULL, 'Ich bin vor vielen Jahren hierher nach Potsdam gekommen.
I came here many years ago to Potsdam.', 2099, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'initiative', 'Initiative', ARRAY[]::text[], 'noun', 'die', 'Sie gründeten eine Initiative zur Verschönerung ihrer Stadt.
They founded an initiative to beautify their city.', 2100, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'component, factor (not: Bestandteil)', 'Komponente', ARRAY[]::text[], 'noun', 'die', 'Beim Lernen von Fremdsprachen spielen viele Komponenten eine Rolle.
Many components play a role in learning foreign languages.', 2101, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conservative', 'konservativ', ARRAY[]::text[], NULL, NULL, 'Ihre Verwandten sind sehr konservativ.
Her relatives are very conservative.', 2102, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cool', 'kühl', ARRAY[]::text[], NULL, NULL, 'Heute war ein kühler Tag.
Today was a cool day.', 2103, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'local', 'lokal', ARRAY[]::text[], NULL, NULL, 'Am liebsten hört er lokale Radiosender.
He prefers to hear local radio stations.', 2104, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to mix, blend, mingle', 'mischen', ARRAY[]::text[], NULL, NULL, 'Heute Abend möchte ich mich unter die Leute mischen.
Tonight I would like to mingle with the people.', 2105, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'naked, bare', 'nackt', ARRAY[]::text[], NULL, NULL, 'Rubens zeichnete gerne nackte Frauen.
Rubens loved to draw naked women.', 2106, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'surface', 'Oberfläche', ARRAY[]::text[], 'noun', 'die', 'Schleifpapier hat eine raue Oberfläche.
Sandpaper has a rough surface.', 2107, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'physical', 'physikalisch', ARRAY[]::text[], NULL, NULL, 'Die Masse ist eine physikalische Größe.
Mass is a physical quantity', 2108, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'empire, kingdom', 'Reich', ARRAY[]::text[], 'noun', 'das', 'Frankreich ist aus dem westfränkischen Reich entstanden.
France emerged from the West Frankish kingdom.', 2109, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'race', 'Rennen', ARRAY[]::text[], 'noun', 'das', 'Nach dem Rennen findet die Siegerehrung statt.
After the race there is an awards ceremony.', 2110, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stir, move', 'rühren', ARRAY[]::text[], NULL, NULL, 'Der Teig muss lange gerührt werden.
The mixture should be stirred for a long time.', 2111, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'blow, hit', 'Schlag', ARRAY[]::text[], 'noun', 'der', 'Der Schlag kam völlig unerwartet.
The blow came unexpectedly.', 2112, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'terrible', 'schrecklich', ARRAY[]::text[], NULL, NULL, 'Wir hatten ein schreckliches Erlebnis im Zoo, ein Löwe ist ausgebrochen.
We had a terrible experience at the zoo, a lion has escaped.', 2113, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shoe', 'Schuh', ARRAY[]::text[], 'noun', 'der', 'Mein linker Schuh ist kaputt.
My left shoe is broken.', 2114, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'seminar', 'Seminar', ARRAY[]::text[], 'noun', 'das', 'Das Seminar endet um 14 Uhr.
The seminar ends at 14 o''clock.', 2116, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'broadcast, show', 'Sendung', ARRAY[]::text[], 'noun', 'die', 'Gestern hat Luise eine interessante Sendung gesehen.
Yesterday Louise saw an interesting show.', 2117, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exciting, thrilling', 'spannend', ARRAY[]::text[], NULL, NULL, 'Sonnabend sah Sarah einen spannenden Film.
Saturday Sarah saw an exciting film.', 2118, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'suspense, tension', 'Spannung', ARRAY[]::text[], 'noun', 'die', 'Die Spannung steigt.
The tension rises.', 2119, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'technology', 'Technologie', ARRAY[]::text[], 'noun', 'die', 'Das Max-Planck-Institut arbeitet mit modernster Technologie.
The Max-Planck-Institute works with the latest technology.', 2120, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'touristic', 'touristisch', ARRAY[]::text[], NULL, NULL, 'Der Harz ist eine bekannte touristische Region.
The Harz Mountains are a popular tourist region.', 2121, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'troops, unit', 'Truppe', ARRAY[]::text[], 'noun', 'die', 'Eine Truppe amerikanischer Soldaten war in Gefahr geraten.
A squad of American soldiers got in danger.', 2122, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consumer', 'Verbraucher', ARRAY[]::text[], 'noun', 'der', 'Zahlreiche Verbraucher haben verschiedene Produkte beurteilt.
Many consumers have evaluated different products.', 2124, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to unite', 'vereinigen', ARRAY[]::text[], NULL, NULL, 'Deutschland ist seit 1990 wieder vereinigt.
Germany is united again since 1990.', 2125, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sale', 'Verkauf', ARRAY[]::text[], 'noun', 'der', 'An Personen unter 16 ist der Verkauf von Alkohol nicht gestattet.
To persons under 16, the sale of alcohol is not permitted.', 2126, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'multiple', 'vielfach', ARRAY[]::text[], NULL, NULL, 'Wir haben vielfach darüber debattiert.
We have debated about that multiple times.', 2127, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quarter (also district)', 'Viertel', ARRAY[]::text[], 'noun', 'das', 'In diesem Viertel sind die Mieten ziemlich teuer.
In this district, rents are very expensive.', 2128, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'previous year', 'Vorjahr', ARRAY[]::text[], 'noun', 'das', 'Wir haben bessere Ergebnisse erzielt als im Vorjahr.
We have achieved better results than in the previous year.', 2129, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to wake up', 'wecken', ARRAY[]::text[], NULL, NULL, 'Die Mutter weckt ihre Tochter.
The mother wakes up her daughter.', 2130, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to look [at] (informal)', 'angucken', ARRAY[]::text[], NULL, NULL, 'Guck mich nicht so komisch an!
Don''t look at me so funny!', 2131, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to listen to', 'anhören', ARRAY[]::text[], NULL, NULL, 'Der Richter hört alle Zeugen an.
The judge listens to all witnesses.', 2132, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to employ, line up, get into mischief, lock', 'anstellen', ARRAY[]::text[], NULL, NULL, 'Stellt keine Dummheiten an!
Don''t do anything stupid!', 2133, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to perform', 'aufführen', ARRAY[]::text[], NULL, NULL, 'Die Theatergruppe führt ein neues Stück auf.
The theater group performs a new piece.', 2134, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'of all people, of all times', 'ausgerechnet', ARRAY[]::text[], NULL, NULL, 'Ausgerechnet jetzt regnet es!
Of all times, now it''s raining!', 2135, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to consider [as in thinking about] (not: betrachten)', 'bedenken', ARRAY[]::text[], NULL, NULL, 'Viola bedenkt ihre Lage.
Viola considers her position.', 2136, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be based', 'beruhen', ARRAY[]::text[], NULL, NULL, 'Die Theorie beruht auf empirischen Untersuchungen.
The theory is based on empirical studies.', 2137, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cause', 'bewirken', ARRAY[]::text[], NULL, NULL, 'Das Medikament bewirkt eine baldige Besserung.
The drug causes a speedy recovery.', 2138, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'balance sheet,conclusion', 'Bilanz', ARRAY[]::text[], 'noun', 'die', 'Alles in allem können wir eine positive Bilanz ziehen.
All in all, we can draw a positive conclusion.', 2139, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bring in, contribute', 'einbringen', ARRAY[]::text[], NULL, NULL, 'Der Schüler bringt viele Ideen in den Unterricht ein.
The student contributes a lot of ideas to the lesson.', 2140, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'experience (as in having experienced)', 'Erlebnis', ARRAY[]::text[], 'noun', 'das', 'Sein erster Zahnarzttermin blieb ihm ein unvergessliches Erlebnis.
His first appointment with the dentist was an unforgettable experience.', 2141, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'usual, usually', 'gewöhnlich', ARRAY[]::text[], NULL, NULL, 'Er kommt gewöhnlich zu spät.
He usually comes too late.', 2142, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plot of land', 'Grundstück', ARRAY[]::text[], 'noun', 'das', 'Familie Buchwald hat ein eigenes Grundstück mit Garten.
The Buchwald family has their own plot of land.', 2143, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to emphasize, come to light', 'herausstellen', ARRAY[]::text[], NULL, NULL, 'Seine Unschuld hat sich erst hinterher herausgestellt.
His innocence has only come to light afterwards.', 2144, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'identity', 'Identität', ARRAY[]::text[], 'noun', 'die', 'Der Mörder besorgte sich eine falsche Identität.
The murderer got hold of a false identity.', 2145, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to invest', 'investieren', ARRAY[]::text[], NULL, NULL, 'Ich habe viel Zeit in dieses Projekt investiert.
I have invested much time into this project.', 2146, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Israeli', 'israelisch', ARRAY[]::text[], NULL, NULL, 'Der israelische Außenminister ist zu Besuch in Ägypten.
The Israeli foreign minister is on a visit in Egypt.', 2147, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'camera', 'Kamera', ARRAY[]::text[], 'noun', 'die', 'Ich habe mir eine neue Kamera gekauft.
I bought a new camera.', 2148, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'canal, channel', 'Kanal', ARRAY[]::text[], 'noun', 'der', 'Wir haben eine Bootstour auf dem Kanal gemacht.
We have made a boat trip on the canal.', 2149, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'career', 'Karriere', ARRAY[]::text[], 'noun', 'die', 'Anne Will hat Karriere beim Fernsehen gemacht.
Anne Will has made a career in television.', 2150, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'complete', 'komplett', ARRAY[]::text[], NULL, NULL, 'Alle sind da, die Gruppe ist komplett!
All are there, the group is complete!', 2151, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'credit', 'Kredit', ARRAY[]::text[], 'noun', 'der', 'Die Bank hat dem jungen Ehepaar einen Kredit gewährt.
The Bank has granted a loan to the young couple.', 2152, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at the moment, momentarily', 'momentan', ARRAY[]::text[], NULL, NULL, 'Momentan gibt es keine passenden Stellenangebote.
Momentarily, there are no matching jobs.', 2153, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plus', 'Plus', ARRAY[]::text[], 'noun', 'das', 'Das Plus an dem Angebot ist der günstige Preis.
The plus side of the offer is the low price.', 2154, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quarter of the year', 'Quartal', ARRAY[]::text[], 'noun', 'das', 'Im dritten Quartal sind die Verluste besonders gestiegen.
In the third quarter of the year the losses have particularly increased.', 2155, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wheel', 'Rad', ARRAY[]::text[], 'noun', 'das', 'Ein Auto hat vier Räder.
A car has four wheels.', 2156, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'computer, calculator', 'Rechner', ARRAY[]::text[], 'noun', 'der', 'Wer hat Zugang zu diesem Rechner?
Who has access to this computer?', 2157, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to justify', 'rechtfertigen', ARRAY[]::text[], NULL, NULL, 'Du musst dich dafür nicht rechtfertigen.
You don''t have to justify yourself for it.', 2158, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the sleep', 'Schlaf', ARRAY[]::text[], 'noun', 'der', 'Erwachsene brauchen ca. acht Stunden Schlaf pro Tag.
Adults need about eight hours of sleep per day.', 2159, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'broadcasting station', 'Sender', ARRAY[]::text[], 'noun', 'der', 'Wir empfangen nur die öffentlich-rechtlichen Sender.
We only receive the public broadcasting stations.', 2160, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'valley', 'Tal', ARRAY[]::text[], 'noun', 'das', 'Sie wandern durch Berg und Tal.
Tehy wander through hill and valley.', 2161, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'depth', 'Tiefe', ARRAY[]::text[], 'noun', 'die', 'Aus der Tiefe des Ozeans hörten sie ein seltsames Geräusch.
From the depths of the ocean, they heard a strange noise.', 2162, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'TV', 'TV', ARRAY[]::text[], 'noun', 'das', 'Wir haben keinen TV-Anschluss, weil wir sowieso nicht gern Fernsehen gucken.
We do not have a TV connection, because we do not like to watch TV anyway.', 2163, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in the course of the day', 'im Verlauf des Tages', ARRAY[]::text[], NULL, NULL, 'Das Päckchen wird im Verlauf des Tages eintreffen.
The package will arrive in the course of the day.', 2164, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fall in love', 'verlieben', ARRAY[]::text[], NULL, NULL, 'Paul hat sich in Paula verliebt.
Paul has fallen in love with Paula.', 2165, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'forty', 'vierzig', ARRAY[]::text[], NULL, NULL, 'Sie ist vierzig Minuten geschwommen.
She has swum for forty minutes.', 2166, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cigarette', 'Zigarette', ARRAY[]::text[], 'noun', 'die', 'Zigaretten sind teuer und das ist gut so.
Cigarettes are expensive and that''s a good thing.', 2167, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'futureadj</sup', 'zukünftig', ARRAY[]::text[], NULL, NULL, 'Zukünftige Generationen werden sicherlich alles besser machen.
Future generations will surely make everything better.', 2168, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shareholder', 'Aktionär', ARRAY[]::text[], 'noun', 'der', 'Er ist ein einflussreicher Aktionär.
He is an influential shareholder.', 2169, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take up, start', 'antreten', ARRAY[]::text[], NULL, NULL, 'Am ersten September tritt der neue Minister sein Amt an.
On September first, the new minister takes up his position.', 2170, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the breath', 'Atem', ARRAY[]::text[], 'noun', 'der', 'Odol macht frischen Atem.
Odol makes fresh breath.', 2171, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'point of view (opinion) (not: Gesichtspunkt)', 'Auffassung', ARRAY[]::text[], 'noun', 'die', 'Ich bin der Auffassung, dass hier noch viel verbessert werden muss.
My point of view is that here needs to be improved a lot.', 2172, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pay attention, take care', 'aufpassen', ARRAY[]::text[], NULL, NULL, 'Kannst du heute Abend auf meine Kinder aufpassen?
Can you take care of my kids tonight?', 2173, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get on, rise', 'aufsteigen', ARRAY[]::text[], NULL, NULL, 'Warme Luft steigt auf.
Warm air rises.', 2174, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to free', 'befreien', ARRAY[]::text[], NULL, NULL, 'Die Geiseln wurden befreit.
The hostages were freed.', 2175, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to discuss', 'besprechen', ARRAY[]::text[], NULL, NULL, 'Wir besprechen das in meinem Büro.
We discuss this in my office.', 2176, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'inhabitant, occupant', 'Bewohner', ARRAY[]::text[], 'noun', 'der', 'Die Bewohner dieses Hauses mussten alle umziehen.
All the inhabitants of this house had to move.', 2177, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'brown', 'braun', ARRAY[]::text[], NULL, NULL, 'Anita hat braune Haare.
Anita has brown hair.', 2178, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'character', 'Charakter', ARRAY[]::text[], 'noun', 'der', 'Heike hat einen schwierigen Charakter.
Heike has a difficult character.', 2179, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'uniform, standardized', 'einheitlich', ARRAY[]::text[], NULL, NULL, 'Wir brauchen einheitliche Regeln, die für alle gelten.
We need uniform rules that apply to everyone.', 2180, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'income (not: Gehalt)', 'Einkommen', ARRAY[]::text[], 'noun', 'das', 'Viele Menschen hier haben nur ein geringes Einkommen.
Many people here have a low income.', 2181, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to move in', 'einziehen', ARRAY[]::text[], NULL, NULL, 'Nächste Woche können wir einziehen.
Next week we can move in.', 2182, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'upbringing, education', 'Erziehung', ARRAY[]::text[], 'noun', 'die', 'In seiner Jugend genoss er eine strenge Erziehung.
In his youth he enjoyed a strict upbringing.', 2183, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to finance', 'finanzieren', ARRAY[]::text[], NULL, NULL, 'Wie finanzierst du dein Studium?
How do you finance your studies?', 2184, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'birth', 'Geburt', ARRAY[]::text[], 'noun', 'die', 'Die Geburt ihres ersten Kindes verlief besser, als sie gedacht hatte.
The birth of her first child went better than she had thought.', 2185, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'absolutely, really', 'geradezu', ARRAY[]::text[], NULL, NULL, 'Die Lage ist geradezu prekär.
The situation is absolutely precarious.', 2186, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'purposeful, pointed, well-aimed', 'gezielt', ARRAY[]::text[], NULL, NULL, 'Er wurde mit einem gezielten Schuss getötet.
He was killed with an well-aimed shot.', 2187, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hall', 'Halle', ARRAY[]::text[], 'noun', 'die', 'In welcher Halle findet die Messe statt?
The trade fair is at which hall?', 2188, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'challenge', 'Herausforderung', ARRAY[]::text[], 'noun', 'die', 'Ich stelle mich gerne neuen Herausforderungen.
I like to be open to new challenges.', 2189, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in, into', 'hinein', ARRAY[]::text[], NULL, NULL, 'Die Ausstellung wurde bis in den Herbst hinein organisiert.
The exhibition was organized even in autumn.', 2190, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hopefully', 'hoffentlich', ARRAY[]::text[], NULL, NULL, 'Hoffentlich wirst du bald wieder gesund.
Hopefully you will soon recover.', 2191, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'noon, midday', 'Mittag', ARRAY[]::text[], 'noun', 'der', 'Ich kann erst Mittags kommen.
I can only come at noon.', 2194, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'defeat', 'Niederlage', ARRAY[]::text[], 'noun', 'die', 'Hannibal erlitt eine eindeutige Niederlage.
Hannibal suffered a clear defeat.', 2195, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'norm', 'Norm', ARRAY[]::text[], 'noun', 'die', 'Abweichungen von der Norm gibt es immer wieder.
Deviations from the norm happen sometimes.', 2196, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'real', 'real', ARRAY[]::text[], NULL, NULL, 'Eigentlich haben wir keine reale Chance mehr.
Actually, we have no real chance.', 2197, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reform', 'Reform', ARRAY[]::text[], 'noun', 'die', 'Es wird eine Reform angestrebt.
The aim is to reform.', 2198, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'restaurant', 'Restaurant', ARRAY[]::text[], 'noun', 'das', 'Sie geht gern in chinesische Restaurants.
She likes to go to Chinese restaurants.', 2199, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to smell', 'riechen', ARRAY[]::text[], NULL, NULL, 'Das Parfum riecht gut!
The perfume smells well!', 2200, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'actor', 'Schauspieler', ARRAY[]::text[], 'noun', 'der', 'Heinz Rühmann war ein deutscher Schauspieler.
Heinz Ruehmann was a German actor.', 2202, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'snow', 'Schnee', ARRAY[]::text[], 'noun', 'der', 'Zu Weihnachten lag leider kein Schnee.
At Christmas, unfortunately, there was no snow.', 2203, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'schoolgirl, student', 'Schülerin', ARRAY[]::text[], 'noun', 'die', 'Sie ist Schülerin der 10. Klasse.
She is a student of the 10th class.', 2204, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'service', 'Service', ARRAY[]::text[], 'noun', 'der', 'Der Service im Hotel war sehr gut.
The hotel service was very good.', 2205, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meeting, session', 'Sitzung', ARRAY[]::text[], 'noun', 'die', 'Falk nimmt an der Sitzung teil.
Falk is attending the meeting.', 2207, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'statistical', 'statistisch', ARRAY[]::text[], NULL, NULL, 'Es handelt sich hier lediglich um eine statistische Erhebung.
This is merely a statistical survey.', 2208, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'storm', 'Sturm', ARRAY[]::text[], 'noun', 'der', 'Der Sturm war sehr stark.
The storm was very strong.', 2209, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to test', 'testen', ARRAY[]::text[], NULL, NULL, 'Wir testen das Auto auf seine Sicherheit.
We test the car on its security.', 2210, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the tear', 'Träne', ARRAY[]::text[], 'noun', 'die', 'Kurt hatte Tränen in den Augen.
Kurt had tears in his eyes.', 2212, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'grief', 'Trauer', ARRAY[]::text[], 'noun', 'die', 'Ullas Trauer war sehr groß.
Ulla''s grief was enorm.', 2213, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to leave', 'überlassen', ARRAY[]::text[], NULL, NULL, 'Ich überlasse dir die Entscheidung.
I leave the decision to you.', 2214, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be defeated, be subject', 'unterliegen', ARRAY[]::text[], NULL, NULL, 'Ärzte unterliegen der Schweigepflicht.
Doctors are subject to professional secrecy.', 2215, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to move, postpone', 'verschieben', ARRAY[]::text[], NULL, NULL, 'Wir müssen unser Treffen verschieben.
We need to postpone our meeting.', 2216, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to use as an excuse, to set in advance, pretend', 'vorgeben', ARRAY[]::text[], NULL, NULL, 'Er gibt vor, kein Geld zu haben.
He pretends to have no money.', 2217, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to have in mind, be planning, intend', 'vorhaben', ARRAY[]::text[], NULL, NULL, 'Dorothee hat vor, nach Ungarn zu gehen.
Dorothy intends to go to Hungary.', 2218, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'board, chairperson', 'Vorstand', ARRAY[]::text[], 'noun', 'der', 'Der Vorstand hat eine Entscheidung getroffen.
The board has made a decision.', 2219, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hesitate', 'zögern', ARRAY[]::text[], NULL, NULL, 'Er zögerte eine Weile, doch dann verließ er endgültig den Raum.
He hesitated for a while, but then he finally left the room.', 2220, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chance, coincidence', 'Zufall', ARRAY[]::text[], 'noun', 'der', 'Was für ein Zufall, dass wir uns hier treffen!
What a coincidence that we meet here!', 2221, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'accidental, by chance', 'zufällig', ARRAY[]::text[], NULL, NULL, 'Eine zufällige Begegnung veränderte ihr Leben.
An accidental encounter changed her life.', 2222, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(form) the basis, (go) to ruins', 'zugrunde', ARRAY[]::text[], NULL, NULL, 'Wenn wir nicht aufpassen, geht alles zugrunde.
If we are not careful, everything will go to ruins.', 2223, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'approval', 'Zustimmung', ARRAY[]::text[], 'noun', 'die', 'Sie haben meine volle Zustimmung.
You have my full approval.', 2224, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to derive, deduce', 'ableiten', ARRAY[]::text[], NULL, NULL, 'Aus der Statistik kann man viele Informationen ableiten.
From he statistics much information can be derived.', 2225, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'member, relative', 'Angehörige', ARRAY[]::text[], 'noun', NULL, 'Die Angehörigen des Patienten müssen verständigt werden.
The relatives of the patient must be informed.', 2226, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'acceptance, assumption', 'Annahme', ARRAY[]::text[], 'noun', 'die', 'Unsere Annahmen erwiesen sich als falsch.
Our assumptions proved to be false.', 2227, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'argument', 'Argument', ARRAY[]::text[], 'noun', 'das', 'Das ist kein überzeugendes Argument.
This is not a convincing argument.', 2228, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'medicine (not: Medikamente)', 'Arzneimittel', ARRAY[]::text[], 'noun', 'das', 'Dieses Arzneimittel ist sehr teuer.
This medicine is very expensive.', 2229, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stop, hold up, delay', 'aufhalten', ARRAY[]::text[], NULL, NULL, 'Kannst du mir bitte die Tür aufhalten?
Can you please hold the door open?', 2230, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'minister of foreign affairs', 'Außenminister', ARRAY[]::text[], 'noun', 'der', 'Der deutsche Außenminister ist auf dem Weg nach Kasachstan.
The German foreign minister is on his way to Kazakhstan.', 2231, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to furnish, provide (not: einrichten)', 'ausstatten', ARRAY[]::text[], NULL, NULL, 'Das Büro ist mit modernster Technik ausgestattet.
The office is provided with modern technology.', 2232, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'user', 'Benutzer', ARRAY[]::text[], 'noun', 'der', 'Die Benutzer dieser Software werden gebeten, sich zu registrieren.
Users of this software are asked to register.', 2233, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to touch', 'berühren', ARRAY[]::text[], NULL, NULL, 'Ich habe sie mit der Hand an der Wange berührt.
I touched her cheek with my hand.', 2234, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'information, reply, the ok', 'Bescheid', ARRAY[]::text[], 'noun', 'der', 'Ich habe den Bescheid noch nicht bekommen.
I still have not received the reply.', 2235, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'regarding', 'bezüglich', ARRAY[]::text[], NULL, NULL, 'Wir wenden uns an Sie bezüglich ihrer Bewerbung.
We turn to you regarding your application.', 2236, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'flower', 'Blume', ARRAY[]::text[], 'noun', 'die', 'Die Dolmetscherin bekam einen Strauß Blumen.
The interpreter was given a bouquet of flowers.', 2237, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Armed Forces', 'Bundeswehr', ARRAY[]::text[], 'noun', 'die', 'Dirk ist Soldat in der Bundeswehr.
Dirk is a soldier in the Armed Forces.', 2238, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'therefore (not: deshalb)', 'demnach', ARRAY[]::text[], NULL, NULL, 'Es gibt demnach keine andere Möglichkeit.
Therefore, there is no other option.', 2239, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'discipline', 'Disziplin', ARRAY[]::text[], 'noun', 'die', 'Disziplin ist im Sport sehr wichtig.
Discipline is very important in sports.', 2240, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dramatic', 'dramatisch', ARRAY[]::text[], NULL, NULL, 'Die Romanhandlung nahm eine dramatische Wendung.
The novel''s action took a dramatic turn.', 2241, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put away, admit, concede', 'einräumen', ARRAY[]::text[], NULL, NULL, 'Der Pressesprecher räumte Fehler der Regierung ein.
The spokesman admitted some mistakes made by the government.', 2242, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to receive, to welcome', 'empfangen', ARRAY[]::text[], NULL, NULL, 'Wir empfangen heute Abend Gäste.
We welcome guests tonight.', 2243, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dismiss, fire', 'entlassen', ARRAY[]::text[], NULL, NULL, 'Sie ist entlassen worden und nun arbeitslos.
She has been fired and is now unemployed.', 2244, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grab, seize', 'ergreifen', ARRAY[]::text[], NULL, NULL, 'Ich möchte die Gelegenheit ergreifen und mich ganz herzlich bei Ihnen bedanken.
I would like to grab this opportunity to express my sincere thanks to you.', 2245, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recognizable', 'erkennbar', ARRAY[]::text[], NULL, NULL, 'Seine strikte Diät führt zu ersten erkennbaren Erfolgen.
His strict diet leads to first recognizable successes.', 2246, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to give [an order]', 'erteilen', ARRAY[]::text[], NULL, NULL, 'Der Offizier erteilt einen Befehl.
The officer gave a command.', 2247, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'existence', 'Existenz', ARRAY[]::text[], 'noun', 'die', 'Die Existenz vieler Tierarten ist gefährdet.
The existence of many species is endangered.', 2248, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'far, distant', 'fern', ARRAY[]::text[], NULL, NULL, 'Mit neuen Teleskopen kann man ferne Galaxien entdecken.
With new telescopes one can detect distant galaxies.', 2249, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'parliamentary party (not: Partei)', 'Fraktion', ARRAY[]::text[], 'noun', 'die', 'Es gibt verschiedene Meinungen innerhalb der Fraktion.
There are different opinions within the parliamentary party.', 2250, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'basic law', 'Grundgesetz', ARRAY[]::text[], 'noun', 'das', 'Die Verfassung der Bundesrepublik heißt Grundgesetz.
The Constitution of the Federal Republic is called the Basic Law.', 2251, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trader, dealer, retailer', 'Händler', ARRAY[]::text[], 'noun', 'der', 'Diese Lagerhalle ist an verschiedene Händler vermietet.
This warehouse is rented to various traders.', 2252, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'while doing this, on this occasion', 'hierbei', ARRAY[]::text[], NULL, NULL, 'Hierbei tat sich eine neue Frage auf.
On this occasion a new question rose.', 2253, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'with it, concerning this, about', 'hierzu', ARRAY[]::text[], NULL, NULL, 'Ich habe hierzu nichts zu sagen.
I have nothing to say about this.', 2254, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the view', 'Hinblick', ARRAY[]::text[], 'noun', 'der', 'Die Unzufriedenheit der Bürger ist im Hinblick auf die politische Situation verständlich.
The discontent of citizens (with regard to)(in view of) the political situation is understandable.', 2255, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meanwhile, however', 'indes', ARRAY[]::text[], NULL, NULL, 'Kritiker warnen indes vor möglichen Folgen.
Critics warn, however, about the possible effects.', 2256, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the individual', 'Individuum', ARRAY[]::text[], 'noun', 'das', 'Ein unbekanntes Individuum wurde gesichtet.
An unknown individual was sighted.', 2257, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'inside', 'innen', ARRAY[]::text[], NULL, NULL, 'Das Haus ist innen noch nicht restauriert.
The house isn''t restored yet inside.', 2258, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'legal, juridical', 'juristisch', ARRAY[]::text[], NULL, NULL, 'Ich brauche einen juristischen Rat.
I need a legal advice', 2259, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'catastrophe', 'Katastrophe', ARRAY[]::text[], 'noun', 'die', 'Eine Katastrophe ist geschehen.
A catastrophe has happened.', 2260, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'funny, strange', 'komisch', ARRAY[]::text[], NULL, NULL, 'Wir waren in eine komische Situation geraten.
We were in a strange situation.', 2261, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'funny, enjoyable', 'lustig', ARRAY[]::text[], NULL, NULL, 'Es war ein lustiger Abend.
It was a funny evening.', 2262, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'motive', 'Motiv', ARRAY[]::text[], 'noun', 'das', 'Was für ein Motiv hatte der Täter?
What was the perpetrator''s motive?', 2263, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'musical', 'musikalisch', ARRAY[]::text[], NULL, NULL, 'Amadeus ist sehr musikalisch.
Amadeus is very musical.', 2264, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'musician', 'Musiker', ARRAY[]::text[], 'noun', 'der', 'Herbert Grönemeyer ist ein bekannter deutscher Musiker.
Herbert Grönemeyer is a knwon German musician.', 2265, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'objective , objectively', 'objektiv', ARRAY[]::text[], NULL, NULL, 'Objektiv gesehen hat sie sicherlich Recht.
Objectively she certainly is right.', 2266, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opposition', 'Opposition', ARRAY[]::text[], 'noun', 'die', 'Regierung und Opposition sind sich selten einig.
Government and opposition are rarely of the same opinion.', 2267, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'staff (not: Arbeiter)', 'Personal', ARRAY[]::text[], 'noun', 'das', 'Ab nächsten Monat können wir neues Personal einstellen.
From next month on we can hire new staff.', 2269, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rule, govern (not: herrschen)', 'regieren', ARRAY[]::text[], NULL, NULL, 'Wer regiert in Deutschland?
Who rules in Germany?', 2270, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sand', 'Sand', ARRAY[]::text[], 'noun', 'der', 'Wir liegen im Sand und sonnen uns.
We lie on the sand and sunbath.', 2271, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strange, peculiar', 'seltsam', ARRAY[]::text[], NULL, NULL, 'Vor einiger Zeit hatte ich eine seltsame Begegnung.
Some time ago I had a strange encounter.', 2272, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'careful, thought-through (not: vorsichtig)', 'sorgfältig', ARRAY[]::text[], NULL, NULL, 'Eine sorgfältige Auswahl der Zutaten ist wichtig.
A careful selection of ingredients is important.', 2273, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to strengthen', 'stärken', ARRAY[]::text[], NULL, NULL, 'Du musst dein Immunsystem stärken.
You have to strengthen your immune system.', 2274, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'station', 'Station', ARRAY[]::text[], 'noun', 'die', 'An der nächsten Station müssen wir aussteigen.
At the next station, we need to get off.', 2275, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instead', 'stattdessen', ARRAY[]::text[], NULL, NULL, 'Du wolltest mir helfen. Stattdessen treibst du dich draußen herum.
You wanted to help me. Instead you hang around somewhere.', 2276, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trend (as in direction), bias', 'Tendenz', ARRAY[]::text[], 'noun', 'die', 'Es ist eine positive Tendenz zu verzeichnen.
There can be charted a positive trend.', 2277, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'training', 'Training', ARRAY[]::text[], 'noun', 'das', 'Wann findet das Training statt?
When will the training take place?', 2278, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to trust, dare to', 'sich+', ARRAY[]::text[], NULL, NULL, 'Der kleine Max traut sich nicht, ins Wasser zu springen.
Little Max does not dare to jump into the water.', 2279, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'transfer, implementation', 'Umsetzung', ARRAY[]::text[], 'noun', 'die', 'Wie soll die praktische Umsetzung aussehen?
What should the practical implementation be like?', 2280, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'incredible', 'unglaublich', ARRAY[]::text[], NULL, NULL, 'Die deutsche Nationalmannschaft feierte einen unglaublichen Erfolg.
The German national team celebrated an incredible success.', 2281, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'salesman', 'Verkäufer', ARRAY[]::text[], 'noun', 'der', 'Er ist von Beruf Verkäufer.
He is a professional salesman.', 2282, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sensible', 'vernünftig', ARRAY[]::text[], NULL, NULL, 'Sie haben ein sehr vernünftiges Kind.
You have a very sensible child.', 2283, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the supply / supplies, the care', 'Versorgung', ARRAY[]::text[], 'noun', 'die', 'Wir müssen sicherstellen, dass wir genügend Versorgung haben.
We must make sure we have enough supplies.', 2284, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mainly', 'vorwiegend', ARRAY[]::text[], NULL, NULL, 'Wir haben es vorwiegend mit skandinavischen Studenten zu tun.
We are mainly dealing with Scandinavian students.', 2286, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the change', 'Wandel', ARRAY[]::text[], 'noun', 'der', 'Die Stadt macht einen Wandel durch.
The city is undergoing a change.', 2287, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to defend oneself', 'wehren', ARRAY[]::text[], NULL, NULL, 'Wehr dich, wenn du ungerecht behandelt wirst!
Defend yourself if you are treated unfairly!', 2288, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to point', 'weisen', ARRAY[]::text[], NULL, NULL, 'Das Schild weist in eine andere Richtung.
The sign points in another direction.', 2289, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dedicate', 'widmen', ARRAY[]::text[], NULL, NULL, 'Dieses Buch ist ihrem Ehemann gewidmet.
This book is dedicated to her husband.', 2290, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'miracle', 'Wunder', ARRAY[]::text[], 'noun', 'das', 'Ein Wunder ist geschehen.
A miracle has happened.', 2291, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'according to', 'zufolge + dat.', ARRAY[]::text[], NULL, NULL, 'Den Umfragen zufolge sind 45% der Deutschen dagegen.
According to the polls 45% of Germans are against it.', 2292, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to approach, close', 'zugehen', ARRAY[]::text[], NULL, NULL, 'Der Deckel geht nicht mehr zu.
The top no longer closes.', 2293, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to attribute, trace back', 'zurückführen', ARRAY[]::text[], NULL, NULL, 'Seine Depression kann man auf seine unglückliche Kindheit zurückführen.
His depression can be traced back to his unhappy childhood.', 2294, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to suspect', 'ahnen', ARRAY[]::text[], NULL, NULL, 'Ich habe geahnt, dass etwas passiert ist.
I suspected that something has happened.', 2295, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to analyse', 'analysieren', ARRAY[]::text[], NULL, NULL, 'Die Ergebnisse müssen noch analysiert werden.
The results must be analyzed.', 2296, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'matter, affair', 'Angelegenheit', ARRAY[]::text[], 'noun', 'die', 'Wir haben es mit einer komplizierten Angelegenheit zu tun.
We are dealing with a complicated affair.', 2297, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rise, open', 'aufgehen', ARRAY[]::text[], NULL, NULL, 'Die Tür geht nicht auf.
The door won''t open.', 2298, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'information (not: Information)', 'Auskunft', ARRAY[]::text[], 'noun', 'die', 'Können Sie mir bitte eine Auskunft geben?
Can you please give me some information?', 2299, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extent, size', 'Ausmaß', ARRAY[]::text[], 'noun', 'das', 'Das Ausmaß der Katastrophe ist unvorstellbar.
The extent of the disaster is unimaginable.', 2300, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to choose', 'sich + aussuchen', ARRAY[]::text[], NULL, NULL, 'Die Farbe kann man sich aussuchen.
The color can be chosen.', 2301, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to move out, to take off (clothes) (not: to undress, get undressed)', 'ausziehen', ARRAY['ausziehen']::text[], NULL, NULL, 'Nasse Strümpfe sollte man ausziehen, damit man sich nicht erkältet. Der Mann kam her und begann, mich auszuziehen.
Wet socks should be taken off, so that one won''t catch a cold. The man came and started undressing me.', 2302, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'explanation, reason (not: Ausrede)', 'Begründung', ARRAY[]::text[], 'noun', 'die', 'Edgar hatte eine zweifelhafte Begründung für sein Fehlen.
Edgar had a dubious justification for his absence.', 2303, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'so', 'derart', ARRAY[]::text[], NULL, NULL, 'Die Situation war derart komisch, dass wir einfach lachen mussten.
The situation was so funny that we had to laugh.', 2304, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'average (adj.)', 'durchschnittlich', ARRAY[]::text[], NULL, NULL, 'Silke hat in der Prüfung durchschnittliche Leistungen erzielt.
Silke has achieved an average performance in the examination.', 2305, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'commitment', 'Engagement', ARRAY[]::text[], 'noun', 'das', 'Soziales Engagement ist gefragt.
Social commitment is required.', 2306, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distance', 'Entfernung', ARRAY[]::text[], 'noun', 'die', 'Das Flugzeug befindet sich noch in einiger Entfernung vom Landeflughafen.
The plane is still at some distance from the target airport.', 2307, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to work for, out', 'erarbeiten', ARRAY[]::text[], NULL, NULL, 'Diese Gruppe erarbeitet einen Finanzierungsplan.
This group works out a financing plan.', 2308, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stain', 'Fleck', ARRAY[]::text[], 'noun', 'der', 'Ich habe einen Fleck auf der Bluse.
I have a stain on the blouse.', 2309, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'captive, (be a) prisoner, trapped', 'gefangen', ARRAY[]::text[], NULL, NULL, 'Er ist in seinen Ansichten gefangen.
He is trapped in his views.', 2310, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Greek', 'griechisch', ARRAY[]::text[], NULL, NULL, 'Moussaka ist eine griechische Spezialität.
Moussaka is a Greek specialty.', 2311, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'action, plot', 'Handlung', ARRAY[]::text[], 'noun', 'die', 'Ich kann mich nicht mehr an die Handlung des Films erinnern.
I can not remember the plot of the film.', 2312, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'immune system', 'Immunsystem', ARRAY[]::text[], 'noun', 'das', 'Dieses Medikament unterstützt die Regenerierung des Immunsystems.
This drug supports the regeneration of the immune system.', 2313, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'suitcase', 'Koffer', ARRAY[]::text[], 'noun', 'der', 'Mein Koffer ist verloren gegangen.
My suitcase has been lost.', 2314, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be worth it', 'lohnen', ARRAY[]::text[], NULL, NULL, 'Es lohnt sich, diesen Film zu sehen.
It is worth it to see this film.', 2315, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'need, trouble', 'Not', ARRAY[]::text[], 'noun', 'die', 'Das Schiff ist in Not geraten.
The ship got in need.', 2317, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'personality, celebrity', 'Persönlichkeit', ARRAY[]::text[], 'noun', 'die', 'Diana ist eine berühmte Persönlichkeit.
Diana is a famous personality.', 2318, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'radical', 'radikal', ARRAY[]::text[], NULL, NULL, 'Eine radikale Veränderung steht uns bevor.
A radical change is upon us.', 2319, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to switch, shift', 'schalten', ARRAY[]::text[], NULL, NULL, 'Auf der Autobahn schalte ich in den fünften Gang.
On the highway I switch to the fifth gear.', 2320, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'key', 'Schlüssel', ARRAY[]::text[], 'noun', 'der', 'Ich finde meinen Schlüssel nicht.
I can not find my keys.', 2321, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'desk', 'Schreibtisch', ARRAY[]::text[], 'noun', 'der', 'Elke arbeitet am Schreibtisch.
Elke is working at a desk.', 2322, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'soul, mind', 'Seele', ARRAY[]::text[], 'noun', 'die', 'Leib und Seele müssen gesund sein.
Body and soul need to be healthy.', 2323, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stable, sturdy', 'stabil', ARRAY[]::text[], NULL, NULL, 'Die Konstruktion ist stabil.
The construction is stable.', 2324, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'systematic', 'systematisch', ARRAY[]::text[], NULL, NULL, 'Du musst systematisch alle Punkte abarbeiten.
You have to systematically work through all the points.', 2325, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employer (not: Arbeitgeber)', 'Unternehmer', ARRAY[]::text[], 'noun', 'der', 'Siegbert ist ein erfolgreicher Unternehmer.
Siegbert is a successful employer.', 2326, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'undertaking, venture, activity', 'Unternehmung', ARRAY[]::text[], 'noun', 'die', 'Das Hotel bietet verschiedene Unternehmungen an.
The hotel offers various activities.', 2327, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to use, process, assimilate', 'verarbeiten', ARRAY[]::text[], NULL, NULL, 'Das Material wurde schon verarbeitet.
The material has been processed.', 2328, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agreement', 'Vereinbarung', ARRAY[]::text[], 'noun', 'die', 'Wir haben eine Vereinbarung getroffen.
We have reached an agreement.', 2329, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'crazy', 'verrückt', ARRAY[]::text[], NULL, NULL, 'Das war eine verrückte Aktion.
That was a crazy action.', 2330, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to perform, provide', 'versehen', ARRAY[]::text[], NULL, NULL, 'Wir müssen jede Datei mit einer Kodierung versehen.
We must provide each file with a code.', 2331, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'familiar, close', 'vertraut', ARRAY[]::text[], NULL, NULL, 'Sie sind einander sehr vertraut.
They are very familiar with each other.', 2332, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'video', 'Video', ARRAY[]::text[], 'noun', 'das', 'Wollen wir ein Video ausleihen?
Should we lend a video?', 2333, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'perception', 'Wahrnehmung', ARRAY[]::text[], 'noun', 'die', 'Bei Alkoholkonsum wird die Wahrnehmung verzerrt.
With the consumption of alcohol, the perception gets distorted.', 2334, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tiny', 'winzig', ARRAY[]::text[], NULL, NULL, 'Sie leben in einem winzigen Dorf.
They live in a tiny village.', 2335, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'what for, to what', 'wozu', ARRAY[]::text[], NULL, NULL, 'Wozu tust du das?
What are you doing this for?', 2336, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be surprised (not überraschen)', 'wundern', ARRAY[]::text[], NULL, NULL, 'Ich wundere mich über dein Desinteresse.
I am surprised by your lack of interest.', 2337, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reduce, dismantle, deconstruct', 'abbauen', ARRAY[]::text[], NULL, NULL, 'Der Stoff wird schnell im Körper abgebaut.
The substance is rapidly reduced in the body.', 2338, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to await, wait out', 'abwarten', ARRAY[]::text[], NULL, NULL, 'Wir sollten die Wahlergebnisse abwarten.
We should await the election results.', 2339, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employee (not: Arbeitnehmer)', 'Angestellte', ARRAY[]::text[], 'noun', NULL, 'Die Angestellten machen einen Betriebsausflug.
The employees make a staff outing.', 2340, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'into, onto one another', 'aufeinander', ARRAY[]::text[], NULL, NULL, 'Leg die Bücher einfach aufeinander.
Simply put the books one onto another.', 2341, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to drop out, be cancelled', 'ausfallen', ARRAY[]::text[], NULL, NULL, 'Die Vorlesung fällt aus.
The lecture is canceled.', 2342, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comment', 'Äußerung', ARRAY[]::text[], 'noun', 'die', 'Bitte vermeide unsachliche Äußerungen!
Please avoid irrelevant comments!', 2343, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'encounter, meeting', 'Begegnung', ARRAY[]::text[], 'noun', 'die', 'Die Begegnung war für beide vollkommen unerwartet.
The meeting was totally unexpected for both.', 2344, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coffee house, cafe', 'Café', ARRAY[]::text[], 'noun', 'das', 'In welchem Café wollen wir uns treffen?
In which cafe will we meet?', 2345, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'data file', 'Datei', ARRAY[]::text[], 'noun', 'die', 'Können Sie mir die Datei schicken?
Can you send me the data file?', 2346, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'service (not: Service)', 'Dienstleistung', ARRAY[]::text[], 'noun', 'die', 'Die kostenlose Lieferung nach Hause ist eine Dienstleistung des Unternehmens.
The free home delivery is a service of the company.', 2347, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '[to] there', 'dorthin', ARRAY[]::text[], NULL, NULL, 'Wann fährst du denn dorthin?
When are you going there?', 2348, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'before', 'ehe', ARRAY[]::text[], NULL, NULL, 'Ehe ich ihn aufhalten konnte, war er verschwunden.
Before I could stop him, he was gone.', 2349, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to install, build in, fit', 'einbauen', ARRAY[]::text[], NULL, NULL, 'Wir bauen eine neue Küche ein.
We are installing a new kitchen.', 2350, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to include', 'einbeziehen', ARRAY[]::text[], NULL, NULL, 'Wir müssen alle Faktoren mit einbeziehen.
We must include all factors.', 2351, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'serious, seriously', 'ernsthaft', ARRAY[]::text[], NULL, NULL, 'Ich mache mir ernsthafte Sorgen.
I''m seriously worried.', 2352, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'astonishing (not: surprising)', 'erstaunlich', ARRAY[]::text[], NULL, NULL, 'Das Ergebnis ist erstaunlich.
The result is astonishing.', 2353, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'narration, story', 'Erzählung', ARRAY[]::text[], 'noun', 'die', 'Hermann Hesse hat viele Erzählungen geschrieben.
Hermann Hesse has written many short stories.', 2354, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distance (not: Distanz, Entfernung)', 'Ferne', ARRAY[]::text[], 'noun', 'die', 'Warum in die Ferne schweifen, wenn das Gute liegt so nah.
Why seek far afield when good things are so close.', 2355, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'poem', 'Gedicht', ARRAY[]::text[], 'noun', 'das', 'Anna liest gern Gedichte.
Anna likes to read poems.', 2356, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'smooth, slippery', 'glatt', ARRAY[]::text[], NULL, NULL, 'Die Straßen sind glatt.
The roads are slippery.', 2357, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gold, golden', 'golden', ARRAY[]::text[], NULL, NULL, 'Charlotte hat einen goldenen Ring am Finger.
Charlotte has a gold ring on her finger.', 2358, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foundation', 'Gründung', ARRAY[]::text[], 'noun', 'die', 'Die Gründung eines Vereins erfordert mindestens sieben Mitglieder.
The foundation of a club requires a minimum of seven members.', 2359, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pretty', 'hübsch', ARRAY[]::text[], NULL, NULL, 'Das ist eine hübsche Katze.
That''s a pretty cat.', 2360, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to interpret', 'interpretieren', ARRAY[]::text[], NULL, NULL, 'Im Deutschunterricht sollen die Schüler ein Gedicht interpretieren.
In German class, the students have to interpret a poem.', 2361, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cellar', 'Keller', ARRAY[]::text[], 'noun', 'der', 'Der Wirt holt eine Flasche Wein aus dem Keller.
The host gets a bottle of wine from the cellar.', 2363, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'account', 'Konto', ARRAY[]::text[], 'noun', 'das', 'Auf welches Konto soll ich das Geld überweisen?
To which account should I transfer the money?', 2364, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bend, to lean - inclinarse', 'neigen', ARRAY[]::text[], NULL, NULL, 'Petra neigte sich nach vorne, um Peter zu küssen.
Petra leaned forward to kiss Peter.', 2365, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'operation', 'Operation', ARRAY[]::text[], 'noun', 'die', 'Die Operation dauerte vier Stunden.
The operation lasted four hours.', 2366, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arrange, sort', 'ordnen', ARRAY[]::text[], NULL, NULL, 'Nach dem Krieg werden die politischen Verhältnisse neu geordnet.
After the war, the political situation will be rearranged.', 2367, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'qualification', 'Qualifikation', ARRAY[]::text[], 'noun', 'die', 'Sie hat eine gute Qualifikation für den Job.
She has a good qualification for the job.', 2368, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to advise, guess', 'raten', ARRAY[]::text[], NULL, NULL, 'Ich rate dir, noch einmal darüber nachzudenken.
I advise you to think twice about it.', 2369, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'collection', 'Sammlung', ARRAY[]::text[], 'noun', 'die', 'Im Museum kann man eine Sammlung alter Münzen anschauen.
In the museum you can view a collection of old coins.', 2370, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'soft, gentle', 'sanft', ARRAY[]::text[], NULL, NULL, 'Heiner hat eine sanfte Stimme.
Heiner has a gentle voice.', 2371, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'apparent (not: vermutlich)', 'scheinbar', ARRAY[]::text[], NULL, NULL, 'Du hast scheinbar überhaupt keine Ahnung.
You have apparently no idea.', 2372, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to taste', 'schmecken', ARRAY[]::text[], NULL, NULL, 'Die Kartoffelsuppe schmeckt gut.
The potato soup tastes well.', 2373, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'municipal', 'städtisch', ARRAY[]::text[], NULL, NULL, 'Viele städtische Einrichtungen müssen geschlossen werden.
Many municipal facilities must be closed.', 2374, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ton, barrel', 'Tonne', ARRAY[]::text[], 'noun', 'die', 'Das Auto wiegt etwa eine Tonne.
The car weighs about a ton.', 2375, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'holder, responsible body', 'Träger', ARRAY[]::text[], 'noun', 'der', 'Träger von Rechten und Pflichten ist jeder, der volljährig ist.
Bearer of rights and obligations, is any person who is of age.', 2376, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trend (as in fashion)', 'Trend', ARRAY[]::text[], 'noun', 'der', 'Ein neuer Trend in der Mode kommt auf.
A new trend in fashion comes up.', 2377, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the more... the better', 'je ... umso', ARRAY[]::text[], NULL, NULL, 'Je mehr Leute kommen, umso lustiger wird es.
The more people will come, the more fun it will be.', 2378, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'variant, variation', 'Variante', ARRAY[]::text[], 'noun', 'die', 'Welche Variante bevorzugst du?
Which variant do you prefer?', 2379, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to award, allocate, forgive, give away', 'vergeben', ARRAY['adj)']::text[], NULL, NULL, 'Sein Platz in der Firma ist schon vergeben.
His place in the company is already given away.', 2380, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'my relative', 'Verwandte', ARRAY[]::text[], 'noun', NULL, 'Zur Hochzeit sind alle Verwandten eingeladen.
All relatives are invited to the wedding.', 2381, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diversity', 'Vielfalt', ARRAY[]::text[], 'noun', 'die', 'Es ist wichtig, eine Vielfalt an Meinungen zu haben.
It is important to have a diversity of opinions.', 2382, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'multitude, variety', 'Vielzahl', ARRAY[]::text[], 'noun', 'die', 'Dieses Restaurant hat eine Vielzahl von Speisen im Angebot.
This restaurant has a variety of dishes on offer.', 2383, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'effective', 'wirksam', ARRAY[]::text[], NULL, NULL, 'Der Arzt hat mir eine wirksame Salbe verschrieben.
The doctor has prescribed an effective ointment.', 2384, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'payment', 'Zahlung', ARRAY[]::text[], 'noun', 'die', 'Die Zahlung erfolgt bar.
The payment will be in cash.', 2385, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put together', 'zusammensetzen', ARRAY[]::text[], NULL, NULL, 'Das Großhirn setzt sich aus zwei Hemisphären zusammen.
The cerebrum is put together of two hemispheres.', 2386, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'take off, put, file', 'ablegen', ARRAY[]::text[], NULL, NULL, 'Sie können Ihren Mantel dort drüben ablegen.
You can put your coat over there.', 2387, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to vote, coordinate', 'abstimmen', ARRAY[]::text[], NULL, NULL, 'Wir müssen unsere Arbeitszeiten besser aufeinander abstimmen.
We need to coordinate better our work times.', 2388, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'academic', 'akademisch', ARRAY[]::text[], NULL, NULL, 'Magister ist ein akademischer Grad.
MA is an academic degree.', 2390, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to encourage, suggest, stimulate', 'anregen', ARRAY[]::text[], NULL, NULL, 'Schwarzer Tee regt die Lebensgeister an.
Black tea stimulates your spirits.', 2391, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'worker (somebody who works)', 'Arbeiter', ARRAY[]::text[], 'noun', 'der', 'Die Arbeiter kommen gut voran.
The workers are making good progress.', 2392, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to annoy', 'ärgern', ARRAY[]::text[], NULL, NULL, 'Über Kritik sollte man sich nicht ärgern.
One should not be annoyed by criticism.', 2393, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to excite, upset, annoy (discourage / unsettle)', 'aufregen', ARRAY[]::text[], NULL, NULL, 'Du brauchst dich nicht so aufzuregen.
You do not have to be so upset.', 2394, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expense, effort', 'Aufwand', ARRAY[]::text[], 'noun', 'der', 'Es ist die Frage, ob sich der Aufwand hier lohnt.
The question is whether the effort here is worth it.', 2395, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expenses', 'Aufwendungen', ARRAY[]::text[], 'noun', 'die', 'Persönliche Aufwendungen für Reise und Unterkunft werden Ihnen erstattet.
Personal expenses for travel and accommodation will be refunded.', 2396, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to extend, improve, expand', 'ausbauen', ARRAY[]::text[], NULL, NULL, 'Wir sollten die Beziehungen zu diesem Verlag ausbauen.
We should expand our relationship with this publisher.', 2397, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to expel', 'ausweisen', ARRAY[]::text[], NULL, NULL, 'Kriminelle Ausländer werden ausgewiesen.
Criminal foreigners are expelled.', 2398, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'belly, stomach', 'Bauch', ARRAY[]::text[], 'noun', 'der', 'Mein Bauch tut weh.
My stomach hurts.', 2399, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cover', 'bedecken', ARRAY[]::text[], NULL, NULL, 'Der größte Teil der Erde ist mit Wasser bedeckt.
Most of the earth is covered with water.', 2400, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'popular', 'beliebt', ARRAY[]::text[], NULL, NULL, 'Eine beliebte Popgruppe gibt in Stuttgart ein Konzert.
A popular rock band gives a concert in Stuttgart.', 2401, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'calculation', 'Berechnung', ARRAY[]::text[], 'noun', 'die', 'Seine Berechnungen sind falsch.
His calculations are wrong.', 2402, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to make, cause', 'bereiten', ARRAY[]::text[], NULL, NULL, 'Mein Freund bereitete mir eine große Freude, als er mich ins Theater einlud.
My friend caused me a great pleasure when he invited me to the theater.', 2403, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'continuation, stock, supply, collection', 'Bestand', ARRAY[]::text[], 'noun', 'der', 'Die Bibliothek hat einen großen Bestand alter Bücher.
The library has a large collection of old books.', 2404, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bend', 'beugen', ARRAY[]::text[], NULL, NULL, 'Ich beuge mich über den Tisch.
I bend over the table.', 2405, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'developing nation', 'Entwicklungsland', ARRAY[]::text[], 'noun', 'das', 'Entwicklungsländer sind auf Hilfe angewiesen.
Developing nations are dependent on aid.', 2406, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sketch, design, draft', 'Entwurf', ARRAY[]::text[], 'noun', 'der', 'Hier ist der erste Entwurf des Gebäudes.
Here is the first draft of the building.', 2407, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take away, remove', 'entziehen', ARRAY[]::text[], NULL, NULL, 'Dieses Getreide entzieht dem Boden viele Nährstoffe.
This grain removes many nutrients from the soil.', 2408, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to raise, produce', 'erbringen', ARRAY[]::text[], NULL, NULL, 'Die Spendenaktion hat 500 Dollar erbracht.
The fundraising campaign has raised $ 500.', 2409, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to invent', 'erfinden', ARRAY[]::text[], NULL, NULL, 'Wann wurde das Fahrrad erfunden?
When was the bicycle invented?', 2410, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quite a few', 'etliche', ARRAY[]::text[], NULL, NULL, 'Der Zug kam etliche Minuten zu spät im Bahnhof an.
The train arrived quite a few minutes late at the station.', 2411, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'experimental', 'experimentell', ARRAY[]::text[], NULL, NULL, 'Sie versucht, ihre Theorie experimentell zu bestätigen.
She tries to confirm her theory experimentally.', 2412, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'technical college (of higher education)', 'Fachhochschule', ARRAY[]::text[], 'noun', 'die', 'Auch an Fachhochschulen soll man zukünftig promovieren können.
Even at technical colleges one should be able to graduate in the future.', 2413, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fascinate', 'faszinieren', ARRAY[]::text[], NULL, NULL, 'Südamerika fasziniert viele junge Leute.
South America fascinates many young people.', 2414, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'television', 'Fernseher', ARRAY[]::text[], 'noun', 'der', 'Schalt endlich den Fernseher ab!
Switch off the TV at last!', 2415, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the financing', 'Finanzierung', ARRAY[]::text[], 'noun', 'die', 'Die Finanzierung des Projektes war nicht ganz einfach.
The financing of the project was not easy.', 2416, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get used to', 'sich gewöhnen', ARRAY[]::text[], NULL, NULL, 'Er gewöhnt sich langsam an seinen neuen Tagesrhythmus.
He is getting used to his new daily routine.', 2417, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to grin', 'grinsen', ARRAY[]::text[], NULL, NULL, 'Als sie ihn ansah, grinste er zurück.
As she looked at him, he grinned back.', 2418, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come here', 'herkommen', ARRAY[]::text[], NULL, NULL, 'Komm her, ich will mit dir reden.
Come here, I want to talk to you.', 2419, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cordial, warm, from the heart', 'herzlich', ARRAY[]::text[], NULL, NULL, 'Herzlich willkommen!
A warm welcome!', 2420, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for this', 'hierfür', ARRAY[]::text[], NULL, NULL, 'Hierfür habe ich keine Verwendung.
I have no use for this.', 2421, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trousers, pants', 'Hose', ARRAY[]::text[], 'noun', 'die', 'Mira hat sich eine schicke Hose gekauft.
Mira has bought fancy pants.', 2422, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stimulus, impulse', 'Impuls', ARRAY[]::text[], 'noun', 'der', 'Ein neuer Impuls motivierte die Mitarbeiter.
A new impulse motivated the employees.', 2423, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'capital', 'Kapital', ARRAY[]::text[], 'noun', 'das', 'Das Unternehmen verfügt nur über geringes Kapital.
The company has only small capital.', 2424, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'seed, core, nucleus, essence', 'Kern', ARRAY[]::text[], 'noun', 'der', 'Hast du den Kern der Aussage verstanden?
Did you understand the essence of the message?', 2425, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to complain', 'klagen', ARRAY[]::text[], NULL, NULL, 'Trotz seiner Schmerzen klagt er nie.
Despite his pain, he never complains.', 2426, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to knock, beat', 'klopfen', ARRAY[]::text[], NULL, NULL, 'Wer klopft da an die Tür?
Who is knocking at the door?', 2427, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lack, be missing', 'mangeln', ARRAY[]::text[], NULL, NULL, 'Es mangelt ihm an vielen Sachen, vor allem aber an Geld.
He lacks many things, but above all money.', 2428, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'motor, engine', 'Motor', ARRAY[]::text[], 'noun', 'der', 'Der Motor ist kaputt.
The engine is broken.', 2429, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'primary', 'primär', ARRAY[]::text[], NULL, NULL, 'Sie sind primär für die Auswahl der Kandidaten zuständig.
You are primarily responsible for the selection of candidates.', 2430, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'standing, status, rank', 'Rang', ARRAY[]::text[], 'noun', 'der', 'Kunst und Kultur haben einen hohen Rang.
Art and culture have a high rank.', 2431, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to smoke', 'rauchen', ARRAY[]::text[], NULL, NULL, 'Hier ist es verboten zu rauchen.
It is forbidden to smoke.', 2432, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'punctual, in [right] time (not: pünktlich)', 'rechtzeitig', ARRAY[]::text[], NULL, NULL, 'Ich bin rechtzeitig angekommen.
I arrived in time.', 2433, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'director (film)', 'Regisseur', ARRAY[]::text[], 'noun', 'der', 'Roman Polanski ist ein bekannter Regisseur.
Roman Polanski is a famous director.', 2434, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'republic', 'Republik', ARRAY[]::text[], 'noun', 'die', 'Die Republik ist eine Staatsform.
The republic is a form of government.', 2435, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to roll', 'rollen', ARRAY[]::text[], NULL, NULL, 'Murmeln rollen über den Fußboden.
Marbles are rolling across the floor.', 2436, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'salt', 'Salz', ARRAY[]::text[], 'noun', 'das', 'An der Suppe fehlt Salz.
The soup lacks salt.', 2437, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'style', 'Stil', ARRAY[]::text[], 'noun', 'der', 'Die Kirche ist im romanischen Stil gebaut.
The church is built in the Romanesque style.', 2439, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foul, bad', 'übel', ARRAY[]::text[], NULL, NULL, 'Ein übler Geruch kam aus der Küche.
A bad smell was coming from the kitchen.', 2440, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unusual, uncommon', 'ungewöhnlich', ARRAY[]::text[], NULL, NULL, 'Das war eine ungewöhnliche Inszenierung von Hamlet.
This was an unusual production of Hamlet.', 2441, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to unite', 'vereinen', ARRAY[]::text[], NULL, NULL, 'Dieser Ansatz vereint Theorie und Praxis.
This approach unites theory and practice.', 2442, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'negotiation, placement', 'Vermittlung', ARRAY[]::text[], 'noun', 'die', 'Das Akademische Auslandsamt ist für die Vermittlung von Erasmusstudenten zuständig.
The International Office is responsible for the placement of Erasmus students.', 2443, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to move, transfer', 'versetzen', ARRAY[]::text[], NULL, NULL, 'Sie werden in eine andere Abteilung versetzt.
You will be transferred to another department.', 2444, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comprehensible', 'verständlich', ARRAY[]::text[], NULL, NULL, 'Das ist kein verständlicher Satz.
This is not a comprehensible sentence.', 2445, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pass by', 'vorübergehen', ARRAY[]::text[], NULL, NULL, 'Auch diese Krise wird vorübergehen.
This crisis will pass by.', 2446, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'election campaign', 'Wahlkampf', ARRAY[]::text[], 'noun', 'der', 'Der Wahlkampf ist in seiner heißen Phase.
The election campaign is in its last stretch.', 2447, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cloud', 'Wolke', ARRAY[]::text[], 'noun', 'die', 'Heute sind viele Wolken am Himmel.
Today, many clouds are in the sky.', 2448, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tooth', 'Zahn', ARRAY[]::text[], 'noun', 'der', 'Der Zahnarzt zieht mir einen Zahn.
The dentist pulls one of my teeth.', 2449, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in existence, (to come, bring) about', 'zustande', ARRAY[]::text[], NULL, NULL, 'Er brachte nur ein müdes Lächeln zustande.
He managed only a weary smile.', 2450, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to agree, consent', 'zustimmen', ARRAY[]::text[], NULL, NULL, 'Ich stimme den AGB zu.
I agree to the terms of service', 2451, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to complete, graduate', 'absolvieren', ARRAY[]::text[], NULL, NULL, 'Ich werde im Sommer ein Praktikum absolvieren.
I will complete an internship in summer.', 2452, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '[physical] effort (not: Aufwand)', 'Anstrengung', ARRAY[]::text[], 'noun', 'die', 'Skispringen erfordert einige Anstrengung.
Ski jumping requires some effort.', 2453, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to breathe', 'atmen', ARRAY[]::text[], NULL, NULL, 'Mein Nachbar in der Oper atmete sehr laut.
My neighbor at the opera was breathing very loud.', 2454, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'obstruction, handicap, disability', 'Behinderung', ARRAY[]::text[], 'noun', 'die', 'Sie hat eine leichte Behinderung.
She has a mild disability.', 2455, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comfortable', 'bequem', ARRAY[]::text[], NULL, NULL, 'Der Stuhl ist nicht sehr bequem.
The chair is not very comfortable.', 2456, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consideration', 'Berücksichtigung', ARRAY[]::text[], 'noun', 'die', 'Eine Berücksichtigung Ihres Antrags ist leider nicht mehr möglich.
A consideration of your application is no longer possible.', 2457, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'board', 'Bord', ARRAY[]::text[], 'noun', 'der', 'Wie viele Personen sind an Bord des Flugzeuges?
How many people are on board the aircraft?', 2458, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'writer, poet', 'Dichter', ARRAY[]::text[], 'noun', 'der', 'Goethe ist ein bekannter deutscher Dichter.
Goethe is a famous German poet.', 2459, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intrusion, interference', 'Eingriff', ARRAY[]::text[], 'noun', 'der', 'Die Verletzung des Postgeheimnisses ist ein Eingriff in die Privatsphäre.
The violation of postal secrecy is an intrusion on privacy.', 2460, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'inhabitant', 'Einwohner', ARRAY[]::text[], 'noun', 'der', 'Wie viele Einwohner hat Berlin?
How many inhabitants does Berlin have?', 2461, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to build, erect', 'errichten', ARRAY[]::text[], NULL, NULL, 'In Berlin wurde eine Mauer errichtet.
In Berlin, there a wall was erected.', 2462, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fan, supporter', 'Fan', ARRAY[]::text[], 'noun', 'der', 'Alex ist Fan von Bayern München.
Alex is a fan of Bayern Munich.', 2463, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mobile phone', 'Handy', ARRAY[]::text[], 'noun', 'das', 'Mein Handy klingelt.
My cell phone rings.', 2466, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to find out', 'herausfinden', ARRAY[]::text[], NULL, NULL, 'Versucht herauszufinden, wie viele Erbsen in ein Glas passen.
Try to find out how many peas fit into a glass.', 2467, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hut, cabin', 'Hütte', ARRAY[]::text[], 'noun', 'die', 'Sie haben eine kleine Hütte im Thüringer Wald.
They have a small cabin in the Thuringian Forest.', 2468, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cooperation (not: Zusammenarbeit)', 'Kooperation', ARRAY[]::text[], 'noun', 'die', 'Die Bereitschaft zur Kooperation ist vorhanden.
The willingness to cooperate exists.', 2469, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to load', 'laden', ARRAY[]::text[], NULL, NULL, 'Kräftige junge Männer laden die Möbel auf einen LKW.
Strong young men load the furniture onto a truck.', 2470, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lean', 'lehnen', ARRAY[]::text[], NULL, NULL, 'Der Mann hatte sich zu weit aus dem Fenster gelehnt.
The man had leaned too far out of the window.', 2471, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'again', 'nochmals', ARRAY[]::text[], NULL, NULL, 'Die Krisenregion darf nicht nochmals sich selbst überlassen werden.
The crisis area must not again be abandoned to itself.', 2472, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ecological, organic', 'ökologisch', ARRAY[]::text[], NULL, NULL, 'Hier wird nur Obst aus ökologischem Anbau verkauft.
Here just fruit from organic production is sold.', 2473, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to qualify', 'qualifizieren', ARRAY[]::text[], NULL, NULL, 'Sie hat sich für den Wettbewerb qualifiziert.
She has qualified for the competition.', 2474, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'simple, plain', 'schlicht', ARRAY[]::text[], NULL, NULL, 'Wir traten in ein schlicht eingerichtetes Zimmer.
We entered into a simply furnished room.', 2475, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'state security service', 'Stasi', ARRAY[]::text[], 'noun', 'die', 'Die Stasi war die Überwachungsinstanz der DDR.
The state security service was the overseer of the GDR.', 2476, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'symbol', 'Symbol', ARRAY[]::text[], 'noun', 'das', 'Was bedeutet dieses Symbol?
What does this symbol mean?', 2477, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'culprit, perpetrator', 'Täter', ARRAY[]::text[], 'noun', 'der', 'Habt ihr den Täter gefasst?
Have you caught the culprit?', 2478, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tour, trip', 'Tour', ARRAY[]::text[], 'noun', 'die', 'Wir haben eine Tour durch Spanien gemacht.
We made a tour through Spain.', 2479, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'separation', 'Trennung', ARRAY[]::text[], 'noun', 'die', 'Er leidet sehr unter der Trennung von seiner Frau.
He suffers a lot from the separation from his wife.', 2480, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'transmission, broadcast', 'Übertragung', ARRAY[]::text[], 'noun', 'die', 'Die Übertragung des Fußballspiels wurde unterbrochen.
The transmission of the football game was interrupted.', 2481, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to overcome', 'überwinden', ARRAY[]::text[], NULL, NULL, 'Du musst deine Höhenangst überwinden.
You have to overcome your fear of heights.', 2482, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'endless, infinite (not: endlos)', 'unendlich', ARRAY[]::text[], NULL, NULL, 'Das Weltall ist unendlich.
The universe is infinite. This book is endless.', 2483, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'constitution', 'Verfassung', ARRAY[]::text[], 'noun', 'die', 'Wann trat die Verfassung der Bundesrepublik in Kraft?
When did the Constitution of the Federal Republic come into force?', 2484, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rent, award', 'verleihen', ARRAY[]::text[], NULL, NULL, 'Elfriede Jelinek wurde der Literaturnobelpreis verliehen.
Elfriede Jelinek was awarded the Nobel Prize for Literature.', 2485, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be capable', 'vermögen', ARRAY[]::text[], NULL, NULL, 'Ich vermag diese Frage nicht zu beantworten.
I am not capable of answering this question.', 2486, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'complete, perfect', 'vollkommen', ARRAY[]::text[], NULL, NULL, 'Das war vollkommen richtig!
That was completely right!', 2487, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from each other', 'voneinander', ARRAY[]::text[], NULL, NULL, 'Hören wir voneinander?
Will we hear from each other?', 2488, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go on ahead, be fast, have priority', 'vorgehen', ARRAY[]::text[], NULL, NULL, 'Meine Uhr geht 10 Minuten vor.
My clock goes on 10 minutes ahead.', 2489, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'a short while ago', 'vorhin', ARRAY[]::text[], NULL, NULL, 'Ich war vorhin einkaufen.
I went shopping a short while ago.', 2490, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'feminine', 'weiblich', ARRAY[]::text[], NULL, NULL, 'Eine weibliche Stimme meldete sich am Telefon.
A feminine voice answered the phone.', 2491, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'magazine, journal', 'Zeitschrift', ARRAY[]::text[], 'noun', 'die', 'Ich habe eine Zeitschrift gekauft.
I bought a magazine.', 2492, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be correct, apply to', 'zutreffen', ARRAY[]::text[], NULL, NULL, 'Die Wettervorhersage traf mal wieder nicht zu.
The weather forecast again was not correct.', 2493, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intention', 'Absicht', ARRAY[]::text[], 'noun', 'die', 'Das war keine böse Absicht.
That was no bad intention.', 2494, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'abstract', 'abstrakt', ARRAY[]::text[], NULL, NULL, 'Das ist abstrakte Kunst.
This is abstract art.', 2495, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'architect', 'Architekt', ARRAY[]::text[], 'noun', 'der', 'Rudolf Skoda war ein bekannter Architekt.
Rudolf Skoda was a famous architect.', 2496, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attractive (not: anziehend)', 'attraktiv', ARRAY[]::text[], NULL, NULL, 'Olaf ist ein attraktiver junger Mann.
Olaf is an attractive young man.', 2497, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to raise, find (not: einbringen)', 'aufbringen', ARRAY[]::text[], NULL, NULL, 'Michael kann die Summe für den Prozess nicht aufbringen.
Michael can not raise the sum for the process.', 2498, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to open', 'aufmachen', ARRAY[]::text[], NULL, NULL, 'Zum Putzen muss ich das Fenster aufmachen.
I need to open the window in order to clean it.', 2499, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attention', 'Aufmerksamkeit', ARRAY[]::text[], 'noun', 'die', 'Kinder brauchen viel Aufmerksamkeit.
Children need lots of attention.', 2500, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the intestines', 'Darm', ARRAY[]::text[], 'noun', 'der', NULL, 2500, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'smooth', 'geschmeidig', ARRAY[]::text[], NULL, NULL, 'Mein Haar ist geschmeidig und seidig glänzend. Geschmeidig! ;)
My hair is smooth and silky. Smooth! ;)', 2500, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'explicit, explicitly', 'ausdrücklich', ARRAY[]::text[], NULL, NULL, 'Ich habe doch ausdrücklich gesagt, dass ich deine CD nicht habe.
I told you explicitly that I do not have your CD.', 2501, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to have an effect', 'auswirken', ARRAY[]::text[], NULL, NULL, 'Sonnenschein wirkt sich positiv auf die Stimmung aus.
Sunshine has a positive effect on the mood.', 2502, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to edit', 'bearbeiten', ARRAY[]::text[], NULL, NULL, 'Der Artikel muss noch einmal bearbeitet werden.
The article must be revised again.', 2503, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to threaten', 'bedrohen', ARRAY[]::text[], NULL, NULL, 'Das Ozonloch bedroht unsere Atmosphäre.
The ozone hole is threatening our atmosphere.', 2504, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'decision, resolution', 'Beschluss', ARRAY[]::text[], 'noun', 'der', 'Die Kommission hat den Beschluss erneut geändert.
The Commission has changed the decision again.', 2505, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to apply (not: beantragen)', 'bewerben', ARRAY[]::text[], NULL, NULL, 'Ich bewerbe mich um einen Praktikumsplatz.
I am applying for an internship.', 2506, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to assess, judge, rate', 'bewerten', ARRAY[]::text[], NULL, NULL, 'Die Arbeit ist gut bewertet worden.
The work has been judged as good. You must rate your eBay purchase.', 2507, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Bible', 'Bibel', ARRAY[]::text[], 'noun', 'die', 'Die Bibel ist das meistverkaufte Buch.
The Bible is the most sold book.', 2508, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'relationship, attachment (not: Verhältnis)', 'Bindung', ARRAY[]::text[], 'noun', 'die', 'Zwischen Eltern und Kindern besteht eine enge Bindung.
Between parents and children there is a close relationship.', 2509, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stock market', 'Börse', ARRAY[]::text[], 'noun', 'die', 'Herr Zschoch spekuliert an der Börse.
Mr. Zschoch speculates at the stock market.', 2510, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'business', 'Business', ARRAY[]::text[], 'noun', 'das', 'Der Geschäftsführer fliegt immer Business Class.
The manager always flies business class.', 2511, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cover', 'decken', ARRAY[]::text[], NULL, NULL, 'Die Einnahmen decken genau die Kosten.
The revenue just covers the costs. I cover you with a blanket.', 2512, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to differentiate', 'differenzieren', ARRAY[]::text[], NULL, NULL, 'Wir müssen noch deutlicher zwischen Können und Wollen differenzieren.
We need to differentiate between ability and desire more clearly.', 2513, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stupid', 'dumm', ARRAY[]::text[], NULL, NULL, 'Das war eine dumme Idee von dir.
That was a stupid idea from you.', 2514, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'husband', 'Ehegatte', ARRAY[]::text[], 'noun', 'der', 'Bei der Preisverleihung erschien sie mit ihrem Ehegatten.
At the awards ceremony, she appeared with her husband.', 2515, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opinion, assessment, evaluation (not: Bewertung)', 'Einschätzung', ARRAY[]::text[], 'noun', 'die', 'Mich interessiert deine Einschätzung der Situation.
I am interested in your evaluation of the situation.', 2516, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to board, get in', 'einsteigen', ARRAY[]::text[], NULL, NULL, 'Erst aussteigen lassen, dann einsteigen!
First let people get off, then board!', 2517, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arrive, come true, happen', 'eintreffen', ARRAY[]::text[], NULL, NULL, 'Morgen trifft das Päckchen bei dir ein.
The parcel will arrive at your place tomorrow morning.', 2518, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'electron', 'Elektron', ARRAY[]::text[], 'noun', 'das', 'In Physik haben wir über Elektronen gesprochen.
In physics we have talked about electrons.', 2519, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take, extract, infer (not: ableiten)', 'entnehmen', ARRAY[]::text[], NULL, NULL, 'Deiner Äußerung kann ich nicht besonders viel entnehmen.
I cannot take much out of your statement.', 2520, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'origin, creation', 'Entstehung', ARRAY[]::text[], 'noun', 'die', 'Was weiß man über die Entstehung der Erde?
What is known about the origin of the earth?', 2521, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to learn', 'erlernen', ARRAY[]::text[], NULL, NULL, 'Kinder können Fremdsprachen schneller erlernen als Erwachsene.
Children can learn foreign languages faster than adults.', 2522, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expansion, extension', 'Erweiterung', ARRAY[]::text[], 'noun', 'die', 'Die Erweiterung der EU wird häufig diskutiert.
The expansion of the EU is often discussed.', 2523, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'enemy', 'Feind', ARRAY[]::text[], 'noun', 'der', 'Der natürliche Feind des Hasen ist der Fuchs.
The natural enemy of the hare is the fox.', 2524, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'flight, escape', 'Flucht', ARRAY[]::text[], 'noun', 'die', 'Die Flucht war erfolgreich.
The escape was successful.', 2525, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'refugee', 'Flüchtling', ARRAY[]::text[], 'noun', 'der', 'Die Flüchtlinge gelangten mit Booten über die Grenze.
The refugees crossed the boarder by boat.', 2526, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'secret (adj.)', 'geheim', ARRAY[]::text[], NULL, NULL, 'Wir haben einen geheimen Plan.
We have a secret plan.', 2527, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sex, gender', 'Geschlecht', ARRAY[]::text[], 'noun', 'das', 'Aufgrund des Geschlechts darf keine Benachteiligung stattfinden.
There must be no discrimination based on the gender.', 2528, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conscience (not: consciousness)', 'Gewissen', ARRAY[]::text[], 'noun', 'das', 'Esther hat ein reines Gewissen.
Esther has a clear conscience.', 2529, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'creditor, believer', 'Gläubiger', ARRAY[]::text[], 'noun', 'der', 'Der Gläubiger fordert zum Ersten des Monats eine Summe von 1000 Euro.
The creditor demands a sum of 1,000 € on the first of the month.', 2530, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the handle, grip, grasp', 'Griff', ARRAY[]::text[], 'noun', 'der', 'Du solltest das Messer nur am Griff anfassen.
You should only touch the knife at the handle.', 2531, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'a stop, hold', 'Halt', ARRAY[]::text[], 'noun', 'der', 'Der Bus fährt ohne Halt bis Halle.
The bus will go to Halle without stopping.', 2532, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shirt', 'Hemd', ARRAY[]::text[], 'noun', 'das', 'Er trägt ein buntes Hemd.
He is wearing a colorful shirt.', 2533, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to leave [behind]', 'hinterlassen', ARRAY[]::text[], NULL, NULL, 'Sie hat ihren Kindern nur Schulden hinterlassen.
She has left her children only debts.', 2534, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'indirect', 'indirekt', ARRAY[]::text[], NULL, NULL, 'Sie haben meine Frage nur indirekt beantwortet.
You have answered my question only indirectly.', 2535, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'infection', 'Infektion', ARRAY[]::text[], 'noun', 'die', 'Die Krankheit wird durch eine Infektion hervorgerufen.
The disease is caused by an infection.', 2536, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'internal', 'intern', ARRAY[]::text[], NULL, NULL, 'Wir hatten eine interne Absprache getroffen.
We had made an internal appointment.', 2537, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the kindergarten', 'Kindergarten', ARRAY[]::text[], 'noun', 'der', 'Lucy geht schon in den Kindergarten.
Lucy is already at the nursery school.', 2538, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'climate', 'Klima', ARRAY[]::text[], 'noun', 'das', 'In Utah herrscht kontinentales Klima.
Utah has a continental climate.', 2539, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'continent', 'Kontinent', ARRAY[]::text[], 'noun', 'der', 'Antarktis ist ein Kontinent.
Antartica is a continent.', 2540, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'termination, (notice of) dismissal', 'Kündigung', ARRAY[]::text[], 'noun', 'die', 'Viele Menschen haben Angst vor der Kündigung ihres Arbeitsplatzes.
Many people are afraid of the termination of their employment.', 2541, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'living, lively', 'lebendig', ARRAY[]::text[], NULL, NULL, 'Doris ist ein sehr lebendiges Mädchen.
Doris is a very lively girl.', 2542, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to praise', 'loben', ARRAY[]::text[], NULL, NULL, 'Kinder muss man viel loben.
Children must be praised a lot.', 2543, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coat', 'Mantel', ARRAY[]::text[], 'noun', 'der', 'Du hast einen schönen dicken Mantel.
You have a nice thick coat.', 2544, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'marketing', 'Marketing', ARRAY[]::text[], 'noun', 'das', 'Helge ist für das Marketing in der Firma zuständig.
Helge is responsible for marketing in the company.', 2545, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'repeatedly', 'mehrmals', ARRAY[]::text[], NULL, NULL, 'Das habe ich dir schon mehrmals gesagt.
I''ve told you repeatedly.', 2546, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to murmur, mutter', 'murmeln', ARRAY[]::text[], NULL, NULL, 'Roman murmelt eine Entschuldigung.
Roman murmurs an apology.', 2548, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'courage', 'Mut', ARRAY[]::text[], 'noun', 'der', 'Die Situation erfordert viel Mut.
The situation requires a lot of courage.', 2549, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'side effect', 'Nebenwirkung', ARRAY[]::text[], 'noun', 'die', 'Es sind bei dieser Arznei keine Nebenwirkungen bekannt.
There are no known side effects with this drug.', 2551, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opera', 'Oper', ARRAY[]::text[], 'noun', 'die', 'Zu Weihnachten habe ich Karten für die Oper bekommen.
For Christmas I got tickets for the opera.', 2552, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'orchestra', 'Orchester', ARRAY[]::text[], 'noun', 'das', 'In welchem Orchester spielst du?
What orchestra do you play in?', 2553, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'parcel, package', 'Paket', ARRAY[]::text[], 'noun', 'das', 'Das Paket ist rechtzeitig angekommen.
The package arrived on time.', 2554, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diagonally, sideways', 'quer', ARRAY[]::text[], NULL, NULL, 'Als ich heute erwachte, lag ich quer in meinem Bett.
When I woke up today, I was lying in my bed diagonally.', 2555, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to register (not: anmelden)', 'registrieren', ARRAY[]::text[], NULL, NULL, 'Alle Besucher werden elektronisch registriert.
All visitors are registered electronically.', 2556, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'relevant', 'relevant', ARRAY[]::text[], NULL, NULL, 'Das Thema ist für mich nicht relevant.
The issue is not relevant for me.', 2557, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to run', 'rennen', ARRAY[]::text[], NULL, NULL, 'Antina rannte, so schnell sie konnte, zum Bahnhof.
Antina ran as fast as she could to the station.', 2558, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'resource', 'Ressource', ARRAY[]::text[], 'noun', 'die', 'Recycling ist ein Versuch, Ressourcen zu schonen.
Recycling is an attempt to conserve resources.', 2559, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'revolution', 'Revolution', ARRAY[]::text[], 'noun', 'die', 'Die Französische Revolution begann 1789.
The French Revolution began in 1789.', 2560, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'guideline', 'Richtlinie', ARRAY[]::text[], 'noun', 'die', 'Wir brauchen für unser Vorgehen eine Richtlinie.
We need a guideline for our action.', 2561, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the return', 'Rückkehr', ARRAY[]::text[], 'noun', 'die', 'Nach dem Krieg begann die Rückkehr der Flüchtlinge.
After the war, refugees started the return [to their homeland].', 2562, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'disc, slice, (glass) pane', 'Scheibe', ARRAY[]::text[], 'noun', 'die', 'Die Erde ist keine Scheibe. Ich will eine Scheibe, bitte.
The earth is not a disc. I want a slice, please.', 2563, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to send, broadcast', 'senden', ARRAY[]::text[], NULL, NULL, 'Können Sie mir eine E-Mail senden?
Can you send me an e-mail?', 2564, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'peace, silence', 'Stille', ARRAY[]::text[], 'noun', 'die', 'Pettersson genoss die Stille.
Pettersson enjoyed the silence.', 2565, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stress', 'Stress', ARRAY[]::text[], 'noun', 'der', 'Isabel hat in letzter Zeit viel Stress.
Isabel has a lot of stress lately.', 2566, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'subjective', 'subjektiv', ARRAY[]::text[], NULL, NULL, 'Meinungen sind immer subjektiv.
Opinions are always subjective.', 2567, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'partly', 'teils', ARRAY[]::text[], NULL, NULL, 'Sie legten den Weg teils zu Fuß, teils mit dem Pferd zurück.
They did some of the way on foot, some on horseback.', 2568, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thesis', 'These', ARRAY[]::text[], 'noun', 'die', 'In seiner Einleitung formuliert der Autor drei Thesen.
In his introduction, the author formulates three thesises', 2569, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'transportation', 'Transport', ARRAY[]::text[], 'noun', 'der', 'Wir übernehmen den Transport Ihrer Möbel.
We handle the transportation of your furniture.', 2570, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'crossing, transition', 'Übergang', ARRAY[]::text[], 'noun', 'der', 'Die Pubertät ist der Übergang von der Kindheit zum Erwachsensein.
Adolescence is the transition from childhood to adulthood.', 2571, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pass into', 'übergehen', ARRAY[]::text[], NULL, NULL, 'Der Frühling geht in den Sommer über.
The spring passes into summer.', 2572, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to remain', 'verbleiben', ARRAY[]::text[], NULL, NULL, 'Beim Verbrennen von Holz verbleibt ein Rest Asche.
When burning wood, there remains some ash.', 2573, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lengthen, extend', 'verlängern', ARRAY[]::text[], NULL, NULL, 'Die Lebenserwartung verlängert sich immer mehr.
The life expectancy is extended more and more.', 2574, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to miss', 'vermissen', ARRAY[]::text[], NULL, NULL, 'Ich vermisse meinen Teddy.
I miss my teddy bear.', 2575, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to close, lock', 'verschließen', ARRAY[]::text[], NULL, NULL, 'Die Tür ist verschlossen.
The door is closed.', 2576, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to condemn', 'verurteilen', ARRAY[]::text[], NULL, NULL, 'Der Angeklagte wurde verurteilt.
The defendant was condemned.', 2577, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to carry out', 'vollziehen', ARRAY[]::text[], NULL, NULL, 'Die Ehe wurde nicht vollzogen.
The marriage was not carried out.', 2578, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'model, example', 'Vorbild', ARRAY[]::text[], 'noun', 'das', 'Vorbild zu sein bedeutet, an der Ampel nur bei Grün die Straße zu überqueren.
To be a model means to cross the street only at the green traffic light.', 2579, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'action (not: Aktion)', 'Vorgehen', ARRAY[]::text[], 'noun', 'das', 'Die Opposition kritisiert das Vorgehen der Polizei gegen die Demonstranten.
The opposition criticizes the actions of the police against the demonstrators.', 2580, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prefer', 'vorziehen', ARRAY[]::text[], NULL, NULL, 'Ich ziehe es vor, zuhause zu bleiben.
I prefer to stay at home.', 2581, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'contradiction, dissent', 'Widerspruch', ARRAY[]::text[], 'noun', 'der', 'Ihre Meinung steht in klarem Widerspruch zu Ihren Ergebnissen.
Your opinion is in clear contradiction with your findings.', 2582, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'with what', 'womit', ARRAY[]::text[], NULL, NULL, 'Womit hast du die Soße gewürzt?
What have you seasoned the sauce with?', 2583, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'desert', 'Wüste', ARRAY[]::text[], 'noun', 'die', 'Die Sahara ist eine Wüste in Afrika.
The Sahara is a desert in Africa.', 2584, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to twitch, shrug', 'zucken', ARRAY[]::text[], NULL, NULL, 'Sie zuckte ratlos mit den Schultern.
She shrugged her shoulders helplessly.', 2585, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cooperate', 'zusammenarbeiten', ARRAY[]::text[], NULL, NULL, 'Die betreuenden Ärzte müssen eng zusammenarbeiten.
The responsible doctors have to cooperate very well.', 2586, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to turn towards, devote oneself to', 'zuwenden', ARRAY[]::text[], NULL, NULL, 'Auch Pflanzen muss man sich zuwenden, damit sie gedeihen.
Plants also need to be turned to, so they will prosper.', 2587, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to break off, stop', 'abbrechen', ARRAY[]::text[], NULL, NULL, 'Bei dem Sturm sind viele Äste abgebrochen.
At the storm many branches have broken off.', 2588, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'alcohol', 'Alkohol', ARRAY[]::text[], 'noun', 'der', 'Bier enthält ca. fünf Prozent Alkohol.
Beer contains about five percent of alcohol.', 2589, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'analogous', 'analog', ARRAY[]::text[], NULL, NULL, 'Das zweite Problem lösen wir analog zum ersten.
The second problem we solve analogous to the first.', 2590, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recognition', 'Anerkennung', ARRAY[]::text[], 'noun', 'die', 'Durch unermüdliches Engagement erwarb er sich die Anerkennung durch die Kollegen.
Through tireless efforts, he gained recognition from his colleagues.', 2591, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stay, residence', 'Aufenthalt', ARRAY[]::text[], 'noun', 'der', 'In Frankfurt habe ich vier Stunden Aufenthalt.
In Frankfurt, I''ve got a four hours'' stay.', 2592, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come up, arise, pay for', 'aufkommen', ARRAY[]::text[], NULL, NULL, 'Die Versicherung wird für den Schaden aufkommen.
The insurance will pay for the damage.', 2593, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'prospect, view', 'Aussicht', ARRAY[]::text[], 'noun', 'die', 'Dieser Antrag hat kaum Aussicht auf Erfolg.
This application has little prospect of success.', 2594, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ball', 'Ball', ARRAY[]::text[], 'noun', 'der', 'Der Ball ist unter das Auto gerollt.
The ball has rolled under the car.', 2595, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'remark, comment', 'Bemerkung', ARRAY[]::text[], 'noun', 'die', 'Dazu möchte ich einige Bemerkungen machen.
I would like to make some remarks.', 2596, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'property, possession', 'Besitz', ARRAY[]::text[], 'noun', 'der', 'Im Besitz der Familie befinden sich drei Villen.
To the family property belong three villas.', 2597, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to keep, protect', 'bewahren', ARRAY[]::text[], NULL, NULL, 'Es ist wichtig, die Ruhe zu bewahren.
It is important to keep calm.', 2598, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chemistry', 'Chemie', ARRAY[]::text[], 'noun', 'die', 'Die Bonbons schmecken wie die pure Chemie.
The candies taste like pure chemistry.', 2599, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'accordingly [to that]', 'dementsprechend', ARRAY[]::text[], NULL, NULL, 'Der Urlaub war nur kurz, dementsprechend gering war der Erholungseffekt.
The vacation was short, the recovery was accordingly small.', 2600, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distance (not: Entfernung, Ferne)', 'Distanz', ARRAY[]::text[], 'noun', 'die', 'Das Internet erlaubt schnelle Kommunikation über große Distanzen hinweg.
The Internet allows rapid communication across vast distances.', 2601, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dominate', 'dominieren', ARRAY[]::text[], NULL, NULL, 'Im Sommer dominiert warmes und trockenes Wetter.
In summer, hot and dry weather dominates.', 2602, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dynamic', 'dynamisch', ARRAY[]::text[], NULL, NULL, 'Fremdsprachenerwerb ist ein dynamischer Prozess.
Language learning is a dynamic process.', 2603, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'egg', 'Ei', ARRAY[]::text[], 'noun', 'das', 'Die beiden Brüder ähneln sich wie ein Ei dem anderen.
The two brothers resemble each other like peas in a pod.', 2604, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to observe', 'einhalten', ARRAY[]::text[], NULL, NULL, 'Die Gesetze sollte man einhalten.
The law should be observed.', 2605, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'somewhat, quite', 'einigermaßen', ARRAY[]::text[], NULL, NULL, 'Es geht mir wieder einigermaßen gut.
I am doing quite well again.', 2606, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to switch on', 'einschalten', ARRAY[]::text[], NULL, NULL, 'Bei Stau schalten wir das Radio ein.
If there''s a traffic jam we turn on the radio.', 2607, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to catch', 'fangen', ARRAY[]::text[], NULL, NULL, 'Die Polizei fängt den Einbrecher.
The police catches the burglar.', 2608, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'time period, deadline', 'Frist', ARRAY[]::text[], 'noun', 'die', 'In zwei Wochen läuft die Frist für den Widerspruch ab.
In two weeks, the time limit for the protest will end.', 2609, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gift', 'Geschenk', ARRAY[]::text[], 'noun', 'das', 'Das Buch ist ein Geschenk von Tante Marianne.
The book is a gift from Aunt Marianne.', 2610, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'design, organization', 'Gestaltung', ARRAY[]::text[], 'noun', 'die', 'Die Gestaltung der Bühne übernimmt der Bühnenbildner.
The scene-painter takes care of the design of the stage.', 2611, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to guarantee (not: garantieren)', 'gewährleisten', ARRAY[]::text[], NULL, NULL, 'Die gleichbleibende Qualität des Produktes wird durch regelmäßige Kontrollen gewährleistet.
The consistent quality of the product is ensured by regular inspections.', 2612, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'home - hogar', 'Heim', ARRAY[]::text[], 'noun', 'das', 'Als Kind wohnte Bernd im Heim.
As a child, Bernd lived in the home.', 2613, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'secretly', 'heimlich', ARRAY[]::text[], NULL, NULL, 'Wir haben heimlich auf der Schultoilette geraucht.
We have smoked secretly in the school toilet.', 2614, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(be) over, for (many years)', 'hinweg', ARRAY[]::text[], NULL, NULL, 'Sie blieb über viele Jahre hinweg allein.
She remained alone for many years.', 2615, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'high point, peak', 'Höhepunkt', ARRAY[]::text[], 'noun', 'der', 'Die Stimmung war auf dem Höhepunkt.
The mood was at its peak.', 2616, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'horizon', 'Horizont', ARRAY[]::text[], 'noun', 'der', 'Hinter dem Horizont geht es weiter.
Beyond the horizon it goes on.', 2617, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to identify', 'identifizieren', ARRAY[]::text[], NULL, NULL, 'Der Sohn sollte die Leiche identifizieren.
The son had to identify the body.', 2618, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Indian', 'indisch', ARRAY[]::text[], NULL, NULL, 'Am Donnerstag wollen wir indisch essen gehen.
On Thursday, we want to eat Indian.', 2619, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to climb', 'klettern', ARRAY[]::text[], NULL, NULL, 'Affen können gut klettern.
Monkeys can climb well.', 2620, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'communicative', 'kommunikativ', ARRAY[]::text[], NULL, NULL, 'Hartmut ist ein kommunikativer Typ.
Hartmut is a communicative type.', 2621, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conference', 'Konferenz', ARRAY[]::text[], 'noun', 'die', 'Die Konferenz der Außenminister findet in Rom statt.
The Conference of Foreign Ministers is held in Rome.', 2622, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cross', 'Kreuz', ARRAY[]::text[], 'noun', 'das', 'Das Kreuz auf der Kirche ist vergoldet.
The cross on the church is gilded.', 2623, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recently', 'kürzlich', ARRAY[]::text[], NULL, NULL, 'Der Film kam erst kürzlich wieder im Fernsehen.
The movie was broadcasted recently on television again.', 2624, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to kiss', 'küssen', ARRAY[]::text[], NULL, NULL, 'Hast du ihn geküsst?
Did you kiss him?', 2625, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'loose, relaxed', 'locker', ARRAY[]::text[], NULL, NULL, 'Die Schraube ist locker.
The screw is loose.', 2626, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'multiple', 'mehrfach', ARRAY[]::text[], NULL, NULL, 'Mehrfach ungesättigte Fettsäuren sind wichtig für die Gesundheit.
Polyunsaturated fatty acids are important for health.', 2627, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'moral', 'moralisch', ARRAY[]::text[], NULL, NULL, 'Das ist moralisch nicht in Ordnung.
This is morally wrong.', 2628, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to approach', 'nähern', ARRAY[]::text[], NULL, NULL, 'Von Westen her nähert sich ein Tiefausläufer Deutschland.
From the west a trough approaches Germany.', 2630, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'necessity', 'Notwendigkeit', ARRAY[]::text[], 'noun', 'die', 'Dafür besteht keine Notwendigkeit.
Therefore there is no necessity.', 2631, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'organ', 'Organ', ARRAY[]::text[], 'noun', 'das', 'Die Haut ist das größte Organ des Körpers.
The skin is the largest organ of the body.', 2632, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'potential', 'potenziell', ARRAY[]::text[], NULL, NULL, 'Nach der Wahl finden Gespräche zwischen den potenziellen Koalitionspartnern statt.
After the election, there are discussions between the potential coalition partners.', 2633, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the press', 'Presse', ARRAY[]::text[], 'noun', 'die', 'Die Presse wittert schon wieder einen Skandal.
The press suspects a scandal again.', 2634, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in principle', 'prinzipiell', ARRAY[]::text[], NULL, NULL, 'Prinzipiell stimme ich zu.
In principle I agree.', 2635, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'problematic', 'problematisch', ARRAY[]::text[], NULL, NULL, 'Das finde ich problematisch.
I think that''s problematic.', 2636, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to profit', 'profitieren', ARRAY[]::text[], NULL, NULL, 'Von den Firmengewinnen profitiert die ganze Belegschaft.
The whole workforce will profit from the company gain.', 2637, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'almost (not: beinähe)', 'quasi', ARRAY[]::text[], NULL, NULL, 'Er hat quasi schon verloren.
He has almost lost.', 2638, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'jurisdiction', 'Rechtsprechung', ARRAY[]::text[], 'noun', 'die', 'Jurastudenten trainieren an Beispielen aus der deutschen Rechtsprechung.
Law students practice using examples from the German jurisdiction.', 2639, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shelf', 'Regal', ARRAY[]::text[], 'noun', 'das', 'Im Regal stapeln sich die ungelesenen Bücher.
On the shelves there are piled unread books.', 2640, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ring', 'Ring', ARRAY[]::text[], 'noun', 'der', 'Er trägt einen Ring an der linken Hand.
He wears a ring on his left hand.', 2641, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'separate, divorce', 'sich scheiden lassen', ARRAY[]::text[], NULL, NULL, 'Das Ehepaar lässt sich scheiden.
The couple gets divorced.', 2642, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'steep', 'steil', ARRAY[]::text[], NULL, NULL, 'Der Weg zum Gipfel ist sehr steil.
The road to the summit is very steep.', 2643, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to argue, quarrel', 'streiten', ARRAY[]::text[], NULL, NULL, 'Streitet euch nicht!
Don''t quarrel!', 2644, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'southern', 'südlich', ARRAY[]::text[], NULL, NULL, 'Leipzig liegt 200 Kilometer südlich von Berlin.
Leipzig is located 200 kilometers south of Berlin.', 2645, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exceed', 'überschreiten', ARRAY[]::text[], NULL, NULL, 'Der Showmaster überschritt wieder seine Sendezeit.
The show host again exceeded his airtime.', 2646, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exercise, practice', 'Übung', ARRAY[]::text[], 'noun', 'die', 'Das Buch enthält viele Übungen zur Grammatik.
The book contains many exercises on grammar.', 2647, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pass away', 'versterben', ARRAY[]::text[], NULL, NULL, 'Der Schauspieler verstarb im Alter von 86 Jahren.
The actor passed away at the age of 86.', 2648, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lecture', 'Vortrag', ARRAY[]::text[], 'noun', 'der', 'Diesen Vortrag habe ich schon einmal gehalten.
I gave this lecture before.', 2649, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accuse, reproach', 'vorwerfen', ARRAY[]::text[], NULL, NULL, 'Die Opposition wirft der Regierung Untätigkeit vor.
The opposition accuses the government of inaction.', 2650, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to wave', 'winken', ARRAY[]::text[], NULL, NULL, 'Charly winkte dem kleinen rothaarigen Mädchen.
Charlie waved to the little redheaded girl.', 2651, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on what', 'worauf', ARRAY[]::text[], NULL, NULL, 'Worauf kommt es beim Kochen an?
On what does it turn when cooking?', 2652, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'line (as in pickup lines)', 'Zeile', ARRAY[]::text[], 'noun', 'die', 'Übersetzer werden pro Zeile bezahlt.
Translators are paid per line.', 2653, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tremble', 'zittern', ARRAY[]::text[], NULL, NULL, 'Vor Angst zitterten ihr die Knie.
Her knees were trembling with fear.', 2654, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hold back, restrain', 'zurückhalten', ARRAY[]::text[], NULL, NULL, 'Ulrike hält sich in der Diskussion zurück.
Ulrike holds herself back at the discussion.', 2655, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'acute, urgent', 'akut', ARRAY[]::text[], NULL, NULL, 'Mit einer akuten Bronchitis solltest du im Bett bleiben.
With acute bronchitis you should stay in bed.', 2656, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to attack', 'angreifen', ARRAY[]::text[], NULL, NULL, 'Der Adler greift im Sturzflug an.
The eagle attacks in a nosedive.', 2657, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rise, go up', 'ansteigen', ARRAY[]::text[], NULL, NULL, 'Der Wasserspiegel der Ozeane steigt beständig an.
The water level of the oceans is rising steadily.', 2658, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to spread, spread out', 'ausbreiten', ARRAY[]::text[], NULL, NULL, 'Die Nachricht breitete sich wie ein Lauffeuer aus.
The news spread like wildfire.', 2659, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'implementation, type', 'Ausführung', ARRAY[]::text[], 'noun', 'die', 'Den VW Golf gibt es in verschiedenen Ausführungen.
The VW Golf is available in various types.', 2660, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distinctive', 'ausgeprägt', ARRAY[]::text[], NULL, NULL, 'Sie hat einen sehr ausgeprägten Charakter.
She has a very distinctive character.', 2661, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to complain', 'beklagen', ARRAY[]::text[], NULL, NULL, 'Ich kann mich nicht beklagen.
I can not complain.', 2662, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to name', 'benennen', ARRAY[]::text[], NULL, NULL, 'Die Straße ist nach dem früheren Präsidenten benannt.
The street is named after the former president.', 2663, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'owner', 'Besitzer', ARRAY[]::text[], 'noun', 'der', 'Der Besitzer des Unfallwagens konnte noch nicht ermittelt werden.
The owner of the car involved inthe accident could not be determined.', 2664, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stupid, dumb', 'blöd', ARRAY[]::text[], NULL, NULL, 'Mario ist so ein blöder Kerl.
Mario is such a stupid guy.', 2665, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'centre', 'Center', ARRAY[]::text[], 'noun', 'das', 'Im Winter trainiere ich im Fitness-Center.
In the winter I train in the fitness centre.', 2666, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to thank', 'danken', ARRAY[]::text[], NULL, NULL, 'Ich danke Ihnen für Ihre Einladung.
Thank you for your invitation.', 2667, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as a result', 'daraufhin', ARRAY[]::text[], NULL, NULL, 'Es begann kräftig zu regnen. Daraufhin wurden die Überschwemmungen noch schlimmer.
It began to rain hard. As a result the floods got worse.', 2668, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'three times', 'dreimal', ARRAY[]::text[], NULL, NULL, 'Er dreht den Pfennig dreimal um, bevor er ihn ausgibt.
He turns the penny three times before he spends it.', 2669, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'entrance', 'Eingang', ARRAY[]::text[], 'noun', 'der', 'Der Eingang befindet sich gegenüber der Bibliothek.
The entrance is opposite the library.', 2670, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agreed', 'einig', ARRAY[]::text[], NULL, NULL, 'Wir sind uns einig.
We agree.', 2671, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to obtain, secure (not: bekommen)', 'erlangen', ARRAY[]::text[], NULL, NULL, 'Er versuchte jahrelang, Gewissheit zu erlangen.
He tried for years to obtain certainty.', 2672, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'phenomenon, appearance', 'Erscheinung', ARRAY[]::text[], 'noun', 'die', 'Der Präsident ist eine beeindruckende Erscheinung.
The President is an impressive appearance.', 2673, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to astonish', 'erstaunen', ARRAY[]::text[], NULL, NULL, 'Der Wahlsieg der Opposition hat niemanden erstaunt.
The electoral victory of the opposition has astonished no one.', 2674, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reply (against a good argument)', 'erwidern', ARRAY[]::text[], NULL, NULL, 'Darauf kann ich nichts erwidern.
I can''t reply to this.', 2675, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'holiday, festivities (not: Urlaub, Fest)', 'Ferien', ARRAY[]::text[], 'noun', 'die', 'In den Ferien besuchen wir die Oma.
During the holidays we visit Grandma.', 2676, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'furthermore', 'ferner', ARRAY[]::text[], NULL, NULL, 'Ferner sei darauf hingewiesen, dass das Gebäude um 22 Uhr geschlossen wird.
Furthermore please note that the building will be closed at 22 clock.', 2677, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'flight', 'Flug', ARRAY[]::text[], 'noun', 'der', 'Der Flug dauert etwa acht Stunden.
The flight takes about eight hours.', 2678, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'problem (not: Problem)', 'Fragestellung', ARRAY[]::text[], 'noun', 'die', 'Das ist eine sehr komplexe Fragestellung.
This is a very complex problem.', 2679, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'friendship', 'Freundschaft', ARRAY[]::text[], 'noun', 'die', 'Beim Geld hört die Freundschaft auf.
When it comes to money, the friendship ends.', 2680, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'breakfast', 'Frühstück', ARRAY[]::text[], 'noun', 'das', 'Um acht Uhr gibt es Frühstück.
Breakfast is at eight o''clock.', 2681, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'salary (not: Löhne, Einkommen)', 'Gehalt', ARRAY[]::text[], 'noun', 'das', 'Das Gehalt wird am Zehnten des Folgemonats ausgezahlt.
The salary is paid on the tenth day of the following month.', 2682, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the secret', 'Geheimnis', ARRAY[]::text[], 'noun', 'das', 'Erst ältere Kinder können Geheimnisse bewahren.
Only older children can keep secrets.', 2683, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sound, noise', 'Geräusch', ARRAY[]::text[], 'noun', 'das', 'Was ist das für ein Geräusch?
What''s that noise?', 2684, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'taste', 'Geschmack', ARRAY[]::text[], 'noun', 'der', 'Jeder hat einen anderen Geschmack.
Everyone has a different taste.', 2685, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gold', 'Gold', ARRAY[]::text[], 'noun', 'das', 'Es ist nicht alles Gold, was glänzt.
It is not all gold that glitters.', 2686, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'harbour', 'Hafen', ARRAY[]::text[], 'noun', 'der', 'Das Schiff läuft in den Hafen ein.
The ship enters the harbor.', 2687, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go out, exceed (not: überschreiten)', 'hinausgehen', ARRAY[]::text[], NULL, NULL, 'Quantenphysik geht über mein Vorstellungsvermögen hinaus.
Quantum physics exceeds my imagination.', 2688, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hat', 'Hut', ARRAY[]::text[], 'noun', 'der', 'Heide trägt gern Hüte.
Heide likes to wear hats.', 2689, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interpretation', 'Interpretation', ARRAY[]::text[], 'noun', 'die', 'Das ist alles eine Frage der Interpretation.
This is all a matter of interpretation.', 2690, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'current (not: derzeitig)', 'jetzig', ARRAY[]::text[], NULL, NULL, 'Die jetzigen Verhältnisse sind die besten, die wir je hatten.
The current conditions are the best we''ve ever had.', 2691, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'complaint, lawsuit', 'Klage', ARRAY[]::text[], 'noun', 'die', 'Die Klage gegen Robert H. wurde wegen Formfehlern abgewiesen.
The lawsuit against Robert H. was rejected because of form errors.', 2692, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clinic, hospital (not: Krankenhaus)', 'Klinik', ARRAY[]::text[], 'noun', 'die', 'Diese Klinik hat einen guten Ruf.
This clinic has a good reputation.', 2693, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to correct, revise', 'korrigieren', ARRAY[]::text[], NULL, NULL, 'Die Klassenarbeiten müssen noch korrigiert werden.
The class work must still be corrected.', 2694, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to terminate, resign', 'kündigen', ARRAY[]::text[], NULL, NULL, 'Ich kündige meinen Arbeitsplatz zum nächsten Monat.
I terminate my job next month.', 2695, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'teacher', 'Lehrerin', ARRAY['der Lehrer']::text[], 'noun', 'die', 'Unsere Lehrerin ist sehr streng.
Our teacher is very strict.', 2696, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come off, go off, start (not: starten, beginnen)', 'losgehen', ARRAY[]::text[], NULL, NULL, 'Der Film geht nach der Tagesschau los.
The film starts after the evening news.', 2697, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'brand, stamp', 'Marke', ARRAY[]::text[], 'noun', 'die', 'Die Marke klebt schief auf dem Umschlag.
The stamp sticks on the envelope in a crooked way.', 2698, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to mark', 'markieren', ARRAY[]::text[], NULL, NULL, 'Er muss im Satz alle Verben markieren.
He must highlight all the verbs in the sentence.', 2699, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the medicine, drug (as in pill) (not: Medizin)', 'Medikament', ARRAY[]::text[], 'noun', 'das', 'Fast jedes Medikament hat unerwünschte Nebenwirkungen.
Almost every drug has adverse side effects.', 2700, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the rent', 'Miete', ARRAY[]::text[], 'noun', 'die', 'Die Miete ist sehr günstig.
The rent is very cheap.', 2701, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to join in, take part, participate (not: beteiligen, mitteilen)', 'mitmachen', ARRAY[]::text[], NULL, NULL, 'Die Schüler haben überhaupt nicht mitgemacht.
The students have not participated.', 2702, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'oil', 'Öl', ARRAY[]::text[], 'noun', 'das', 'Die nächsten Kriege werden nicht um Öl, sondern um Wasser geführt.
The next wars won''t be fought over oil but over water.', 2703, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pass, passport', 'Pass', ARRAY[]::text[], 'noun', 'der', 'Voraussetzung für die Einreise ist ein gültiger Pass.
Prerequisite for entry is a valid passport', 2704, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'imagination, fantasy (not: Vorstellung)', 'Phantasie', ARRAY[]::text[], 'noun', 'die', 'Sie hat eine blühende Phantasie.
She has a vivid imagination.', 2705, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'prognosis', 'Prognose', ARRAY[]::text[], 'noun', 'die', 'Die Klimaforscher zeichnen eine düstere Prognose.
The climate scientists draw a grim prognosis.', 2706, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'protein (not: Eiweiß)', 'Protein', ARRAY[]::text[], 'noun', 'das', 'Zehn Prozent des Eiklars sind Proteine, der Rest ist Wasser.
Ten percent of the egg white are proteins, the rest is water.', 2707, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'protocol, record', 'Protokoll', ARRAY[]::text[], 'noun', 'das', 'Alle Beschlüsse werden im Protokoll festgehalten.
All decisions are recorded in the minutes.', 2708, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to describe (not: beschreiben)', 'schildern', ARRAY[]::text[], NULL, NULL, 'Der Zeuge schilderte den Unfall.
The witness described the accident.', 2709, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fright, shock', 'Schreck', ARRAY[]::text[], 'noun', 'der', 'Ach du Schreck!
Yikes!', 2710, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'since then', 'seither', ARRAY[]::text[], NULL, NULL, 'Seither hat sich kaum etwas verändert.
Since then nothing has changed much.', 2711, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'series', 'Serie', ARRAY[]::text[], 'noun', 'die', 'Die Serie von Einbrüchen im Stadtzentrum reißt nicht ab.
The series of burglaries in the city center does not stop.', 2712, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tea', 'Tee', ARRAY[]::text[], 'noun', 'der', 'Vorsicht, der Tee ist sehr heiß.
Caution, the tea is very hot.', 2713, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to transport', 'transportieren', ARRAY[]::text[], NULL, NULL, 'Mit Schiffen kann man große Mengen billig transportieren.
With ships large quantities can be transported very cheap.', 2714, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tower', 'Turm', ARRAY[]::text[], 'noun', 'der', 'Vom Turm aus hat man eine gute Aussicht auf die Stadt.
From the tower you have a good view of the city.', 2715, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conviction', 'Überzeugung', ARRAY[]::text[], 'noun', 'die', 'Nach meiner Überzeugung ist das richtig.
I have the conviction that that is correct.', 2716, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to defend', 'verteidigen', ARRAY[]::text[], NULL, NULL, 'Die Mannschaft verteidigte verbissen ihr Tor.
The team defended doggedly their goal.', 2717, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to transform, turn into', 'verwandeln', ARRAY[]::text[], NULL, NULL, 'Der Zauberer kann sich in jedes beliebige Tier verwandeln.
The magician can transform into any animal.', 2718, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to refuse', 'verweigern', ARRAY[]::text[], NULL, NULL, 'Der Angeklagte kann die Aussage verweigern.
The defendent may refuse to testify.', 2719, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'virtual', 'virtuell', ARRAY[]::text[], NULL, NULL, 'Computersüchtige sind in der virtuellen Realität mehr zuhause als im wahren Leben.
Computer addicts are more at home in virtual reality than in real life.', 2720, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for the present', 'vorerst', ARRAY[]::text[], NULL, NULL, 'Vorerst müssen wir uns mit kleinen Fortschritten zufrieden geben.
For the present, we must be content with little progress.', 2721, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'guideline (not: Richtlinie)', 'Vorgabe', ARRAY[]::text[], 'noun', 'die', 'Die Vorgaben des Verlags sind nicht leicht zu erfüllen.
The guideline of the publisher is not easy to meet.', 2722, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tell sb to do sth', 'vorschreiben', ARRAY[]::text[], NULL, NULL, 'Ich lasse mir von dir nicht vorschreiben, wie ich zu leben habe.
I won''t let you tell me how I should live.', 2723, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'insane', 'wahnsinnig', ARRAY[]::text[], NULL, NULL, 'Diese Unordnung macht mich wahnsinnig!
This disorder makes me go insane!', 2724, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'delusion', 'Wahn', ARRAY[]::text[], 'noun', 'der', 'Er lebt in einem Wahn...
He lives in a delusion...', 2724, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to leave, go away', 'weggehen', ARRAY[]::text[], NULL, NULL, 'Geh weg, ich kann dich nicht mehr sehen.
Go away, I don''t want to see you anymore.', 2725, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Christmas', 'Weihnachten', ARRAY[]::text[], 'noun', NULL, 'Frohe Weihnachten und ein gutes neues Jahr!
Merry Christmas and a Happy New Year!', 2726, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'change, turn (esp. the 1989-90 political change in the GDR)', 'Wende', ARRAY[]::text[], 'noun', 'die', 'Nach der Wende kauften sie ihr altes Haus zurück.
After the turn, they bought back their old house.', 2727, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to contradict', 'widersprechen', ARRAY[]::text[], NULL, NULL, 'Das widerspricht meinen Grundsätzen.
This contradicts my principles.', 2728, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'what...for, what...of (not: wofür)', 'wonach', ARRAY[]::text[], NULL, NULL, 'Wonach suchst du?
What are you looking for?', 2729, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'accessible', 'zugänglich', ARRAY[]::text[], NULL, NULL, 'Diese Akten sind nur Wissenschaftlern zugänglich.
These files are only accessible to scientists.', 2730, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dependence', 'Abhängigkeit', ARRAY[]::text[], 'noun', 'die', 'Das Gewicht verändert sich in Abhängigkeit zur Größe.
The weight changes in dependence to size.', 2731, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get, fetch, pick up', 'abholen', ARRAY[]::text[], NULL, NULL, 'Wer kann heute die Kinder abholen?
Who can pick up the kids today?', 2732, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take off, dismiss', 'absetzen', ARRAY[]::text[], NULL, NULL, 'Vor dem Duschen setzt man besser die Brille ab.
Before taking a shower one should better take off the glasses.', 2733, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put up', 'anbringen', ARRAY[]::text[], NULL, NULL, 'Hier darf man keine Plakate anbringen.
Here it''s not allowed to put up a poster.', 2734, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to suggest, indicate, point (not: hinweisen)', 'andeuten', ARRAY[]::text[], NULL, NULL, 'Wie der Name schon andeutet, findet der Musiksommer im Sommer statt.
As the name suggests, the summer music is in the summer.', 2735, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'labour market', 'Arbeitsmarkt', ARRAY[]::text[], 'noun', 'der', 'Die Lage am Arbeitsmarkt ist unverändert schlecht.
The labor market remains bad.', 2736, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'annoyance, trouble', 'Ärger', ARRAY[]::text[], 'noun', 'der', 'Mit dem neuen Computer habe ich nur Ärger.
With the new computer I''m just asking for trouble.', 2737, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take off, break open', 'aufbrechen', ARRAY[]::text[], NULL, NULL, 'Der Dieb bricht das Schloss auf.
The thief broke open the lock.', 2738, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put on', 'aufsetzen', ARRAY[]::text[], NULL, NULL, 'Die Verkäuferin setzte ihr freundlichstes Lächeln auf.
The saleswoman put on her friendliest smile.', 2739, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'detailed', 'ausführlich', ARRAY[]::text[], NULL, NULL, 'Die Methode wird ausführlich beschrieben.
The method is described in detail.', 2740, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'excellent, perfect', 'ausgezeichnet', ARRAY[]::text[], NULL, NULL, 'Das war ein ausgezeichnetes Essen.
That was an excellent meal.', 2741, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'even out, reconcile', 'ausgleichen', ARRAY[]::text[], NULL, NULL, 'Die Aktie konnte ihre Verluste vom Vortag ausgleichen.
The stock was able to even out the losses from the previous day.', 2742, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extraordinary', 'außerordentlich', ARRAY[]::text[], NULL, NULL, 'Das Theaterstück hat mir außerordentlich gut gefallen.
The play has pleased me extraordinarily well.', 2743, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exchange', 'Austausch', ARRAY[]::text[], 'noun', 'der', 'Der Austausch der Batterien sollte nur vom Fachmann vorgenommen werden.
The exchange of the batteries should only be undertaken by a specialist.', 2744, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to apply for', 'beantragen', ARRAY[]::text[], NULL, NULL, 'Nach zehn Jahren muss man einen neuen Pass beantragen.
After ten years you have to apply for a new passport.', 2745, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'care', 'Betreuung', ARRAY[]::text[], 'noun', 'die', 'Der Kindergarten bietet auch Betreuung in der Ferienzeit an.
The nursery school also offers care in the holiday season.', 2746, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'blind', 'blind', ARRAY[]::text[], NULL, NULL, 'Das Mädchen ist auf einem Auge blind.
The girl is blind on one eye.', 2747, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bomb', 'Bombe', ARRAY[]::text[], 'noun', 'die', 'Bei Bauarbeiten werden immer wieder Bomben aus dem Zweiten Weltkrieg gefunden.
During construction work again and again bombs from World War II are found.', 2748, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in between [them]', 'dazwischen', ARRAY[]::text[], NULL, NULL, 'Dornröschen fiel in einen tiefen Schlaf. Der Prinz weckte sie auf. Dazwischen lagen hundert Jahre.
Sleeping Beauty fell into a deep sleep. The prince woke her up. In between there were a hundred years.', 2750, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conceivable', 'denkbar', ARRAY[]::text[], NULL, NULL, 'Es ist auch denkbar, dass er sich anders entscheidet.
It is also conceivable that he decides otherwise.', 2751, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dialogue', 'Dialog', ARRAY[]::text[], 'noun', 'der', 'Das Theaterstück enthält spannende Dialoge.
The play contains fascinating dialogues.', 2752, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'independent, on their own (not: unabhängig)', 'eigenständig', ARRAY[]::text[], NULL, NULL, 'Die Aufgaben sind eigenständig zu erledigen.
The tasks must be performed independently.', 2753, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to unite, agree', 'einigen', ARRAY[]::text[], NULL, NULL, 'Es ist viel billiger, sich außergerichtlich zu einigen.
It''s much cheaper to agree out of court.', 2754, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to introduce (not: einführen)', 'einleiten', ARRAY[]::text[], NULL, NULL, 'Die Regierung leitet Reformen ein.
The government introduces reforms.', 2755, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fall asleep', 'einschlafen', ARRAY[]::text[], NULL, NULL, 'Babys schlafen gern an Mamas Brust ein.
Babies like to fall asleep on Mom''s breast.', 2756, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'including (not: inklusiv)', 'einschließlich', ARRAY[]::text[], NULL, NULL, 'Der Preis beträgt einschließlich Flug, Übernachtung und Frühstück 250 Euro pro Person.
The price is including airfare, lodging and breakfast 250 € per person.', 2757, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'apology, excuse (not: Ausrede, Verziehung)', 'Entschuldigung', ARRAY[]::text[], 'noun', 'die', 'Dafür gibt es keine Entschuldigung.
There is no excuse.', 2759, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'increase', 'Erhöhung', ARRAY[]::text[], 'noun', 'die', 'Der Angestellte forderte eine Erhöhung seines Gehalts.
The employee asked for an increase in his salary.', 2760, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to establish', 'etablieren', ARRAY[]::text[], NULL, NULL, 'Das Produkt hat sich am Markt etabliert.
The product has established on the market.', 2761, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'damp', 'feucht', ARRAY[]::text[], NULL, NULL, 'Die Wäsche ist noch ganz feucht.
The laundry is still damp.', 2762, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to whisper', 'flüstern', ARRAY[]::text[], NULL, NULL, 'Wir flüsterten, damit uns niemand hörte.
We whispered so no one could hear us.', 2763, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gas', 'Gas', ARRAY[]::text[], 'noun', 'das', 'Wir heizen mit Gas.
We heat with gas.', 2764, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'religious, spiritual (not: religiös)', 'geistlich', ARRAY[]::text[], NULL, NULL, 'Der Pfarrer gab dem Paar seinen geistlichen Segen.
The priest gave the couple his spiritual blessings.', 2765, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gene', 'Gen', ARRAY[]::text[], 'noun', 'das', 'Defekte Gene können Krankheiten verursachen.
Defective genes can cause diseases.', 2766, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to glide', 'gleiten', ARRAY[]::text[], NULL, NULL, 'Das Schiff gleitet durch die Wellen.
The ship glides through the waves.', 2767, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'outstanding', 'hervorragend', ARRAY[]::text[], NULL, NULL, 'Das war eine hervorragende Leistung.
This was an outstanding performance.', 2768, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'after, afterwards', 'hinterher', ARRAY[]::text[], NULL, NULL, 'Hinterher ist man immer schlauer.
Afterwards one is always wiser.', 2769, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'heat', 'Hitze', ARRAY[]::text[], 'noun', 'die', 'Sprayflaschen muss man vor großer Hitze schützen.
Spray bottles must be protected from excessive heat.', 2770, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intellectual', 'intellektuell', ARRAY[]::text[], NULL, NULL, 'Das Buch ist eine intellektuelle Herausforderung.
This book is an intellectual challenge.', 2771, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'beyond', 'jenseits', ARRAY[]::text[], NULL, NULL, 'Das Dorf befindet sich jenseits der Berge.
The village is situated beyond the mountains.', 2772, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'no...at all', 'keinerlei', ARRAY[]::text[], NULL, NULL, 'Die Maschine weist keinerlei Mängel auf.
The machine has no faults at all.', 2773, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'childhood', 'Kindheit', ARRAY[]::text[], 'noun', 'die', 'Ich hatte eine glückliche Kindheit.
I had a happy childhood.', 2774, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'piano', 'Klavier', ARRAY[]::text[], 'noun', 'das', 'Im Saal steht ein Klavier.
In the hall there is a piano.', 2775, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consistent[ly], consequent[ly]', 'konsequent', ARRAY[]::text[], NULL, NULL, 'Es ist nicht immer leicht, Entscheidungen konsequent durchzuhalten.
It is not always easy to stick to decisions consistently.', 2776, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'constant, continuous', 'kontinuierlich', ARRAY[]::text[], NULL, NULL, 'Das Niveau nimmt kontinuierlich ab.
The level is continuously decreasing.', 2777, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'concentration', 'Konzentration', ARRAY[]::text[], 'noun', 'die', 'Diese Aufgabe erfordert meine volle Konzentration.
This task requires my full concentration.', 2778, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'correct (not: richtig)', 'korrekt', ARRAY[]::text[], NULL, NULL, 'Die korrekte Antwort lautet anders.
The correct answer is different.', 2779, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'body (not: Körper)', 'Leib', ARRAY[]::text[], 'noun', 'der', 'Sie begann, ihm das Hemd vom Leib zu reißen.
She began to strip off his shirt from his body.', 2780, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'painter', 'Maler', ARRAY[]::text[], 'noun', 'der', 'Der Maler streicht die Wände.
The painter paints the walls.', 2781, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'financial, material', 'materiell', ARRAY[]::text[], NULL, NULL, 'Materiell geht es uns gut.
Financially, we are fine.', 2782, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'humanity', 'Menschheit', ARRAY[]::text[], 'noun', 'die', 'Klimawandel betrifft die ganze Menschheit.
Climate change affects all of humanity.', 2783, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strange', 'merkwürdig', ARRAY[]::text[], NULL, NULL, 'Das erscheint mir merkwürdig.
That strikes me as strange.', 2784, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'milk', 'Milch', ARRAY[]::text[], 'noun', 'die', 'Babys trinken nur Milch.
Babies drink only milk.', 2785, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'murder (not: murderer)', 'Mord', ARRAY[]::text[], 'noun', 'der', 'Beim Fall Ötzi handelt es sich wahrscheinlich um Mord.
In the case of Ötzi, it is likely to be murder.', 2786, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'oral', 'mündlich', ARRAY[]::text[], NULL, NULL, 'Mündliche Prüfungen sind anders als schriftliche.
Oral examinations are different than written ones.', 2787, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'side by side', 'nebeneinander', ARRAY[]::text[], NULL, NULL, 'Sie sitzen in der Schule nebeneinander.
At school they sit side by side.', 2788, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pedagogical', 'pädagogisch', ARRAY[]::text[], NULL, NULL, 'Lehrer haben eine pädagogische Ausbildung.
Teachers have pedagogical training.', 2789, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pilot', 'Pilot', ARRAY[]::text[], 'noun', 'der', 'Der Pilot sitzt im Cockpit.
The pilot sits in the cockpit.', 2790, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to press', 'pressen', ARRAY[]::text[], NULL, NULL, 'Das Kind presst seinen Teddy an sich.
The child presses his teddy bear to his chest.', 2791, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'psychological', 'psychisch', ARRAY[]::text[], NULL, NULL, 'Eine Depression ist eine psychische Krankheit.
Depression is a psychological illness.', 2792, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'result (not: Ereignis)', 'Resultat', ARRAY[]::text[], 'noun', 'das', 'Das Resultat konnte mich nicht überzeugen.
The result did not convince me.', 2793, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the giant', 'Riese', ARRAY[]::text[], 'noun', 'der', 'Das Schloss wird von einem gefährlichen Riesen bewacht.
The castle is guarded by a dangerous giant.', 2794, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on behalf', 'stellvertretend', ARRAY[]::text[], NULL, NULL, 'Die Mutter nahm stellvertretend für den Sohn den Preis in Empfang.
The mother took the award on behalf of her son.', 2795, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stick, floor', 'Stock', ARRAY[]::text[], 'noun', 'der', 'Der alte Mann stützte sich auf seinen Stock.
The old man leaned on his stick.', 2796, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'punishment', 'Strafe', ARRAY[]::text[], 'noun', 'die', 'Es ist nicht leicht, sich sinnvolle Strafen auszudenken.
It is not easy to come up with meaningful punishments.', 2797, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to train, coach', 'trainieren', ARRAY[]::text[], NULL, NULL, 'Christian trainiert für Olympia.
Christian is training for the Olympics.', 2798, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'translator', 'Übersetzer', ARRAY[]::text[], 'noun', 'der', 'Helge arbeitet als Übersetzer.
Helge works as a translator.', 2799, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shore, bank', 'Ufer', ARRAY[]::text[], 'noun', 'das', 'Die Fähre liegt am anderen Ufer.
The ferry is located on the opposite bank.', 2800, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'survey', 'Umfrage', ARRAY[]::text[], 'noun', 'die', 'In der letzten Umfrage kam die Opposition auf den ersten Platz.
In the last survey, the opposition came in the first place.', 2801, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'uncertain, insecure', 'unsicher', ARRAY[]::text[], NULL, NULL, 'Nach der Knieoperation war er im Laufen noch etwas unsicher.
After the knee surgery he was walking a little insecure.', 2802, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'initially, at the beginning (not: vorerst)', 'anfangs', ARRAY[]::text[], NULL, NULL, 'Anfangs glaubte ich noch, ich könnte ihn verändern.
Initially, I still believed I could change him.', 2803, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to register, sign up', 'anmelden', ARRAY[]::text[], NULL, NULL, 'Wir melden uns im Sufi Camp sobald wir ankommen.
We will register in the Sufi camp as soon as we arrive.', 2804, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to show, point out', 'aufzeigen', ARRAY[]::text[], NULL, NULL, 'Die Broschüre will Schülern berufliche Perspektiven aufzeigen.
The brochure aims to show students career prospects.', 2805, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get off', 'aussteigen', ARRAY[]::text[], NULL, NULL, 'Während der Fahrt darf man nicht aussteigen.
During the trip one may not get off.', 2806, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exchange, replace', 'austauschen', ARRAY[]::text[], NULL, NULL, 'Wenn die Uhr stehen bleibt, muss man die Batterie austauschen.
When the clock stops, you need to replace the battery.', 2807, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from out of town', 'auswärtig', ARRAY[]::text[], NULL, NULL, 'Sie hatte nur auswärtige Freunde.
She only had friends from out of town.', 2808, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'baby', 'Baby', ARRAY[]::text[], 'noun', 'das', 'Maria bekam ihr Baby in Bethlehem.
Mary got her baby in Bethlehem.', 2809, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'any, as you like', 'beliebig', ARRAY[]::text[], NULL, NULL, 'Jeder Gast darf beliebig viele Freunde mitbringen.
Each guest may bring as many friends as he likes.', 2810, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lie ahead, be imminent', 'bevorstehen', ARRAY[]::text[], NULL, NULL, 'Uns stehen schwere Zeiten bevor.
Difficult times lie ahead of us.', 2811, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'city centre', 'City', ARRAY[]::text[], 'noun', 'die', 'Immer mehr Geschäfte ziehen aus der City auf die grüne Wiese.
More and more businesses move from the city centre to the countryside.', 2812, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'current (not: jetzig)', 'derzeitig', ARRAY[]::text[], NULL, NULL, 'Die Amtsperiode des derzeitigen Präsidenten endet in vier Jahren.
The term of the current president ends in four years.', 2813, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'difference', 'Differenz', ARRAY[]::text[], 'noun', 'die', 'Die Differenz zwischen Umsatz und Kosten ist der Gewinn.
The difference between revenues and costs is the profit.', 2814, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'darkness', 'Dunkelheit', ARRAY[]::text[], 'noun', 'die', 'Die Wanderer wurden von der einbrechenden Dunkelheit überrascht.
The travelers were surprised by the falling darkness.', 2815, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dozen', 'Dutzend', ARRAY[]::text[], 'noun', 'das', 'Es waren etwa zwei Dutzend Leute da.
There were about two dozen people there.', 2816, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to intervene', 'eingreifen', ARRAY[]::text[], NULL, NULL, 'Das Jugendamt greift ein, wenn Kinder in Gefahr sind.
The Youth Office intervenes when children are in danger.', 2817, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ice, ice cream', 'Eis', ARRAY[]::text[], 'noun', 'das', 'Zum Nachtisch nehmen wir noch ein Eis.
For dessert, we take ice cream.', 2818, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reception, welcoming', 'Empfang', ARRAY[]::text[], 'noun', 'der', 'Sie bereiteten ihm einen festlichen Empfang.
They gave him a festive reception.', 2819, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recipient', 'Empfänger', ARRAY[]::text[], 'noun', 'der', 'Der Brief erreicht in ca. zwei Tagen seinen Empfänger.
The letter will reach its recepient in about two days.', 2820, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to relax', 'entspannen', ARRAY[]::text[], NULL, NULL, 'Im Urlaub wollen sich die meisten entspannen.
On vacation most people want to relax.', 2821, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nutrition, diet', 'Ernährung', ARRAY[]::text[], 'noun', 'die', 'Gesunde Ernährung enthält viel Obst und Gemüse.
A healthy diet includes plenty of fruits and vegetables.', 2822, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'protestant', 'evangelisch', ARRAY[]::text[], NULL, NULL, 'Nach der Reformation wurde dieses Gebiet evangelisch.
After the Reformation, this area became protestant.', 2823, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to flee, escape', 'fliehen', ARRAY[]::text[], NULL, NULL, 'Die Menschen fliehen vor dem Bürgerkrieg ins Nachbarland.
People are escaping the civil war by fleeing to the neighboring country.', 2824, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'peaceful', 'friedlich', ARRAY[]::text[], NULL, NULL, 'Die Kinder liegen friedlich in ihren Bettchen.
The children lie peacefully in their cribs.', 2826, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'terrible (not: schrecklich)', 'furchtbar', ARRAY[]::text[], NULL, NULL, 'Das Erdbeben war eine furchtbare Katastrophe.
The earthquake was a terrible disaster.', 2827, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'genetic', 'genetisch', ARRAY[]::text[], NULL, NULL, 'Genetische Defekte können Krankheiten verursachen.
Genetic defects can cause diseases.', 2828, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'point of view, according', 'Gesichtspunkt', ARRAY[]::text[], 'noun', 'der', 'Die Substanz muss nach medizinischen Gesichtspunkten eingesetzt werden.
The substance must be used according to medical criteria.', 2829, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'grandmother', 'Großmutter', ARRAY[]::text[], 'noun', 'die', 'Rotkäppchen brachte ihrer Großmutter Kuchen und Wein.
Little Red Riding Hood brought cake and wine to her grandmother.', 2830, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'origin [location, not beginning]', 'Herkunft', ARRAY[]::text[], 'noun', 'die', 'Die Herkunft des Namens ist nicht bekannt.
The origin of the name is not known.', 2831, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wedding', 'Hochzeit', ARRAY[]::text[], 'noun', 'die', 'Am Wochenende bin ich zu einer Hochzeit eingeladen.
This weekend I am invited to a wedding.', 2832, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hunger', 'Hunger', ARRAY[]::text[], 'noun', 'der', 'Hast du Hunger?
Are you hungry?', 2833, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'any time', 'jederzeit', ARRAY[]::text[], NULL, NULL, 'Du kannst mich jederzeit anrufen.
You can call me any time.', 2834, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(state of the) economy', 'Konjunktur', ARRAY[]::text[], 'noun', 'die', 'Die Reformen sollen die Konjunktur beleben.
The reforms aim to revitalize the economy.', 2835, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'competitor (not: Gegner)', 'Konkurrent', ARRAY[]::text[], 'noun', 'der', 'Erfolgreiche Konkurrenten sollte man aufkaufen.
Successful competitors one should buy.', 2836, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'load, burden (not: Belastung)', 'Last', ARRAY[]::text[], 'noun', 'die', 'Sie trägt die Last der Verantwortung.
She bears the burden of responsibility.', 2837, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'year (of one’s life)', 'Lebensjahr', ARRAY[]::text[], 'noun', 'das', 'Im ersten Lebensjahr entwickeln sich Kinder in einem rasanten Tempo.
In the first year of life, children develop at a rapid pace.', 2838, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'medium', 'Medium', ARRAY[]::text[], 'noun', 'das', 'Das Internet ist ein relativ neues Medium.
The Internet is a relatively new medium.', 2839, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'methodical', 'methodisch', ARRAY[]::text[], NULL, NULL, 'Das Lehrbuch ist methodisch durchdacht.
This book is thought-out methodologically well.', 2840, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mixture', 'Mischung', ARRAY[]::text[], 'noun', 'die', 'Dieser Früchtetee ist eine Mischung aus Apfel-, Orangen- und Birnenstücken.
This fruit tea is a blend of apple, pear and orange pieces.', 2841, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pattern, model', 'Muster', ARRAY[]::text[], 'noun', 'das', 'Bei diesem Schlips gefällt mir das Muster nicht.
With this tie I don''t like the pattern.', 2842, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'successor', 'Nachfolger', ARRAY[]::text[], 'noun', 'der', 'Sein Nachfolger wird es nicht leicht haben.
His successor will not have an easy job.', 2843, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lasting, sustainable', 'nachhaltig', ARRAY[]::text[], NULL, NULL, 'Die Reform hatte eine nachhaltige Wirkung.
The reform had a lasting effect.', 2844, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'curious', 'neugierig', ARRAY[]::text[], NULL, NULL, 'Affen sind neugierig.
Monkeys are curious.', 2845, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'note, grade', 'Note', ARRAY[]::text[], 'noun', 'die', 'Leider brachte er wieder schlechte Noten mit nach Hause.
Unfortunately, he came home with bad grades again.', 2846, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'zero', 'null', ARRAY[]::text[], NULL, NULL, 'Beim Telefonieren muss man eine Null vorwählen.
When making calls you have to dial a zero first.', 2847, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'uncle', 'Onkel', ARRAY[]::text[], 'noun', 'der', 'Katrin hat einen Onkel in Alabama.
Katrin has an uncle in Alabama.', 2848, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'potential', 'Potenzial', ARRAY[]::text[], 'noun', 'das', 'Verona hat ein großes Potenzial.
Verona has a great potential.', 2849, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the protest', 'Protest', ARRAY[]::text[], 'noun', 'der', 'Die Kürzungen riefen heftige Proteste hervor.
The cuts provoked fierce protests.', 2850, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to clean', 'putzen', ARRAY[]::text[], NULL, NULL, 'Nächste Woche putze ich die Fenster.
Next week I will clean the windows.', 2851, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to clean, purify', 'reinigen', ARRAY[]::text[], NULL, NULL, 'Der Filter reinigt die Luft.
The filter cleans the air.', 2852, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stimulus, appeal', 'Reiz', ARRAY[]::text[], 'noun', 'der', 'Der Reiz des Spiels liegt in seiner Unvorhersehbarkeit.
The appeal of the game is its unpredictability.', 2853, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'remaining', 'restlich', ARRAY[]::text[], NULL, NULL, 'Die restlichen Kosten trägt die Stadt.
The remaining costs are taken over by the city.', 2854, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to result', 'resultieren', ARRAY[]::text[], NULL, NULL, 'Die guten Ergebnisse resultieren aus akribischer Forschungsarbeit.
The good outcome results from meticulous research.', 2855, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'raw material', 'Rohstoff', ARRAY[]::text[], 'noun', 'der', 'Holz ist ein nachwachsender Rohstoff.
Wood is a renewable raw material.', 2856, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'facts', 'Sachverhalt', ARRAY[]::text[], 'noun', 'der', 'Erich kann komplexe Sachverhalte schnell erfassen.
Erich can grasp complex facts quickly.', 2857, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the shot', 'Schuss', ARRAY[]::text[], 'noun', 'der', 'Der Schuss traf ihn an der Schulter.
The shot hit him at the shoulder.', 2858, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'same', 'selbe', ARRAY['s)']::text[], NULL, NULL, 'Anja erledigt die Aufgaben noch am selben Tag.
Anja completes the tasks on the same day.', 2860, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'protection, fuse', 'Sicherung', ARRAY[]::text[], 'noun', 'die', 'Die Sicherung ist durchgebrannt.
The fuse is blown.', 2861, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'winner', 'Sieger', ARRAY[]::text[], 'noun', 'der', 'Der Sieger erhält einen Pokal.
The winner receives a trophy.', 2862, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cut off, block, close', 'sperren', ARRAY[]::text[], NULL, NULL, 'Die Straße ist gesperrt.
The road is closed.', 2863, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'statistics', 'Statistik', ARRAY[]::text[], 'noun', 'die', 'Glaube nur der Statistik, die du selbst gefälscht hast.
Only believe in the statistics that you yourself have forged.', 2864, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'radiation', 'Strahlung', ARRAY[]::text[], 'noun', 'die', 'Das Gebiet ist mit radioaktiver Strahlung verseucht.
The area is contaminated with radioactive radiation.', 2865, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'taxi', 'Taxi', ARRAY[]::text[], 'noun', 'das', 'Können Sie mir bitte ein Taxi rufen?
Can you call me a taxi please?', 2866, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tournament', 'Turnier', ARRAY[]::text[], 'noun', 'das', 'Das Turnier beginnt um drei.
The tournament starts at three.', 2867, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the takeover', 'Übernahme', ARRAY[]::text[], 'noun', 'die', 'Die Firmenleitung kündigt die Übernahme durch die Konkurrenz an.
The company''s management announces the takeover by the competitors.', 2868, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to surround, enclose', 'umgeben', ARRAY[]::text[], NULL, NULL, 'Das Schloss ist von einem kleinen Park umgeben.
The castle is surrounded by a small park.', 2869, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'disputed', 'umstritten', ARRAY[]::text[], NULL, NULL, 'Diese These ist sehr umstritten.
This thesis is disputed a lot.', 2870, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the processing [of]', 'Verarbeitung', ARRAY[]::text[], 'noun', 'die', 'Durch die Verarbeitung zu Konserven gehen dem Gemüse Vitamine verloren.
By processing the vegetables vitamins are lost.', 2871, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'suspicious', 'verdächtig', ARRAY[]::text[], NULL, NULL, 'Wenn die beiden sich treffen, ist das verdächtig.
When the two meet, that''s suspicious.', 2872, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to clarify (as in explain)', 'verdeutlichen', ARRAY[]::text[], NULL, NULL, 'Das will ich mit einem Beispiel verdeutlichen.
I will explain that with an example.', 2873, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'publication', 'Veröffentlichung', ARRAY[]::text[], 'noun', 'die', 'Der frisch gebackene Doktor kann schon auf zahlreiche Veröffentlichungen verweisen.
The new Doctor can already point to numerous publications.', 2874, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'distribution', 'Verteilung', ARRAY[]::text[], 'noun', 'die', 'Der Manager bemüht sich um eine gerechte Verteilung der Aufgaben.
The Manager will seek to ensure fair distribution of tasks.', 2875, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reunification', 'Wiedervereinigung', ARRAY[]::text[], 'noun', 'die', 'Auch fünfzehn Jahre nach der Wiedervereinigung sind die Lebensumstände in beiden Teilen Deutschlands noch sehr unterschiedlich.
Even fifteen years after the reunification the living conditions in both parts of Germany are still very different.', 2876, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to weigh', 'wiegen', ARRAY[]::text[], NULL, NULL, 'Der Kürbis wiegt sieben Kilo.
The pumpkin weighs seven pounds.', 2877, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'joke', 'Witz', ARRAY[]::text[], 'noun', 'der', 'Jakobus erzählt gern Witze.
James likes to tell jokes.', 2878, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wonderful', 'wunderschön', ARRAY[]::text[], NULL, NULL, 'Da betrat eine wunderschöne Frau das Zimmer.
A lovely woman walked into the room.', 2879, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'departure, parting', 'Abschied', ARRAY[]::text[], 'noun', 'der', 'Es war ein tränenreicher Abschied
It was a tearful parting.', 2880, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to attack, accumulate', 'anfallen', ARRAY[]::text[], NULL, NULL, 'In Nobelrestaurants fällt viel Müll an
Fancy restaurants accumulate a lot of garbage', 2881, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lead, command, quote', 'anführen', ARRAY[]::text[], NULL, NULL, 'Schalke führt die Bundesliga an
Schalke leads the Bundesliga', 2882, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to break out, erupt', 'ausbrechen', ARRAY[]::text[], NULL, NULL, 'Der Vulkan ist wieder ausgebrochen
The volcano has erupted once again', 2883, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bear, endure', 'aushalten', ARRAY[]::text[], NULL, NULL, 'Wie lange hältst du das noch aus?
How long can you endure that?', 2884, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to give sb the task of doing sth, hire (a firm)', 'beauftragen', ARRAY[]::text[], NULL, NULL, 'Herr Töpfer ist mit der Organisation des Festes beauftragt.
Mr. Potter is given the task of organizing the festival.', 2885, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'use', 'Benutzung', ARRAY[]::text[], 'noun', 'die', 'Die Benutzung der Toilette ist kostenpflichtig
The use of the toilet will be charged', 2886, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Berne(se)', 'Berner', ARRAY[]::text[], NULL, NULL, 'Der Berner Bachchor führt das Weihnachtsoratorium auf.
The Bernese Bach Choir performs the Christmas Oratorio', 2887, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dispute, deny', 'bestreiten', ARRAY[]::text[], NULL, NULL, 'Der Beschuldigte bestreitet die Vorwürfe
The defendant denies the allegations', 2888, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'judgement, review', 'Beurteilung', ARRAY[]::text[], 'noun', 'die', 'Der Schüler bekam eine gute Beurteilung
The student got a good review', 2889, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'applicant', 'Bewerber', ARRAY[]::text[], 'noun', 'der', 'Auf eine freie Stelle kommen zwanzig Bewerber.
On one vacancy there are twenty applicants.', 2890, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'deficit', 'Defizit', ARRAY[]::text[], 'noun', 'das', 'Die Firma beendete das Haushaltsjahr mit einem Defizit von 200 000 Euro.
The company ended the financial year with a deficit of 200 000 €.', 2892, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to press, insist', 'dringen', ARRAY[]::text[], NULL, NULL, 'Ich werde darauf dringen, dass Sie mehr Geld bekommen.
I will insist that you will get more money.', 2893, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'effective', 'effektiv', ARRAY[]::text[], NULL, NULL, 'Isabel arbeitet am effektivsten unter Zeitdruck.
Isabel works most effectively under time pressure.', 2894, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to force one´s way in, penetrate', 'eindringen', ARRAY[]::text[], NULL, NULL, 'Die Bankräuber sind unerkannt in den Tresorraum eingedrungen.
The bank robbers have forced their way into the vault undetectedly.', 2895, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lonely, isolated', 'einsam', ARRAY[]::text[], NULL, NULL, 'Im Alter sind viele Menschen einsam.
At old age many people are lonely.', 2896, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lock up, surround, include', 'einschließen', ARRAY[]::text[], NULL, NULL, 'Im Preis ist das Frühstück eingeschlossen.
The breakfast is included in the price.', 2897, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'restriction', 'Einschränkung', ARRAY[]::text[], 'noun', 'die', 'Die Nutzung des Internets ist hier nur unter Einschränkungen möglich.
The use of the Internet is possible only under restrictions.', 2898, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to slip (sb’s mind), be dropped', 'entfallen', ARRAY[]::text[], NULL, NULL, 'Der Name ist mir gerade entfallen.
The name slipped my mind right now.', 2899, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'investigation', 'Ermittlung', ARRAY[]::text[], 'noun', 'die', 'Die Ermittlungen sind noch nicht abgeschlossen.
The investigation is still ongoing.', 2900, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the yield', 'Ertrag', ARRAY[]::text[], 'noun', 'der', 'Auf diesem Boden bringen Kartoffeln gute Erträge.
On this ground potatoes make good yields.', 2901, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hall, corridor', 'Flur', ARRAY[]::text[], 'noun', 'der', 'Der Lärm hallt durch die Flure.
The noise echoes through the corridors.', 2902, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'format', 'Format', ARRAY[]::text[], 'noun', 'das', 'Welches Format soll das Papier haben?
What format should the paper have?', 2903, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thorough', 'gründlich', ARRAY[]::text[], NULL, NULL, 'Gründliches Zähneputzen schützt vor Karies.
Brushing teeth thoroughly prevents tooth decay.', 2904, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hero', 'Held', ARRAY[]::text[], 'noun', 'der', 'Die siegreichen Fußballer wurden wie Helden gefeiert.
The victorious footballers were celebrated as heroes.', 2905, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in, into, Come in!', 'herein', ARRAY['rein']::text[], NULL, NULL, 'Nur immer herein! Wir haben für alle Platz!
Just come in! We have room for everyone!', 2906, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'production', 'Herstellung', ARRAY[]::text[], 'noun', 'die', 'Die Herstellung von Lebensmitteln wird streng überwacht.
The production of food is closely monitored.', 2907, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'this year', 'heuer', ARRAY[]::text[], NULL, NULL, 'Die Oma wird heuer schon 95.
The grandmother already becomes 95 this year.', 2908, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(lasting) for years', 'jahrelang', ARRAY[]::text[], NULL, NULL, 'In der Wüste wartet man oft jahrelang auf Regen.
In the desert, one often waits for rain for years.', 2909, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Japanese', 'japanisch', ARRAY[]::text[], NULL, NULL, 'Origami ist eine japanische Faltkunst.
Origami is a Japanese art of folding.', 2910, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ever', 'jemals', ARRAY[]::text[], NULL, NULL, 'Warst du jemals im Ausland?
Have you ever been abroad?', 2911, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'emperor', 'Kaiser', ARRAY[]::text[], 'noun', 'der', 'Kaiser Augustus ordnete eine Volkszählung an.
Emperor Augustus ordered a census.', 2912, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(small) room, chamber', 'Kammer', ARRAY[]::text[], 'noun', 'die', 'Die Würste hängen in der Kammer.
The sausages are hanging in a small room.', 2913, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chain', 'Kette', ARRAY[]::text[], 'noun', 'die', 'Sie trägt eine goldene Kette um den Hals.
She wears a golden chain around her neck.', 2914, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stick [with glue]', 'kleben', ARRAY[]::text[], NULL, NULL, 'Sie klebte das Poster an die Wand.
She stuck the poster on the wall.', 2915, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clothes', 'Kleidung', ARRAY[]::text[], 'noun', 'die', 'Schwarze Kleidung ist ein Ausdruck für Trauer.
Black clothing is an expression of grief.', 2916, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pub, bar', 'Kneipe', ARRAY[]::text[], 'noun', 'die', 'Nach der Arbeit treffen wir uns in der Kneipe zum Bier.
After work we meet in the pub for a beer.', 2917, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'constant', 'konstant', ARRAY[]::text[], NULL, NULL, 'Der Temperaturregler hält die Temperatur konstant auf zwanzig Grad.
The thermostat keeps the temperature constant at twenty degrees.', 2918, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'critic [person]', 'Kritiker', ARRAY[]::text[], 'noun', 'der', 'Die Kritiker haben das Stück sehr gelobt.
Critics have praised the piece very much.', 2919, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coast', 'Küste', ARRAY[]::text[], 'noun', 'die', 'Die Küste ist über 200 km mit Öl verseucht.
The coast is polluted with oil over 200 kilometers.', 2920, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'boring', 'langweilig', ARRAY[]::text[], NULL, NULL, 'Mir ist langweilig.
I''m bored.', 2921, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'liberal', 'liberal', ARRAY[]::text[], NULL, NULL, 'Diese Ansichten sind mir zu liberal.
These views are too liberal.', 2922, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'logical', 'logisch', ARRAY[]::text[], NULL, NULL, 'Das ist doch logisch.
It''s logical.', 2923, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'knife', 'Messer', ARRAY[]::text[], 'noun', 'das', 'Das Messer liegt rechts neben dem Teller.
The knife is on right side next to the plate.', 2924, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'measuring, measurement', 'Messung', ARRAY[]::text[], 'noun', 'die', 'Nach der Messung schaltet sich die Waage automatisch ab.
After the measurement, the scale will turn off automatically.', 2925, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from time to time', 'mitunter', ARRAY[]::text[], NULL, NULL, 'In deutschen Großstädten kann man mitunter auch amerikanische Luxus-limousinen entdecken.
In German cities, you can find American luxury sedans from time to time.', 2926, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Muslim', 'Moslem', ARRAY[]::text[], 'noun', 'der', 'Gläubige Moslems fasten im Ramadan.
Devout Muslims fast during Ramadan.', 2927, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'motto', 'Motto', ARRAY[]::text[], 'noun', 'das', 'Der Wettbewerb stand unter dem Motto „Schöner unsere Städte und Dörfer“.
The competition was held under the motto "more beautiful our towns and villages."', 2928, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the side, in addition, by the way', 'nebenbei gesagt', ARRAY[]::text[], NULL, NULL, 'Nebenbei gesagt, Messer sind oft scharf.
By the way, knives are often sharp.', 2929, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nervous', 'nervös', ARRAY[]::text[], NULL, NULL, 'Er trommelte nervös mit den Fingern auf dem Lenkrad.
He drummed his fingers nervously on the steering wheel.', 2930, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to note', 'notieren', ARRAY[]::text[], NULL, NULL, 'Moment, das möchte ich mir notieren.
One moment please, I want to note that.', 2931, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'user', 'Nutzer', ARRAY[]::text[], 'noun', 'der', 'Alle Nutzer müssen eine Jahresgebühr von 30 Euro zahlen.
All users must pay an annual fee of 30 €.', 2932, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'passenger', 'Passagier', ARRAY[]::text[], 'noun', 'der', 'Zahlreiche Passagiere befanden sich auf dem Oberdeck.
Many passengers were on the upper deck.', 2935, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'embarrassing', 'peinlich', ARRAY[]::text[], NULL, NULL, 'Das ist mir aber peinlich.
That''s just embarrassing.', 2936, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opening night, premiere', 'Premiere', ARRAY[]::text[], 'noun', 'die', 'Zur Premiere kamen nur geladene Gäste.
At the opening night there were only invited guests.', 2937, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sample, test, rehearsal', 'Probe', ARRAY[]::text[], 'noun', 'die', 'Die Probe für das Theaterstück beginnt um acht.
The rehearsal for the play begins at eight.', 2938, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'square metre', 'Quadratmeter', ARRAY[]::text[], 'noun', 'der', 'Das Grundstück ist 200 Quadratmeter groß.
The estate consists of 200 square meters.', 2939, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to annoy, provoke, tempt', 'reizen', ARRAY[]::text[], NULL, NULL, 'An dieser Arbeit reizt mich die Aussicht auf Dienstreisen.
In this work, the prospect on business trips tempts me.', 2940, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hall', 'Saal', ARRAY[]::text[], 'noun', 'der', 'Der Saal fasst 400 Personen.
The hall can hold 400 people.', 2941, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'crooked, not straight', 'schief', ARRAY[]::text[], NULL, NULL, 'Hast du den schiefen Turm von Pisa schon mal in echt gesehen?
Have you ever seen the Leaning Tower of Pisa in real life?', 2942, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'weakness', 'Schwäche', ARRAY[]::text[], 'noun', 'die', 'Katja hat eine Schwäche für Schokolade.
Katja has a weakness for chocolate.', 2943, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sector', 'Sektor', ARRAY[]::text[], 'noun', 'der', 'Der öffentliche Sektor leidet unter zu geringen Investitionen.
The public sector suffers from too little investment.', 2944, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'spontaneous', 'spontan', ARRAY[]::text[], NULL, NULL, 'Das können wir heute Abend spontan entscheiden.
We can decide tonight spontaneously.', 2945, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the jump', 'Sprung', ARRAY[]::text[], 'noun', 'der', 'Das Lied schaffte den Sprung in die Top Ten.
The song managed the jump into the top ten.', 2946, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'symptom', 'Symptom', ARRAY[]::text[], 'noun', 'das', 'Wenn die Ursachen nicht bekannt sind, werden nur die Symptome behandelt.
If the causes are unknown, the symptoms are treated.', 2947, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tennis', 'Tennis', ARRAY[]::text[], 'noun', 'das', 'Mittwochs geht Steffi zum Tennis.
On wednesdays Steffi goes to tennis.', 2948, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'top', 'Top', ARRAY[]::text[], 'noun', 'das', 'Anke trägt gern eng anliegende Tops.
Anke likes to wear tight-fitting tops.', 2949, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cloth', 'Tuch', ARRAY[]::text[], 'noun', 'das', 'Ein Sari ist ein langes Tuch, das kunstvoll um den Körper gewickelt wird.
A sari is a long cloth that is wrapped artfully around the body.', 2950, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hand over, transfer', 'übergeben', ARRAY[]::text[], NULL, NULL, 'Morgen übergeben wir Ihnen die Papiere.
Tomorrow we will hand you over the papers.', 2951, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'surprise', 'Überraschung', ARRAY[]::text[], 'noun', 'die', 'Das war eine gelungene Überraschung.
That was a successful surprise.', 2952, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'translation', 'Übersetzung', ARRAY[]::text[], 'noun', 'die', 'Das ist aber eine schlechte Übersetzung.
But this is a bad translation.', 2953, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'countless', 'unzählig', ARRAY[]::text[], NULL, NULL, 'Nach unzähligen Versuchen erreichte er Miriam am Telefon.
After countless attempts, he reached Miriam on the phone.', 2954, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the spread [of news]', 'Verbreitung', ARRAY[]::text[], 'noun', 'die', 'Der Begriff hat inzwischen eine weite Verbreitung gefunden.
The term has now widely spread.', 2955, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to misplace, postpone', 'verlegen', ARRAY[]::text[], NULL, NULL, 'Silvie hatte schon wieder ihre Schlüssel verlegt.
Silvie had misplaced her keys again.', 2956, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reduce', 'verringern', ARRAY[]::text[], NULL, NULL, 'Bei Nebel muss man das Tempo verringern.
In fog, you must reduce the speed.', 2957, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to provide (not: versorgen)', 'verschaffen', ARRAY[]::text[], NULL, NULL, 'Thomas verschafft dem Freund eine Wohnung und einen Job.
Thomas provides his friend with an apartment and a job.', 2958, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to drive out, to sell', 'vertreiben', ARRAY[]::text[], NULL, NULL, 'Der Händler vertreibt elektrische Geräte.
The retailer sells electrical appliances.', 2959, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'virus', 'Virus', ARRAY[]::text[], 'noun', 'das', 'Grippe wird durch Viren verursacht.
Influenza is caused by viruses.', 2960, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plan, project ("what did you plan?")', 'Vorhaben', ARRAY[]::text[], 'noun', 'das', 'Sie sprechen über ihre Vorhaben.
They talk about their projects.', 2961, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'template, presentation, submission', 'Vorlage', ARRAY[]::text[], 'noun', 'die', 'Die Bücher werden gegen Vorlage des Benutzerausweises ausgegeben. Es stehen verschiedene Vorlagen zur Verfügung, um typische Dokumente zu erstellen. Die Frist für die Vorlage von Beweisen endet heute.
The books will be issued on presentation of a library card. Various templates are available to create common documents. The deadline for the submission of evidence ends today.', 2962, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the warmth', 'Wärme', ARRAY[]::text[], 'noun', 'die', 'Die Wärme entweicht durch schlecht isolierte Fenster.
The heat escapes through poorly insulated windows.', 2963, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to advertise', 'werben', ARRAY[]::text[], NULL, NULL, 'Das Reisebüro wirbt für Kurzreisen nach Spanien.
The travel agency advertises for short trips to Spain.', 2964, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'advertising', 'Werbung', ARRAY[]::text[], 'noun', 'die', 'Wieder mal nur Werbung im Briefkasten.
Again just advertising in the mailbox.', 2965, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'valuable', 'wertvoll', ARRAY[]::text[], NULL, NULL, 'Der Schmuck ist sehr wertvoll.
The jewelry is very valuable.', 2966, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meadow', 'Wiese', ARRAY[]::text[], 'noun', 'die', 'Da stehen drei Kühe auf der Wiese.
There are three cows on the meadow.', 2967, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'furious', 'wütend', ARRAY[]::text[], NULL, NULL, 'Rumpelstilzchen stampfte wütend mit dem Fuß.
Rumpelstiltskin stamped his foot furiously.', 2968, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tent', 'Zelt', ARRAY[]::text[], 'noun', 'das', 'Pfadfinder schlafen in Zelten.
Scouts sleep in tents.', 2969, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for the most part', 'zumeist', ARRAY[]::text[], NULL, NULL, 'Bei den Tätern handelt es sich zumeist um Männer.
For the most part the perpetrators are men.', 2970, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to step back, resign', 'zurücktreten', ARRAY[]::text[], NULL, NULL, 'Die Regierung tritt geschlossen zurück.
The Government resigns as a union.', 2971, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to keep from', 'abhalten', ARRAY[]::text[], NULL, NULL, 'Du kannst mich nicht davon abhalten, hier zu parken.
You can not keep me from parking here.', 2972, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to turn off, shut down, park', 'abstellen', ARRAY[]::text[], NULL, NULL, 'Ihr Auto können Sie auf dem Hotelparkplatz abstellen.
You can park your car in the hotel''s parking lot.', 2973, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'supporter, trailer', 'Anhänger', ARRAY[]::text[], 'noun', 'der', 'Im Baumarkt kann man auch Anhänger ausleihen.
At the hardware store, you can also rent trailers.', 2974, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'display, advertisement', 'Anzeige', ARRAY[]::text[], 'noun', 'die', 'Wenn man der Anzeige glaubt, ist der Tank leer.
If you believe the display, the tank is empty.', 2975, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'enlightenment, solution', 'Aufklärung', ARRAY[]::text[], 'noun', 'die', 'Die Aufklärung des Mordfalls dauerte mehrere Jahre.
The solution of the murder case took several years.', 2976, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the dissolving, breaking up', 'Auflösung', ARRAY[]::text[], 'noun', 'die', 'Die Polizei fordert die Auflösung der Demonstration.
The police calls for the dissolving of the demonstration.', 2977, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fill out', 'ausfüllen', ARRAY[]::text[], NULL, NULL, 'An der Rezeption muss man ein Formular ausfüllen.
At the reception, you must fill out a form.', 2978, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to thank', 'bedanken', ARRAY[]::text[], NULL, NULL, 'Hast du dich schon bedankt?
Have you already thanked?', 2979, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fix, fasten', 'befestigen', ARRAY[]::text[], NULL, NULL, 'Der Luftballon ist an einer Schnur befestigt.
The balloon is fixed to a cord.', 2980, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to teach', 'beibringen', ARRAY[]::text[], NULL, NULL, 'Die Katzenmutter bringt ihren Kätzchen das Jagen bei.
The mother cat teaches her kittens to hunt.', 2981, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'modest', 'bescheiden', ARRAY[]::text[], NULL, NULL, 'Die Wünsche sind ganz bescheiden.
The wishes are quite modest.', 2982, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accelerate', 'beschleunigen', ARRAY[]::text[], NULL, NULL, 'Viel Sonne beschleunigt das Wachstum der Pflanzen.
Lots of sun accelerates the growth of plants.', 2983, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get, take care', 'besorgen', ARRAY[]::text[], NULL, NULL, 'Peter besorgt Steaks und Susanne die Kohle für den Grill.
Peter gets the steaks and Susanne the coal for the barbecue.', 2984, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'order, reservation', 'Bestellung', ARRAY[]::text[], 'noun', 'die', 'Können wir die Bestellung aufgeben?
Can we place an order?', 2985, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bend, turn', 'biegen', ARRAY[]::text[], NULL, NULL, 'Das Auto biegt um die Ecke.
The car turns the corner.', 2986, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'boy', 'Bube', ARRAY[]::text[], 'noun', 'der', 'Hubertus ist gerade Vater eines Buben geworden.
Hubert has just become the father of a boy.', 2987, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'alliance', 'Bündnis', ARRAY[]::text[], 'noun', 'das', 'Ein Bündnis mit dieser Partei ist ausgeschlossen.
An alliance with that party is excluded.', 2988, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'castle (not: Schloss)', 'Burg', ARRAY[]::text[], 'noun', 'die', 'Der Weg zur Burg ist sehr steil.
The road to the castle is very steep.', 2989, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stand there', 'dastehen', ARRAY[]::text[], NULL, NULL, 'Der Verein steht mit seinem Olympiasieger gut da.
The club stands there well because of his Olympic gold medalist.', 2990, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lasting, permanently', 'dauerhaft', ARRAY[]::text[], NULL, NULL, 'Bei Frost darf die Heizung nicht dauerhaft abgestellt werden.
With frost, the heating can not be turned off permanently.', 2991, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'German-speaking', 'deutschsprachig', ARRAY[]::text[], NULL, NULL, 'Die Orthographiereform betrifft den ganzen deutschsprachigen Raum.
The spelling reform affects the entire German-speaking countries.', 2992, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dialect', 'Dialekt', ARRAY[]::text[], 'noun', 'der', 'Zuhause spricht Bert Dialekt, auf der Arbeit nicht.
Bert only speaks dialect at home, not at work.', 2993, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'carrying out, conducting', 'Durchführung', ARRAY[]::text[], 'noun', 'die', 'Die Durchführung der Wahlen verlief problemlos.
The conduct of the elections went smoothly.', 2994, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agreement', 'Einigung', ARRAY[]::text[], 'noun', 'die', 'Die Streitenden kamen zu keiner Einigung.
The contestants came to no agreement.', 2995, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'view, insight', 'Einsicht', ARRAY[]::text[], 'noun', 'die', 'Wirst du Einsicht in deine Stasi-Akten nehmen?
Will you take insight into your Stasi files?', 2996, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arouse, annoy', 'erregen', ARRAY[]::text[], NULL, NULL, 'Etwas hatte seine Aufmerksamkeit erregt.
Something had aroused his attention.', 2997, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to catch', 'erwischen', ARRAY[]::text[], NULL, NULL, 'Jetzt hab ich dich erwischt.
Now I''ve caught you.', 2998, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'separately, extra', 'extra', ARRAY[]::text[], NULL, NULL, 'Die Jacke ist extra dick gefüttert.
The jacket is with extra thick lining.', 2999, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'flexible', 'flexibel', ARRAY[]::text[], NULL, NULL, 'Wir haben flexible Arbeitszeiten.
We have flexible working hours.', 3000, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to nest, nesting', 'verschachteln', ARRAY['die Verschachtelung']::text[], NULL, NULL, 'Auch die Verschachtelung verschiedener Funktionen ist möglich.
You can also nest functions within functions.', 3000, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to conquer', 'erobern', ARRAY[]::text[], NULL, NULL, 'Trotzdem haben die Europäer später die Welt erobert, nicht die Chinesen.
Nevertheless, the Europeans went on to conquer the globe and not the Chinese.', 3000, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the Prevention', 'Vorbeugung', ARRAY[]::text[], 'noun', 'die', 'Hygiene ist wichtig für die Vorbeugung von Krankheiten.
Hygiene is important for the prevention of illnesses.', 3000, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'away, gone', 'fort', ARRAY[]::text[], NULL, NULL, 'Weit fort von hier wohnt Schneewittchen bei den sieben Zwergen hinter den sieben Bergen.
Far away from here lives Snow White with the Seven Dwarfs behind the seven mountains.', 3001, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'brother-in-law, sister-in-law', 'Schwager', ARRAY['Schwägerin']::text[], NULL, NULL, 'Ich habe einen Schwager namens Bobo – das ist eine ganz andere Geschichte.
I have a brother-in-law named Bobo -- which is a whole other story.', 3001, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'memory', 'Gedächtnis', ARRAY[]::text[], 'noun', 'das', 'Stephan hat ein gutes Gedächtnis.
Stephen has a good memory.', 3002, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'prison', 'Gefängnis', ARRAY[]::text[], 'noun', 'das', 'Dafür kann man ins Gefängnis kommen.
For this you could get to prison.', 3003, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gesture', 'Geste', ARRAY[]::text[], 'noun', 'die', 'Die Einladung zum Mittagessen war eine nette Geste.
The invitation to lunch was a nice gesture.', 3004, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'equation', 'Gleichung', ARRAY[]::text[], 'noun', 'die', 'Die Gleichung geht nicht auf.
The equation does not work out.', 3005, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be responsible, to stick', 'haften', ARRAY[]::text[], NULL, NULL, 'Eltern haften für ihre Kinder.
Parents are responsible for their children.', 3006, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'marvellous', 'herrlich', ARRAY[]::text[], NULL, NULL, 'Abends sahen wir einen herrlichen Sonnenuntergang über dem Meer.
In the evening we saw a marvellous sunset over the sea.', 3007, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'power, reign', 'Herrschaft', ARRAY[]::text[], 'noun', 'die', 'Unter der Herrschaft Herzog Ernsts wurde das Schloss gebaut.
Under the reign of Duke Ernst, the castle was built.', 3008, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to squat, crouch', 'hocken', ARRAY[]::text[], NULL, NULL, 'Die Kinder hocken ums Lagerfeuer.
The children crouched around the camp fire.', 3009, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'infrastructure', 'Infrastruktur', ARRAY[]::text[], 'noun', 'die', 'Die Region ist wegen ihrer guten Infrastruktur attraktiv für Investoren.
The region is attractive for investors because of its good infrastructure.', 3010, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'catalogue', 'Katalog', ARRAY[]::text[], 'noun', 'der', 'Die Hose hab ich im Katalog bestellt.
The pants I ordered from the catalogue.', 3011, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ecclesiastical', 'kirchlich', ARRAY[]::text[], NULL, NULL, 'Der Ostermontag ist ein kirchlicher Feiertag.
Easter Monday is an ecclesiastical holiday.', 3012, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clever', 'klug', ARRAY[]::text[], NULL, NULL, 'Das war eine kluge Entscheidung.
That was a clever decision.', 3013, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'report', 'Meldung', ARRAY[]::text[], 'noun', 'die', 'Es gab widersprüchliche Meldungen aus dem Krisengebiet.
There were conflicting reports from the crisis area.', 3014, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mission', 'Mission', ARRAY[]::text[], 'noun', 'die', 'In welcher Mission ist der Außenminister in Asien unterwegs?
On which mission is the foreign minister traveling in Asia?', 3015, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'communication, announcement', 'Mitteilung', ARRAY[]::text[], 'noun', 'die', 'Die Mitteilung kommt mit der Post.
The announcement comes in the mail.', 3016, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to follow, succeed', 'nachfolgen', ARRAY[]::text[], NULL, NULL, 'Wer wird Gerhard Schröder im Amt des Bundeskanzlers nachfolgen?
Who will succeed Gerhard Schröder as chancellor?', 3017, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to follow, pursue, be slow', 'nachgehen', ARRAY[]::text[], NULL, NULL, 'Die Rathausuhr geht schon wieder zehn Minuten nach.
The city hall clock is again ten minutes slow.', 3018, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nourishment, food', 'Nahrung', ARRAY[]::text[], 'noun', 'die', 'Während des Krieges war die Nahrung streng rationiert.
During the war, the food was strictly rationed.', 3019, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fog', 'Nebel', ARRAY[]::text[], 'noun', 'der', 'Dichter Nebel behindert den Verkehr.
Dense fog hinders the traffic.', 3020, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'officer', 'Offizier', ARRAY[]::text[], 'noun', 'der', 'Abends treffen sich die Offiziere im Kasino.
In the evenings, the officers meet at the casino.', 3021, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'grandma', 'Oma', ARRAY[]::text[], 'noun', 'die', 'Die Ferien verbringen die Kinder bei ihrer Oma.
The children spend their holidays at their grandma''s house.', 3022, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'philosophy', 'Philosophie', ARRAY[]::text[], 'noun', 'die', 'Christine studiert Mathematik, besucht aber auch Kurse in Philosophie.
Christine is studying mathematics, but she''s also attending courses in philosophy.', 3023, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'implementation (not: Umsetzung)', 'Realisierung', ARRAY[]::text[], 'noun', 'die', 'Zur Realisierung des Projekts fehlen noch 800 Euro.
For the implementation of the project there are still missing 800 €.', 3024, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'light, appearance, certificate', 'Schein', ARRAY[]::text[], 'noun', 'der', 'Der Arzt stellt einen Schein aus.
The doctor is writing a certificate.', 3025, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tow, carry', 'schleppen', ARRAY[]::text[], NULL, NULL, 'Die Mutter schleppt die schweren Einkaufstaschen nach Hause.
The mother is carrying the heavy shopping bags home.', 3026, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the cut', 'Schnitt', ARRAY[]::text[], 'noun', 'der', 'Der Verkäufer trennt dem Fisch mit einem Schnitt den Kopf ab.
The seller detaches the head of the fish with one cut.', 3027, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interface', 'Schnittstelle', ARRAY[]::text[], 'noun', 'die', 'Hat der Laptop eine USB-Schnittstelle?
Does the laptop have an USB interface?', 3028, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'debt', 'Schulden', ARRAY[]::text[], 'noun', 'die', 'Um das neue Auto kaufen zu können, musste er Schulden machen.
To buy the new car he had to go into debt.', 3029, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the longing', 'Sehnsucht', ARRAY[]::text[], 'noun', 'die', 'Julia hat Sehnsucht nach Romeo.
Julia is longing for Romeo.', 3030, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scandal', 'Skandal', ARRAY[]::text[], 'noun', 'der', 'Die Scheidung war ein Skandal.
The divorce was a scandal.', 3031, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stadium', 'Stadion', ARRAY[]::text[], 'noun', 'das', 'Das Stadion hat 40 000 Plätze.
The stadium has 40 000 seats.', 3032, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stop', 'stoppen', ARRAY[]::text[], NULL, NULL, 'Auch Stützungskäufe können den Verfall der Aktie nicht stoppen.
Also support purchases can not stop the decline of the stock.', 3033, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sweet', 'süß', ARRAY[]::text[], NULL, NULL, 'Das ist ein süßes kleines Mädchen.
This is a sweet little girl.', 3034, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tip, hint', 'Tipp', ARRAY[]::text[], 'noun', 'der', 'Ich gebe dir einen Tipp.
I''ll give you a hint.', 3035, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accord, correspond, agree', 'übereinstimmen', ARRAY[]::text[], NULL, NULL, 'Das Wetter stimmt mit der Vorhersage nicht überein.
The weather isn''t according with the forecast.', 3036, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unpleasant', 'unangenehm', ARRAY[]::text[], NULL, NULL, 'Hier ist es unangenehm kalt.
It''s unpleasantly cold here.', 3037, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put (up), accommodate', 'unterbringen', ARRAY[]::text[], NULL, NULL, 'Wo können wir nur die vielen Gäste unterbringen?
Where can we accommodate all those many guests?', 3038, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'available', 'verfügbar', ARRAY[]::text[], NULL, NULL, 'Es sind keine Gelder mehr verfügbar.
There are no more funds available.', 3039, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to extend, enlarge', 'vergrößern', ARRAY[]::text[], NULL, NULL, 'Viele Mädchen wollen sich die Brust vergrößern lassen.
Many girls want to get enlarged their breasts.', 3040, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to announce', 'verkünden', ARRAY[]::text[], NULL, NULL, 'Das Wahlbüro verkündet den Wahlsieger.
The election office announces the winner.', 3041, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to destroy (not: zerstören)', 'vernichten', ARRAY[]::text[], NULL, NULL, 'Wir müssen die Akten schnellstmöglich vernichten.
We must destroy the files as soon as possible.', 3042, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to confuse', 'verwirren', ARRAY[]::text[], NULL, NULL, 'Zu viele Fakten verwirren die Zuhörer.
Too many facts confuse the audience.', 3043, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'temporary (not: temporär)', 'vorläufig', ARRAY[]::text[], NULL, NULL, 'Das ist nur eine vorläufige Lösung.
This is only a temporary solution.', 3044, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to see again', 'wiedersehen', ARRAY[]::text[], NULL, NULL, 'Ich hoffe, dass wir uns irgendwann mal wiedersehen.
I hope that someday we''ll see each other again.', 3045, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wound', 'Wunde', ARRAY[]::text[], 'noun', 'die', 'Die Mutter klebt ihrem Sohn ein Pflaster auf die Wunde.
The mother sticks a bandaid on her son''s wound.', 3046, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'root', 'Wurzel', ARRAY[]::text[], 'noun', 'die', 'Kiefern haben tiefe Wurzeln, Fichten dagegen flache.
Pine trees have deep roots, spruces, on the other hand, have flat ones.', 3047, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'witness', 'Zeuge', ARRAY[]::text[], 'noun', 'der', 'Martin wurde Zeuge des Unfalls.
Martin became witness of the accident.', 3048, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'report, testimonial', 'Zeugnis', ARRAY[]::text[], 'noun', 'das', 'Am letzten Schultag gibt es Zeugnisse.
On the last day of school you get reports.', 3049, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in favour of', 'zugunsten', ARRAY[]::text[], NULL, NULL, 'Im Zweifelsfall wird zugunsten des Angeklagten entschieden.
In case of doubt the benefit of the doubt should be given to the accused.', 3050, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the loser', 'Versager', ARRAY['die Versagen']::text[], 'noun', 'der', 'Haarwaschen ist für Versager
Washing your hair is for losers', 3050, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'generosity', 'Großzügigkeit', ARRAY[]::text[], 'noun', 'die', 'Handelsaktivitäten werden wieder einmal als Akt der Großzügigkeit dargestellt.
Once again, commercial concerns are being portrayed as acts of generosity.', 3050, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the recovery', 'Genesung', ARRAY[]::text[], 'noun', 'die', NULL, 3050, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to copy, portray [in an image]', 'abbilden', ARRAY[]::text[], NULL, NULL, 'Die Pflanzen sind naturgetreu abgebildet.
The plants are copied realistically.', 3051, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cover', 'abdecken', ARRAY[]::text[], NULL, NULL, 'Nicht alle Schäden werden von der Versicherung abgedeckt.
Not all losses are covered by insurance.', 3052, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take off, come off, peel off', 'ablösen', ARRAY[]::text[], NULL, NULL, 'Nach dem Sonnenbrand löst sich die Haut ab.
After a sunburn the skin peels off.', 3053, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to play [a tape/song]', 'abspielen', ARRAY[]::text[], NULL, NULL, 'Die Polizei spielt das Tonband vor dem Zeugen ab.
The police plays the tape in front of the witness.', 3054, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to deviate, differ', 'abweichen', ARRAY[]::text[], NULL, NULL, 'Du darfst nicht vom Weg abweichen, sonst verirrst du dich.
You must not deviate from the path, otherwise you''ll get lost.', 3055, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stand out, show signs of, draw', 'abzeichnen', ARRAY[]::text[], NULL, NULL, 'Im Sudan zeichnet sich erneut eine Hungerkatastrophe ab.
In Sudan another famine is becoming apparent again.', 3056, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sight', 'Anblick', ARRAY[]::text[], 'noun', 'der', 'Dieses Gemälde bietet einen schönen Anblick.
This painting offers a beautiful sight.', 3058, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dependent (not: abhängig)', 'angewiesen', ARRAY[]::text[], NULL, NULL, 'Viele Studenten sind auf finanzielle Unterstützung durch die Eltern angewiesen.
Many students depend on financial support from the parents.', 3059, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'request', 'Anliegen', ARRAY[]::text[], 'noun', 'das', 'Wenn Sie gestatten, hätte ich noch ein kleines Anliegen.
If you don''t mind, I would have another little request.', 3060, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'adaptation', 'Anpassung', ARRAY[]::text[], 'noun', 'die', 'Die Anpassung der Wünsche an die Realität fällt nicht immer leicht.
The adaptation of wishes to reality is not always easy.', 3061, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the rise, increase', 'Anstieg', ARRAY[]::text[], 'noun', 'der', 'Ein Anstieg der Steuern ist unvermeidlich.
An increase in taxes is inevitable.', 3062, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exhausting', 'anstrengend', ARRAY[]::text[], NULL, NULL, 'Früher war Wäschewaschen sehr anstrengend.
In former times doing the laundry was very exhausting.', 3063, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employment office', 'Arbeitsamt', ARRAY[]::text[], 'noun', 'das', 'Am Dienstag habe ich wieder vier Stunden auf dem Arbeitsamt zugebracht.
On Tuesday I spent another four hours at the employment office.', 3064, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be based on (not: beruhen)', 'basieren', ARRAY[]::text[], NULL, NULL, 'Diese Erkenntnis basiert auf empirischen Beobachtungen.
This finding is based on empirical observations.', 3065, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'order', 'Befehl', ARRAY[]::text[], 'noun', 'der', 'Auch einem Befehl kann man widersprechen.
An order can also be objected.', 3066, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'handicapped', 'behindert', ARRAY[]::text[], NULL, NULL, 'Nach dem Unfall war er schwer geistig behindert.
After the accident he was severely mentally handicapped.', 3067, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'willingness, disposition', 'Bereitschaft', ARRAY[]::text[], 'noun', 'die', 'Die Institute zeigen Bereitschaft zur Kooperation.
The institutes are showing a willingness to cooperate.', 3068, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'complaint (not: die Klage)', 'Beschwerde', ARRAY[]::text[], 'noun', 'die', 'Ihrer Beschwerde werde ich nachgehen.
I will pursue your complaint.', 3069, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bow, arc, sheet', 'Bogen', ARRAY[]::text[], 'noun', 'der', 'Robin Hood schießt mit Pfeil und Bogen.
Robin Hood shoots with a bow and arrow.', 3070, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(sport) national division', 'Bundesliga', ARRAY[]::text[], 'noun', 'die', 'Der Fußballverein stieg in die Bundesliga auf.
The soccer club was promoted to the national division.', 3071, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shortly', 'demnächst', ARRAY[]::text[], NULL, NULL, 'Der neue Roman erscheint demnächst auch in deutscher Übersetzung.
The new novel will also be published in German translation shortly.', 3073, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diverse, various', 'divers', ARRAY[]::text[], NULL, NULL, 'Das Problem wird divers diskutiert.
The problem is diversly discussed.', 3074, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'drug', 'Droge', ARRAY[]::text[], 'noun', 'die', 'Es gibt Beratungsstellen für Menschen, die Probleme mit Drogen haben.
There are counseling services for people who have problems with drugs.', 3075, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'honour', 'Ehre', ARRAY[]::text[], 'noun', 'die', 'Es ist eine große Ehre, mit dem Nobelpreis ausgezeichnet zu werden.
It is a great honour to be awarded the Nobel Prize.', 3076, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'property', 'Eigentum', ARRAY[]::text[], 'noun', 'das', 'Das ist mein Eigentum.
This is my property.', 3077, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unique, one-of-a-kind', 'einmalig', ARRAY[]::text[], NULL, NULL, 'Das ist eine einmalige Chance.
This is a unique opportunity.', 3078, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'individual case', 'Einzelfall', ARRAY[]::text[], 'noun', 'der', 'Es handelt sich hier um einen Einzelfall.
This is an individual case.', 3079, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'elegant', 'elegant', ARRAY[]::text[], NULL, NULL, 'Der elegante Herr im Smoking heißt Charles.
The elegant gentleman in a tuxedo is called Charles.', 3080, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to (come to) meet, accommodate', 'entgegenkommen', ARRAY[]::text[], NULL, NULL, 'Sie kommt ihm auf der Straße entgegen.
She is meeting him on the street.', 3081, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to design', 'entwerfen', ARRAY[]::text[], NULL, NULL, 'Stella hat ihre erste Kollektion entworfen.
Stella has designed her first collection.', 3082, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'epoch', 'Epoche', ARRAY[]::text[], 'noun', 'die', 'Mit Goethes Tod endet die Epoche der Weimarer Klassik.
With Goethe''s death ends the epoch of the Weimar Classics.', 3083, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agent, virus, germ', 'Erreger', ARRAY[]::text[], 'noun', 'der', 'Der Erreger der Vogelgrippe ist jetzt bekannt.
The agent of the avian flu is now known.', 3084, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'remark, observation (not: Bemerkung)', 'Feststellung', ARRAY[]::text[], 'noun', 'die', 'Erlauben Sie mir die Feststellung, dass dies nicht zum ersten Mal passiert ist.
Allow me to make the remark that this has not happened for the first time.', 3085, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'formal', 'formal', ARRAY[]::text[], NULL, NULL, 'Der Antrag ist formal in Ordnung, wird aus inhaltlichen Gründen aber abgelehnt.
The application is formally correct, but rejected for reasons of content.', 3086, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'formulation', 'Formulierung', ARRAY[]::text[], 'noun', 'die', 'Die Formulierung ist noch etwas steif.
The formulation is still a little bit stiff.', 3087, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ground, site', 'Gelände', ARRAY[]::text[], 'noun', 'das', 'In dem waldreichen Gelände konnte man selten weit sehen.
In the densly wooded site you could rarely see far.', 3088, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lover', 'Geliebte', ARRAY[]::text[], 'noun', NULL, 'Gewöhnlich versteckt man seinen Geliebten im Kleiderschrank.
Usually you hide your lover in the wardrobe.', 3089, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'siblings', 'Geschwister', ARRAY[]::text[], 'noun', 'die', 'Ingrid hat vier Geschwister.
Ingrid has four siblings.', 3090, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gram', 'Gramm', ARRAY[]::text[], 'noun', 'das', 'Für meine Eierkuchen brauche ich 200 Gramm Mehl.
For my pancakes I need 200 grams of flour.', 3091, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'valid', 'gültig', ARRAY[]::text[], NULL, NULL, 'Der Fahrschein ist eine Stunde lang gültig.
The ticket is valid for one hour.', 3092, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nowadays', 'heutzutage', ARRAY[]::text[], NULL, NULL, 'Heutzutage ist alles anders.
Nowadays, everything is different.', 3093, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go there, drive there', 'hinfahren', ARRAY[]::text[], NULL, NULL, 'Wo fahren wir dieses Jahr hin?
Where are we going to go to this year?', 3094, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as a result of', 'infolge', ARRAY[]::text[], NULL, NULL, 'Heute entstehen Wüsten infolge von Bodenerosion.
Today deserts arise as a result of soil erosion.', 3095, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'production, staging', 'Inszenierung', ARRAY[]::text[], 'noun', 'die', 'Die Inszenierung an der Leipziger Oper hat mir am besten gefallen.
The production at the Leipzig Opera I liked best.', 3096, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'isolate, insulate', 'isolieren', ARRAY[]::text[], NULL, NULL, 'Das Haus ist gut isoliert.
The house is well insulated.', 3097, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'captain', 'Kapitän', ARRAY[]::text[], 'noun', 'der', 'Nicht nur Schiffe, auch Fußballmannschaften haben einen Kapitän.
Not only ships, also soccer teams have a captain.', 3098, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'box, crate', 'Kiste', ARRAY[]::text[], 'noun', 'die', 'Nach dem Umzug stand die neue Wohnung voller Kisten.
After the move the new apartment was full of boxes.', 3099, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'clinical', 'klinisch', ARRAY[]::text[], NULL, NULL, 'Das Medikament wurde klinisch getestet.
The drug has been tested clinically.', 3100, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bone', 'Knochen', ARRAY[]::text[], 'noun', 'der', 'Der Hund bekommt die Knochen vom Braten.
The dog is getting the bone of the roast.', 3101, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'context (not: Zusammenhang)', 'Kontext', ARRAY[]::text[], 'noun', 'der', 'Es ist wichtig, Vokabeln im Kontext zu lernen.
It is important to learn vocabulary in context.', 3102, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'creative', 'kreativ', ARRAY[]::text[], NULL, NULL, 'Für komplizierte Probleme braucht man kreative Lösungen.
For complicated problems you need creative solutions.', 3103, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'work of art', 'Kunstwerk', ARRAY[]::text[], 'noun', 'das', 'Das ist kein Schrott, sondern ein modernes Kunstwerk.
This is not scrap, but a work of modern art.', 3104, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'living being', 'Lebewesen', ARRAY[]::text[], 'noun', 'das', 'Menschen zählen zu den hoch entwickelten Lebewesen.
Humans rank among the most highly developed living beings.', 3105, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'truck', 'LKW', ARRAY['Lastkraftwagen']::text[], 'noun', 'der', 'Ich habe so viele Sachen, dass ich zum Umzug einen LKW brauche.
I have so many things that I need a truck for my move.', 3106, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wage, pay, reward', 'Lohn', ARRAY[]::text[], 'noun', 'der', 'Der Lohn wird am Zehnten des Folgemonats gezahlt.
The wage will be paid on the tenth day of the following month.', 3107, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stomach (organ)', 'Magen', ARRAY[]::text[], 'noun', 'der', 'Mein Magen tut weh.
My stomach hurts.', 3108, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for me, as far as I’m concerned', 'meinetwegen', ARRAY[]::text[], NULL, NULL, 'Meinetwegen brauchst du dir keine Sorgen machen.
As far as I''m concerned, you don''t need to worry.', 3109, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fashion', 'Mode', ARRAY[]::text[], 'noun', 'die', 'Digitale Armbanduhren sind aus der Mode gekommen.
Digital watches went out of fashion.', 3110, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'murderer', 'Mörder', ARRAY[]::text[], 'noun', 'der', 'Mörder können durch DNA-Analysen schnell gefunden werden.
Murderers can be easily found by DNA analysis.', 3111, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'now', 'nunmehr', ARRAY[]::text[], NULL, NULL, 'Es ist nunmehr an der Zeit, Abschied zu nehmen.
It is now time to say goodbye.', 3112, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'useful', 'nützlich', ARRAY[]::text[], NULL, NULL, 'Das Buch enthält viele nützliche Tipps.
The book contains many useful tips.', 3113, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opening, hole', 'Öffnung', ARRAY[]::text[], 'noun', 'die', 'Wir müssen die Öffnung des Safes veranlassen.
We need to arrange for the opening the safe.', 3114, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'organizational', 'organisatorisch', ARRAY[]::text[], NULL, NULL, 'Die organisatorische Leitung des Festivals übernimmt Herr Müller.
Mr. Miller takes over the organizational lead of the festival.', 3115, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Palestinian', 'palästinensisch', ARRAY[]::text[], NULL, NULL, 'Die palästinensische Regierung steht vor Problemen.
The Palestinian government is facing problems.', 3116, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'game, partida de ...', 'Partie', ARRAY[]::text[], 'noun', 'die', 'Spielen wir noch eine Partie Schach?
Are we going to play another game of chess?', 3117, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'town hall', 'Rathaus', ARRAY[]::text[], 'noun', 'das', 'Der Stadtrat debattiert mittwochs im Rathaus.
The City Council debates on Wednesdays at the town hall.', 3118, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reflection (as in thinking)', 'Reflexion', ARRAY[]::text[], 'noun', 'die', 'Eine genaue Reflexion des Problems ist dringend nötig.
An accurate reflection of the problem is urgently needed.', 3119, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pension', 'Rente', ARRAY[]::text[], 'noun', 'die', 'Von der staatlichen Rente kann man kaum leben.
One can hardly live off the state pension.', 3120, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rest', 'ruhen', ARRAY[]::text[], NULL, NULL, 'Am ersten Mai ruht die Arbeit.
On the first of May the work rests.', 3121, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'guilty', 'schuldig', ARRAY[]::text[], NULL, NULL, 'Der Angeklagte bekannte sich schuldig.
The accused pleaded guilty.', 3122, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to swing', 'schwingen', ARRAY[]::text[], NULL, NULL, 'Heute schwingt der Opa den Kochlöffel.
Today the grandfather is swinging the cooking spoon.', 3123, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sexual', 'sexuell', ARRAY[]::text[], NULL, NULL, 'In welchem Alter machen Jugendliche ihre ersten sexuellen Erfahrungen?
At what age do young people make their first sexual experiences?', 3124, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'the show', 'Show', ARRAY[]::text[], 'noun', 'die', 'Hast du gestern die Show im Fernsehen gesehen?
Have you seen the show on TV yesterday?', 3125, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'constant, constantly', 'stetig', ARRAY[]::text[], NULL, NULL, 'Der Wind wehte stetig aus Süden.
The wind blew steadily from the south.', 3126, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'foundation, institute, donation', 'Stiftung', ARRAY[]::text[], 'noun', 'die', 'Stiftungen unterstützen gemeinnützige Projekte mit Geld.
Foundations support community projects with money.', 3127, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dive, dip', 'tauchen', ARRAY[]::text[], NULL, NULL, 'Im Urlaub taucht Thomas immer.
Thomas always dives on vacation.', 3129, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plate', 'Teller', ARRAY[]::text[], 'noun', 'der', 'Helge lädt sich drei Stück Kuchen auf seinen Teller.
Helge is putting three pieces of cake on his plate.', 3130, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to overlook', 'übersehen', ARRAY[]::text[], NULL, NULL, 'Der Lehrer übersieht keinen Fehler.
The teacher doesn''t overlook any mistakes.', 3131, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unclear', 'unklar', ARRAY[]::text[], NULL, NULL, 'Mir ist unklar, wie das passieren konnte.
It''s unclear to me, how this could happen.', 3132, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'among (our-)selves, each other', 'untereinander', ARRAY[]::text[], NULL, NULL, 'Die Geschwister verstehen sich gut untereinander.
The siblings get along well with each other.', 3133, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'differentiation, distinction', 'Unterscheidung', ARRAY[]::text[], 'noun', 'die', 'Ich finde es wichtig, diese Unterscheidung zu machen.
I think it''s important to make the distinction.', 3134, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to organize (not: organisieren)', 'veranstalten', ARRAY[]::text[], NULL, NULL, 'Die Universität veranstaltet einen Tag der offenen Tür.
The university arranges an open day.', 3135, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to burn', 'verbrennen', ARRAY[]::text[], NULL, NULL, 'Holz verbrennt zu Asche.
Wood burns to ashes.', 3136, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'futile', 'vergeblich', ARRAY[]::text[], NULL, NULL, 'Alle Versuche, einen Käufer für das Haus zu finden, waren vergeblich.
All attempts to find a buyer for the house were futile.', 3137, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to negotiate', 'verhandeln', ARRAY[]::text[], NULL, NULL, 'Über den Preis können wir noch verhandeln.
About the price we can still negotiate.', 3138, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tie, connect', 'verknüpfen', ARRAY[]::text[], NULL, NULL, 'Die Projekte sind miteinander verknüpft.
The projects are tied with each other.', 3139, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fail', 'versagen', ARRAY[]::text[], NULL, NULL, 'In der Prüfung hat er völlig versagt.
In the test, he has completely failed.', 3140, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'version', 'Version', ARRAY[]::text[], 'noun', 'die', 'Die neue Version des Computerprogramms ist leistungsstärker als die alte.
The new version of the computer program is more powerful than the old one.', 3141, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put into practice, carry out', 'verwirklichen', ARRAY[]::text[], NULL, NULL, 'Träume sollte man verwirklichen.
Dreams should be realized.', 3142, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to list, record', 'verzeichnen', ARRAY[]::text[], NULL, NULL, 'Wo sind die Namen der Kursteilnehmer verzeichnet?
Where are the names of the students recorded?', 3143, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'voter', 'Wähler', ARRAY[]::text[], 'noun', 'der', 'Die Wähler warten auf die Umsetzung der Wahlversprechen.
Voters are waiting for the implemention of the election promises.', 3144, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interaction', 'Wechselwirkung', ARRAY[]::text[], 'noun', 'die', 'Wechselwirkungen mit anderen Medikamenten sind nicht bekannt.
Interactions with other medicines are not known.', 3145, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'piece of paper, note', 'Zettel', ARRAY[]::text[], 'noun', 'der', 'Der ganze Schreibtisch liegt voller Zettel.
The whole desk is full of pieces of paper.', 3146, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interest (banking)', 'Zins', ARRAY[]::text[], 'noun', 'der', 'Bei dieser Investition kann man vier Prozent Zinsen erwarten.
With this investment, you can expect four percent interest.', 3147, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'zone', 'Zone', ARRAY[]::text[], 'noun', 'die', 'In dieser Zone des Bahnhofs herrscht Rauchverbot.
In this zone of the train station smoking is forbidden.', 3148, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reduction, decline, mining', 'Abbau', ARRAY[]::text[], 'noun', 'der', 'Wir bedauern den Abbau von Arbeitsplätzen sehr.
We regret the reduction of jobs very much.', 3149, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agency', 'Agentur', ARRAY[]::text[], 'noun', 'die', 'Die Agentur wird von verschiedenen Personen geführt.
The agency is run by different people.', 3150, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'academy', 'Akademie', ARRAY[]::text[], 'noun', 'die', 'Die Jury der Akademie hat sich für einen Kandidaten entschieden.
The jury of the Academy has chosen a candidate.', 3151, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'inquiry, request', 'Anfrage', ARRAY[]::text[], 'noun', 'die', 'Wir senden Ihnen auf Anfrage gern eine Broschüre zu.
We will be happy to send a brochure on request.', 3152, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accuse (of sg)', 'anklagen', ARRAY[]::text[], NULL, NULL, 'Er wird wegen Diebstahls angeklagt.
He is accused of theft.', 3153, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'present (as to be present)', 'anwesend', ARRAY[]::text[], NULL, NULL, 'Alle Gäste sind anwesend.
All guests are present.', 3154, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'performance (not: Leistung)', 'Aufführung', ARRAY[]::text[], 'noun', 'die', 'Die Schüler planen eine Aufführung von Schillers “Don Carlos”.
The students are planning a performance of Schiller''s "Don Carlos".', 3155, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to clear up, inform', 'aufklären', ARRAY[]::text[], NULL, NULL, 'Das Problem wird sich aufklären.
The problem will be cleared up.', 3156, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'edition, condition, plating', 'Auflage', ARRAY[]::text[], 'noun', 'die', 'Die Grammatik erscheint dieses Jahr in der dritten Auflage.
The grammar book is going to be published this year in its third edition.', 3157, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to apply, serve, instruct', 'auftragen', ARRAY[]::text[], NULL, NULL, 'Sie trägt die Creme auf ihre Haut auf.
She''s applying the cream to her skin.', 3158, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to wake up', 'aufwachen', ARRAY[]::text[], NULL, NULL, 'Wach auf, du musst zur Arbeit!
Wake up, you have to go to work!', 3159, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extension, consolidation', 'Ausbau', ARRAY[]::text[], 'noun', 'der', 'Der Ausbau des Hauses erfolgt nur langsam.
The extension of the house is happening slowly.', 3160, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get by, get on, manage', 'auskommen', ARRAY[]::text[], NULL, NULL, 'Sie kommen gut miteinander aus.
They get along well with each other.', 3161, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to turn off', 'ausschalten', ARRAY[]::text[], NULL, NULL, 'Ich schalte jetzt den Fernseher aus.
I''m turning off the TV now.', 3162, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to leave, retire, be eliminated', 'ausscheiden', ARRAY[]::text[], NULL, NULL, 'Die deutsche Mannschaft ist schon im Achtelfinale ausgeschieden.
The German team has been eliminated already in the second round.', 3163, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bake', 'backen', ARRAY[]::text[], NULL, NULL, 'Ich backe einen Kuchen.
I''m baking a cake.', 3164, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bear', 'Bär', ARRAY[]::text[], 'noun', 'der', 'In den Pyrenäen gibt es Bären.
In the Pyrenees there are bears.', 3165, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to regret, feel sorry', 'bedauern', ARRAY[]::text[], NULL, NULL, 'Wir bedauern den Vorfall sehr.
We are very sorry for the incident.', 3166, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'concern, doubt', 'Bedenken', ARRAY[]::text[], 'noun', 'das', 'Hast du keine Bedenken, nach Kolumbien zu fahren?
Don''t you have any concerns about traveling to Colombia?', 3167, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to satisfy', 'befriedigen', ARRAY[]::text[], NULL, NULL, 'Du bist schwer zu befriedigen.
You''re hard to satisfy.', 3168, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fight, combat', 'bekämpfen', ARRAY[]::text[], NULL, NULL, 'Im Hundertjährigen Krieg bekämpften sich Engländer und Franzosen.
In the Hundred Years'' War the English and the French fought against each other.', 3169, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to damage', 'beschädigen', ARRAY[]::text[], NULL, NULL, 'Unser Haus wurde durch den Sturm beschädigt.
Our house was damaged by the storm.', 3170, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'operational', 'betrieblich', ARRAY[]::text[], NULL, NULL, 'Wir haben mit betrieblichen Schwierigkeiten zu kämpfen.
We have to deal with operational difficulties.', 3171, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'letter', 'Buchstabe', ARRAY[]::text[], 'noun', 'der', 'Wie viele Buchstaben hat das deutsche Alphabet?
How many letters are in the German alphabet?', 3172, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'civil, civic', 'bürgerlich', ARRAY[]::text[], NULL, NULL, 'Er ging seinen bürgerlichen Pflichten nach.
He did his civic duties.', 3173, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'document', 'Dokument', ARRAY[]::text[], 'noun', 'das', 'Ein Zeugnis ist ein wichtiges Dokument.
A certificate is an important document.', 3174, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'native', 'einheimisch', ARRAY[]::text[], NULL, NULL, 'Die einheimischen Stämme wurden vertrieben.
The native tribes have been frightened away.', 3175, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to judge, assess', 'einschätzen', ARRAY[]::text[], NULL, NULL, 'Ich habe Julia falsch eingeschätzt.
I''ve misjudged Julia.', 3176, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'detail', 'Einzelheit', ARRAY[]::text[], 'noun', 'die', 'Die Einzelheiten klären wir in einem persönlichen Gespräch.
The details we will clarify in a personal interview.', 3177, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sensitive', 'empfindlich', ARRAY[]::text[], NULL, NULL, 'Dieses Duschgel ist speziell für empfindliche Haut.
This shower gel is specially designed for sensitive skin.', 3178, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fulfilment', 'Erfüllung', ARRAY[]::text[], 'noun', 'die', 'Ich hoffe, dein Wunsch geht in Erfüllung.
I hope your wish will come to fulfilment.', 3179, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to develop, tap', 'erschließen', ARRAY[]::text[], NULL, NULL, 'Neue Rohstoffquellen müssen erschlossen werden.
New sources of raw materials must be developed.', 3180, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bring up, educate', 'erziehen', ARRAY[]::text[], NULL, NULL, 'Muriel erzieht ihren Sohn ganz allein.
Muriel is bringing up her son all by herself.', 3181, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'external', 'extern', ARRAY[]::text[], NULL, NULL, 'In seinem Job hat er viele externe Verpflichtungen.
In his job he has many external obligations.', 3182, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'finance minister', 'Finanzminister', ARRAY[]::text[], 'noun', 'der', 'Der derzeitige deutsche Finanzminister heißt Hans Eichel.
The current German Finance Minister is called Hans Eichel.', 3183, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to form', 'formen', ARRAY[]::text[], NULL, NULL, 'Aus dem Teig formen Sie ein kleines rundes Brot.
The dough you shape a into small round bread.', 3184, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cheerful', 'fröhlich', ARRAY[]::text[], NULL, NULL, 'Brigitte ist ein fröhliches Mädchen.
Brigitte is a cheerful girl.', 3185, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'leader, guide', 'Führer', ARRAY[]::text[], 'noun', 'der', 'Ein Führer begleitete unseren Stadtrundgang und erklärte uns viel.
A guide accompanied our city walk and explained us a lot.', 3186, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fusion, merger', 'Fusion', ARRAY[]::text[], 'noun', 'die', 'Die Fusion der beiden Unternehmen ist für nächstes Jahr geplant.
The fusion of the two companies is planned for next year.', 3187, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'smell', 'Geruch', ARRAY[]::text[], 'noun', 'der', 'Der Geruch ist unerträglich.
The smell is unbearable.', 3188, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'balance', 'Gleichgewicht', ARRAY[]::text[], 'noun', 'das', 'Das gesamtwirtschaftliche Gleichgewicht ist gestört.
The macroeconomic balance is disturbed.', 3189, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'generous', 'großzügig', ARRAY[]::text[], NULL, NULL, 'Der Vorstand hat dem Bewerber ein großzügiges Angebot gemacht.
The Board has made a generous offer to the candidate.', 3190, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'indigenous, native, at home', 'heimisch', ARRAY[]::text[], NULL, NULL, 'Theo fühlt sich inzwischen hier heimisch.
In the meantime Theo feels at home here.', 3191, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'investor', 'Investor', ARRAY[]::text[], 'noun', 'der', 'Wir müssen einen Investor für unser Projekt finden.
We need to find an investor for this project.', 3192, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hunt', 'jagen', ARRAY[]::text[], NULL, NULL, 'Die Jäger jagen im Wald Hirsche und Bären.
The hunters are hunting deers and bears in the forest.', 3193, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fellow, bloke', 'Kerl', ARRAY[]::text[], 'noun', 'der', 'Christoph ist ein komischer Kerl.
Christopher is a funny fellow.', 3194, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'colleague', 'Kollegin', ARRAY[]::text[], 'noun', 'die', 'Wir haben eine tschechische Kollegin im Betrieb.
We have a Czech colleague in the company.', 3195, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to combine', 'kombinieren', ARRAY[]::text[], NULL, NULL, 'Karriere und Familie sollte man gut kombinieren können.
One should be able to combine career and family well.', 3196, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'composer', 'Komponist', ARRAY[]::text[], 'noun', 'der', 'Johann Sebastian Bach war Komponist.
Johann Sebastian Bach was a composer.', 3197, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conventional', 'konventionell', ARRAY[]::text[], NULL, NULL, 'Wir bevorzugen konventionelle Methoden und Verfahren.
We prefer conventional methods and procedures.', 3198, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to crawl', 'kriechen', ARRAY[]::text[], NULL, NULL, 'Das Baby kriecht unter den Tisch.
The baby crawls under the table.', 3199, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'curve', 'Kurve', ARRAY[]::text[], 'noun', 'die', 'Das Auto kam in der Kurve ins Schleudern.
The car started skidding in the curve.', 3200, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'laboratory', 'Labor', ARRAY[]::text[], 'noun', 'das', 'Im Labor führt man chemische Experimente durch.
In the laboratory you carry out chemical experiments.', 3201, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'district', 'Landkreis', ARRAY[]::text[], 'noun', 'der', 'Der Gesuchte wurde im Landkreis Regensburg gefasst.
The demanded person was caught in in the district of Regensburg.', 3202, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to steer, guide', 'lenken', ARRAY[]::text[], NULL, NULL, 'Der Prüfling versuchte, das Gespräch auf ein anderes Thema zu lenken.
The specimen was trying to steer the conversation towards another topic.', 3203, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ultimately', 'letztendlich', ARRAY[]::text[], NULL, NULL, 'Letztendlich hat es doch geklappt.
Ultimately it worked.', 3204, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'linear', 'linear', ARRAY[]::text[], NULL, NULL, 'Was sind lineare Funktionen?
What are linear functions?', 3205, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fairy tale', 'Märchen', ARRAY[]::text[], 'noun', 'das', 'Kinder lieben Märchen.
Children love fairy tales.', 3206, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Middle Ages', 'Mittelalter', ARRAY[]::text[], 'noun', 'das', 'Im Mittelalter starben viele Menschen an Seuchen.
In the Middle Ages many people died from epidemics.', 3207, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(piece of) furniture', 'Möbel', ARRAY[]::text[], 'noun', 'das', 'Wir kaufen uns neue Möbel.
We are going to buy new furniture.', 3208, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'modern age', 'Moderne', ARRAY[]::text[], 'noun', 'die', 'Das Weltbild änderte sich in der Moderne grundlegend.
The conception of the world changed dramatically in the modern age.', 3209, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to motivate', 'motivieren', ARRAY[]::text[], NULL, NULL, 'Schüler muss man zum Lernen motivieren.
Students must be motivated to learn.', 3210, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strenuous, laborious', 'mühsam', ARRAY[]::text[], NULL, NULL, 'Es ist sehr mühsam, eine fremde Sprache zu lernen.
It is strenuous to learn a foreign language.', 3211, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nerve', 'Nerv', ARRAY[]::text[], 'noun', 'der', 'Meine Nerven sind sehr angespannt.
My nerves are very tense.', 3212, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'northern', 'nördlich', ARRAY[]::text[], NULL, NULL, 'Im nördlichen Teil des Landes ist es sehr gebirgig.
In the northern part of the country it is very mountainous.', 3213, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'oven, stove', 'Ofen', ARRAY[]::text[], 'noun', 'der', 'In ihrer Wohnung wird noch mit einem Ofen geheizt.
Her apartment is still heated by a oven.', 3214, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'care', 'Pflege', ARRAY[]::text[], 'noun', 'die', 'Diese Pflanze braucht viel Licht und Pflege.
This plant needs plenty of light and care.', 3215, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'platform', 'Plattform', ARRAY[]::text[], 'noun', 'die', 'Es wurde eine Plattform zum Informationsaustausch im Internet eingerichtet.
A platform was extablished for exchange of information on the Internet.', 3216, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'post, position', 'Posten', ARRAY[]::text[], 'noun', 'der', 'Er ist die richtige Person für diesen Posten.
He is the right person for this position.', 3217, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'professional', 'professionell', ARRAY[]::text[], NULL, NULL, 'Wir suchen professionelle Unterstützung für unser Projekt.
We are looking for professional support for our project.', 3218, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pro, professional', 'Profi', ARRAY[]::text[], 'noun', 'der', 'Der Einbrecher muss ein Profi gewesen sein.
The burglar must have been a pro.', 3219, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'psychological', 'psychologisch', ARRAY[]::text[], NULL, NULL, 'Wir suchen Testpersonen für ein psychologisches Experiment.
We are looking for volunteers for a psychological experiment.', 3220, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'qualitative', 'qualitativ', ARRAY[]::text[], NULL, NULL, 'Das ist ein qualitativ hochwertiges Produkt.
This is a qualitative high-value product.', 3221, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'regime', 'Regime', ARRAY[]::text[], 'noun', 'das', 'Die Bevölkerung Chiles litt unter dem diktatorischen Regime.
The population of Chile was suffering under the dictatorial regime.', 3222, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'plenty, generous', 'reichlich', ARRAY[]::text[], NULL, NULL, 'Es gab reichlich zu essen und zu trinken.
There was plenty to eat and drink.', 3223, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to ride', 'reiten', ARRAY[]::text[], NULL, NULL, 'Wir reiten durch den Wald.
We are riding through the forest.', 3224, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'skirt, rock music', 'Rock', ARRAY[]::text[], 'noun', 'der', 'Schotten tragen Röcke.
Scots wear skirts.', 3225, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'resignation', 'Rücktritt', ARRAY[]::text[], 'noun', 'der', 'Der Direktor hat seinen baldigen Rücktritt angekündigt.
The director has announced to resign soon.', 3226, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cabinet, wardrobe', 'Schrank', ARRAY[]::text[], 'noun', 'der', 'Familie Laue hat sich einen neuen Schrank gekauft.
The Laue family has bought a new wardrobe.', 3227, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pregnant', 'schwanger', ARRAY[]::text[], NULL, NULL, 'Sie ist im vierten Monat schwanger.
She is four months pregnant.', 3228, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'secretary', 'Sekretärin', ARRAY[]::text[], 'noun', 'die', 'Sie bewirbt sich um eine Stelle als Sekretärin.
She applies for a job as a secretary.', 3229, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'solidarity', 'Solidarität', ARRAY[]::text[], 'noun', 'die', 'Viele Menschen drückten durch Spenden ihre Solidarität mit den Opfern aus.
Many people expressed their solidarity with donations for the victims.', 3230, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'socialist', 'sozialistisch', ARRAY[]::text[], NULL, NULL, 'Dieses Land war lange Zeit sozialistisch.
This country was socialist for a long time.', 3231, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to (go for a) walk', 'spazieren', ARRAY[]::text[], NULL, NULL, 'Jeden Sonntag gehen wir spazieren.
Every Sunday we go for a walk.', 3232, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'athlete', 'Sportler', ARRAY[]::text[], 'noun', 'der', 'Wer ist der beliebteste Sportler der Deutschen?
Who is the most popular athlete of the Germans?', 3233, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stability', 'Stabilität', ARRAY[]::text[], 'noun', 'die', 'Außenpolitische Stabilität ist sehr wichtig.
Foreign policy stability is very important.', 3234, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'status', 'Status', ARRAY[]::text[], 'noun', 'der', 'Lehrer haben in Frankreich einen hohen Status.
Teachers have a high status in France.', 3235, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dust', 'Staub', ARRAY[]::text[], 'noun', 'der', 'Stephan hat eine Allergie gegen Staub.
Stephan has an allergy to dust.', 3236, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'structural', 'strukturell', ARRAY[]::text[], NULL, NULL, 'Unsere Schwierigkeiten lassen sich durch strukturelle Probleme erklären.
Our difficulties can be explained by structural problems.', 3237, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dumb, silent', 'stumm', ARRAY[]::text[], NULL, NULL, 'Sie ist von Geburt an stumm.
She is silent since she was born.', 3238, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dance', 'Tanz', ARRAY[]::text[], 'noun', 'der', 'Wir haben einen klassischen Tanz gelernt.
We have learned a traditional dance.', 3239, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pot', 'Topf', ARRAY[]::text[], 'noun', 'der', 'Nimm einen größeren Topf!
Take a larger pot!', 3240, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'view, overview', 'Überblick', ARRAY[]::text[], 'noun', 'der', 'Zu Beginn des Seminars wird ein Überblick über die einzelnen Veranstaltungen gegeben.
At the beginning of the seminar an overview of the different classes is given.', 3241, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to kill', 'umbringen', ARRAY[]::text[], NULL, NULL, 'Sag mir die Wahrheit, ich werde dich schon nicht umbringen.
Tell me the truth, I won''t kill you.', 3242, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'uncertainty', 'Unsicherheit', ARRAY[]::text[], 'noun', 'die', 'Bei vielen Jugendlichen herrscht Unsicherheit hinsichtlich ihrer Berufswahl.
Many young people feel uncertainty regarding their career choice.', 3243, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go down', 'untergehen', ARRAY[]::text[], NULL, NULL, 'Die Sonne geht unter.
The sun is going down.', 3244, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to owe, have sb to thank for sth', 'verdanken', ARRAY[]::text[], NULL, NULL, 'Brit verdankt ihren Eltern sehr viel.
Brit owes her parents a lot.', 3245, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'increased', 'vermehrt', ARRAY[]::text[], NULL, NULL, 'Wir stellen uns vermehrt die Frage, ob unsere Vorgehensweise die richtige ist.
We are increasingly wondering whether our approach is the right one.', 3246, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to assemble, gather', 'versammeln', ARRAY[]::text[], NULL, NULL, 'Auf dem Platz sind viele Menschen versammelt.
On the square, many people are gathered.', 3247, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to despair', 'verzweifeln', ARRAY[]::text[], NULL, NULL, 'Langsam begann Kerstin zu verzweifeln.
Slowly Kerstin started to despair.', 3248, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'curtain', 'Vorhang', ARRAY[]::text[], 'noun', 'der', 'Die Vorhänge sind schmutzig.
The curtains are dirty.', 3249, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to change, convert', 'wandeln', ARRAY[]::text[], NULL, NULL, 'Die Verhältnisse können sich noch wandeln.
The relationships can still change.', 3250, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'angle, corner', 'Winkel', ARRAY[]::text[], 'noun', 'der', 'Ein gleichseitiges Dreieck hat drei Winkel zu je 60 Grad.
An equilateral triangle has three angles of 60 degrees.', 3251, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'possibly', 'womöglich', ARRAY[]::text[], NULL, NULL, 'Olaf hat womöglich noch andere dumme Sachen gemacht.
Olaf has possibly made some more stupid things.', 3252, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quotation, quote', 'Zitat', ARRAY[]::text[], 'noun', 'das', 'Von wem ist dieses Zitat?
From who is this quote?', 3253, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'permissible', 'zulässig', ARRAY[]::text[], NULL, NULL, 'Das Verfahren ist gesetzlich nicht zulässig.
The procedure is legally not permissible.', 3254, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to meet, come together', 'zusammenkommen', ARRAY[]::text[], NULL, NULL, 'Wir sind heute hier zusammengekommen, um Annas Geburtstag zu feiern.
We are gathered here today to celebrate Anna''s birthday.', 3255, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to live together', 'zusammenleben', ARRAY[]::text[], NULL, NULL, 'Toni und Anna leben zusammen.
Tony and Anna are living together.', 3256, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'watch', 'zusehen', ARRAY[]::text[], NULL, NULL, 'Erwin sieht Eva beim Schreiben zu.
Erwin is watching Eva as she writes.', 3257, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'adventure', 'Abenteuer', ARRAY[]::text[], 'noun', 'das', 'Unser letzter Urlaub war ein richtiges Abenteuer.
Our last holiday was a real adventure.', 3258, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'boundary, disassociation', 'Abgrenzung', ARRAY[]::text[], 'noun', 'die', 'Eine Abgrenzung von Privatsphäre und Öffentlichkeit ist unbedingt notwendig.
A boundary between privacy and publicity is absolutely necessary.', 3259, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take off, withdraw, subtract', 'abziehen', ARRAY[]::text[], NULL, NULL, 'Der Präsident weiß nicht, wann er die Truppen abziehen kann.
The President does not know when he will be able to pull out the troops.', 3260, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'act', 'Akt', ARRAY[]::text[], 'noun', 'der', 'Der dritte Akt des Stückes gefiel mir am besten.
I liked the third act of the play best.', 3261, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'player, actor', 'Akteur', ARRAY[]::text[], 'noun', 'der', 'Das Theaterstück wird trotz des Ausfalls von drei Akteuren aufgeführt.
The play will be performed despite the loss of three players.', 3262, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to mobilize, activate', 'aktivieren', ARRAY[]::text[], NULL, NULL, 'Die Ärztin verschreibt ein Medikament, das die Abwehrkräfte aktivieren soll.
The doctor prescribes a drug which is supposed to activate the immune system.', 3263, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'alliance', 'Allianz', ARRAY[]::text[], 'noun', 'die', 'Diplomatie macht auch unpopuläre Allianzen möglich.
Diplomacy makes also unpopular alliances possible.', 3264, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'daily, usual, ordinary', 'alltäglich', ARRAY[]::text[], NULL, NULL, 'Im alltäglichen Leben passieren oft Dinge, die man nicht erwartet.
In daily life many times things happen that you don''t expect.', 3265, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'poverty', 'Armut', ARRAY[]::text[], 'noun', 'die', 'Armut ist auch ein Problem von reichen Ländern.
Poverty is also a problem of rich countries.', 3266, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go to (see), call on', 'aufsuchen', ARRAY[]::text[], NULL, NULL, 'Du solltest jetzt endlich einen Arzt aufsuchen.
You should now finally go see a doctor.', 3267, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'balancing, compensation, change', 'Ausgleich', ARRAY[]::text[], 'noun', 'der', 'Sport ist ein guter Ausgleich zu geistiger Tätigkeit.
Sport is a good compensation for intellectual activity.', 3268, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to display, issue, make out', 'ausstellen', ARRAY[]::text[], NULL, NULL, 'Ich werde Ihnen einen Scheck ausstellen.
I will issue you a check.', 3269, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'enthusiasm', 'Begeisterung', ARRAY[]::text[], 'noun', 'die', 'Doktor Seydlitz praktiziert seinen Beruf mit Begeisterung.
Doctor Seydlitz is practising his profession with enthusiasm.', 3270, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to contain, include', 'beinhalten', ARRAY[]::text[], NULL, NULL, 'Das Angebot beinhaltet Flug und Unterkunft.
The offer includes flight and accommodation.', 3271, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to provide, put on standby', 'bereitstellen', ARRAY[]::text[], NULL, NULL, 'Die Recyclingfirma stellt Müllcontainer bereit.
The recycling company provides waste containers.', 3272, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to appoint', 'berufen', ARRAY[]::text[], NULL, NULL, 'Mit 35 Jahren wurde sie auf eine Professur für Alte Geschichte berufen.
At the age of 35, she was appointed as a Professor of Ancient History.', 3273, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'considerable', 'beträchtlich', ARRAY[]::text[], NULL, NULL, 'Es handelt sich bei diesem Kauf um eine beträchtliche Summe.
This purchase involves a considerable sum.', 3274, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prove itself, oneself', 'bewähren', ARRAY[]::text[], NULL, NULL, 'Sie hat sich für diesen Posten bewährt.
She has proven herself for this position.', 3275, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cope with, overcome', 'bewältigen', ARRAY[]::text[], NULL, NULL, 'Wir haben die Probleme gut bewältigt.
We have coped well with the problems.', 3276, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'district', 'Bezirk', ARRAY[]::text[], 'noun', 'der', 'Die ehemalige DDR war in Bezirke eingeteilt.
The former GDR was divided into districts.', 3277, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bloom', 'blühen', ARRAY[]::text[], NULL, NULL, 'Tulpen blühen im April.
Tulips bloom in April.', 3278, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'characteristic', 'charakteristisch', ARRAY[]::text[], NULL, NULL, 'Das momentane Wetter ist charakteristisch für diese Region.
The current weather is typical for this region.', 3279, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Chinese', 'chinesisch', ARRAY[]::text[], NULL, NULL, 'Zum Frauentag ging ich mit Cordula chinesisch essen.
At Women''s Day I went out with Cordula to eat Chinese food.', 3280, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'grateful', 'dankbar', ARRAY[]::text[], NULL, NULL, 'Ich bin dir für deine Hilfe sehr dankbar.
I am very grateful to you for your help.', 3281, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'constant, lasting', 'dauernd', ARRAY[]::text[], NULL, NULL, 'Er ist dauernd krank.
He is always sick.', 3282, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'detailed', 'detailliert', ARRAY[]::text[], NULL, NULL, 'Ich hoffe, ich kann Ihnen bald detailliertere Angaben machen.
I hope I can soon provide more detailed information.', 3283, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diagnosis', 'Diagnose', ARRAY[]::text[], 'noun', 'die', 'Wir warten noch auf die ärztliche Diagnose.
We are still waiting for the medical diagnosis.', 3284, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'discreet, confidential', 'diskret', ARRAY[]::text[], NULL, NULL, 'Behandeln Sie das Problem bitte diskret!
Handle the problem discreetly, please!', 3285, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'of Dresden', 'Dresdner', ARRAY[]::text[], NULL, NULL, 'Jeder Dresdner kennt die Frauenkirche.
Everyone of Dresden knows the Frauenkirche.', 3286, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'darkness', 'Dunkel', ARRAY[]::text[], 'noun', 'das', 'Ich gehe nicht gern im Dunkeln nach Hause.
I do not like going home in the darkness.', 3287, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diameter', 'Durchmesser', ARRAY[]::text[], 'noun', 'der', 'Der Durchmesser dieses Kreises beträgt fünf Zentimeter.
The diameter of this circle is five centimeters.', 3288, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'invitation', 'Einladung', ARRAY[]::text[], 'noun', 'die', 'Ich habe eine Einladung zur Hochzeit bekommen.
I received an invitation to the wedding.', 3289, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to submit', 'einreichen', ARRAY[]::text[], NULL, NULL, 'Sie können Ihre Unterlagen bis nächsten Montag einreichen.
You can submit your application until next Monday.', 3290, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hammer in, smash, choose', 'einschlagen', ARRAY[]::text[], NULL, NULL, 'Sie hat den Nagel in die Wand eingeschlagen.
She has hammered the nail into the wall.', 3291, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'one-sided', 'einseitig', ARRAY[]::text[], NULL, NULL, 'Meine Nachbarn führen eine sehr einseitige Beziehung.
My neighbors have a very one-sided relationship.', 3292, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(to be) in agreement', 'einverstanden', ARRAY[]::text[], NULL, NULL, 'Ich bin mit deinem Vorschlag einverstanden.
I am in agreement with your proposal.', 3293, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recommendation', 'Empfehlung', ARRAY[]::text[], 'noun', 'die', 'Dieses Gericht ist eine Empfehlung des Hauses.
This dish is a recommendation of the house.', 3294, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to please, take pleasure', 'erfreuen', ARRAY[]::text[], NULL, NULL, 'Ich bin höchst erfreut, Sie kennen zu lernen.
I am very pleased to meet you.', 3295, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to recover, relax', 'erholen', ARRAY[]::text[], NULL, NULL, 'Erholen Sie sich gut!
Relax well!', 3296, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opening', 'Eröffnung', ARRAY[]::text[], 'noun', 'die', 'Die Eröffnung des neuen Museums fand vor drei Wochen statt.
The opening of the new museum took place three weeks ago.', 3297, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shoot dead', 'erschießen', ARRAY[]::text[], NULL, NULL, 'Der Jäger hat das Reh erschossen.
The hunter shot the deer dead.', 3298, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to spare', 'ersparen', ARRAY[]::text[], NULL, NULL, 'Ich hätte dir diese unangenehme Situation gern erspart.
I would have liked to spare you this unpleasant situation.', 3299, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to extend, include', 'erstrecken', ARRAY[]::text[], NULL, NULL, 'Russland erstreckt sich über elf Zeitzonen.
Russia extends over eleven time zones.', 3300, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bear', 'ertragen', ARRAY[]::text[], NULL, NULL, 'Sie erträgt die Schmerzen nicht mehr.
She can''t bear the pain anymore.', 3301, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rock', 'Felsen', ARRAY[]::text[], 'noun', 'der', 'Auf den Felsen am Meer haben wir ein Picknick gemacht.
We had a picnic at the rocks by the sea.', 3302, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fluent', 'fließend', ARRAY[]::text[], NULL, NULL, 'Frau Engelbert spricht fließend Französisch.
Frau Engelbert speaks French fluently.', 3303, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'liquid', 'Flüssigkeit', ARRAY[]::text[], 'noun', 'die', 'Man sollte täglich mehrere Liter Flüssigkeit zu sich nehmen.
We should take in several liters of liquids daily.', 3304, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'young lady, miss', 'Fräulein', ARRAY[]::text[], 'noun', 'das', 'Guten Tag, Fräulein Müller!
Good day, Miss Mueller!', 3305, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cemetery', 'Friedhof', ARRAY[]::text[], 'noun', 'der', 'Der Friedhof liegt im Osten der Stadt.
The cemetery is located in the east of the city.', 3306, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'front', 'Front', ARRAY[]::text[], 'noun', 'die', 'Die Front des Hauses wird restauriert.
The front of the house is being restored.', 3307, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'abundance', 'Fülle', ARRAY[]::text[], 'noun', 'die', 'Es gibt eine Fülle an Möglichkeiten.
There is an abundance of options.', 3308, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mountains', 'Gebirge', ARRAY[]::text[], 'noun', 'das', 'Letzten Sommer fuhren wir ins Gebirge.
Last summer we went to the mountains.', 3309, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'financial year', 'Geschäftsjahr', ARRAY[]::text[], 'noun', 'das', 'Das Geschäftsjahr 2004 war ein erfolgreiches Jahr.
The financial year 2004 was a successful year.', 3310, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to confess', 'gestehen', ARRAY[]::text[], NULL, NULL, 'Er gesteht seinem Bruder die ganze Wahrheit.
He is confessing the whole truth to his brother.', 3311, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nevertheless', 'gleichwohl', ARRAY[]::text[], NULL, NULL, 'Viele Menschen waren einverstanden. Gleichwohl gab es auch kritische Stimmen.
Many people agreed. Nevertheless, there were also critical voices.', 3312, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'grass', 'Gras', ARRAY[]::text[], 'noun', 'das', 'Das Gras ist grün.
The grass is green.', 3313, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'city, large town', 'Großstadt', ARRAY[]::text[], 'noun', 'die', 'Berlin ist eine Großstadt.
Berlin is a large town.', 3314, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'slope, inclination', 'Hang', ARRAY[]::text[], 'noun', 'der', 'Das Auto stürzt den Hang hinunter.
The car plunges down the slope.', 3315, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conventional', 'herkömmlich', ARRAY[]::text[], NULL, NULL, 'Herkömmliche Tests weisen oft Mängel auf.
Conventional tests often have defects.', 3316, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in addition', 'hinzu', ARRAY[]::text[], NULL, NULL, 'Hinzu kommt, dass sie krank geworden sind.
In addition, they became sick.', 3317, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hill', 'Hügel', ARRAY[]::text[], 'noun', 'der', 'Auf dem Hügel steht eine kleine Kirche.
On the hill stands a small church.', 3318, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to infect', 'infizieren', ARRAY[]::text[], NULL, NULL, 'In Afrika infizieren sich immer mehr Menschen mit Aids.
In Africa, more and more people become infected with AIDS.', 3319, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'engineer', 'Ingenieur', ARRAY[]::text[], 'noun', 'der', 'Falks Vater ist Ingenieur.
Falk''s father is an engineer.', 3320, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to confront', 'konfrontieren', ARRAY[]::text[], NULL, NULL, 'Die Eltern wollten ihn nie mit der Realität konfrontieren.
The parents never wanted to confront him with reality.', 3321, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'congress, convention', 'Kongress', ARRAY[]::text[], 'noun', 'der', 'Der Kongress findet auf der Neuen Messe statt.
The congress will take place at the new fairgrounds.', 3322, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'free (of charge)', 'kostenlos', ARRAY[]::text[], NULL, NULL, 'Bei Fragen können Sie diese kostenlose Telefonnummer anrufen.
If you have questions you can call this toll-free telephone number.', 3323, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nothing but, just', 'lauter', ARRAY[]::text[], NULL, NULL, 'Es gibt in dieser Stadt lauter tolle Dinge zu entdecken.
There is nothing but great things in this city to discover.', 3324, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put out, delete', 'löschen', ARRAY[]::text[], NULL, NULL, 'Um Mitternacht war der Brand endgültig gelöscht.
At midnight the fire was put out finally.', 3325, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'male', 'männlich', ARRAY[]::text[], NULL, NULL, 'Wie nennt man ein männliches Pferd?
How do you call a male horse?', 3326, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mechanical', 'mechanisch', ARRAY[]::text[], NULL, NULL, 'Wir haben noch eine alte mechanische Schreibmaschine.
We still have an old mechanical typewriter.', 3327, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'by the media', 'medial', ARRAY[]::text[], NULL, NULL, 'Der Informationsaustausch findet auf medialem Weg statt.
The exchange of information will take place by the media.', 3328, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'monthly', 'monatlich', ARRAY[]::text[], NULL, NULL, 'Die monatliche Miete beträgt 300 Euro.
The monthly rent is 300 €.', 3329, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'muscle', 'Muskel', ARRAY[]::text[], 'noun', 'der', 'Beim Sport trainiert man die Muskeln.
By doing sports you train the muscles.', 3330, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'proof, evidence, certificate', 'Nachweis', ARRAY[]::text[], 'noun', 'der', 'Wir benötigen einen Nachweis darüber, dass Sie studieren.
We need a certificate that shows that you are studying.', 3331, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ninety', 'neunzig', ARRAY[]::text[], NULL, NULL, 'Neunzig Personen wurden befragt.
Ninety people were interviewed.', 3332, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'frequently', 'oftmals', ARRAY[]::text[], NULL, NULL, 'Oftmals wurde Dominique gefragt, ob er Mädchen oder Junge sei.
Frequently Dominique was asked if he was a girl or a boy.', 3333, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'orientation', 'Orientierung', ARRAY[]::text[], 'noun', 'die', 'In großen Städten verliere ich leicht die Orientierung.
In big cities, I lose the orientation easily.', 3334, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'local', 'örtlich', ARRAY[]::text[], NULL, NULL, 'Bei dieser Operation werden Sie nur örtlich betäubt.
At this surgery you will only get a local anesthetic.', 3335, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'physical', 'physisch', ARRAY[]::text[], NULL, NULL, 'Meine physische Verfassung ist zur Zeit nicht die stabilste.
My physical condition is currently not the most stable one.', 3336, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'car, auto', 'PKW', ARRAY[]::text[], 'noun', 'der', 'Die Anreise erfolgt mit dem PKW.
The journey to the destination is by car.', 3337, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Polish', 'polnisch', ARRAY[]::text[], NULL, NULL, 'Zbigniew ist polnischer Staatsbürger.
Zbigniew is a Polish citizen.', 3338, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'precise', 'präzise', ARRAY[]::text[], NULL, NULL, 'Bitte machen Sie Ihre Angaben so präzise wie möglich!
Please give your details as precisely as possible!', 3339, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rhythm', 'Rhythmus', ARRAY[]::text[], 'noun', 'der', 'Zu diesem Rhythmus kann man gut tanzen.
To this rhythm, you can dance well.', 3340, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consideration', 'Rücksicht', ARRAY[]::text[], 'noun', 'die', 'Du solltest Rücksicht auf deine Geschwister nehmen.
You should be considerate of your siblings.', 3341, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'together with, along with', 'samt', ARRAY[]::text[], NULL, NULL, 'Im Saal war die ganze Jahrgangsstufe samt Lehrern vertreten.
In the hall the whole grade along with teachers was represented.', 3342, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to float, hover, be in the balance', 'schweben', ARRAY[]::text[], NULL, NULL, 'Die Feder schwebt zu Boden.
The feather is floating to the ground.', 3343, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'senate', 'Senat', ARRAY[]::text[], 'noun', 'der', 'Der Senat hat eine Entscheidung getroffen.
The Senate has made a decision.', 3344, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'seventeen', 'siebzehn', ARRAY[]::text[], NULL, NULL, 'Er ist erst siebzehn Jahre alt.
He is only seventeen years old.', 3345, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'immediately', 'sogleich', ARRAY[]::text[], NULL, NULL, 'Faust fand sogleich Argumente, um Gretchen zu überzeugen.
Faust immediately found arguments to convince Gretchen.', 3346, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'control, steering', 'Steuerung', ARRAY[]::text[], 'noun', 'die', 'Die Steuerung der Maschinen erfolgt von diesem Raum aus.
The control of the machines comes out of this room.', 3347, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pride', 'Stolz', ARRAY[]::text[], 'noun', 'der', 'Sie empfindet sehr viel Stolz für ihre Kinder.
She takes very much pride in her children.', 3348, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shine', 'strahlen', ARRAY[]::text[], NULL, NULL, 'Die Sonne strahlt vom Himmel.
The sun shines from the sky.', 3349, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'symbolic', 'symbolisch', ARRAY[]::text[], NULL, NULL, 'Diese Geste hatte symbolischen Wert.
This gesture had a symbolic value.', 3350, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'participation', 'Teilnahme', ARRAY[]::text[], 'noun', 'die', 'Ich freue mich über die rege Teilnahme am Seminar.
I am pleased with the enthusiastic participation in the seminar.', 3351, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to (make a telephone) call', 'telefonieren', ARRAY[]::text[], NULL, NULL, 'Moment, ich telefoniere gerade.
Just a moment, I''m just making a telephone call.', 3352, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'faithful', 'treu', ARRAY[]::text[], NULL, NULL, 'Hunde sind treue Weggefährten.
Dogs are faithful companions.', 3353, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to comfort', 'trösten', ARRAY[]::text[], NULL, NULL, 'Niemand konnte ihn in dieser Situation trösten.
No one could comfort him in this situation.', 3354, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get over, survive', 'überstehen', ARRAY[]::text[], NULL, NULL, 'Wir haben die schlimmste Zeit nun überstanden.
We have survived the worst time of it now.', 3355, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'universe', 'Universum', ARRAY[]::text[], 'noun', 'das', 'Wie groß ist das Universum?
How big is the universe?', 3356, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'entertainment, conversation', 'Unterhaltung', ARRAY[]::text[], 'noun', 'die', 'Die Teilnehmer haben eine sehr interessante Unterhaltung geführt.
The participants have had a very interesting conversation.', 3357, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'documents', 'Unterlagen', ARRAY[]::text[], 'noun', 'die', 'Wir benötigen noch verschiedene Unterlagen von Ihnen.
We still need several documents from you.', 3358, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sign', 'unterschreiben', ARRAY[]::text[], NULL, NULL, 'Dorothea hat ihren Mietvertrag gestern unterschrieben.
Dorothea has signed her lease yesterday.', 3359, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arrange, see to it', 'veranlassen', ARRAY[]::text[], NULL, NULL, 'Die Geschäftsführerin hat eine Versammlung für heute Nachmittag veranlasst.
The manager has arranged a meeting for this afternoon.', 3360, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'organization, association, unification', 'Vereinigung', ARRAY[]::text[], 'noun', 'die', 'Er wurde der Mitgliedschaft in einer kriminellen Vereinigung angeklagt.
He was accused of having a membership in a criminal organization.', 3361, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arrest', 'verhaften', ARRAY[]::text[], NULL, NULL, 'Ein Verdächtiger wurde verhaftet.
A suspect was arrested.', 3362, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to run, associate', 'verkehren', ARRAY[]::text[], NULL, NULL, 'Der Zug zwischen Halle und Leipzig verkehrt jetzt alle halbe Stunde.
The train between Halle and Leipzig runs now every half hour.', 3363, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'supposed', 'vermeintlich', ARRAY[]::text[], NULL, NULL, 'Die Opposition versucht, vermeintliche Schwächen der Regierung auszunutzen.
The opposition is trying to exploit alleged weaknesses of the government.', 3364, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to miss', 'verpassen', ARRAY[]::text[], NULL, NULL, 'Ich habe den Zug verpasst.
I missed the train.', 3365, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'replacement, substitute', 'Vertretung', ARRAY[]::text[], 'noun', 'die', 'Während ihres Erziehungsurlaubs wird es eine Vertretung geben.
During her maternity leave there will be a substitute.', 3366, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'adult education centre', 'Volkshochschule', ARRAY[]::text[], 'noun', 'die', 'Christiane gibt Kurse an der Volkshochschule.
Christiane holds classes at the adult education centre.', 3367, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go ahead, make progress', 'vorangehen', ARRAY[]::text[], NULL, NULL, 'Die Arbeit geht gut voran.
The work is progressing well.', 3368, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ahead, forward', 'voraus', ARRAY[]::text[], NULL, NULL, 'Ruben ist dir im Kopfrechnen voraus.
Ruben is ahead in mental arithmetic.', 3369, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'previous', 'vorig', ARRAY[]::text[], NULL, NULL, 'Vorige Woche war ich krank.
Previous week I was sick.', 3370, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'caution', 'Vorsicht', ARRAY[]::text[], 'noun', 'die', 'Beim Autofahren ist viel Vorsicht geboten.
Caution is required when driving.', 3371, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'awake', 'wach', ARRAY[]::text[], NULL, NULL, 'Opa liegt nachts oft lange wach.
Grandpa often lies awake for a long time at night.', 3372, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'probability', 'Wahrscheinlichkeit', ARRAY[]::text[], 'noun', 'die', 'Die Wahrscheinlichkeit, dass er kommt, ist sehr gering.
The probability that he will come is very low.', 3373, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cheek', 'Wange', ARRAY[]::text[], 'noun', 'die', 'Du hast rote Wangen.
You''re having red cheeks.', 3374, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pass on', 'weitergeben', ARRAY[]::text[], NULL, NULL, 'Geben Sie diese Informationen nicht weiter!
Don''t pass on this information!', 3375, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to carry on, continue', 'weitermachen', ARRAY[]::text[], NULL, NULL, 'Ich würde diesen Job gern weitermachen.
I would like to continue doing this job.', 3376, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tool', 'Werkzeug', ARRAY[]::text[], 'noun', 'das', 'Werkzeuge sind in der unteren Schublade.
Tools are in the bottom drawer.', 3377, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'drawing', 'Zeichnung', ARRAY[]::text[], 'noun', 'die', 'Sie hat viele Zeichnungen aus ihrer Kindheit.
She has a lot of drawings from her childhood.', 3378, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put on, get oneself sth', 'zulegen', ARRAY[]::text[], NULL, NULL, 'Wir haben uns ein neues Auto zugelegt.
We got ourselves a new car.', 3379, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'increase', 'Zunahme', ARRAY[]::text[], 'noun', 'die', 'Wegen starker Zunahme der Studierenden müssen Zulassungsbeschränkungen vorgenommen werden.
Due to strong increase in enrollment of students entry restrictions must be made.', 3380, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be entitled', 'zustehen', ARRAY[]::text[], NULL, NULL, 'Diese Auszeichnung steht ihm wirklich zu.
He really is entitled to get this award.', 3381, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'onion, bulb', 'Zwiebel', ARRAY[]::text[], 'noun', 'die', 'Wir haben keine Zwiebeln mehr.
We have no more onions.', 3382, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lift off, withdraw', 'abheben', ARRAY[]::text[], NULL, NULL, 'Das Flugzeug hebt pünktlich ab.
The plane will lift off on time.', 3383, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'refusal, rejection', 'Ablehnung', ARRAY[]::text[], 'noun', 'die', 'Das Reformkonzept stieß auf Zurückhaltung und Ablehnung.
The reform concept met with reluctance and rejection.', 3384, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cut off', 'abschneiden', ARRAY[]::text[], NULL, NULL, 'Schneidest du deine Haare selbst ab?
Do you cut off your hair by yourself?', 3385, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'vote, coordination', 'Abstimmung', ARRAY[]::text[], 'noun', 'die', 'Die Entscheidung wurde in Abstimmung mit der Personalabteilung getroffen.
The decision was made in coordination with the Personnel Department.', 3386, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to act', 'agieren', ARRAY[]::text[], NULL, NULL, 'UNICEF agiert weltweit.
UNICEF acts worldwide.', 3387, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at most', 'allenfalls', ARRAY[]::text[], NULL, NULL, 'Wir könnten Ihnen allenfalls eine Halbtagsstelle anbieten.
We could at most offer you a part-time position.', 3388, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'alternative', 'alternativ', ARRAY[]::text[], NULL, NULL, 'Mehr und mehr Menschen informieren sich über alternative Heilmethoden.
More and more people want to learn about alternative healing methods.', 3389, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to order, arrange', 'anordnen', ARRAY[]::text[], NULL, NULL, 'Es wird Waffenstillstand angeordnet.
A ceasefire is arranged.', 3390, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'order', 'Anordnung', ARRAY[]::text[], 'noun', 'die', 'Wer gibt hier die Anordnungen?
Who gives the orders here?', 3391, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stimulus, idea', 'Anregung', ARRAY[]::text[], 'noun', 'die', 'In diesem Heft finden Sie viele Anregungen für Bastelarbeiten.
In this magazine you will find many ideas for crafts.', 3392, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to prepare, cause', 'anrichten', ARRAY[]::text[], NULL, NULL, 'Das Erdbeben richtete großen Schaden an.
The earthquake caused a lot of damage.', 3393, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to line up', 'anstehen', ARRAY[]::text[], NULL, NULL, 'Wir haben lange vor dem Kino angestanden.
We lined up in front of the cinema for a long time.', 3394, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'medical', 'ärztlich', ARRAY[]::text[], NULL, NULL, 'Ärzte müssen ihre ärztliche Schweigepflicht ernst nehmen.
Physicians need to take their medical confidentiality seriously.', 3395, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to call out, up, upon', 'aufrufen', ARRAY[]::text[], NULL, NULL, 'Die Lehrerin ruft einen Schüler auf.
The teacher is calling on a student.', 3396, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'essay', 'Aufsatz', ARRAY[]::text[], 'noun', 'der', 'Im Deutschunterricht werden Aufsätze geschrieben.
In German class you write essays.', 3397, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to write down', 'aufschreiben', ARRAY[]::text[], NULL, NULL, 'Schreib deine Ideen auf, damit du sie nicht vergisst!
Write down your ideas, so you won''t forget them!', 3398, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to jump up, on, burst open', 'aufspringen', ARRAY[]::text[], NULL, NULL, 'Joschka sprang von seinem Platz auf.
Joschka jumped up from his seat.', 3399, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'extravagant, costly', 'aufwendig', ARRAY[]::text[], NULL, NULL, 'Ihre Gastgeber hatten ein aufwendiges Mahl vorbereitet.
Their hosts had prepared an extravagant meal.', 3400, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to extend, expand', 'ausdehnen', ARRAY[]::text[], NULL, NULL, 'Hoffentlich dehnt er seine Rede nicht zu sehr aus!
I hope he won''t expand his speech too much!', 3401, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take advantage', 'ausnutzen', ARRAY[]::text[], NULL, NULL, 'Das schöne Wetter müssen wir ausnutzen.
We have to take advantage of the nice weather.', 3402, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to try out', 'ausprobieren', ARRAY[]::text[], NULL, NULL, 'Habt ihr euer neues Kartenspiel schon ausprobiert?
Have you already tried out your new card game?', 3403, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to make way, evade, avoid', 'ausweichen', ARRAY[]::text[], NULL, NULL, 'Der Fahrer konnte dem Hindernis nicht mehr ausweichen.
The driver could not avoid the obstacle anymore.', 3404, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'oven', 'Backofen', ARRAY[]::text[], 'noun', 'der', 'Du musst den Backofen 10 Minuten vorheizen.
You have to preheat the oven for 10 minutes.', 3405, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bacterium', 'Bakterie', ARRAY[]::text[], 'noun', 'die', 'Bakterien kann man mit Antibiotika bekämpfen.
Bacteria can be fought with antibiotics.', 3406, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to intend', 'beabsichtigen', ARRAY[]::text[], NULL, NULL, 'Er beabsichtigt, ein Praktikum zu machen.
He intends to do an internship.', 3407, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to restrict, damage', 'beeinträchtigen', ARRAY[]::text[], NULL, NULL, 'Rauchen beeinträchtigt die Gesundheit.
Smoking damages health.', 3408, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'results', 'Befund', ARRAY[]::text[], 'noun', 'der', 'In einer Woche kommt der Befund aus dem Labor.
In a week the results are going to get here from the lab.', 3409, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to proceed', 'begeben', ARRAY[]::text[], NULL, NULL, 'Nachdem das Flugzeug gelandet war, begaben sich alle Passagiere zu den Ausgängen.
After the plane had landed, all the passengers proceeded to the exits.', 3410, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to commit, make, celebrate', 'begehen', ARRAY[]::text[], NULL, NULL, 'Es ist ein Verbrechen begangen worden.
A crime has been committed.', 3411, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'remarkable', 'bemerkenswert', ARRAY[]::text[], NULL, NULL, 'Judith Hermann hat ein bemerkenswertes Buch verfasst.
Judith Herman has written a remarkable book.', 3412, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'effort', 'Bemühung', ARRAY[]::text[], 'noun', 'die', 'Trotz aller Bemühungen scheiterte unser Plan.
Despite all efforts our plan failed.', 3413, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'observer', 'Beobachter', ARRAY[]::text[], 'noun', 'der', 'Die UNO sendet Beobachter ins Krisengebiet.
The UN is sending observers to the crisis area.', 3414, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'advisor, consultant', 'Berater', ARRAY[]::text[], 'noun', 'der', 'Politiker haben viele Berater, die oft widersprüchlicher Meinung sind.
Politicians have a lot of consultants who often have contradictory opinions.', 3415, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rescue, hide', 'bergen', ARRAY[]::text[], NULL, NULL, 'Die Verunglückten konnten erst nach Stunden geborgen werden.
The casualties were only rescued after several hours.', 3416, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to eliminate', 'beseitigen', ARRAY[]::text[], NULL, NULL, 'Das Chaos nach der Party wird von allen gemeinsam beseitigt.
The chaos after the party will be eliminated from everybody together.', 3417, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'concerned', 'besorgt', ARRAY[]::text[], NULL, NULL, 'Er sah sie mit besorgter Miene an.
He looked at her with a concerned expression.', 3418, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'observer', 'Betrachter', ARRAY[]::text[], 'noun', 'der', 'Was fällt dem Betrachter des Bildes auf?
What is the observer of the picture noticing?', 3419, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'operating system', 'Betriebssystem', ARRAY[]::text[], 'noun', 'das', 'Unser Computer benötigt ein neues Betriebssystem.
Our computer needs a new operating system.', 3420, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'screen, monitor', 'Bildschirm', ARRAY[]::text[], 'noun', 'der', 'Auf dem Bildschirm ist nichts zu sehen.
O the screen there is nothing to see.', 3421, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'blossom', 'Blüte', ARRAY[]::text[], 'noun', 'die', 'Die Blüten dieser Pflanze sind gelb-rot.
The bloosoms of this plant are yellow-red.', 3422, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'glasses', 'Brille', ARRAY[]::text[], 'noun', 'die', 'Ich habe meine Brille verlegt.
I misplaced my glasses.', 3423, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to characterize', 'charakterisieren', ARRAY[]::text[], NULL, NULL, 'Sie wird oft als selbstbewusst charakterisiert.
She is often characterized as self-confident.', 3424, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chronic', 'chronisch', ARRAY[]::text[], NULL, NULL, 'Simon hat eine chronische Bronchitis.
Simon has a chronic bronchitis.', 3425, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'data processing', 'Datenverarbeitung', ARRAY[]::text[], 'noun', 'die', 'Durch die elektronische Datenverarbeitung wird vieles erleichtert.
Through electronic data processing many things become easier.', 3426, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to demonstrate', 'demonstrieren', ARRAY[]::text[], NULL, NULL, 'Letztes Jahr demonstrierten viele Studenten gegen Studiengebühren.
Last year, many students were demonstrating against tuition fees.', 3427, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to document', 'dokumentieren', ARRAY[]::text[], NULL, NULL, 'Es ist wichtig, jeden Arbeitsschritt zu dokumentieren.
It is important to document each step of the work.', 3428, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thirteen', 'dreizehn', ARRAY[]::text[], NULL, NULL, 'Sie hat dreizehn Kinder, zehn Mädchen und drei Jungen.
She has thirteen children, ten girls and three boys.', 3429, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'confused, in a mess', 'durcheinander', ARRAY[]::text[], NULL, NULL, 'Nach dem Unfall war er so durcheinander, dass er nicht weiterfahren wollte.
After the accident he was so confused that he did not want to continue driving.', 3430, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gloomy', 'düster', ARRAY[]::text[], NULL, NULL, 'Heute war ein grauer, düsterer Tag.
Today was a gray, gloomy day.', 3431, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'efficient', 'effizient', ARRAY[]::text[], NULL, NULL, 'Effizientes, schnelles Arbeiten ist wichtig.
Efficient, fast work is important.', 3432, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'owner', 'Eigentümer', ARRAY[]::text[], 'noun', 'der', 'Wir suchen den Eigentümer dieses Autos.
We are looking for the owner of this car.', 3433, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to let in, get involved', 'einlassen', ARRAY[]::text[], NULL, NULL, 'Lass dich nicht auf Glücksspiele ein!
Don''t get involved in gambling!', 3434, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'entry, registration', 'Eintragung', ARRAY[]::text[], 'noun', 'die', 'In einem Tagebuch macht man persönliche Eintragungen.
In a diary you make personal entries.', 3435, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'emotional', 'emotional', ARRAY[]::text[], NULL, NULL, 'Das war ein sehr emotionaler Film.
That was a very emotional film.', 3436, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ensemble', 'Ensemble', ARRAY[]::text[], 'noun', 'das', 'Heute spielt ein berühmtes Ensemble aus Österreich.
Today a famous ensemble from Austria is going to play.', 3437, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'disappointment', 'Enttäuschung', ARRAY[]::text[], 'noun', 'die', 'Lucies Enttäuschung über die Absage ist groß.
Lucie''s disappointment about the cancellation is great.', 3438, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to explore, investigate', 'erforschen', ARRAY[]::text[], NULL, NULL, 'Im 21. Jahrhundert begannen die Menschen, auch weiter entfernte Planeten zu erforschen.
In the 21 Century, people began to explore planets, which are more distant, too.', 3439, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'within reach, reachable', 'erreichbar', ARRAY[]::text[], NULL, NULL, 'Berlin ist von Leipzig aus gut mit dem Zug erreichbar.
From Leipzig, Berlin can easily be reached by train.', 3440, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exhaust', 'erschöpfen', ARRAY[]::text[], NULL, NULL, 'Die finanziellen Ressourcen des Unternehmens sind erschöpft.
The company''s financial resources are exhausted.', 3441, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to make more difficult', 'erschweren', ARRAY[]::text[], NULL, NULL, 'Ein starker Wind erschwerte die Arbeit.
A strong wind made it more difficult to work.', 3442, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to wake up', 'erwachen', ARRAY[]::text[], NULL, NULL, 'Oskar erwachte plötzlich aus einem tiefen Traum.
Oscar suddenly woke up from a deep dream.', 3443, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to wake, arouse', 'erwecken', ARRAY[]::text[], NULL, NULL, 'Blumen können große Freude erwecken.
Flowers can arouse great joy.', 3444, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fist', 'Faust', ARRAY[]::text[], 'noun', 'die', 'Moritz ballte seine Hand zur Faust.
Moritz clenched his fist.', 3445, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'festival', 'Festival', ARRAY[]::text[], 'noun', 'das', 'Auf dem Festival waren sehr viele Menschen.
At the festival were very many people.', 3446, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to flee', 'flüchten', ARRAY[]::text[], NULL, NULL, 'Die Verbrecher konnten durch den Hintereingang flüchten.
The criminals were able to flee through the back door.', 3447, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to eat', 'fressen', ARRAY[]::text[], NULL, NULL, 'Katzen fressen Mäuse.
Cats eat mice.', 3448, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gallery', 'Galerie', ARRAY[]::text[], 'noun', 'die', 'Hast du schon die neue Galerie besichtigt?
Have you visited the new gallery yet?', 3449, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'vegetables', 'Gemüse', ARRAY[]::text[], 'noun', 'das', 'Zum Mittag gab es Schnitzel, Kartoffeln und Gemüse.
For lunch, there was schnitzel, potatoes and vegetables.', 3450, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comfortable, cosy', 'gemütlich', ARRAY[]::text[], NULL, NULL, 'Wir haben uns einen gemütlichen Abend gemacht.
We made ourselves a cozy evening.', 3451, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'approval, permit, permission', 'Genehmigung', ARRAY[]::text[], 'noun', 'die', 'Für Ihr Vorhaben brauchen Sie eine amtliche Genehmigung.
For your project you need an official permission.', 3452, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'eager, anxious, tense', 'gespannt', ARRAY[]::text[], NULL, NULL, 'Ich bin gespannt auf den Film.
I''m anxious to see the movie.', 3453, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'so to speak, as it were', 'gewissermaßen', ARRAY[]::text[], NULL, NULL, 'Diese Erkenntnis kam gewissermaßen über Nacht.
This realization came so to speak overnight.', 3454, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to water, pour', 'gießen', ARRAY[]::text[], NULL, NULL, 'Wer gießt meine Pflanzen, wenn ich weg bin?
Who will pour my plants when I''m gone?', 3455, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be alike, be just like', 'gleichen', ARRAY[]::text[], NULL, NULL, 'Agnes gleicht ihrer Mutter sehr.
Agnes is a lot like her mother.', 3456, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'grandfather', 'Großvater', ARRAY[]::text[], 'noun', 'der', 'Lutz lebt bei seinem Großvater.
Lutz lives with his grandfather.', 3457, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'primary school', 'Grundschule', ARRAY[]::text[], 'noun', 'die', 'Im Alter von 6 Jahren gehen Kinder in die Grundschule.
At the age of 6, children go to primary school.', 3458, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to greet', 'grüßen', ARRAY[]::text[], NULL, NULL, 'Sie grüßt mich immer sehr freundlich.
She greets me always very friendly.', 3459, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hatred', 'Hass', ARRAY[]::text[], 'noun', 'der', 'Kriege provozieren Hass und Gewalt.
Wars provoke hatred and violence.', 3460, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to come from, follow', 'hervorgehen', ARRAY[]::text[], NULL, NULL, 'Das Projekt ging aus einer studentischen Veranstaltung hervor.
The project came from a student event.', 3461, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'over, across', 'hinüber', ARRAY[]::text[], NULL, NULL, 'Sie lief zum Taxistand hinüber.
She ran over to the taxi stand.', 3462, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cave', 'Höhle', ARRAY[]::text[], 'noun', 'die', 'Wir haben eine Höhle besichtigt, in der es Tropfsteine gibt.
We visited a cave in which there are stalactites.', 3463, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'town centre, downtown', 'Innenstadt', ARRAY[]::text[], 'noun', 'die', 'Die Leipziger Innenstadt ist gut überschaubar.
You can overview the town centre of Leipzig well.', 3464, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intelligent', 'intelligent', ARRAY[]::text[], NULL, NULL, 'Tina ist eine sehr intelligente Frau.
Tina is a very intelligent woman.', 3465, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be wrong', 'irren', ARRAY[]::text[], NULL, NULL, 'Du irrst dich, er ist kein Chirurg, sondern Zahnarzt.
You''re wrong, he is not a surgeon, but a dentist.', 3466, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'jazz', 'Jazz', ARRAY[]::text[], 'noun', 'der', 'Carmen hört gern Jazz.
Carmen likes listening to jazz.', 3467, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'monastery, convent', 'Kloster', ARRAY[]::text[], 'noun', 'das', 'Mönche und Nonnen leben im Kloster.
Monks and nuns live in the monastery.', 3468, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coal', 'Kohle', ARRAY[]::text[], 'noun', 'die', 'Früher heizten die Menschen mit Kohle.
In the past, people heated with coal.', 3469, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consumer', 'Konsument', ARRAY[]::text[], 'noun', 'der', 'In der Marktwirtschaft spricht man von Produzenten und Konsumenten.
In the market economy you speak of producers and consumers.', 3470, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agricultural', 'landwirtschaftlich', ARRAY[]::text[], NULL, NULL, 'Jörn leitet einen landwirtschaftlichen Betrieb.
Jörn runs an agricultural company.', 3471, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'noise', 'Lärm', ARRAY[]::text[], 'noun', 'der', 'Das Müllauto macht morgens Lärm.
The garbage truck makes noise in the mornings.', 3472, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to listen, eavesdrop', 'lauschen', ARRAY[]::text[], NULL, NULL, 'Hast du wieder an der Tür gelauscht?
Have you been listening at the door again?', 3473, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'litre', 'Liter', ARRAY[]::text[], 'noun', 'der', 'Man sollte jeden Tag mindestens zwei Liter Flüssigkeit trinken.
You should drink at least two liters of liquids every day.', 3474, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lure, tempt', 'locken', ARRAY[]::text[], NULL, NULL, 'Tante Ilse lockt ihren Hund mit Futter.
Aunt Ilse lures her dog with food.', 3475, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pub, bar', 'Lokal', ARRAY[]::text[], 'noun', 'das', 'Das Lokal schließt um Mitternacht.
The pub closes at midnight.', 3476, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get rid of', 'loswerden', ARRAY[]::text[], NULL, NULL, 'Theo möchte sein Auto gern loswerden.
Theo wants to get rid of his car.', 3477, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'painting', 'Malerei', ARRAY[]::text[], 'noun', 'die', 'Wie gefällt dir die moderne Malerei?
How do you like modern painting?', 3478, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'significant, decisive', 'maßgeblich', ARRAY[]::text[], NULL, NULL, 'Agnes Helbig war maßgeblich an Gerhards Erfolg beteiligt.
Agnes was instrumental in Gerhard Helbig success.', 3479, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scale, yardstick, standard', 'Maßstab', ARRAY[]::text[], 'noun', 'der', 'Diese Straßenkarte ist im Maßstab 1:5000.
This road map is on a scale of 1:5000.', 3480, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'matter', 'Materie', ARRAY[]::text[], 'noun', 'die', 'Erst seit dem Urknall gibt es Materie, Raum und Zeit.
Only since the Big Bang there is matter, space and time.', 3481, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mobile', 'mobil', ARRAY[]::text[], NULL, NULL, 'Von Arbeitnehmern wird erwartet, mobil zu sein.
Employees are expected to be mobile.', 3482, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'motor', 'motorisch', ARRAY[]::text[], NULL, NULL, 'Die Ärzte suchen nach Gründen für seine motorischen Störungen.
The doctors are looking for reasons for his motor disorders.', 3483, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coin', 'Münze', ARRAY[]::text[], 'noun', 'die', 'Ronald sammelt alte Münzen.
Ronald collects old coins.', 3484, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wet', 'nass', ARRAY[]::text[], NULL, NULL, 'Mein Pulli ist nass.
My sweater is wet.', 3485, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'network', 'Netzwerk', ARRAY[]::text[], 'noun', 'das', 'Das Unternehmen ist gerade dabei, ein internes Netzwerk einzurichten.
The company is in the process of setting up an internal network.', 3486, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'operative', 'operativ', ARRAY[]::text[], NULL, NULL, 'Die operativen Kosten sind viel zu hoch.
The operative costs are much too high.', 3487, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Pakistani', 'pakistanisch', ARRAY[]::text[], NULL, NULL, 'In der pakistanischen Hauptstadt kam es zu Unruhen.
In the Pakistani capital, there was unrest.', 3488, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'philosophical', 'philosophisch', ARRAY[]::text[], NULL, NULL, 'Das ist ein sehr philosophisches Buch.
This is a very philosophical book.', 3489, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'internship', 'Praktikum', ARRAY[]::text[], 'noun', 'das', 'Maria hat ein Praktikum in Italien gemacht.
Mary has done an internship in Italy.', 3490, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'realistic', 'realistisch', ARRAY[]::text[], NULL, NULL, 'Diese Idee ist nicht realistisch.
This idea is not realistic.', 3491, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fall, decline', 'Rückgang', ARRAY[]::text[], 'noun', 'der', 'Wir haben einen Rückgang der Zuschauerzahlen zu verzeichnen.
We have to record a decline in the numbers of viewers.', 3492, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'objective, matter-of-fact', 'sachlich', ARRAY[]::text[], NULL, NULL, 'Sie versteht es, sachlich und nüchtern zu argumentieren.
She knows how to argue objectively and unemotional.', 3493, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sack', 'Sack', ARRAY[]::text[], 'noun', 'der', 'Im Keller haben wir noch zwei Säcke Kartoffeln.
In the basement we still have two bags of potatoes.', 3494, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'debtor', 'Schuldner', ARRAY[]::text[], 'noun', 'der', 'Wenn ein Schuldner nicht zahlt, kann der Gläubiger gerichtlich gegen ihn vorgehen.
If a debtor fails to pay, the creditor can take legal action against him.', 3495, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Swiss', 'schweizerisch', ARRAY[]::text[], NULL, NULL, 'Wir fliegen mit einer schweizerischen Fluggesellschaft in den Urlaub.
We are going to fly with a Swiss airline in the holidays.', 3496, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to confiscate, guarantee', 'sicherstellen', ARRAY[]::text[], NULL, NULL, 'Man muss sicherstellen, dass Gesetze auch eingehalten werden.
You must guarantee that laws are being respected.', 3497, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to shine, reflect', 'spiegeln', ARRAY[]::text[], NULL, NULL, 'Sonjas Gesicht spiegelt sich im See.
Sonja''s face is reflected in the lake.', 3498, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(type of) sport, discipline', 'Sportart', ARRAY[]::text[], 'noun', 'die', 'Welche Sportart magst du am liebsten?
Which type of sport do you like best?', 3499, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'trunk, stem, tribe', 'Stamm', ARRAY[]::text[], 'noun', 'der', 'Der Stamm dieses Baumes hat einen Durchmesser von einem Meter.
The trunk of this tree has a diameter of one meter.', 3500, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to steal', 'stehlen', ARRAY[]::text[], NULL, NULL, 'Hotzenplotz hat ein Fahrrad gestohlen.
Hotzenplotz has stolen a bicycle.', 3501, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stripe, strip', 'Streifen', ARRAY[]::text[], 'noun', 'der', 'Sie hat einen Rock mit grünen Streifen.
She has a skirt with green stripes.', 3502, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cup', 'Tasse', ARRAY[]::text[], 'noun', 'die', 'Ich trinke eine Tasse Tee.
I am drinking a cup of tea.', 3503, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'carpet', 'Teppich', ARRAY[]::text[], 'noun', 'der', 'Justus gefällt unser gelber Teppich nicht.
Justus does not like our yellow carpet.', 3504, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'devil', 'Teufel', ARRAY[]::text[], 'noun', 'der', 'Der Teufel lebt in der Hölle.
The devil lives in hell.', 3505, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'superfluous', 'überflüssig', ARRAY[]::text[], NULL, NULL, 'Deine Sorge ist überflüssig.
Your worry is superfluous.', 3506, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'screening, check, inspection', 'Überprüfung', ARRAY[]::text[], 'noun', 'die', 'Eine ständige Überprüfung der Produktqualität ist wünschenswert.
A constant inspection of the product quality is desirable.', 3507, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to monitor, keep under surveillance', 'überwachen', ARRAY[]::text[], NULL, NULL, 'Die Polizei überwacht das Haus rund um die Uhr.
The police is monitoring the house around the clock.', 3508, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to cover, put on, overdraw', 'überziehen', ARRAY[]::text[], NULL, NULL, 'Die Bauarbeiter haben sich Regenjacken übergezogen.
The construction workers have put on rain jackets.', 3509, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to convert, change', 'umwandeln', ARRAY[]::text[], NULL, NULL, 'Der Generator wandelt Bewegungsenergie in elektrische Energie um.
The generator converts kinetic energy into electrical energy.', 3510, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'invisible', 'unsichtbar', ARRAY[]::text[], NULL, NULL, 'Mit einer Tarnkappe kann man unsichtbar werden.
With a magic hat you can become invisible.', 3511, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nonsense', 'Unsinn', ARRAY[]::text[], 'noun', 'der', 'Du redest Unsinn.
You''re talking nonsense.', 3512, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meanwhile', 'unterdessen', ARRAY[]::text[], NULL, NULL, 'Du warst lange weg. Unterdessen hat sich hier viel getan.
You were gone for a long time. In the meantime, a lot has changed here.', 3513, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'binding, friendly', 'verbindlich', ARRAY[]::text[], NULL, NULL, 'Ihre Teilnahme an der Informationsveranstaltung ist verbindlich.
Your participation in the information session is binding.', 3514, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ban, prohibition', 'Verbot', ARRAY[]::text[], 'noun', 'das', 'Ich halte dieses Verbot für gerechtfertigt.
I think this ban is justified.', 3515, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'embarrassed', 'verlegen', ARRAY[]::text[], NULL, NULL, 'Als man ihn lobte, wurde er ganz verlegen.
When they praised him, he got quite embarrassed.', 3516, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'assumption, presumption', 'Vermutung', ARRAY[]::text[], 'noun', 'die', 'Meine Vermutung hat sich bestätigt.
My assumption has been confirmed.', 3517, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'meeting, gathering, assembly', 'Versammlung', ARRAY[]::text[], 'noun', 'die', 'Die Versammlung findet erst morgen statt.
The meeting will take place tomorrow.', 3518, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expected', 'voraussichtlich', ARRAY[]::text[], NULL, NULL, 'Der voraussichtliche Abflug findet in zirka zwei Stunden statt.
The expected departure will take place in about two hours.', 3519, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'washing, laundry', 'Wäsche', ARRAY[]::text[], 'noun', 'die', 'Hängst du bitte die Wäsche auf?
Can you please hang out the laundry to dry?', 3520, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'workshop, garage', 'Werkstatt', ARRAY[]::text[], 'noun', 'die', 'Das Auto muss zur Durchsicht in die Werkstatt.
The car needs to be inspected at the workshop.', 3521, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'economic policy', 'Wirtschaftspolitik', ARRAY[]::text[], 'noun', 'die', 'Die Wirtschaftspolitik der Regierung wird oft kritisiert.
The government''s economic policy is often criticized.', 3522, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'from what, about what', 'wovon', ARRAY[]::text[], NULL, NULL, 'Weißt du überhaupt, wovon du redest?
Do you even know what you''re talking about?', 3523, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stuff', 'Zeug', ARRAY[]::text[], 'noun', 'das', 'Wirf endlich das komische Zeug weg!
Throw away the strange stuff at last!', 3524, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to one another', 'zueinander', ARRAY[]::text[], NULL, NULL, 'Die Geschäftspartner waren sehr freundlich zueinander.
The business partners have been very kind to one another.', 3525, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tongue', 'Zunge', ARRAY[]::text[], 'noun', 'die', 'Dirk hat sich auf die Zunge gebissen.
Dirk has bitten his tongue.', 3526, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put back, put aside, cover (distance)', 'zurücklegen', ARRAY[]::text[], NULL, NULL, 'Wir legten zu Fuß eine Strecke von fünfzehn Kilometern zurück.
We covered a distance of ten miles on foot.', 3527, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to promise, accept', 'zusagen', ARRAY[]::text[], NULL, NULL, 'Ich sage Ihnen zu, dass ich mich um diese Sache kümmern werde.
I promise to you that I''ll take care of this issue.', 3528, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'put together', 'zusammenstellen', ARRAY[]::text[], NULL, NULL, 'Der Koch hat ein schmackhaftes Menu zusammengestellt.
The chef has put together a delicious menu.', 3529, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'force, pressure, compulsion', 'Zwang', ARRAY[]::text[], 'noun', 'der', 'Wenn ein Kind nicht gern musiziert, sollte kein Zwang ausgeübt werden.
If a child does not like playing music, there should be no pressure.', 3530, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'inevitable', 'zwangsläufig', ARRAY[]::text[], NULL, NULL, 'Wenn man schneller geht, verbraucht man zwangsläufig mehr Energie.
If you go faster, you inevitably consume more energy.', 3531, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'in between', 'zwischendurch', ARRAY[]::text[], NULL, NULL, 'Wir haben zwischendurch einen Kaffee getrunken.
We have been drinking a coffee in between.', 3532, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'concluding, final', 'abschließend', ARRAY[]::text[], NULL, NULL, 'Abschließend möchte ich die Thesen noch einmal zusammenfassen.
Finally, I would like to summarize the thesis again.', 3533, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to turn away, avert', 'abwenden', ARRAY[]::text[], NULL, NULL, 'Sie konnten das Unglück gerade noch abwenden.
They could only just avert the disaster.', 3534, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'apparent', 'anscheinend', ARRAY[]::text[], NULL, NULL, 'Sie hatten uns anscheinend nicht gesehen.
They had apparently not seen us.', 3535, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to settle, establish', 'ansiedeln', ARRAY[]::text[], NULL, NULL, 'Angelockt durch die gute Infrastruktur siedeln sich hier viele Firmen an.
Attracted by the good infrastructure many companies settle here.', 3536, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'antibiotic', 'Antibiotikum', ARRAY[]::text[], 'noun', 'das', 'Sie muss Antibiotika gegen ihre Bronchitis nehmen.
She has to take antibiotics for her bronchitis.', 3537, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instruction', 'Anweisung', ARRAY[]::text[], 'noun', 'die', 'Bewahren Sie Ruhe und folgen Sie unbedingt den Anweisungen des Kabinenpersonals.
Stay calm and follow the instructions of the cabin crew.', 3538, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'suit', 'Anzug', ARRAY[]::text[], 'noun', 'der', 'Ich passe nicht mehr in meinen Anzug.
I do not fit into my suit anymore.', 3539, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'architecture', 'Architektur', ARRAY[]::text[], 'noun', 'die', 'Die mittelalterliche Architektur ist in Rothenburg noch gut erhalten.
The medieval architecture is well preserved in Rothenburg.', 3540, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'atom', 'Atom', ARRAY[]::text[], 'noun', 'das', 'Moleküle sind Verbindungen aus Atomen.
Molecules are compounds composed of atoms.', 3541, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to keep, store', 'aufbewahren', ARRAY[]::text[], NULL, NULL, 'Geschenke bewahren wir in einer Truhe auf.
We store gifts in a chest.', 3542, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'conspicuous', 'auffällig', ARRAY[]::text[], NULL, NULL, 'Dein Kollege lädt dich aber auffällig oft zum Kaffee ein.
Your colleague invites you for coffee conspicuously often.', 3543, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'upright, erect', 'aufrecht', ARRAY[]::text[], NULL, NULL, 'Eine aufrechte Körperhaltung beugt Rückenproblemen vor.
An upright posture helps prevent back problems.', 3544, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to open, hit', 'aufschlagen', ARRAY[]::text[], NULL, NULL, 'Ich schlage eine Zeitschrift auf.
I open a magazine.', 3545, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'climb, rise', 'Aufstieg', ARRAY[]::text[], 'noun', 'der', 'Der Aufstieg zur Burg ist sehr steil.
The climb to the castle is very steep.', 3546, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'outing, trip', 'Ausflug', ARRAY[]::text[], 'noun', 'der', 'Am Sonntag machen wir einen Ausflug mit dem Fahrrad.
On Sunday we take a trip by bicycle.', 3547, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'exit, outcome, starting point', 'Ausgang', ARRAY[]::text[], 'noun', 'der', 'Der Ausgang des Hauses war versperrt.
The exit of the house was locked.', 3548, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'equipment, provision, furnishings', 'Ausstattung', ARRAY[]::text[], 'noun', 'die', 'Die technische Ausstattung sollte noch verbessert werden.
The technical equipment should be improved.', 3549, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to evaluate, analyse', 'auswerten', ARRAY[]::text[], NULL, NULL, 'Im Anschluss an die Datenerhebung werden die Ergebnisse ausgewertet.
After the data is collected, the results are evaluated.', 3550, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Bavarian', 'Bayer', ARRAY[]::text[], 'noun', 'der', 'Ich bin gebürtiger Bayer.
I am native of Bavaria.', 3551, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'working, handling', 'Bearbeitung', ARRAY[]::text[], 'noun', 'die', 'Das Finanzamt bemüht sich um eine zügige Bearbeitung des Antrags.
The Tax Office is committed to rapidly handle the application.', 3552, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stimulate', 'beleben', ARRAY[]::text[], NULL, NULL, 'Konkurrenz belebt das Geschäft.
Competition is good for business.', 3553, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'employed, working', 'berufstätig', ARRAY[]::text[], NULL, NULL, 'Beide Elternteile sind berufstätig.
Both parents are working.', 3554, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to get (hold of)', 'beschaffen', ARRAY[]::text[], NULL, NULL, 'Ich muss mir noch eine Pistole beschaffen.
I must still get hold of a gun.', 3555, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'characteristic, specific feature', 'Besonderheit', ARRAY[]::text[], 'noun', 'die', 'Worin liegt die Besonderheit von Alternativschulen?
What is the specific feature of Alternative Schools?', 3556, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consideration', 'Betracht', ARRAY[]::text[], 'noun', 'der', 'Das kommt nicht in Betracht.
That is out of consideration.', 3557, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'biology', 'Biologie', ARRAY[]::text[], 'noun', 'die', 'Nehmen wir ein Beispiel aus der Biologie.
Let''s take an example from biology.', 3558, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'blond', 'blond', ARRAY[]::text[], NULL, NULL, 'Steffi Graf hat lange, blonde Haare.
Steffi Graf has long, blond hair.', 3559, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'width', 'Breite', ARRAY[]::text[], 'noun', 'die', 'Das Volumen eines Raumes berechnet sich aus Breite mal Tiefe mal Höhe.
The volume of a room is calculated from width multiplied by depth multiplied by height.', 3560, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'butter', 'Butter', ARRAY[]::text[], 'noun', 'die', 'Die Butter steht im Kühlschrank.
The butter is in the refrigerator.', 3561, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'champion', 'Champion', ARRAY[]::text[], 'noun', 'der', 'Wir sind die Champions, olé!
We are the champions, Olé!', 3562, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'differentiation', 'Differenzierung', ARRAY[]::text[], 'noun', 'die', 'Es geht vor allem um die soziale Differenzierung der Gesellschaft.
It is all about the social differentiation of society.', 3563, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(musical) conductor', 'Dirigent', ARRAY[]::text[], 'noun', 'der', 'Kurt Masur ist Dirigent eines großen Orchesters.
Kurt Masur is musical conductor of a large orchestra.', 3564, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'drastic', 'drastisch', ARRAY[]::text[], NULL, NULL, 'Der Zustand des Patienten hat sich heute Nacht drastisch verschlechtert.
The patient''s condition has deteriorated drastically tonight.', 3565, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hurry', 'eilen', ARRAY[]::text[], NULL, NULL, 'Der Sanitäter eilt dem Verletzten zu Hilfe.
The paramedic hurries to help the injured.', 3566, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to see, realize, look into', 'einsehen', ARRAY[]::text[], NULL, NULL, 'Im Stadtarchiv kann man alte Akten einsehen.
In the city archives you can look into old records.', 3567, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'endless, infinite', 'endlos', ARRAY[]::text[], NULL, NULL, 'Sie haben darüber endlose Diskussionen geführt.
They have conducted endless discussions about it.', 3568, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'discovery', 'Entdeckung', ARRAY[]::text[], 'noun', 'die', 'Die Entdeckung der Elektrizität veränderte das Leben der Menschen elementar.
The discovery of electricity changed people''s lives fundamentally.', 3569, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to unfold, develop', 'entfalten', ARRAY[]::text[], NULL, NULL, 'Rotwein entfaltet sein volles Aroma bei Zimmertemperatur.
Red wine develops its full flavor at room temperature.', 3570, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'invention', 'Erfindung', ARRAY[]::text[], 'noun', 'die', 'Der Computer ist eine sehr nützliche Erfindung.
The computer is a very useful invention.', 3571, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'available', 'erhältlich', ARRAY[]::text[], NULL, NULL, 'Zuckertüten sind nur im Sommer erhältlich.
Sugar bags are only available in summer.', 3572, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to expect, hope for', 'erhoffen', ARRAY[]::text[], NULL, NULL, 'Durch Fortbildungen erhoffen sich viele Menschen bessere Chancen auf dem Arbeitsmarkt.
Through training many people are hoping to get better chances at the job market.', 3573, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to suffer', 'erleiden', ARRAY[]::text[], NULL, NULL, 'Die Großmutter erlitt einen Schlaganfall.
The grandmother suffered a stroke.', 3574, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'replacement, compensation', 'Ersatz', ARRAY[]::text[], 'noun', 'der', 'Ich fordere Ersatz für den entstandenen Schaden.
I demand compensation for the damage.', 3575, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'explicit', 'explizit', ARRAY[]::text[], NULL, NULL, 'Ich habe Sie explizit davor gewarnt, mein Grundstück zu betreten.
I have explicitly warned you not to enter my property.', 3576, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'specialist, informed', 'fachlich', ARRAY[]::text[], NULL, NULL, 'Sie gab ihm einen fachlichen Rat.
She gave him an informed advice.', 3577, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to arrest, detain', 'festnehmen', ARRAY[]::text[], NULL, NULL, 'Die Polizei konnte den Dieb schnell finden und festnehmen.
The police was able to find the thief quickly and to arrest him.', 3578, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fire brigade', 'Feuerwehr', ARRAY[]::text[], 'noun', 'die', 'Martin ist Mitglied in der Feuerwehr.
Martin is a member of the fire brigade.', 3579, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fever', 'Fieber', ARRAY[]::text[], 'noun', 'das', 'Friedemann hatte heute Nacht hohes Fieber.
Friedemann had a high fever last night.', 3580, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fix (one’s eyes), fixate', 'fixieren', ARRAY[]::text[], NULL, NULL, 'Der Hund fixierte den Briefträger mit seinen Augen.
The dog fixated the postman with his eyes.', 3581, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'airline', 'Fluggesellschaft', ARRAY[]::text[], 'noun', 'die', 'Mit welcher Fluggesellschaft fliegst du in den Urlaub?
Which ariline do you go on holiday with?', 3582, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'photographic', 'fotografisch', ARRAY[]::text[], NULL, NULL, 'Markus hat ein fotografisches Gedächtnis.
Marcus has a photographic memory.', 3583, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to release', 'freigeben', ARRAY[]::text[], NULL, NULL, 'Das Baby wurde zur Adoption freigegeben.
The baby was released for adoption.', 3584, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fee', 'Gebühr', ARRAY[]::text[], 'noun', 'die', 'Auch in Deutschland wird eine Gebühr zur Straßennutzung eingeführt.
In Germany, a fee will be introduced for road use.', 3585, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'secret service', 'Geheimdienst', ARRAY[]::text[], 'noun', 'der', 'Der Geheimdienst hat vor Terroranschlägen gewarnt.
The Secret Service has warned about terrorist attacks.', 3586, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Secretary-General', 'Generalsekretär', ARRAY[]::text[], 'noun', 'der', 'Der Generalsekretär hält eine Rede.
The Secretary-General gives a speech.', 3587, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'luggage', 'Gepäck', ARRAY[]::text[], 'noun', 'das', 'Mein Gepäck ist sehr schwer.
My luggage is very heavy.', 3588, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rumour', 'Gerücht', ARRAY[]::text[], 'noun', 'das', 'In einer Kleinstadt gibt es immer viele Gerüchte.
In a small town, there are always lots of rumors.', 3589, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'legislator, legislature', 'Gesetzgeber', ARRAY[]::text[], 'noun', 'der', 'Die Streitfrage ist durch den Gesetzgeber eindeutig entschieden.
The issue is clearly decided by the legislator.', 3590, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'regular, even', 'gleichmäßig', ARRAY[]::text[], NULL, NULL, 'Atmen Sie ruhig und gleichmäßig!
Breathe calmly and evenly!', 3591, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'as it were, so to speak', 'gleichsam', ARRAY[]::text[], NULL, NULL, 'Ihr Brief war gleichsam eine einzige Anklage.
Your letter was so to speak a single indictment.', 3592, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'structure, organization', 'Gliederung', ARRAY[]::text[], 'noun', 'die', 'Eine chronologische Gliederung orientiert sich an der Zeit.
A chronological structure follows the time.', 3593, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'grave', 'Grab', ARRAY[]::text[], 'noun', 'das', 'Es lagen viele Blumen auf dem Grab.
There were lots of flowers on the grave.', 3594, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'limiting value, limit', 'Grenzwert', ARRAY[]::text[], 'noun', 'der', 'Die Luftverschmutzung darf einen bestimmten Grenzwert nicht überschreiten.
The air pollution can not exceed a certain threshold.', 3595, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'craft, trade', 'Handwerk', ARRAY[]::text[], 'noun', 'das', 'Im Erzgebirge findet man noch viel traditionelles Handwerk.
In the Erzgebirge there are still many traditional crafts.', 3596, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hate', 'hassen', ARRAY[]::text[], NULL, NULL, 'Ich hasse Glatteis.
I hate ice.', 3597, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'notebook', 'Heft', ARRAY[]::text[], 'noun', 'das', 'Moritz hat das Heft mit den Hausaufgaben zuhause vergessen.
Moritz has left the notebook with his homework at home.', 3598, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'helper, accomplice', 'Helfer', ARRAY[]::text[], 'noun', 'der', 'Viele freiwillige Helfer unterstützten uns.
Many accomplices helped out.', 3599, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to evoke, arouse, cause', 'hervorrufen', ARRAY[]::text[], NULL, NULL, 'Die Rede rief heftige Diskussionen hervor.
The speech evoked heated debates.', 3600, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to accept', 'hinnehmen', ARRAY[]::text[], NULL, NULL, 'Das Wetter muss man hinnehmen, wie es ist.
The weather must be accepted as it is.', 3601, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'identical', 'identisch', ARRAY[]::text[], NULL, NULL, 'Autor und Erzähler sind nicht identisch.
Author and narrator are not identical.', 3602, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'illegal', 'illegal', ARRAY[]::text[], NULL, NULL, 'Drogenhandel ist illegal.
Drug trafficking is illegal.', 3603, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'industrial', 'industriell', ARRAY[]::text[], NULL, NULL, 'Die industrielle Revolution ließ die Städte schnell wachsen.
The industrial revolution made the cities grow rapidly.', 3604, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intelligence', 'Intelligenz', ARRAY[]::text[], 'noun', 'die', 'Sie wollen die Intelligenz ihres Kindes testen lassen.
&amp;lt;div&amp;gt;They want to have the intelligence of their child tested.&amp;lt;/div&amp;gt;', 3605, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to what extent', 'inwieweit', ARRAY[]::text[], NULL, NULL, 'Inwieweit werden soziale Rollen durch die neuen Medien verändert?
To what extent are social roles altered by the new media?', 3606, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hunter', 'Jäger', ARRAY[]::text[], 'noun', 'der', 'Nach der Jagd treffen sich die Jäger zur Heimfahrt.
After the hunt, the hunters meet to drive home.', 3607, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'any', 'jegliche', ARRAY['s)']::text[], NULL, NULL, 'Die Innenstadt ist für jeglichen Verkehr gesperrt.
The downtown area is closed to any traffic.', 3608, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'potato', 'Kartoffel', ARRAY[]::text[], 'noun', 'die', 'Die Kartoffel wurde aus Amerika importiert.
The potato was imported from America.', 3609, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cheese', 'Käse', ARRAY[]::text[], 'noun', 'der', 'In Frankreich isst man sehr viel Käse.
In France they eat a lot of cheese.', 3610, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sound, tone', 'Klang', ARRAY[]::text[], 'noun', 'der', 'Dieses Instrument hat einen ganz dumpfen Klang.
This instrument has a very dull sound.', 3611, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to ring', 'klingeln', ARRAY[]::text[], NULL, NULL, 'Es hat an der Tür geklingelt.
The doorbell has been rung.', 3612, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to comment', 'kommentieren', ARRAY[]::text[], NULL, NULL, 'Kleine Kinder kommentieren gern ihre eigenen Handlungen.
Young children like to comment on their own actions.', 3613, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'compromise', 'Kompromiss', ARRAY[]::text[], 'noun', 'der', 'Wir müssen einen Kompromiss finden.
We need to find a compromise.', 3614, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'queen', 'Königin', ARRAY[]::text[], 'noun', 'die', 'Die Königin von England kommt bald zu Besuch.
The Queen of England comes to visit soon.', 3615, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'construction, design', 'Konstruktion', ARRAY[]::text[], 'noun', 'die', 'Matthias ist für die Konstruktion der Kulissen zuständig.
Matthias is responsible for the construction of the scenes.', 3616, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'circulation', 'Kreislauf', ARRAY[]::text[], 'noun', 'der', 'Beim Sport kommt der Kreislauf in Schwung.
During sports the circulation gets actice.', 3617, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ball, sphere, bullet', 'Kugel', ARRAY[]::text[], 'noun', 'die', 'Die Erde ist eine Kugel.
The earth is a ball.', 3618, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cow', 'Kuh', ARRAY[]::text[], 'noun', 'die', 'Der Bauer hat eine Herde von vierzig Kühen.
The farmer has a herd of forty cows.', 3619, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to store, to camp', 'lagern', ARRAY[]::text[], NULL, NULL, 'Kartoffeln sollten in einem dunklen Raum gelagert werden.
Potatoes should be stored in a dark room.', 3620, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'corpse', 'Leiche', ARRAY[]::text[], 'noun', 'die', 'Die Leiche wurde seziert.
The corps was dissected.', 3621, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'passion', 'Leidenschaft', ARRAY[]::text[], 'noun', 'die', 'Motorradfahren ist seine Leidenschaft.
Motorcycling is his passion.', 3622, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'productivity, power', 'Leistungsfähigkeit', ARRAY[]::text[], 'noun', 'die', 'Vitaminmangel vermindert die Leistungsfähigkeit.
Vitamin deficiency reduces the power.', 3623, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'delivery', 'Lieferung', ARRAY[]::text[], 'noun', 'die', 'Sie bekommen ihre Bestellung in mehreren Lieferungen.
You will get your orders in several deliveries.', 3624, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'league', 'Liga', ARRAY[]::text[], 'noun', 'die', 'In welcher Liga spielt Rot-Weiß Erfurt?
In which league does Rot-Weiss Erfurt play?', 3625, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mild, gentle', 'mild', ARRAY[]::text[], NULL, NULL, 'Dieses Duschgel ist besonders mild und gut für empfindliche Haut geeignet.
This shower gel is gentle and suitable for sensitive skin.', 3626, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'milligram', 'Milligramm', ARRAY[]::text[], 'noun', 'das', 'Der Körper braucht täglich 75 Milligramm Vitamin C.
The body needs a daily dose of 75 milligrams of vitamin C.', 3627, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'offspring, new generation', 'Nachwuchs', ARRAY[]::text[], 'noun', 'der', 'In Deutschland fördert man den sportlichen Nachwuchs sehr.
In Germany the new generation in sports is being promoted very well.', 3628, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'neck', 'Nacken', ARRAY[]::text[], 'noun', 'der', 'Sie schlingt die Arme um meinen Nacken.
She throws her arms around my neck.', 3629, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Olympics', 'Olympia', ARRAY[]::text[], 'noun', 'das', 'Die Jugend der Welt trainiert für Olympia.
The youth of the world trains for the Olympics.', 3630, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Olympic', 'olympisch', ARRAY[]::text[], NULL, NULL, 'Er möchte gern an einem olympischen Eishockey-Turnier teilnehmen.
He would like to participate in an Olympic hockey tournament.', 3631, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Palestinian', 'Palästinenser', ARRAY[]::text[], 'noun', 'der', 'Arafat war wohl der berühmteste Palästinenser.
Arafat was probably the most famous Palestinian.', 3632, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'party conference, convention', 'Parteitag', ARRAY[]::text[], 'noun', 'der', 'Der Vorschlag fand auf dem Parteitag breite Zustimmung.
The proposal received broad support at the party conference.', 3633, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'party', 'Party', ARRAY[]::text[], 'noun', 'die', 'Die Party beginnt gegen acht Uhr.
The party starts at eight clock.', 3634, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'permanent', 'permanent', ARRAY[]::text[], NULL, NULL, 'Diese permanente Überforderung trage ich nicht mehr lange mit.
I will not support this permanent excessive demand any longer.', 3635, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to plead', 'plädieren', ARRAY[]::text[], NULL, NULL, 'Die Verteidigung plädiert für Freispruch.
The defense pleaded on acquittal.', 3636, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'planet', 'Planet', ARRAY[]::text[], 'noun', 'der', 'Der Jupiter ist der größte Planet unseres Sonnensystems.
Jupiter is the largest planet in our solar system.', 3637, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'priest', 'Priester', ARRAY[]::text[], 'noun', 'der', 'Katholische Priester dürfen nicht heiraten.
Catholic priests must not marry.', 3638, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'problematic nature, problems', 'Problematik', ARRAY[]::text[], 'noun', 'die', 'Wir wollen diese Problematik hier nicht weiter vertiefen.
We do not want to deepen this problem any further here.', 3639, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rustle, roar', 'rauschen', ARRAY[]::text[], NULL, NULL, 'Die Bäume rauschen im Wind.
The trees rustle in the wind.', 3640, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'proper, real', 'regelrecht', ARRAY[]::text[], NULL, NULL, 'Das Schaf hat mich regelrecht umgerannt.
The sheep has run over me, really.', 3641, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rain', 'regnen', ARRAY[]::text[], NULL, NULL, 'Es regnet schon seit gestern.
It''s been raining since yesterday.', 3642, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recession', 'Rezession', ARRAY[]::text[], 'noun', 'die', 'Die Politik sucht Wege aus der Rezession.
The politicians seek a way out of the recession.', 3643, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to slide', 'rutschen', ARRAY[]::text[], NULL, NULL, 'Sie ist vom Stuhl gerutscht und auf den Rücken gefallen.
She slided off the chair and fell on her back.', 3644, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'salon, drawing room', 'Salon', ARRAY[]::text[], 'noun', 'der', 'Im Salon steht ein schwarzer Flügel.
In the drawing room there is a black concert piano.', 3645, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'actress', 'Schauspielerin', ARRAY[]::text[], 'noun', 'die', 'Sie ist Schauspielerin am Eisenacher Theater.
She is an actress at the Eisenach Theatre.', 3646, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pregnancy', 'Schwangerschaft', ARRAY[]::text[], 'noun', 'die', 'Eine Schwangerschaft dauert gewöhnlich neun Monate.
A pregnancy usually lasts nine months.', 3647, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sweat', 'Schweiß', ARRAY[]::text[], 'noun', 'der', 'Deine Füße riechen nach Schweiß.
Your feet smell like sweat.', 3648, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sigh', 'seufzen', ARRAY[]::text[], NULL, NULL, 'Er seufzte tief und fasste sich an die Stirn.
He sighed deeply and put his hand to his forehead.', 3649, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scale, dial, range', 'Skala', ARRAY[]::text[], 'noun', 'die', 'Man kann den pH-Wert mit Hilfe einer Skala messen.
One can measure the pH value using a scale.', 3650, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Soviet', 'sowjetisch', ARRAY[]::text[], NULL, NULL, 'Aus der sowjetischen Besatzungszone entstand die DDR.
From the Soviet zone of occupation the GDR was formed.', 3651, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fissure, cleft, column', 'Spalte', ARRAY[]::text[], 'noun', 'die', 'In der dritten Spalte der Tabelle steht der Preis.
In the third column of the table there is the price.', 3652, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'spectrum', 'Spektrum', ARRAY[]::text[], 'noun', 'das', 'Wir haben ein breites Spektrum an Möglichkeiten.
We have a wide spectrum of possibilities.', 3653, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to specialize', 'spezialisieren', ARRAY[]::text[], NULL, NULL, 'In der Facharztausbildung müssen sich junge Ärzte auf einen Fachbereich spezialisieren.
In the specialist training young doctors must specialize in a subject area.', 3654, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'perceptible', 'spürbar', ARRAY[]::text[], NULL, NULL, 'Der Wind ließ am Abend spürbar nach.
In the evening the wind perceptively decreased.', 3655, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'stiff, rigid, paralysed', 'starr', ARRAY[]::text[], NULL, NULL, 'Wladimir ist starr vor Kälte.
Vladimir is paralysed with cold.', 3656, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'socket, electrical outlet', 'Steckdose', ARRAY[]::text[], 'noun', 'die', 'Wenn der Drucker nicht druckt, ist vielleicht der Stecker nicht in der Steckdose.
If the printer does not print, maybe the plug is not in the socket.', 3657, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tax', 'steuerlich', ARRAY[]::text[], NULL, NULL, 'Für Alleinerziehende gibt es steuerliche Erleichterungen.
For single parents, there are tax simplifications.', 3658, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stretch', 'strecken', ARRAY[]::text[], NULL, NULL, 'Sie streckte ihre Arme und Beine.
She stretched her arms and legs.', 3659, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'board, table', 'Tafel', ARRAY[]::text[], 'noun', 'die', 'Die Lehrerin schreibt Vokabeln an die Tafel.
The teacher writes down words on the board.', 3660, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diary', 'Tagebuch', ARRAY[]::text[], 'noun', 'das', 'Am Abend schrieb Anne stundenlang in ihr Tagebuch.
In the evening, Anne wrote in her diary for hours.', 3661, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'talent', 'Talent', ARRAY[]::text[], 'noun', 'das', 'Tina hat großes musikalisches Talent.
Tina has great musical talent.', 3662, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pace, speed', 'Tempo', ARRAY[]::text[], 'noun', 'das', 'Bei Nebel und Nässe sollte das Tempo beim Autofahren reduziert werden.
In fog and rain, the pace should be reduced when driving.', 3663, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fatal', 'tödlich', ARRAY[]::text[], NULL, NULL, 'Der Unfall hatte tödliche Folgen.
The accident was fatal.', 3664, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to embrace', 'umarmen', ARRAY[]::text[], NULL, NULL, 'Sie umarmen sich zum Abschied.
They embraced each other to say goodbye.', 3665, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'restlessness, agitation', 'Unruhe', ARRAY[]::text[], 'noun', 'die', 'Von einer inneren Unruhe getrieben, ging Ute zur Tür.
Driven by an inner restlessness, Ute headed for the door.', 3666, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'signature', 'Unterschrift', ARRAY[]::text[], 'noun', 'die', 'Da fehlt noch die Unterschrift unter dem Vertrag.
The signature is still missing under the contract.', 3667, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'underline, emphasize', 'unterstreichen', ARRAY[]::text[], NULL, NULL, 'Die Schüler haben die Aufgabe bekommen, alle Verben im Text zu unterstreichen.
The students have been given the task to underline all the verbs in the text.', 3668, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unchanged', 'unverändert', ARRAY[]::text[], NULL, NULL, 'Die Situation ist unverändert schlecht.
The situation is unchanged bad.', 3669, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'immediate, prompt', 'unverzüglich', ARRAY[]::text[], NULL, NULL, 'Wir erwarten Ihre unverzügliche Antwort.
We await your prompt response.', 3670, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'improbable, unlikely', 'unwahrscheinlich', ARRAY[]::text[], NULL, NULL, 'Es ist unwahrscheinlich, dass es in Deutschland im August schneit.
It is unlikely that it snows in Germany in August.', 3671, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'origin', 'Ursprung', ARRAY[]::text[], 'noun', 'der', 'Die Donau hat ihren Ursprung im Schwarzwald.
The Danube has its origins in the Black Forest.', 3672, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'crime', 'Verbrechen', ARRAY[]::text[], 'noun', 'das', 'Die Polizei versucht, das Verbrechen aufzuklären.
The police is trying to solve the crime.', 3673, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to deteriorate, expire', 'verfallen', ARRAY[]::text[], NULL, NULL, 'Die Gültigkeit des Gutscheins verfällt nach einem halben Jahr.
The validity of the voucher expires after six months.', 3674, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pleasure', 'Vergnügen', ARRAY[]::text[], 'noun', 'das', 'Es ist mir ein Vergnügen.
It''s my pleasure.', 3675, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'behaviour', 'Verhaltensweise', ARRAY[]::text[], 'noun', 'die', 'Diese Verhaltensweise ist Katzen angeboren.
This behavior is innate in cats.', 3676, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'landlord', 'Vermieter', ARRAY[]::text[], 'noun', 'der', 'Der Vermieter wohnt im nächsten Haus.
The landlord lives in the house next door.', 3677, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reduce, decrease', 'vermindern', ARRAY[]::text[], NULL, NULL, 'Durch diese Pillen werden die Schmerzen vermindert.
With these pills, the pain is reduced.', 3678, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to hear, learn sth from sb', 'vernehmen', ARRAY[]::text[], NULL, NULL, 'Er konnte nur undeutlich vernehmen, was gesagt wurde.
He could hear only vaguely what was said.', 3679, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reason', 'Vernunft', ARRAY[]::text[], 'noun', 'die', 'Der Vorschlag entbehrt jeder Vernunft.
The proposal lacks any reason.', 3680, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'prescription, order', 'Verordnung', ARRAY[]::text[], 'noun', 'die', 'Es handelt sich hier um eine Verordnung meines Arztes.
This is my doctor''s prescription.', 3681, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to intensify, make more rigorous', 'verschärfen', ARRAY[]::text[], NULL, NULL, 'Die internationalen Sicherheitskontrollen wurden verschärft.
The international security controls have been intensified.', 3682, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'contractual', 'vertraglich', ARRAY[]::text[], NULL, NULL, 'Der Kauf des Hauses muss noch vertraglich geregelt werden.
The purchase of the house must still be regulated contractually.', 3683, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'villa', 'Villa', ARRAY[]::text[], 'noun', 'die', 'Hinter der Villa erstreckt sich ein parkähnliches Grundstück bis zum Fluss.
Behind the villa there is a park-like ground extending to the river.', 3684, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'morning', 'Vormittag', ARRAY[]::text[], 'noun', 'der', 'Am Vormittag sind die Geschäfte noch nicht so voll.
In the morning, the shops are not so full.', 3685, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'far, much', 'weitaus', ARRAY[]::text[], NULL, NULL, 'In Leipzig wohnen weitaus mehr Menschen als in Erfurt.
In Leipzig live far more people than in Erfurt.', 3686, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'living room', 'Wohnzimmer', ARRAY[]::text[], 'noun', 'das', 'Heute essen wir im Wohnzimmer.
Today we eat in the living room.', 3687, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on what, of what', 'woran', ARRAY[]::text[], NULL, NULL, 'Woran ist sie gestorben?
Of what did she die?', 3688, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'destruction', 'Zerstörung', ARRAY[]::text[], 'noun', 'die', 'Nach dem Bombenangriff bot die Stadt ein Bild der Zerstörung.
After the bombing, the city was a scene of destruction.', 3689, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interest rate', 'Zinssatz', ARRAY[]::text[], 'noun', 'der', 'Die Zentralbank hat den Zinssatz angehoben.
The central bank has raised the interest rate.', 3690, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'admission, licence', 'Zulassung', ARRAY[]::text[], 'noun', 'die', 'Die Zulassung zur Prüfung ist Voraussetzung für die Teilnahme an der Klausur.
Admission to the examination is a prerequisite for participation in the exam.', 3691, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to give back, return', 'zurückgeben', ARRAY[]::text[], NULL, NULL, 'Gib mir mein Buch zurück!
Give me back my book!', 3692, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'composition', 'Zusammensetzung', ARRAY[]::text[], 'noun', 'die', 'Die Zusammensetzung der Gruppen war sehr unterschiedlich.
The composition of the groups was very different.', 3693, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'deduction, depreciation', 'Abschreibung', ARRAY[]::text[], 'noun', 'die', 'Durch Abschreibungen verringert man seine Steuerschuld.
Depreciation decreases one''s tax duty.', 3694, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'axle, axis', 'Achse', ARRAY[]::text[], 'noun', 'die', 'Die Erde dreht sich um ihre eigene Achse.
The earth rotates around its own axis.', 3695, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'official', 'amtlich', ARRAY[]::text[], NULL, NULL, 'Dafür benötigt man eine amtliche Beglaubigung.
For this you need an official confirmation.', 3696, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'instead of', 'anstelle', ARRAY[]::text[], NULL, NULL, 'Ein Freund hat anstelle des Kandidaten die Prüfung abgelegt.
A friend has taken the exam instead of the candidate.', 3697, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'presence', 'Anwesenheit', ARRAY[]::text[], 'noun', 'die', 'Mary wird uns am Sonntag mit ihrer Anwesenheit beglücken.
Mary will bless us with her presence on Sunday.', 3698, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to publish, put on, hang up', 'auflegen', ARRAY[]::text[], NULL, NULL, 'Ich wollte noch etwas sagen, aber Bert hatte den Hörer schon aufgelegt.
I wanted to say something, but Bert had already hung up the phone.', 3699, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'excitement', 'Aufregung', ARRAY[]::text[], 'noun', 'die', 'Vor Aufregung brachte sie kein Wort heraus.
She was so excited that she could not speak.', 3700, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tear open', 'aufreißen', ARRAY[]::text[], NULL, NULL, 'Ungeduldig reißt Ruth die Gummibärchentüte auf.
Impatiently Ruth tears open the gummibear bag.', 3701, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put up(right), straighten', 'aufrichten', ARRAY[]::text[], NULL, NULL, 'Er richtete sich wieder auf, bevor er weitersprach.
He straightened before he spoke again.', 3702, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lay out, design, interpret', 'auslegen', ARRAY[]::text[], NULL, NULL, 'Den Text kann man unterschiedlich auslegen.
The text can be interpreted differently.', 3703, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unusual', 'außergewöhnlich', ARRAY[]::text[], NULL, NULL, 'Das ist ein ganz außergewöhnlich schönes Blau.
This is an unusually beautiful blue.', 3704, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'expressway, motorway', 'Autobahn', ARRAY[]::text[], 'noun', 'die', 'Schon wieder Stau auf der Autobahn zwischen Apolda und Weimar.
Once again a traffic jam on the motorway between Apolda and Weimar.', 3705, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'battery', 'Batterie', ARRAY[]::text[], 'noun', 'die', 'Die Batterie gibt Energie.
The battery provides energy.', 3706, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'important, significant', 'bedeutsam', ARRAY[]::text[], NULL, NULL, 'Das Buch ist für mich sehr bedeutsam geworden.
The book has become very important to me.', 3707, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Belgian', 'belgisch', ARRAY[]::text[], NULL, NULL, 'Belgische Pralinen sind eine Delikatesse.
Belgian chocolates are a delicacy.', 3708, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pale', 'blass', ARRAY[]::text[], NULL, NULL, 'Bei Fieber sieht sie immer so blass aus.
In fever she always looks so pale.', 3709, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to bellow, roar, shout', 'brüllen', ARRAY[]::text[], NULL, NULL, 'Löwen brüllen, um ihre Opfer einzuschüchtern.
Lions roar to intimidate their victims.', 3710, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chaos', 'Chaos', ARRAY[]::text[], 'noun', 'das', 'Nach der Feier herrschte im Kinderzimmer ein einziges Chaos.
After the party there was chaos in the playroom.', 3711, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'director, boss', 'Chefin', ARRAY[]::text[], 'noun', 'die', 'Wenn die Chefin Urlaub hat, ist es richtig gemütlich im Büro.
If the boss is on vacation, it''s really comfortable in the office.', 3712, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'chip, crisp', 'Chip', ARRAY[]::text[], 'noun', 'der', 'Wer hat die Tüte mit den Chips leergegessen?
Who has emptied bag of crisps?', 3713, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'choir, chorus', 'Chor', ARRAY[]::text[], 'noun', 'der', 'Ulrike singt im Chor.
Ulrike sings in the choir.', 3714, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'design', 'Design', ARRAY[]::text[], 'noun', 'das', 'Wenn die Stühle unbequem sind, nützt auch das beste Design nichts.
If the chairs are uncomfortable, the best design is no good.', 3715, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'interpreter', 'Dolmetscher', ARRAY[]::text[], 'noun', 'der', 'Dolmetscher werden bei Arbeitsessen nie satt.
Interpreters are never getting satisfied at work dinner.', 3716, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'average', 'Durchschnitt', ARRAY[]::text[], 'noun', 'der', 'Sein Gehalt liegt über dem Durchschnitt.
His salary is above average.', 3717, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pull through, pass through', 'durchziehen', ARRAY[]::text[], NULL, NULL, 'Zur Weihnachtszeit durchzieht die Straßen ein Duft von Glühwein und Zimt.
At Christmas, a scent of mulled wine and cinnamon passes through the streets.', 3718, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'married couple', 'Ehepaar', ARRAY[]::text[], 'noun', 'das', 'Die beiden sitzen auf dem Sofa wie ein altes Ehepaar.
They are sitting on the sofa like an old married couple.', 3719, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'break in, collapse', 'Einbruch', ARRAY[]::text[], 'noun', 'der', 'Der Einbruch ereignete sich am helllichten Tage.
The break in took place in broad daylight.', 3720, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put in, insert', 'einlegen', ARRAY[]::text[], NULL, NULL, 'Sie legte eine DVD in den Recorder ein.
She put a DVD into the recorder.', 3721, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'entry, admission', 'Eintritt', ARRAY[]::text[], 'noun', 'der', 'Der Eintritt ist frei.
Admission is free.', 3722, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'elementary, basic', 'elementar', ARRAY[]::text[], NULL, NULL, 'Essen und Trinken sind elementare Bedürfnisse.
Food and drink are basic needs.', 3723, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recovery, relaxation, rest', 'Erholung', ARRAY[]::text[], 'noun', 'die', 'Nach der vielen Arbeit brauche ich jetzt ein wenig Erholung.
After all the work I now need a little rest.', 3724, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to enact, declare', 'erlassen', ARRAY[]::text[], NULL, NULL, 'Italien hat ein Gesetz zum Rauchverbot in Restaurants erlassen.
Italy enacted a law to ban smoking in restaurants.', 3725, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'European', 'Europäer', ARRAY[]::text[], 'noun', 'der', 'Die Europäer brachten neue Krankheiten nach Amerika.
The Europeans brought new diseases to the America.', 3726, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'factory', 'Fabrik', ARRAY[]::text[], 'noun', 'die', 'Die Fabrik stellt die Produktion ein.
The factory stops the production.', 3727, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fugitive, cursory, fleeting', 'flüchtig', ARRAY[]::text[], NULL, NULL, 'Der verurteilte Mädchenmörder ist flüchtig.
The convicted murderer of girls is fugitive.', 3728, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to photograph', 'fotografieren', ARRAY[]::text[], NULL, NULL, 'Die Kinder werden in der Schule fotografiert.
The children are being photographed at school.', 3729, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fear', 'Furcht', ARRAY[]::text[], 'noun', 'die', 'Roman klapperte vor Furcht mit den Zähnen.
Roman rattled with his teeth of fear.', 3730, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'entirely', 'gänzlich', ARRAY[]::text[], NULL, NULL, 'Der Vater hatte zwei gänzlich verschiedene Füße.
The father had two entirely different feet.', 3731, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'patience', 'Geduld', ARRAY[]::text[], 'noun', 'die', 'Angler brauchen sehr viel Geduld.
Anglers need a lot of patience.', 3732, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'general', 'General', ARRAY[]::text[], 'noun', 'der', 'Der General schaute aus dem Fenster.
The General looked out of the window.', 3733, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'German studies', 'Germanistik', ARRAY[]::text[], 'noun', 'die', 'Ingo studiert Germanistik in Leipzig.
Ingo does German studies at Leipzig.', 3734, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to allow, permit', 'gestatten', ARRAY[]::text[], NULL, NULL, 'Rauchen ist hier nicht gestattet.
Smoking is not permitted here.', 3735, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'drink, beverage', 'Getränk', ARRAY[]::text[], 'noun', 'das', 'Getränke gibt es am Automaten.
Drinks are available from vending machines.', 3736, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rifle, shotgun', 'Gewehr', ARRAY[]::text[], 'noun', 'das', 'Der Jäger lehnt das Gewehr an einen Baum.
The hunter is leaning the rifle against a tree.', 3737, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'limb, joint, link', 'Glied', ARRAY[]::text[], 'noun', 'das', 'Eine Kette ist nur so stark wie ihr schwächstes Glied.
A chain is only as strong as its weakest link.', 3738, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'count, earl', 'Graf', ARRAY[]::text[], 'noun', 'der', 'Der Graf wohnt auf einer Burg.
The Count lives in a castle.', 3739, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'committee', 'Gremium', ARRAY[]::text[], 'noun', 'das', 'Über den Einspruch entscheidet das zuständige Gremium.
On the appeal the committee in charge has to decide.', 3740, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'goodwill, favour', 'Gunst', ARRAY[]::text[], 'noun', 'die', 'Leider habe ich jetzt endgültig ihre Gunst verscherzt.
Unfortunately, I have now finally forfeited her favor.', 3741, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'report, reference', 'Gutachten', ARRAY[]::text[], 'noun', 'das', 'Zur Bewerbung gehören der Lebenslauf, Zeugnisse und ein Gutachten eines Hochschullehrers.
To an application belong a CV, transcripts and a letter from a university lecturer.', 3742, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'workman, tradesman', 'Handwerker', ARRAY[]::text[], 'noun', 'der', 'Heute kommt Kevin nicht ins Büro, weil er die Handwerker zuhause hat.
Today, Kevin won''t come to the office because he has the workmen at home.', 3743, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'front door', 'Haustür', ARRAY[]::text[], 'noun', 'die', 'Die Haustür ist zugeschlossen.
The front door is locked.', 3744, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take out', 'herausnehmen', ARRAY[]::text[], NULL, NULL, 'Er nahm die Kette aus der Schachtel heraus.
He took the chain out of the box.', 3745, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to emphasize, stress', 'hervorheben', ARRAY[]::text[], NULL, NULL, 'Ich möchte einen weiteren Gesichtspunkt hervorheben.
I want to emphasize one other point.', 3746, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hypothesis', 'Hypothese', ARRAY[]::text[], 'noun', 'die', 'Forschungsbeiträge beginnen oft mit einer Hypothese.
Research articles often begin with a hypothesis.', 3747, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Minister of the Interior', 'Innenminister', ARRAY[]::text[], 'noun', 'der', 'Der Innenminister streitet sich mit dem Außenminister.
The minister of the Interior squarrels with the Foreign Minister.', 3748, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Islam', 'Islam', ARRAY[]::text[], 'noun', 'der', 'Der Islam ist eine der großen Weltreligionen.
Islam is one of the great world religions.', 3749, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Italian', 'Italiener', ARRAY[]::text[], 'noun', 'der', 'Giovanni ist Italiener und kommt aus Palermo.
Giovanni is Italian and comes from Palermo.', 3750, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cassette, tape', 'Kassette', ARRAY[]::text[], 'noun', 'die', 'Auf der Kassette sind alte Lieder aus meiner Jugendzeit.
On the tape there are old songs from my youth.', 3751, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'box, crate', 'Kasten', ARRAY[]::text[], 'noun', 'der', 'Für die Party brauchen wir noch einen Kasten Bier.
For the party, we still need a box of beer.', 3752, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cognitive', 'kognitiv', ARRAY[]::text[], NULL, NULL, 'Autodidakten setzen eine Vielzahl von kognitiven Strategien ein.
Autodidacts use a variety of cognitive strategies.', 3753, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comment, opinion', 'Kommentar', ARRAY[]::text[], 'noun', 'der', 'Auf deine Kommentare kann ich verzichten.
I can do without your comments.', 3754, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'concept, conception', 'Konzeption', ARRAY[]::text[], 'noun', 'die', 'Wir sollten zuerst eine Konzeption erarbeiten und dann erst an die Öffentlichkeit gehen.
We should first draw up a concept and then go public.', 3755, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'creativity', 'Kreativität', ARRAY[]::text[], 'noun', 'die', 'Der Kreativität sind keine Grenzen gesetzt.
Creativity knows no bounds.', 3756, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'long-standing', 'langjährig', ARRAY[]::text[], NULL, NULL, 'Die Trauerrede hielt der langjährige Freund der Familie.
The eulogy was held by the longtime family friend.', 3757, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to (tell a) lie', 'lügen', ARRAY[]::text[], NULL, NULL, 'Du hast gelogen.
You lied.', 3758, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'magazine, storehouse', 'Magazin', ARRAY[]::text[], 'noun', 'das', 'Die Bücher müssen erst aus dem Magazin geholt werden.
The books must be fetched from the magazine at first.', 3759, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'market share', 'Marktanteil', ARRAY[]::text[], 'noun', 'der', 'Diese Zuschauerquote entspricht einem Marktanteil von 30 Prozent.
This audience represents a market share of 30 percent.', 3760, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mouse', 'Maus', ARRAY[]::text[], 'noun', 'die', 'Mit Speck fängt man Mäuse.
Mice are being caught with bacon.', 3761, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'human right', 'Menschenrecht', ARRAY[]::text[], 'noun', 'das', 'Die Umsetzung der Menschenrechte bereitet selbst in Europa Schwierigkeiten.
Even the implementation of human rights in Europe means trouble.', 3762, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tenant', 'Mieter', ARRAY[]::text[], 'noun', 'der', 'Mieter dürfen Haustiere nur mit Zustimmung des Vermieters halten.
Tenants may keep pets only with the consent of the landlord.', 3763, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'military', 'Militär', ARRAY[]::text[], 'noun', 'das', 'Nach der Schule geht er zum Militär.
After school he goes to the military.', 3764, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'minority', 'Minderheit', ARRAY[]::text[], 'noun', 'die', 'Sorben sind in Deutschland eine Minderheit.
Sorbs in Germany are a minority.', 3765, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'minimal', 'minimal', ARRAY[]::text[], NULL, NULL, 'Die Chancen bei dieser Bewerbung sind minimal.
The chances are minimal with this application.', 3766, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ministry, department', 'Ministerium', ARRAY[]::text[], 'noun', 'das', 'Sie arbeitet am Ministerium für Finanzen.
She works at the Ministry of Finance.', 3767, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'presumed, suspected', 'mutmaßlich', ARRAY[]::text[], NULL, NULL, 'Die Polizei fasste den mutmaßlichen Mörder.
The police seized the suspected murderer.', 3768, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'myth, legend', 'Mythos', ARRAY[]::text[], 'noun', 'der', 'Bei der Behauptung, Frauen könnten schlechter einparken als Männer, handelt es sich um einen Mythos.
Claiming that women could park worse than men, is a myth.', 3769, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'later, belated', 'nachträglich', ARRAY[]::text[], NULL, NULL, 'Ich gratuliere dir nachträglich zum Geburtstag.
I congratulate you belated for your birthday.', 3770, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'by the name of, called', 'namens', ARRAY[]::text[], NULL, NULL, 'Er wohnte in einem kleinen Dorf namens Dingolfing.
He lived in a small village called Dingolfing.', 3771, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'natural science', 'Naturwissenschaft', ARRAY[]::text[], 'noun', 'die', 'Angelika ist gut in Naturwissenschaften und Mathematik.
Angelika is good at science and mathematics.', 3772, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'scientific', 'naturwissenschaftlich', ARRAY[]::text[], NULL, NULL, 'Das kann man mit naturwissenschaftlichen Verfahren untersuchen.
This can be investigated by scientific methods.', 3773, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to operate, have surgery', 'operieren', ARRAY[]::text[], NULL, NULL, 'Magdalena ist schon zweimal am Knie operiert worden.
Magdalena has been operated twice at the knee.', 3774, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'parking place', 'Parkplatz', ARRAY[]::text[], 'noun', 'der', 'Ich finde keinen Parkplatz, ich komm zu spät zu dir, mein Schatz.
I can not find a parking lot, I''m late , my darling.', 3775, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'partnership', 'Partnerschaft', ARRAY[]::text[], 'noun', 'die', 'Spaß in der Partnerschaft ist eine ernste Angelegenheit.
Fun in apartnership is a serious matter.', 3776, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'period', 'Periode', ARRAY[]::text[], 'noun', 'die', 'Die Firma erlebt zurzeit die erfolgreichste Periode ihrer Geschichte.
The company is currently experiencing the most successful period in its history.', 3777, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'preparation, medication', 'Präparat', ARRAY[]::text[], 'noun', 'das', 'Der Sportlehrer verabreicht seinen Schülerinnen verbotene Präparate.
The physical education teacher gave his pupils banned medications.', 3778, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'province, provinces', 'Provinz', ARRAY[]::text[], 'noun', 'die', 'Die Lebensumstände in der Hauptstadt und in der Provinz sind völlig unterschiedlich.
The living conditions in the capital and in the provinces are completely different.', 3779, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'quantitative', 'quantitativ', ARRAY[]::text[], NULL, NULL, 'Bei dieser Dissertation handelt es sich um eine quantitative Studie.
In this thesis, there is a quantitative study.', 3780, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'prevailing condition', 'Rahmenbedingung', ARRAY[]::text[], 'noun', 'die', 'Die Regierung will die Rahmenbedingungen für Familien verbessern.
The government wants to improve the prevailing conditions for families.', 3781, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'head of government', 'Regierungschef', ARRAY[]::text[], 'noun', 'der', 'Sie strebt das Amt des Regierungschefs an.
She aims for becoming head of government', 3782, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'column, pillar', 'Säule', ARRAY[]::text[], 'noun', 'die', 'Die Säulen tragen verschiedene Kapitelle.
The pillars support various capitals.', 3783, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to be ashamed', 'schämen', ARRAY[]::text[], NULL, NULL, 'Du brauchst dich deshalb nicht zu schämen.
You do not have to be ashamed.', 3784, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'divorce', 'Scheidung', ARRAY[]::text[], 'noun', 'die', 'Eine Scheidung ist ziemlich teuer.
A divorce is quite costly.', 3785, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'slim', 'schlank', ARRAY[]::text[], NULL, NULL, 'Es ist nicht so einfach, schlank zu bleiben.
It is not so easy to stay slim.', 3786, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'beauty', 'Schönheit', ARRAY[]::text[], 'noun', 'die', 'Sie war keine Schönheit.
She was not a beauty.', 3787, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'school', 'schulisch', ARRAY[]::text[], NULL, NULL, 'Im Lebenslauf schildert sie ihren schulischen Werdegang.
In her CV she describes her school career.', 3788, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to serve', 'servieren', ARRAY[]::text[], NULL, NULL, 'Der Tee wird in flachen Schalen serviert.
The tea is served in shallow bowls.', 3789, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'specialist', 'Spezialist', ARRAY[]::text[], 'noun', 'der', 'Er ist ein Spezialist auf diesem Gebiet.
He is a specialist in this field.', 3790, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'increase', 'Steigerung', ARRAY[]::text[], 'noun', 'die', 'Wirtschaftsexperten erwarten eine Steigerung des Bruttoinlandsproduktes.
Economists expect an increase in gross domestic product.', 3791, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'deputy', 'Stellvertreter', ARRAY[]::text[], 'noun', 'der', 'Für den Präsidenten werden vier Stellvertreter gewählt.
For the President four deputies are elected.', 3792, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'strict', 'strikt', ARRAY[]::text[], NULL, NULL, 'Die Sekretärin hat strikte Anweisung, niemanden ins Zimmer zu lassen.
The secretary has strict orders not to let anyone into the room.', 3793, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to structure', 'strukturieren', ARRAY[]::text[], NULL, NULL, 'Einen wissenschaftlichen Aufsatz muss man gut strukturieren.
A scientific paper must be well structured.', 3794, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'subsidy', 'Subvention', ARRAY[]::text[], 'noun', 'die', 'Die Bauern bekommen Subventionen dafür, dass sie auf ihren Feldern Gras statt Getreide wachsen lassen.
The farmers receive subsidies for growing grass instead of grain on their fields.', 3795, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'therapeutic', 'therapeutisch', ARRAY[]::text[], NULL, NULL, 'Hierfür gibt es eine Vielzahl an therapeutischen Möglichkeiten.
There are a variety of therapeutic options for this.', 3796, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ticket', 'Ticket', ARRAY[]::text[], 'noun', 'das', 'Tickets gibt es an der Abendkasse und an den bekannten Vorverkaufsstellen.
Tickets are available at the box office and at the usual outlets.', 3797, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tunnel', 'Tunnel', ARRAY[]::text[], 'noun', 'der', 'Der Zug fährt durch einen Tunnel.
The train goes through a tunnel.', 3798, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'overview', 'Übersicht', ARRAY[]::text[], 'noun', 'die', 'Vom Lehrerpult aus hat man eine gute Übersicht über die Klasse.
From the teacher''s desk one has a good overview of the class.', 3799, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exaggerate', 'übertreiben', ARRAY[]::text[], NULL, NULL, 'Jetzt übertreibst du aber!
Now you''re exaggerating!', 3800, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for free, in vain', 'umsonst', ARRAY[]::text[], NULL, NULL, 'Alle Arbeit war umsonst.
All work was in vain.', 3801, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unhappy, unfortunate', 'unglücklich', ARRAY[]::text[], NULL, NULL, 'Jens ist so unglücklich hingefallen, dass er sich das Bein gebrochen hat.
Jens has fallen so unfortunately, that he has broken his leg.', 3802, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'uniform', 'Uniform', ARRAY[]::text[], 'noun', 'die', 'Selbst die Uniformen der Polizei sehen jetzt recht sportlich aus.
Even the uniforms of the police now look quite sporty.', 3803, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'injustice, wrong', 'Unrecht', ARRAY[]::text[], 'noun', 'das', 'Du bist im Unrecht.
You are wrong.', 3804, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to suppress', 'unterdrücken', ARRAY[]::text[], NULL, NULL, 'Sie konnte ein Lachen kaum unterdrücken.
She could hardly suppress a laugh.', 3805, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to double', 'verdoppeln', ARRAY[]::text[], NULL, NULL, 'In zehn Jahren verdoppelte sich die Bevölkerung.
In ten years the population will have doubled.', 3806, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to drive out, suppress', 'verdrängen', ARRAY[]::text[], NULL, NULL, 'Stephan hat die Probleme jahrelang verdrängt.
Stephan has surpressed the problems for years.', 3807, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to simplify', 'vereinfachen', ARRAY[]::text[], NULL, NULL, 'Um die Fragestellung zu vereinfachen, ist sie in drei Teilfragen unterteilt.
To simplify the question, it is divided into three sub-questions.', 3808, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to astonish', 'verwundern', ARRAY[]::text[], NULL, NULL, 'Das verwundert mich gar nicht.
That does not astonish me at all.', 3809, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'vitamin', 'Vitamin', ARRAY[]::text[], 'noun', 'das', 'Kiwis enthalten viel Vitamin C.
Kiwis are rich in vitamin C.', 3810, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'national economy', 'Volkswirtschaft', ARRAY[]::text[], 'noun', 'die', 'Die Volkswirtschaft ist letztes Jahr nur unwesentlich gewachsen.
The national economy has grown only slightly last year.', 3811, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lean forward, prevent', 'vorbeugen', ARRAY[]::text[], NULL, NULL, 'Vorbeugen ist besser als Heilen.
Prevention is better than cure.', 3812, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to read sth for sb', 'vorlesen', ARRAY[]::text[], NULL, NULL, 'Abends liest die Oma Geschichten vor.
Grandma reads stories in the evening.', 3813, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lecture', 'Vorlesung', ARRAY[]::text[], 'noun', 'die', 'Die Vorlesung ist total überlaufen.
The lecture is totally crowded.', 3814, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'early, premature', 'vorzeitig', ARRAY[]::text[], NULL, NULL, 'Die Bauarbeiten wurden vorzeitig abgeschlossen.
The construction was completed earlier.', 3815, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to blow, flutter', 'wehen', ARRAY[]::text[], NULL, NULL, 'Die Fahnen wehen im Sommerwind.
The flags are fattering in the breeze.', 3816, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'continuing education', 'Weiterbildung', ARRAY[]::text[], 'noun', 'die', 'Die Firmenleitung schickt ihre Mitarbeiter regelmäßig auf Weiterbildungen.
The management sends its employees on a regular basis on continuing education.', 3817, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'welcome', 'willkommen', ARRAY[]::text[], NULL, NULL, 'Der Gastgeber heißt alle willkommen und eröffnet das Büffet.
The host welcomes everyone and opens the buffet.', 3818, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'how, which', 'wodurch', ARRAY[]::text[], NULL, NULL, 'Wodurch kann man die Leistungsfähigkeit steigern?
How can we improve performance?', 3819, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tear (up, to pieces)', 'zerreißen', ARRAY[]::text[], NULL, NULL, 'Eric hat sich seine Jacke beim Klettern zerrissen.
Eric has torn his jacket while climbing.', 3820, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to aim', 'zielen', ARRAY[]::text[], NULL, NULL, 'Beim Basketball muss man gut zielen können.
In basketball you have to aim well.', 3821, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'target, objective', 'Zielsetzung', ARRAY[]::text[], 'noun', 'die', 'Im Laufe der Arbeit musste sie ihre Zielsetzung korrigieren.
In the course of the work she had to correct her target.', 3822, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'sugar', 'Zucker', ARRAY[]::text[], 'noun', 'der', 'In Cola ist eine Menge Zucker.
In Coke''s a lot of sugar.', 3823, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to lead to sth, supply', 'zuführen', ARRAY[]::text[], NULL, NULL, 'Wasser muss man Energie zuführen, um es zum Kochen zu bringen.
Water needs to be supplied with energy in order to heat it up.', 3824, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reject', 'zurückweisen', ARRAY[]::text[], NULL, NULL, 'Der Beschuldigte weist die Vorwürfe zurück.
The accused rejects the allegations.', 3825, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to believe sb capable', 'zutrauen', ARRAY[]::text[], NULL, NULL, 'Das hätte ich ihr nicht zugetraut.
I would not have believed her capable.', 3826, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reliable', 'zuverlässig', ARRAY[]::text[], NULL, NULL, 'Wenn es um Pünktlichkeit geht, ist Helmut absolut zuverlässig.
When it comes to punctuality, Helmut is absolutely reliable.', 3827, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to enclose, differentiate, distinguish', 'abgrenzen', ARRAY[]::text[], NULL, NULL, 'Um die eigene Identität zu wahren, ist es wichtig, sich von anderen abzugrenzen.
In order to preserve one''s own identity, it is important to distinguish oneself from others.', 3828, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'agreement', 'Abkommen', ARRAY[]::text[], 'noun', 'das', 'Sie haben ein Abkommen zur gegenseitigen Unterstützung geschlossen.
They have concluded an agreement for mutual support.', 3829, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to distract, deflect', 'ablenken', ARRAY[]::text[], NULL, NULL, 'Du lenkst schon wieder vom Thema ab.
You distract again fromthe subject.', 3830, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tear (down, off), stop', 'abreißen', ARRAY[]::text[], NULL, NULL, 'Der Strom der Spenden reißt nicht ab.
The stream of donations does not stop.', 3831, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to switch off', 'abschalten', ARRAY[]::text[], NULL, NULL, 'Schalte den Computer bitte nicht ab, ich muss noch etwas schreiben.
Please do not switch off the computer, I must write something.', 3832, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'graduate', 'Absolvent', ARRAY[]::text[], 'noun', 'der', 'Die Absolventen werden feierlich verabschiedet.
The graduates will be formally proclaimed.', 3833, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'defence', 'Abwehr', ARRAY[]::text[], 'noun', 'die', 'Das Immunsystem ist für die Abwehr von Krankheiten zuständig.
The immune system is responsible for the defence from diseases.', 3834, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to one another', 'aneinander', ARRAY[]::text[], NULL, NULL, 'Sie haben sich aneinander gewöhnt.
They have got used to one another.', 3835, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to notice, add, let show', 'anmerken', ARRAY[]::text[], NULL, NULL, 'Sie lässt sich den Schmerz nicht anmerken.
You does not let show the pain.', 3836, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'apple', 'Apfel', ARRAY[]::text[], 'noun', 'der', 'Äpfel sind gesund.
Apples are healthy.', 3837, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'work capacity, worker', 'Arbeitskraft', ARRAY[]::text[], 'noun', 'die', 'An dieser Stelle sollten wir die Arbeitskräfte bündeln.
At this point we should bundle the workers.', 3838, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'assistant', 'Assistent', ARRAY[]::text[], 'noun', 'der', 'Der Mann im grünen Jackett ist der Assistent vom Professor.
The man in the green jacket is the assistant to the professor.', 3839, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'aesthetic', 'ästhetisch', ARRAY[]::text[], NULL, NULL, 'Die Landschaft ist ästhetisch reizvoll.
The landscape is aesthetically appealing.', 3840, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to open, raise, wind', 'aufziehen', ARRAY[]::text[], NULL, NULL, 'Mechanische Uhren muss man aufziehen.
Mechanical watches need to be winded.', 3841, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to exempt, gut', 'ausnehmen', ARRAY[]::text[], NULL, NULL, 'Erst muss man den Fisch ausnehmen, dann kann man ihn braten.
First you have to exempt the fish, then you can fry it.', 3842, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'evaluation, analysis', 'Auswertung', ARRAY[]::text[], 'noun', 'die', 'Die Auswertung der Fragebögen erfolgt durch Spezialisten.
The analysis of questionnaires is carried out by specialists.', 3843, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bar', 'Bar', ARRAY[]::text[], 'noun', 'die', 'Sie sitzt ganz allein an der Bar und trinkt einen Schnaps nach dem anderen.
She sits all alone at the bar and drinks one schnaps after the other.', 3844, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'threat', 'Bedrohung', ARRAY[]::text[], 'noun', 'die', 'Die Bedrohung durch Computerviren ist nicht zu unterschätzen.
The threat of computer viruses is not to be underestimated.', 3845, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to one side', 'beiseite', ARRAY[]::text[], NULL, NULL, 'Er schiebt den Teller beiseite und zeichnet mit dem Finger einen Stadtplan aufs Tischtuch.
He pushes his plate to one side and draws a map with his finger on the tablecloth.', 3846, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fighting, controlling', 'Bekämpfung', ARRAY[]::text[], 'noun', 'die', 'Dieses Mittel eignet sich zur Bekämpfung von Blattläusen.
This remedy is useful for control of aphids.', 3847, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to behave', 'benehmen', ARRAY[]::text[], NULL, NULL, 'Kannst du dich bitte diesmal anständig benehmen?
Can you please behave properly this time?', 3848, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'restriction', 'Beschränkung', ARRAY[]::text[], 'noun', 'die', 'Die Beschränkung der Geschwindigkeit wird nach der Baustelle aufgehoben.
The speed restriction ends after the construction area.', 3849, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pray', 'beten', ARRAY[]::text[], NULL, NULL, 'Die Bauern beten um Regen.
Farmers pray for rain.', 3850, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'bitter', 'bitter', ARRAY[]::text[], NULL, NULL, 'Die Schokolade ist mir zu bitter.
The chocolate is too bitter.', 3851, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'block', 'Block', ARRAY[]::text[], 'noun', 'der', 'Lass uns noch einmal um den Block fahren.
Let''s go around the block again.', 3852, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to drill', 'bohren', ARRAY[]::text[], NULL, NULL, 'Der Zahnarzt muss heute bohren.
The dentist must drill today.', 3853, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fry, roast', 'braten', ARRAY[]::text[], NULL, NULL, 'Schnitzel darf man nur kurz braten.
Schnitzel must only be fried shortly.', 3854, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to brake, slow down', 'bremsen', ARRAY[]::text[], NULL, NULL, 'Vor einer roten Ampel sollte man bremsen.
At a red light you should slow down.', 3855, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'at home', 'daheim', ARRAY[]::text[], NULL, NULL, 'Zum Abendessen müssen wir wieder daheim sein.
For dinner we have to be home again.', 3856, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'loan', 'Darlehen', ARRAY[]::text[], 'noun', 'das', 'Sabine bekommt bei keiner Bank mehr ein Darlehen.
Sabine gets no loan anymore at any bank.', 3857, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'date', 'Datum', ARRAY[]::text[], 'noun', 'das', 'Welches Datum haben wir heute?
What is the date today?', 3858, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tolerate', 'dulden', ARRAY[]::text[], NULL, NULL, 'Ich dulde keinen Widerspruch.
I don''t tolerate any opposition.', 3859, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go through', 'durchgehen', ARRAY[]::text[], NULL, NULL, 'Solche Fehler werden wir nicht einfach durchgehen lassen.
Such errors, we will not let go easily.', 3860, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pull in, ask for, catch up', 'einholen', ARRAY[]::text[], NULL, NULL, 'Geht schon los, ich hole euch schon ein.
Just go, I will catch up anyway.', 3861, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'former', 'einstig', ARRAY[]::text[], NULL, NULL, 'Der einstige Bundeskanzler ist jetzt Privatmann.
The former chancellor is now a private citizen.', 3862, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'preservation, maintenance', 'Erhaltung', ARRAY[]::text[], 'noun', 'die', 'Fortpflanzung dient zur Erhaltung der Art.
Reproduction is used for preservation of the species', 3863, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to inquire', 'erkundigen', ARRAY[]::text[], NULL, NULL, 'Erkundigen Sie sich beim Akademischen Auslandsamt nach Sprachkursen.
Inquire at theAcademic International Centre about language courses.', 3864, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'storyteller, narrator', 'Erzähler', ARRAY[]::text[], 'noun', 'der', 'Opa ist ein guter Erzähler.
Grandpa is a good storyteller.', 3865, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(academic) department, field', 'Fachbereich', ARRAY[]::text[], 'noun', 'der', 'Der Fachbereich Informatik bekommt einen neuen Leiter.
The department of computer science has a new leader.', 3866, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'experts', 'Fachleute', ARRAY[]::text[], 'noun', 'die', 'Diese Messe ist für Laien und Fachleute gleichermaßen von Interesse.
This show is for amateurs and professionals alike of interest.', 3867, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'facts', 'Fakten', ARRAY[]::text[], 'noun', 'die', 'Olaf kann man nur mit harten Fakten überzeugen.
Olaf can only be convinced with hard facts.', 3868, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'due', 'fällig', ARRAY[]::text[], NULL, NULL, 'Die Zinsen werden am Jahresende fällig.
Interest is due at the end of the year.', 3869, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'version, composure, frame, socket', 'Fassung', ARRAY[]::text[], 'noun', 'die', 'Die Glühbirne ist nicht richtig in der Fassung.
The bulb is not properly in the socket.', 3870, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'wing', 'Flügel', ARRAY[]::text[], 'noun', 'der', 'Der Vogel hat sich den Flügel gebrochen.
The bird has broken a wing.', 3871, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'liquid', 'flüssig', ARRAY[]::text[], NULL, NULL, 'Heißes Wachs ist flüssig.
Hot wax is liquid.', 3872, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'consequently', 'folglich', ARRAY[]::text[], NULL, NULL, 'Da ich Iris nie Hoffnungen gemacht habe, kann ich sie ihr folglich auch nicht nehmen.
Since I''ve never made Iris hopes, I consequently can''t take them from her', 3873, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'forum, audience, public discussion', 'Forum', ARRAY[]::text[], 'noun', 'das', 'Sie sprach vor einem internationalen Forum.
She spoke before an international forum.', 3874, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'frequency', 'Frequenz', ARRAY[]::text[], 'noun', 'die', 'Radio grün sendet auf einer Frequenz von 92,4.
Radio green broadcasts on a frequency of 92.4', 3875, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fruit', 'Frucht', ARRAY[]::text[], 'noun', 'die', 'An der Obsttheke gibt es Früchte aus aller Welt.
At the fruit counter, there are fruits from around the world.', 3876, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'twenty-five', 'fünfundzwanzig', ARRAY[]::text[], NULL, NULL, 'Isabel ist fünfundzwanzig Jahre alt.
Isabel''s twenty-five years old.', 3877, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'justice', 'Gerechtigkeit', ARRAY[]::text[], 'noun', 'die', 'Kinder haben ein starkes Empfinden für Gerechtigkeit.
Children have a strong sense of justice.', 3878, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'peak, summit', 'Gipfel', ARRAY[]::text[], 'noun', 'der', 'Die schneebedeckten Gipfel glitzerten in der Abendsonne.
The snow-capped peaks glistened in the sun.', 3879, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'shining, brilliant', 'glänzend', ARRAY[]::text[], NULL, NULL, 'Das war eine glänzende Leistung.
That was a brilliant performance.', 3880, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'large part, majority', 'Großteil', ARRAY[]::text[], 'noun', 'der', 'Ein Großteil der Einnahmen ergibt sich aus Spenden.
A large part of the revenue arose from donations.', 3881, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'harmless', 'harmlos', ARRAY[]::text[], NULL, NULL, 'Windpocken sind eine harmlose Kinderkrankheit.
Chickenpox is a harmless childhood disease.', 3882, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ugly', 'hässlich', ARRAY[]::text[], NULL, NULL, 'Ist der aber hässlich!
But he''s ugly!', 3883, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'high-quality', 'hochwertig', ARRAY[]::text[], NULL, NULL, 'Wir verkaufen nur hochwertige Produkte, von deren Qualität wir überzeugt sind.
We only sell quality products, of which quality we are convinced.', 3884, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'listener, receiver', 'Hörer', ARRAY[]::text[], 'noun', 'der', 'Der Radiosender legt großen Wert auf die Meinung seiner Hörer.
The radio station attaches great importance to the opinion of his listeners.', 3885, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Native American', 'Indianer', ARRAY[]::text[], 'noun', 'der', 'Die Indianer Nordamerikas müssen immer noch um ihre Rechte kämpfen.
The Natives of North America must still fight for their rights.', 3886, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'industrial(ized) country', 'Industrieland', ARRAY[]::text[], 'noun', 'das', 'Übergewicht ist vor allem ein Problem der Industrieländer.
Obesity is primarily a problem of industrialized countries.', 3887, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to install', 'installieren', ARRAY[]::text[], NULL, NULL, 'Dieses Programm kann kostenlos installiert werden.
This program can be installed free of charge.', 3888, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intercultural', 'interkulturell', ARRAY[]::text[], NULL, NULL, 'In der interkulturellen Kommunikation kommt es immer wieder zu Missverständnissen.
In intercultural communication there are always misunderstandings.', 3889, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'jacket', 'Jacke', ARRAY[]::text[], 'noun', 'die', 'Die Jacke hängt am Haken.
The jacket is on the hook.', 3890, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'hunt, chase', 'Jagd', ARRAY[]::text[], 'noun', 'die', 'In den frühen Morgenstunden geht er auf die Jagd.
In the early morning hours, he goes hunting.', 3891, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'season', 'Jahreszeit', ARRAY[]::text[], 'noun', 'die', 'Der Frühling ist die schönste Jahreszeit.
Spring is the best season.', 3892, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to plan, design', 'konzipieren', ARRAY[]::text[], NULL, NULL, 'Das Gerät ist für die Verwendung im Haushalt konzipiert.
The unit is designed for domestic use.', 3893, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lamp', 'Lampe', ARRAY[]::text[], 'noun', 'die', 'Die Lampe in der Küche ist kaputt.
The lamp in the kitchen is broken.', 3894, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rural', 'ländlich', ARRAY[]::text[], NULL, NULL, 'In dieser ländlichen Idylle kann man sich wunderbar erholen.
In this rural idyll, you can relax.', 3895, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'lens', 'Linse', ARRAY[]::text[], 'noun', 'die', 'Eine konkave Linse ist in der Mitte dünner als am Rand.
A concave lens is thinner in the middle than at the edge.', 3896, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to let go', 'loslassen', ARRAY[]::text[], NULL, NULL, 'Wenn man einen Drachen loslässt, fliegt er weg.
If you let go of a dragon, it flies away.', 3897, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'gap', 'Lücke', ARRAY[]::text[], 'noun', 'die', 'Der Stürmer nutzt die Lücke in der Abwehr.
The attacker uses the gap in the defense.', 3898, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'metal', 'Metall', ARRAY[]::text[], 'noun', 'das', 'Eisen, Kupfer und Zink sind Metalle.
Iron, copper and zinc are metals.', 3899, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'abuse, misuse', 'Missbrauch', ARRAY[]::text[], 'noun', 'der', 'Der Junge könnte einem Missbrauch zum Opfer gefallen sein.
The boy could be a victim of abuse.', 3900, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'motivation', 'Motivation', ARRAY[]::text[], 'noun', 'die', 'Die Motivation ist entscheidend für den Lernerfolg.
The motivation is crucial for successful learning.', 3901, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'thoughtful', 'nachdenklich', ARRAY[]::text[], NULL, NULL, 'Nachdenklich schüttelte er den Kopf.
Thoughtfully, he shook his head.', 3902, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'optimistic', 'optimistisch', ARRAY[]::text[], NULL, NULL, 'Bezüglich des Weihnachtsgeschäfts zeigt sich der Handel optimistisch.
For the Christmas sales, the trade is being optimistic.', 3903, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'option', 'Option', ARRAY[]::text[], 'noun', 'die', 'Diese Option lasse ich mir offen.
This option I let open for myself.', 3904, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'file', 'Ordner', ARRAY[]::text[], 'noun', 'der', 'Der Ordner mit den Prozessakten steht im Regal.
The file containing the documents about the proces is on the shelf.', 3905, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ocean', 'Ozean', ARRAY[]::text[], 'noun', 'der', 'In den Tiefen des Ozeans warten gesunkene Schiffe auf ihre Entdeckung durch Schatzsucher.
In the depths of the ocean, sunken ships are waiting the discovery by treasure hunters.', 3906, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'physicist', 'Physiker', ARRAY[]::text[], 'noun', 'der', 'Klaus arbeitet als Physiker.
Klaus works as a physicist.', 3907, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pistol', 'Pistole', ARRAY[]::text[], 'noun', 'die', 'Der Bankräuber bedrohte die Angestellten mit einer Pistole.
The robber threatened the employees with a gun.', 3908, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to protest', 'protestieren', ARRAY[]::text[], NULL, NULL, 'Die Gewerkschaft protestiert gegen die angekündigten Lohnkürzungen.
The union is protesting against the announced pay cuts.', 3909, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reach, range', 'Reichweite', ARRAY[]::text[], 'noun', 'die', 'Die Wasserpistole hat eine Reichweite von fünf Metern.
The water gun has a range of five meters.', 3910, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'repair', 'Reparatur', ARRAY[]::text[], 'noun', 'die', 'Die Reparatur ist teurer als ein Neukauf.
The repair is more expensive than a new purchase.', 3911, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to represent', 'repräsentieren', ARRAY[]::text[], NULL, NULL, 'Der Bürgermeister repräsentiert die Stadt im Städtebund.
The mayor represents the city in the league of cities.', 3912, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'respect', 'Respekt', ARRAY[]::text[], 'noun', 'der', 'Vor dieser Leistung habe ich großen Respekt.
For to this performance I have great respect.', 3913, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rose', 'Rose', ARRAY[]::text[], 'noun', 'die', 'Zum zehnten Hochzeitstag bekam sie zehn rote Rosen von ihrem Mann.
For the tenth wedding anniversary, she got ten red roses from her husband', 3914, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rucksack, backpack', 'Rucksack', ARRAY[]::text[], 'noun', 'der', 'Im Rucksack trägt sie den Proviant und den Regenschirm.
In the backpack she carries the food and the umbrella.', 3915, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'singer', 'Sänger', ARRAY[]::text[], 'noun', 'der', 'Das Konzert muss ausfallen, weil der Sänger erkältet ist.
The concert must be cancelled, because the singer has a cold.', 3916, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to scold, grumble', 'schimpfen', ARRAY[]::text[], NULL, NULL, 'Die Mutter schimpft mit den frechen Kindern.
The mother scolds the naughty children.', 3917, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'dirty', 'schmutzig', ARRAY[]::text[], NULL, NULL, 'Die schmutzigen Schuhe lässt Ruben vor der Tür stehen.
The dirty shoes Ruben lets outside.', 3918, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'diagonal, at an angle', 'schräg', ARRAY[]::text[], NULL, NULL, 'Die Brücke geht schräg über den Fluss.
The bridge goes diagonally across the river.', 3919, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stride, walk', 'schreiten', ARRAY[]::text[], NULL, NULL, 'Ein Mann schreitet in der Halle auf und ab.
A man walks the the hall up and down.', 3920, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'on the part of', 'seitens', ARRAY[]::text[], NULL, NULL, 'Die positiven Reaktionen seitens des Publikums bestätigten den Regisseur.
The positive reactions on the part of the audience confirmed the director.', 3921, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Social Democrat', 'Sozialdemokrat', ARRAY[]::text[], 'noun', 'der', 'Die Sozialdemokraten stellen die Regierung.
The Social Democrats are the government.', 3922, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stretch, tighten', 'spannen', ARRAY[]::text[], NULL, NULL, 'Ich spanne ein Seil im Garten, um Wäsche aufzuhängen.
I stretch a rope in the garden to hang clothes.', 3923, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'tablet, pill', 'Tablette', ARRAY[]::text[], 'noun', 'die', 'Die Tabletten muss man eine halbe Stunde vor dem Essen einnehmen.
The pills must be taken half an hour before a meal.', 3924, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'daily newspaper', 'Tageszeitung', ARRAY[]::text[], 'noun', 'die', 'Die Tageszeitung ist um sechs Uhr morgens im Briefkasten.
The daily newspaper is in the mailbox at 6 o''clock in the morning.', 3925, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to deceive, be mistaken', 'täuschen', ARRAY[]::text[], NULL, NULL, 'Da habe ich mich leider getäuscht.
I have unfortunately be mistaken.', 3926, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'therapist', 'Therapeut', ARRAY[]::text[], 'noun', 'der', 'Es ist wichtig, den richtigen Therapeuten zu finden.
It is important to find the right therapist.', 3927, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to overtax, be too much', 'überfordern', ARRAY[]::text[], NULL, NULL, 'Diese Aufgabe überfordert ihn total.
This task totally overtaxes him.', 3928, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to rearrange, adjust, switch', 'umstellen', ARRAY[]::text[], NULL, NULL, 'Sie haben ihre Buchhaltung auf Computer umgestellt.
They have switched their accounting to computerbased.', 3929, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'move, parade', 'Umzug', ARRAY[]::text[], 'noun', 'der', 'Den Umzug bezahlt die Firma.
The move is paid for by the company.', 3930, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'unexpected', 'unerwartet', ARRAY[]::text[], NULL, NULL, 'Die Flutwelle kam völlig unerwartet.
The tidal wave was totally unexpected.', 3931, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'organizer', 'Veranstalter', ARRAY[]::text[], 'noun', 'der', 'Die Veranstalter sprachen von 5000 Demonstranten, die Polizei von 2000.
The organizers talked about 5,000 demonstrators, the police about 2000.', 3932, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to draw up, write', 'verfassen', ARRAY[]::text[], NULL, NULL, 'Die Schüler verfassen einen offenen Brief an den Bürgermeister.
Students write an open letter to the mayor.', 3933, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'comparatively', 'vergleichsweise', ARRAY[]::text[], NULL, NULL, 'Das ist vergleichsweise leicht zu lösen.
To be solved comparatively easy.', 3934, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'combination, link', 'Verknüpfung', ARRAY[]::text[], 'noun', 'die', 'Das Seminar ist eine gelungene Verknüpfung von Theorie und Praxis.
The seminar is a successful link of theory and practice.', 3935, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to deepen, become absorbed', 'vertiefen', ARRAY[]::text[], NULL, NULL, 'Anja ist ganz in ihre Lektüre vertieft.
Anja is deepend in her reading.', 3936, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'advance', 'Vorfeld', ARRAY[]::text[], 'noun', 'das', 'Wir sollten uns das im Vorfeld sehr genau ansehen.
We should view this in advance very well.', 3937, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'predecessor', 'Vorgänger', ARRAY[]::text[], 'noun', 'der', 'Ihr Vorgänger im Amt war sehr beliebt.
Her predecessor in office was very popular.', 3938, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to predominate', 'vorherrschen', ARRAY[]::text[], NULL, NULL, 'In Utah herrscht kontinentales Klima vor.
In Utah, continental climate predominates.', 3939, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'currency', 'Währung', ARRAY[]::text[], 'noun', 'die', 'Seit 2002 haben viele EU-Staaten eine gemeinsame Währung: den Euro.
Since 2002, many EU countries have a common currency: the euro.', 3940, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to take away', 'wegnehmen', ARRAY[]::text[], NULL, NULL, 'Das Jugendamt hat ihr die Kinder weggenommen.
The Youth Office has taken away her children.', 3941, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'world champion', 'Weltmeister', ARRAY[]::text[], 'noun', 'der', 'Der viermalige Weltmeister beendet seine Sportkarriere.
The four-time world champion ends his sports career.', 3942, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'for what', 'wofür', ARRAY[]::text[], NULL, NULL, 'Wofür hast du so viel Geld bezahlt?
What did you pay so much money for?', 3943, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'rage, fury', 'Wut', ARRAY[]::text[], 'noun', 'die', 'Sie ist ganz rot vor Wut.
She is all red with rage.', 3944, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'classification, assignment', 'Zuordnung', ARRAY[]::text[], 'noun', 'die', 'Die Zuordnung zu einem Sprachkurs erfolgt durch einen Sprachtest.
The assignment for a language course takes place through a language test.', 3945, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to fall back', 'zurückgreifen', ARRAY[]::text[], NULL, NULL, 'Hier sollten wir auf die guten Erfahrungen aus dem letzten Jahr zurückgreifen.
Here we shouldfall back on the good experience from last year.', 3946, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'increase', 'Zuwachs', ARRAY[]::text[], 'noun', 'der', 'Analysten rechnen mit einem deutlichen Zuwachs im nächsten Quartal.
Analysts expect a significant increase in the next quarter.', 3947, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'waste, trash', 'Abfall', ARRAY[]::text[], 'noun', 'der', 'Bring bitte den Abfall hinaus!
Please bring out the trash!', 3948, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'absurd', 'absurd', ARRAY[]::text[], NULL, NULL, 'Der Vater hält ihre Ideen für völlig absurd.
The father thinks their ideas are completely absurd.', 3949, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'file', 'Akte', ARRAY[]::text[], 'noun', 'die', 'Er bat darum, Einsicht in seine Akte zu bekommen.
He asked for entry to his file', 3950, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'one and a half', 'anderthalb', ARRAY[]::text[], NULL, NULL, 'Der Zug hatte anderthalb Stunden Verspätung.
The train had one and a half hour delay.', 3951, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to belong', 'angehören', ARRAY[]::text[], NULL, NULL, 'Er gehörte zeitlebens keiner Partei an.
He belonged to no party in lifetime.', 3952, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'loan, bond, borrowing', 'Anleihe', ARRAY[]::text[], 'noun', 'die', 'Manche Anleihen kann man bei fallenden Zinssätzen kündigen.
Some bonds can be terminated when interest rates fall.', 3953, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to do sth to sb', 'antun', ARRAY[]::text[], NULL, NULL, 'Du willst uns verlassen? Das kannst du uns nicht antun.
You want to leave us?You cannot do that to us.', 3954, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to entrust, confide', 'anvertrauen', ARRAY[]::text[], NULL, NULL, 'Wem kannst du dich anvertrauen?
Who can you confide to?', 3955, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Arab', 'Araber', ARRAY[]::text[], 'noun', 'der', 'Unsere Zahlen haben wir von den Arabern übernommen.
Our numbers we have inherited from the Arabs.', 3956, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'working hours', 'Arbeitszeit', ARRAY[]::text[], 'noun', 'die', 'Die Gewerkschaften wollen die wöchentliche Arbeitszeit reduzieren.
The unions want to reduce the working hours per week.', 3957, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to tidy up, clear (up)', 'aufräumen', ARRAY[]::text[], NULL, NULL, 'Am Wochenende müssen die Kinder ihr Zimmer aufräumen.
In the weekend, the children have to clean their room.', 3958, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'supervisory board', 'Aufsichtsrat', ARRAY[]::text[], 'noun', 'der', 'Der Aufsichtsrat hat das Sanierungskonzept gebilligt.
The Supervisory Board has approved the rehabilitation plan.', 3959, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'starting point', 'Ausgangspunkt', ARRAY[]::text[], 'noun', 'der', 'Kehren wir zum Ausgangspunkt der Diskussion zurück.
Let us return to the starting point of the discussion.', 3960, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'orientation, organization', 'Ausrichtung', ARRAY[]::text[], 'noun', 'die', 'Die Ausrichtung der nächsten Olympischen Spiele wird wohl an Paris fallen.
The organization of the next Olympic Games will probably go to Paris.', 3961, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'identity card', 'Ausweis', ARRAY[]::text[], 'noun', 'der', 'Dieser Ausweis ist zehn Jahre gültig.
This identity card is valid for ten years.', 3962, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'attention, consideration', 'Beachtung', ARRAY[]::text[], 'noun', 'die', 'Der Lehrer schenkt Marie keine Beachtung.
The teacher gives no attention to Mary.', 3963, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'degree, diploma', 'Diplom', ARRAY[]::text[], 'noun', 'das', 'Sofort nach seinem Diplom begann Klaus mit der Promotion.
Immediately after his graduation Klaus began with his promotion.', 3964, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'anyway', 'eh', ARRAY[]::text[], NULL, NULL, 'Ich kann an dem Abend eh nicht ausgehen.
I can not go out that night anyway.', 3965, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'insight', 'Einblick', ARRAY[]::text[], 'noun', 'der', 'Praktika bieten einen Einblick ins Berufsleben.
Internships provide an insight into working life.', 3966, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'angel', 'Engel', ARRAY[]::text[], 'noun', 'der', 'Den Hirten erschien ein Engel.
To the shepherds an angel appeared.', 3967, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to escape', 'entgehen', ARRAY[]::text[], NULL, NULL, 'Er entging nur mit Müh und Not seiner gerechten Strafe.
He escaped only with great difficulty to justice.', 3968, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'recording, entry', 'Erfassung', ARRAY[]::text[], 'noun', 'die', 'Kundenkarten dienen der Erfassung von Daten über den Käufer und sein Kaufverhalten.
Loyalty cards are used to collect data about the customer and their buying behavior.', 3969, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'flag', 'Fahne', ARRAY[]::text[], 'noun', 'die', 'Bei Staatstrauer wehen die Fahnen auf Halbmast.
At national mournings flags fly at half mast.', 3970, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'faculty', 'Fakultät', ARRAY[]::text[], 'noun', 'die', 'Die Fakultät für Wirtschaftswissenschaften bietet drei Diplomstudiengänge an.
The faculty of economics offers three graduate degree programs.', 3971, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'façade, front', 'Fassade', ARRAY[]::text[], 'noun', 'die', 'Die Fassade des Hauses wird neu gestrichen.
The facade of the house is newly painted.', 3972, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'celebration', 'Feier', ARRAY[]::text[], 'noun', 'die', 'Zu der Feier am Sonnabend sind nur die Verwandten eingeladen.
To the celebration on Saturday only relatives are invited.', 3973, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to determine', 'festsetzen', ARRAY[]::text[], NULL, NULL, 'Der Abgabetermin wird auf den 1. Juni festgesetzt.
The deadline is determined for 1 June.', 3974, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'spring', 'Frühling', ARRAY[]::text[], 'noun', 'der', 'Im Frühling werden die Tage wieder länger.
In spring, the days are getting longer.', 3975, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'district council', 'Gemeinderat', ARRAY[]::text[], 'noun', 'der', 'Im nächsten Jahr wird ein neuer Gemeinderat gewählt.
Next year a new district council will be elected.', 3976, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', '(using) genetic engineering', 'gentechnisch', ARRAY[]::text[], NULL, NULL, 'Gentechnisch veränderte Lebensmittel müssen gekennzeichnet werden.
Genetically modified foods must be labeled.', 3977, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'fabric, tissue', 'Gewebe', ARRAY[]::text[], 'noun', 'das', 'Die Jacke war aus einem besonders festen Gewebe genäht.
The jacket was woven from a very resistant fabric.', 3978, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'splendid, superb', 'großartig', ARRAY[]::text[], NULL, NULL, 'Das Essen schmeckt wirklich großartig.
The food tastes really superb.', 3979, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'greeting', 'Gruß', ARRAY[]::text[], 'noun', 'der', 'Sag deiner Mutter einen schönen Gruß von mir.
Tell your mother a nice greeting from me.', 3980, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to publish, give change, hand out', 'herausgeben', ARRAY[]::text[], NULL, NULL, 'Können Sie mir auf 50 Euro herausgeben?
Can you give change to 50 €?', 3981, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'helpless', 'hilflos', ARRAY[]::text[], NULL, NULL, 'Johanna blickt den Lehrer hilflos an, damit er ihr die Aufgabe nochmal erklärt.
Johanna looks helplessly at the teacher, so he explains her the exercise again.', 3982, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to stage', 'inszenieren', ARRAY[]::text[], NULL, NULL, 'Die Oper war großartig inszeniert.
The opera was staged great.', 3983, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'jurist, law student', 'Jurist', ARRAY[]::text[], 'noun', 'der', 'Der jetzige Rektor der Universität ist Jurist.
The current rector of the university''s a jurist.', 3984, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'candle', 'Kerze', ARRAY[]::text[], 'noun', 'die', 'Die Kerzen auf dem Geburtstagskuchen muss man selbst auspusten.
The candles on the birthday cake you have to blow out yourself.', 3985, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'cook', 'Koch', ARRAY[]::text[], 'noun', 'der', 'Viele Köche verderben den Brei.
Too many cooks spoil the broth.', 3986, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Cologne', 'Kölner', ARRAY[]::text[], NULL, NULL, 'Vom Turm des Kölner Doms aus hat man einen schönen Blick über die Stadt und den Rhein.
From the tower of Cologne Cathedral, you have a beautiful view over the city and the Rhine.', 3987, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'municipality, local authority', 'Kommune', ARRAY[]::text[], 'noun', 'die', 'Bund, Länder und Kommunen haben mit niedrigeren Steuereinnahmen zu rechnen.
Federation, state and local municipalities have to reckon with lower tax revenues.', 3988, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'coral', 'Koralle', ARRAY[]::text[], 'noun', 'die', 'Korallen sind ein Schmuckmaterial von ganz besonderer Faszination.
Corals are a decorative material of particular fascination.', 3989, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'health insurance company', 'Krankenkasse', ARRAY[]::text[], 'noun', 'die', 'Die Krankenkassen erhöhen ihre Beiträge um durchschnittlich 0,5 Prozentpunkte.
The health insurance companies increase their premiums by an average of 0.5 percentage points.', 3990, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'synthetic material, plastic', 'Kunststoff', ARRAY[]::text[], 'noun', 'der', 'Die meisten Gummistiefel sind aus Kunststoff.
Most boots are made of plastic.', 3991, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'state government', 'Landesregierung', ARRAY[]::text[], 'noun', 'die', 'Die Landesregierung ist zerstritten.
The state government is divided.', 3992, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'mood', 'Laune', ARRAY[]::text[], 'noun', 'die', 'Sonnenschein macht gute Laune.
Sunshine makes a good mood.', 3993, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to warn, urge', 'mahnen', ARRAY[]::text[], NULL, NULL, 'Die Behörden mahnen zur Vorsicht beim Umgang mit Mobilfunk.
Authorities urge caution when dealing with mobile phones.', 3994, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'food', 'Nahrungsmittel', ARRAY[]::text[], 'noun', 'das', 'Sandra ist gegen viele Nahrungsmittel allergisch.
Sandra is allergic to many foods.', 3995, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'Dutch', 'niederländisch', ARRAY[]::text[], NULL, NULL, 'Die niederländische Sprache ist mit der deutschen verwandt.
The Dutch language is related to the German one.', 3996, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'nowhere', 'nirgendwo', ARRAY[]::text[], NULL, NULL, 'Das Buch ist nirgendwo zu finden.
The book is nowhere to be found.', 3997, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'East German', 'ostdeutsch', ARRAY[]::text[], NULL, NULL, 'Auch fünfzehn Jahre nach der Wende liegen ostdeutsche Löhne deutlich unter West-niveau.
Even fifteen years after the fall East German wages are far below Western level.', 3998, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'eastern', 'östlich', ARRAY[]::text[], NULL, NULL, 'Der Wind weht böig aus östlichen Richtungen.
The wind blows from easterly directions.', 3999, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'philosopher', 'Philosoph', ARRAY[]::text[], 'noun', 'der', 'Friedrich der Große war Schriftsteller und Philosoph, Feldherr und Komponist.
Frederick the Great was a writer and philosopher, soldier and composer.', 4000, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'prince', 'Prinz', ARRAY[]::text[], 'noun', 'der', 'Der Prinz küsste Dornröschen, und sie erwachte.
The Prince kissed Sleeping Beauty, and she awoke.', 4001, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'profile', 'Profil', ARRAY[]::text[], 'noun', 'das', 'Winterreifen haben ein starkes Profil.
Winter tires have a strong profile.', 4002, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'radioactive', 'radioaktiv', ARRAY[]::text[], NULL, NULL, 'Die ganze Region ist radioaktiv verseucht.
The whole region is contaminated with radioactivity.', 4003, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to reflect', 'reflektieren', ARRAY[]::text[], NULL, NULL, 'Weil das Wasser die Sonnenstrahlen reflektiert, bekommt man beim Segeln schnell Sonnenbrand.
Because the water reflects the sun''s rays, you get sunburned very easily when sailing.', 4004, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'appropriateness, proportion, relation', 'Relation', ARRAY[]::text[], 'noun', 'die', 'Der Aufwand steht in keiner Relation zum Ertrag.
The effort is in no relation to ith income.', 4005, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'reef', 'Riff', ARRAY[]::text[], 'noun', 'das', 'Im Riff leben verschiedene Korallenarten und bunte Fische.
The reef is home to several species of coral and colorful fish.', 4006, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'snake, line', 'Schlange', ARRAY[]::text[], 'noun', 'die', 'Vor dem Museum bildete sich eine lange Schlange.
Before the museum therewas a long queue.', 4007, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to creep, prowl, sneak', 'schleichen', ARRAY[]::text[], NULL, NULL, 'Leise schleichen die Kinder aus dem Bett und zum Kühlschrank.
Quietly, the children sneak out of bed and to the refrigerator.', 4008, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'pig', 'Schwein', ARRAY[]::text[], 'noun', 'das', 'Schweine sind Allesfresser.
Pigs are omnivores.', 4009, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to sail', 'segeln', ARRAY[]::text[], NULL, NULL, 'Am Sonntag will mein Süßer mit mir segeln geh’n.
On Sunday my sweet one wants to sail with me.', 4010, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'independence', 'Selbstständigkeit', ARRAY[]::text[], 'noun', 'die', 'Der Kindergarten will die Selbstständigkeit der Kinder fördern.
The nursery aims to promote the independence of the children.', 4011, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'settlement, housing development', 'Siedlung', ARRAY[]::text[], 'noun', 'die', 'Das Dorf entstand aus einer fränkischen Siedlung.
The village grew out of a Frankish settlement.', 4012, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'solid, sound', 'solide', ARRAY[]::text[], NULL, NULL, 'Eine solide Ausbildung ist die beste Voraussetzung für einen erfolgreichen Berufseinstieg.
A solid education is the best prerequisite for a successful career.', 4013, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'saying, slogan', 'Spruch', ARRAY[]::text[], 'noun', 'der', 'Die Wände waren mit Sprüchen beschmiert.
The walls were daubed with slogans.', 4014, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'opinion, statement', 'Stellungnahme', ARRAY[]::text[], 'noun', 'die', 'Die Politiker gaben im Anschluss an ihre Unterredung eine Stellungnahme ab.
The politicians gave a statement after their discussions.', 4015, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'ray, beam', 'Strahl', ARRAY[]::text[], 'noun', 'der', 'Die Strahlen der Sonne fallen durch das Blätterdach.
The rays of the sun fall through the canopy.', 4016, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to strive', 'streben', ARRAY[]::text[], NULL, NULL, 'Birgit strebt nach olympischem Gold.
Birgit strives for Olympic gold.', 4017, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'current, trend', 'Strömung', ARRAY[]::text[], 'noun', 'die', 'Der Fluss hat hier eine starke Strömung.
The river here has a strong current.', 4018, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'technological', 'technologisch', ARRAY[]::text[], NULL, NULL, 'Der technologische Fortschritt hat die Kommunikation beschleunigt.
The technological progress has accelerated communication.', 4019, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to dry', 'trocknen', ARRAY[]::text[], NULL, NULL, 'Bei Wind trocknet die Wäsche schneller.
When it''s windy clothes dry faster.', 4020, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to pass, overhaul', 'überholen', ARRAY[]::text[], NULL, NULL, 'Auf der Autobahn darf man nur links überholen.
On the highway you can only overhaul on the left.', 4021, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'intolerable', 'unerträglich', ARRAY[]::text[], NULL, NULL, 'Der Lärm von der Baustelle ist unerträglich.
The noise from the construction site is intolerable.', 4022, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to put in charge, imply, store', 'unterstellen', ARRAY[]::text[], NULL, NULL, 'Ihnen wird die Abteilung für Forschung und Entwicklung unterstellt.
You will be put in charge of the Department of Research and Development.', 4023, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'obligation, liability, reliability', 'Verbindlichkeit', ARRAY[]::text[], 'noun', 'die', 'Die Ehe ist ein Ausdruck der Verbindlichkeit in einer unverbindlichen Welt.
Marriage is an expression of reliability in a non-binding world.', 4024, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to use, consume', 'verbrauchen', ARRAY[]::text[], NULL, NULL, 'Energiesparlampen verbrauchen weniger Strom als herkömmliche Glühbirnen.
Energy saving light bulbs consume less electricity than conventional bulbs.', 4025, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to neglect', 'vernachlässigen', ARRAY[]::text[], NULL, NULL, 'Paula arbeitet zuviel und vernachlässigt ihre Tochter.
Paula works too much and neglects her daughter.', 4026, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'volume, total amount', 'Volumen', ARRAY[]::text[], 'noun', 'das', 'Der Auftrag hat ein Volumen von ca. 50 000 Euro.
The contract has a volume of about 50 000 €.', 4027, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to go past, pass', 'vorbeigehen', ARRAY[]::text[], NULL, NULL, 'Alles geht vorbei.
Everything will pass.', 4028, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'to present, perform', 'vortragen', ARRAY[]::text[], NULL, NULL, 'Die Projektgruppe trägt ihre Ergebnisse vor.
The team presents its finding.', 4029, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'woman (derogatory)', 'Weib', ARRAY[]::text[], 'noun', 'das', 'Seine Nachbarin ist ein furchtbares Weib.
His neighbor is a terrible woman.', 4030, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'West German', 'westdeutsch', ARRAY[]::text[], NULL, NULL, 'Westdeutsche Produkte konnte man manchmal auch in der DDR kaufen.
West German products could sometimes be bought in the GDR.', 4031, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'access', 'Zugriff', ARRAY[]::text[], 'noun', 'der', 'Auf diese Daten hat nur der Administrator Zugriff.
To this data only the administrator has access.', 4032, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'listener, audience (pl)', 'Zuhörer', ARRAY[]::text[], 'noun', 'der', 'Daniel ist ein guter Zuhörer.
Daniel is a good listener.', 4033, 'seed'),
  ('b7c8e3a0-6d4f-4e2a-9c1b-000000005000', 'undoubtedly', 'zweifellos', ARRAY[]::text[], NULL, NULL, 'Das bekannteste optische Gerät ist zweifellos die Brille.
The best-known optical device is undoubtedly the glasses.', 4034, 'seed');
