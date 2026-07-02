ALTER TABLE "decks" ALTER COLUMN "owner_id" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "cards" ADD COLUMN "frequency_rank" integer;