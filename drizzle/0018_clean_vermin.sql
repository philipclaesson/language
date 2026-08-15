CREATE TABLE "daily_progress" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"day" date NOT NULL,
	"words_done" boolean DEFAULT false NOT NULL,
	"verbs_done" boolean DEFAULT false NOT NULL,
	"freund_count" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "daily_progress_user_day" UNIQUE("user_id","day")
);
--> statement-breakpoint
ALTER TABLE "daily_progress" ADD CONSTRAINT "daily_progress_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;