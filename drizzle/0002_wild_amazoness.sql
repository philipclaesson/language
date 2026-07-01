CREATE TABLE "verb_review_state" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"verb_id" uuid NOT NULL,
	"due" timestamp with time zone DEFAULT now() NOT NULL,
	"stability" double precision DEFAULT 0 NOT NULL,
	"difficulty" double precision DEFAULT 0 NOT NULL,
	"reps" integer DEFAULT 0 NOT NULL,
	"lapses" integer DEFAULT 0 NOT NULL,
	"last_review" timestamp with time zone,
	"state" text DEFAULT 'new' NOT NULL,
	CONSTRAINT "verb_review_state_user_verb" UNIQUE("user_id","verb_id")
);
--> statement-breakpoint
CREATE TABLE "verb_reviews" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"verb_id" uuid NOT NULL,
	"rating" integer NOT NULL,
	"graded" boolean DEFAULT true NOT NULL,
	"typed_answer" jsonb,
	"reviewed_at" timestamp with time zone DEFAULT now() NOT NULL,
	"elapsed_ms" integer
);
--> statement-breakpoint
CREATE TABLE "verbs" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"infinitive" text NOT NULL,
	"english" text NOT NULL,
	"regularity" text NOT NULL,
	"frequency_rank" integer NOT NULL,
	"form_ich" text NOT NULL,
	"form_du" text NOT NULL,
	"form_er" text NOT NULL,
	"form_wir" text NOT NULL,
	"form_ihr" text NOT NULL,
	"form_sie" text NOT NULL,
	"notes" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "verbs_infinitive_unique" UNIQUE("infinitive")
);
--> statement-breakpoint
ALTER TABLE "verb_review_state" ADD CONSTRAINT "verb_review_state_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "verb_review_state" ADD CONSTRAINT "verb_review_state_verb_id_verbs_id_fk" FOREIGN KEY ("verb_id") REFERENCES "public"."verbs"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "verb_reviews" ADD CONSTRAINT "verb_reviews_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "verb_reviews" ADD CONSTRAINT "verb_reviews_verb_id_verbs_id_fk" FOREIGN KEY ("verb_id") REFERENCES "public"."verbs"("id") ON DELETE cascade ON UPDATE no action;