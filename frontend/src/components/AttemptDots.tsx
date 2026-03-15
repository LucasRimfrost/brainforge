import { useState } from "react";
import { cn } from "@/lib/utils";

interface AttemptDotsProps {
  maxAttempts: number;
  attemptsUsed: number;
  isSolved: boolean;
  guesses: string[];
  /** Dot size class — use "size-3" for compact (result cards) or "size-4" for normal */
  size?: "sm" | "md";
  /** Index of dot currently animating (pop effect) */
  poppedDot?: number;
}

export function AttemptDots({
  maxAttempts,
  attemptsUsed,
  isSolved,
  guesses,
  size = "md",
  poppedDot = -1,
}: AttemptDotsProps) {
  const [activeDot, setActiveDot] = useState<number | null>(null);

  return (
    <div className="flex items-center gap-2">
      {Array.from({ length: maxAttempts }).map((_, i) => {
        const used = i < attemptsUsed;
        const isWinning = isSolved && i === attemptsUsed - 1;
        const guess = guesses[i];
        const isOpen = activeDot === i;

        let dotColor: string;
        if (!used) {
          dotColor = "bg-muted ring-1 ring-border";
        } else if (isWinning) {
          dotColor =
            "bg-[#6EBF8B] shadow-[0_0_6px_rgba(110,191,139,0.4)]";
        } else {
          dotColor =
            "bg-[#E08B8B] shadow-[0_0_4px_rgba(224,139,139,0.3)]";
        }

        const sizeClass = size === "sm" ? "size-3" : "size-4";

        return (
          <div key={i} className="relative">
            <span
              className={cn(
                "flex items-center justify-center rounded-full transition-all duration-300 cursor-default",
                sizeClass,
                dotColor,
                poppedDot === i && "animate-pop",
              )}
              onMouseEnter={() => setActiveDot(i)}
              onMouseLeave={() => setActiveDot(null)}
              onClick={() => setActiveDot(isOpen ? null : i)}
            />

            {/* Tooltip */}
            {isOpen && (
              <div className="absolute bottom-full left-1/2 z-50 mb-2 -translate-x-1/2 animate-in fade-in duration-150">
                <div className="whitespace-nowrap rounded-md bg-popover px-2.5 py-1.5 text-xs shadow-md ring-1 ring-border">
                  <span className="text-muted-foreground">
                    Guess {i + 1}:{" "}
                  </span>
                  {used ? (
                    <span
                      className={cn(
                        "font-medium font-mono",
                        isWinning ? "text-[#4da36a]" : "text-[#d06060]",
                      )}
                    >
                      {guess}
                    </span>
                  ) : (
                    <span className="text-muted-foreground italic">
                      Not attempted
                    </span>
                  )}
                </div>
                {/* Caret */}
                <div className="flex justify-center">
                  <div className="size-2 -mt-[3px] rotate-45 bg-popover ring-1 ring-border ring-t-0 ring-l-0 clip-caret" />
                </div>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
