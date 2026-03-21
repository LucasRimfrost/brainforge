import { cn } from "@/lib/utils";

interface SegmentedProgressBarProps {
  maxAttempts: number;
  attemptsUsed: number;
  isSolved: boolean;
  guesses: string[];
  /** Index of segment currently animating (newly filled) */
  animatingSegment?: number;
}

export function SegmentedProgressBar({
  maxAttempts,
  attemptsUsed,
  isSolved,
  guesses,
  animatingSegment = -1,
}: SegmentedProgressBarProps) {
  return (
    <div className="flex w-full gap-1">
      {Array.from({ length: maxAttempts }).map((_, i) => {
        const used = i < attemptsUsed;
        const isWinning = isSolved && i === attemptsUsed - 1;
        const isCurrent = !isSolved && i === attemptsUsed && attemptsUsed < maxAttempts;
        const guess = guesses[i];
        const isAnimating = animatingSegment === i;

        let segmentClass: string;
        if (!used && !isCurrent) {
          // Unused
          segmentClass = "segment-unused";
        } else if (isCurrent) {
          // Current active slot
          segmentClass = "segment-current";
        } else if (isWinning) {
          // Correct guess
          segmentClass = "segment-correct";
        } else {
          // Wrong guess
          segmentClass = "segment-wrong";
        }

        return (
          <div
            key={i}
            className={cn(
              "flex flex-1 items-center justify-center rounded-[5px] font-mono text-[11px] leading-none transition-colors duration-300",
              segmentClass,
              isAnimating && !isWinning && "animate-segment-fill",
              isAnimating && isWinning && "animate-segment-correct",
            )}
            style={{ height: 34 }}
          >
            {used && guess && (
              <span className="truncate px-1.5">{guess}</span>
            )}
          </div>
        );
      })}
    </div>
  );
}
