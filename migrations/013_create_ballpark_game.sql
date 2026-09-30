-- Ballpark: daily estimation game (docs/games/ballpark.md)

-- Register the game
INSERT INTO games (id, name, description, sort_order)
VALUES (
    'ballpark',
    'Ballpark',
    'Guess the number. Higher or lower? Land close enough to win.',
    3
);

-- Challenges. `answer` is never sent to a client before the reveal.
CREATE TABLE ballpark_challenges (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title          TEXT NOT NULL,
    question       TEXT NOT NULL,
    unit           TEXT NOT NULL,
    answer         DOUBLE PRECISION NOT NULL CHECK (answer > 0 AND answer <= 1e15),
    decimals       SMALLINT NOT NULL DEFAULT 0 CHECK (decimals BETWEEN 0 AND 3),
    tolerance_pct  DOUBLE PRECISION NOT NULL DEFAULT 10 CHECK (tolerance_pct >= 1 AND tolerance_pct <= 50),
    difficulty     TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    explanation    TEXT NOT NULL,
    source_url     TEXT,
    max_attempts   INTEGER NOT NULL DEFAULT 5 CHECK (max_attempts BETWEEN 1 AND 10),
    -- The unique index serves the by-date lookup and the archive range scan.
    scheduled_date DATE UNIQUE NOT NULL,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Submissions. The stored `feedback` is authoritative: fixing an answer later
-- must not re-judge old submissions.
CREATE TABLE ballpark_submissions (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    challenge_id   UUID NOT NULL REFERENCES ballpark_challenges(id) ON DELETE CASCADE,
    guess          DOUBLE PRECISION NOT NULL CHECK (guess >= 0 AND guess <= 1e15),
    feedback       TEXT NOT NULL CHECK (feedback IN ('too_low', 'too_high', 'within')),
    is_correct     BOOLEAN GENERATED ALWAYS AS (feedback = 'within') STORED,
    error_pct      DOUBLE PRECISION NOT NULL CHECK (error_pct >= 0),
    attempt_number INTEGER NOT NULL CHECK (attempt_number > 0),
    submitted_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT ballpark_unique_attempt UNIQUE (user_id, challenge_id, attempt_number)
);
-- No extra (user_id, challenge_id) index: the unique constraint's btree already
-- leads with those columns.

-- Stats (per-game streaks and totals), same shape as trivia_stats.
CREATE TABLE ballpark_stats (
    user_id          UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    current_streak   INTEGER NOT NULL DEFAULT 0,
    longest_streak   INTEGER NOT NULL DEFAULT 0,
    total_solved     INTEGER NOT NULL DEFAULT 0,
    total_attempts   INTEGER NOT NULL DEFAULT 0,
    last_solved_date DATE
);

CREATE INDEX idx_ballpark_stats_leaderboard
    ON ballpark_stats (current_streak DESC, total_solved DESC);
