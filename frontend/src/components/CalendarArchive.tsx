import { useMemo, useState } from "react";
import { Link } from "react-router-dom";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface ArchiveDay {
  date: string; // YYYY-MM-DD
  is_solved: boolean;
  attempts_used: number;
  max_attempts: number;
}

interface CalendarArchiveProps {
  entries: ArchiveDay[];
  basePath: string; // e.g. "/trivia" or "/code-output"
}

function getDaysInMonth(year: number, month: number): number {
  return new Date(year, month + 1, 0).getDate();
}

function getFirstDayOfWeek(year: number, month: number): number {
  return new Date(year, month, 1).getDay();
}

type DayStatus = "solved" | "failed" | "in_progress" | "not_attempted" | "empty";

function getDayStatus(entry: ArchiveDay | undefined): DayStatus {
  if (!entry) return "empty";
  if (entry.is_solved) return "solved";
  if (entry.attempts_used >= entry.max_attempts) return "failed";
  if (entry.attempts_used > 0) return "in_progress";
  return "not_attempted";
}

const statusStyles: Record<DayStatus, string> = {
  solved:
    "bg-green-100 text-green-800 ring-1 ring-green-300 hover:bg-green-200 dark:bg-green-500/20 dark:text-green-400 dark:ring-green-500/30 dark:hover:bg-green-500/30",
  failed:
    "bg-red-100 text-red-800 ring-1 ring-red-300 hover:bg-red-200 dark:bg-red-500/15 dark:text-red-400 dark:ring-red-500/25 dark:hover:bg-red-500/25",
  in_progress:
    "bg-amber-100 text-amber-800 ring-1 ring-amber-300 hover:bg-amber-200 dark:bg-yellow-500/15 dark:text-yellow-400 dark:ring-yellow-500/25 dark:hover:bg-yellow-500/25",
  not_attempted:
    "bg-muted/50 text-muted-foreground ring-1 ring-border hover:bg-muted",
  empty: "",
};

const WEEKDAYS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const MONTH_NAMES = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

export function CalendarArchive({ entries, basePath }: CalendarArchiveProps) {
  const now = new Date();
  const [viewYear, setViewYear] = useState(now.getFullYear());
  const [viewMonth, setViewMonth] = useState(now.getMonth());

  // Build a lookup map from YYYY-MM-DD to entry
  const entryMap = useMemo(() => {
    const map = new Map<string, ArchiveDay>();
    for (const e of entries) {
      map.set(e.date, e);
    }
    return map;
  }, [entries]);

  const daysInMonth = getDaysInMonth(viewYear, viewMonth);
  const firstDay = getFirstDayOfWeek(viewYear, viewMonth);

  // Build calendar grid (6 rows x 7 columns max)
  const cells: (number | null)[] = [];
  for (let i = 0; i < firstDay; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);
  while (cells.length % 7 !== 0) cells.push(null);

  const todayStr = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}-${String(now.getDate()).padStart(2, "0")}`;

  function prevMonth() {
    if (viewMonth === 0) {
      setViewYear((y) => y - 1);
      setViewMonth(11);
    } else {
      setViewMonth((m) => m - 1);
    }
  }

  function nextMonth() {
    if (viewMonth === 11) {
      setViewYear((y) => y + 1);
      setViewMonth(0);
    } else {
      setViewMonth((m) => m + 1);
    }
  }

  // Don't allow navigating past the current month
  const isCurrentMonth =
    viewYear === now.getFullYear() && viewMonth === now.getMonth();

  // Compute stats
  const totalSolved = entries.filter((e) => e.is_solved).length;
  const totalEntries = entries.length;

  return (
    <div>
      {/* Month navigation */}
      <div className="mb-6 flex items-center justify-between">
        <Button variant="ghost" size="icon" onClick={prevMonth}>
          <ChevronLeft className="size-5" />
        </Button>
        <h2 className="text-lg font-semibold">
          {MONTH_NAMES[viewMonth]} {viewYear}
        </h2>
        <Button
          variant="ghost"
          size="icon"
          onClick={nextMonth}
          disabled={isCurrentMonth}
          className={cn(isCurrentMonth && "invisible")}
        >
          <ChevronRight className="size-5" />
        </Button>
      </div>

      {/* Weekday headers */}
      <div className="mb-2 grid grid-cols-7 gap-1.5 text-center">
        {WEEKDAYS.map((day) => (
          <div
            key={day}
            className="py-1.5 text-xs font-medium text-muted-foreground"
          >
            {day}
          </div>
        ))}
      </div>

      {/* Calendar grid */}
      <div className="grid grid-cols-7 gap-1.5">
        {cells.map((day, idx) => {
          if (day === null) {
            return <div key={`empty-${idx}`} className="aspect-square" />;
          }

          const dateStr = `${viewYear}-${String(viewMonth + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`;
          const isFuture = dateStr > todayStr;
          const entry = entryMap.get(dateStr);
          const status = isFuture ? "empty" : getDayStatus(entry);
          const isToday = dateStr === todayStr;
          const isClickable = status !== "empty";

          const cell = (
            <div
              className={cn(
                "flex aspect-square items-center justify-center rounded-lg text-sm font-medium transition-all duration-150",
                statusStyles[status],
                isClickable && "hover:scale-110 hover:shadow-md",
                isToday && status !== "empty" && "ring-2 ring-primary",
                isToday && status === "empty" && "ring-2 ring-primary/50 text-foreground",
                isFuture && "text-muted-foreground/30",
              )}
            >
              {day}
            </div>
          );

          if (isClickable) {
            return (
              <Link key={dateStr} to={`${basePath}/${dateStr}`} className="rounded-lg focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50">
                {cell}
              </Link>
            );
          }

          return <div key={dateStr}>{cell}</div>;
        })}
      </div>

      {/* Legend */}
      <div className="mt-6 flex flex-wrap items-center justify-center gap-4 text-xs text-muted-foreground">
        <div className="flex items-center gap-1.5">
          <span className="size-3 rounded bg-green-100 ring-1 ring-green-300 dark:bg-green-500/20 dark:ring-green-500/30" />
          Solved
        </div>
        <div className="flex items-center gap-1.5">
          <span className="size-3 rounded bg-red-100 ring-1 ring-red-300 dark:bg-red-500/15 dark:ring-red-500/25" />
          Failed
        </div>
        <div className="flex items-center gap-1.5">
          <span className="size-3 rounded bg-amber-100 ring-1 ring-amber-300 dark:bg-yellow-500/15 dark:ring-yellow-500/25" />
          In progress
        </div>
        <div className="flex items-center gap-1.5">
          <span className="size-3 rounded bg-muted/50 ring-1 ring-border" />
          Available
        </div>
      </div>

      {/* Stats */}
      <div className="mt-4 text-center text-sm text-muted-foreground">
        {totalSolved} of {totalEntries} challenge{totalEntries === 1 ? "" : "s"}{" "}
        solved
      </div>
    </div>
  );
}
