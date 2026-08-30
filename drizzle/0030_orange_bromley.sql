ALTER TABLE "verb_review_state" DROP CONSTRAINT "verb_review_state_user_verb";--> statement-breakpoint
ALTER TABLE "verb_review_state" ADD COLUMN "tense" text DEFAULT 'present' NOT NULL;--> statement-breakpoint
ALTER TABLE "verb_reviews" ADD COLUMN "tense" text DEFAULT 'present' NOT NULL;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "past_kind" text;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "perfekt" text;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "praet_ich" text;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "praet_du" text;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "praet_er" text;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "praet_wir" text;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "praet_ihr" text;--> statement-breakpoint
ALTER TABLE "verbs" ADD COLUMN "praet_sie" text;--> statement-breakpoint
ALTER TABLE "verb_review_state" ADD CONSTRAINT "verb_review_state_user_verb" UNIQUE("user_id","verb_id","tense");