CREATE TABLE submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    answer TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    attempt_number INTEGER NOT NULL,
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT unique_attempt UNIQUE (user_id, challenge_id, attempt_number),
    CONSTRAINT valid_attempt_number CHECK (attempt_number > 0)
);