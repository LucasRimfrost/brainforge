import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { ChevronLeft, ChevronRight } from "lucide-react";

interface ChallengeNavProps {
  currentDate: string; // YYYY-MM-DD
  basePath: string; // e.g. "/trivia" or "/code-output"
  getArchive: () => Promise<{ scheduled_date: string }[]>;
}

export function ChallengeNav({
  currentDate,
  basePath,
  getArchive,
}: ChallengeNavProps) {
  const [prevDate, setPrevDate] = useState<string | null>(null);
  const [nextDate, setNextDate] = useState<string | null>(null);

  useEffect(() => {
    getArchive()
      .then((entries) => {
        const dates = entries.map((e) => e.scheduled_date).sort();

        const idx = dates.indexOf(currentDate);
        if (idx > 0) {
          setPrevDate(dates[idx - 1]);
        }
        if (idx >= 0 && idx < dates.length - 1) {
          setNextDate(dates[idx + 1]);
        }
      })
      .catch(() => {
        // Silently fail — nav arrows just won't show
      });
  }, [currentDate, basePath, getArchive]);

  if (!prevDate && !nextDate) return null;

  return (
    <div className="relative mb-6 flex h-9 items-center">
      {/* Left arrow */}
      <div className="flex-1">
        {prevDate && (
          <Link
            to={`${basePath}/${prevDate}`}
            className="inline-flex items-center gap-1 rounded-md px-2 py-1.5 text-sm text-muted-foreground transition-colors duration-150 hover:bg-muted hover:text-foreground active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
          >
            <ChevronLeft className="size-4" />
            <span className="hidden sm:inline">{prevDate}</span>
            <span className="sm:hidden">Prev</span>
          </Link>
        )}
      </div>

      {/* Center date */}
      <span className="absolute left-1/2 -translate-x-1/2 text-sm font-medium text-muted-foreground">
        {currentDate}
      </span>

      {/* Right arrow */}
      <div className="flex flex-1 justify-end">
        {nextDate && (
          <Link
            to={`${basePath}/${nextDate}`}
            className="inline-flex items-center gap-1 rounded-md px-2 py-1.5 text-sm text-muted-foreground transition-colors duration-150 hover:bg-muted hover:text-foreground active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
          >
            <span className="hidden sm:inline">{nextDate}</span>
            <span className="sm:hidden">Next</span>
            <ChevronRight className="size-4" />
          </Link>
        )}
      </div>
    </div>
  );
}
