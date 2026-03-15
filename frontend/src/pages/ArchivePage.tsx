import { useCallback, useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { getArchive } from "@/api/trivia";
import { ApiRequestError } from "@/api/client";
import type { ArchiveEntry } from "@/api/types";
import { CalendarArchive } from "@/components/CalendarArchive";
import { Archive, Calendar } from "lucide-react";

export function ArchivePage() {
  const [entries, setEntries] = useState<ArchiveEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const fetchArchive = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const data = await getArchive();
      setEntries(data);
    } catch (err) {
      if (err instanceof ApiRequestError) {
        setError(err.message);
      } else {
        setError("Failed to load archive.");
      }
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchArchive();
  }, [fetchArchive]);

  if (loading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <div className="text-center">
          <div className="mx-auto mb-3 size-8 animate-spin rounded-full border-2 border-muted border-t-primary" />
          <p className="text-sm text-muted-foreground">Loading archive...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <div className="text-center">
          <Archive className="mx-auto mb-3 size-10 text-muted-foreground/50" />
          <p className="text-lg font-medium">{error}</p>
          <Button
            variant="outline"
            size="sm"
            className="mt-4"
            onClick={fetchArchive}
          >
            Try again
          </Button>
        </div>
      </div>
    );
  }

  if (entries.length === 0) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <div className="text-center">
          <Archive className="mx-auto mb-3 size-10 text-muted-foreground/50" />
          <p className="text-lg font-medium">No previous challenges yet</p>
          <p className="mt-1 text-sm text-muted-foreground">
            Check back tomorrow!
          </p>
        </div>
      </div>
    );
  }

  const calendarEntries = entries.map((e) => ({
    date: e.scheduled_date,
    is_solved: e.is_solved,
    attempts_used: e.attempts_used,
    max_attempts: e.max_attempts,
  }));

  return (
    <div className="mx-auto max-w-lg">
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2 text-xl">
            <Calendar className="size-5" />
            Daily Trivia Archive
          </CardTitle>
        </CardHeader>
        <CardContent>
          <CalendarArchive entries={calendarEntries} basePath="/trivia" />
        </CardContent>
      </Card>
    </div>
  );
}
