export const difficultyConfig: Record<
  string,
  { label: string; class: string }
> = {
  easy: {
    label: "Easy",
    class:
      "bg-green-100 text-green-700 dark:bg-green-500/15 dark:text-green-400",
  },
  medium: {
    label: "Medium",
    class:
      "bg-amber-100 text-amber-700 dark:bg-amber-500/15 dark:text-amber-400",
  },
  hard: {
    label: "Hard",
    class:
      "bg-red-100 text-red-700 dark:bg-red-500/15 dark:text-red-400",
  },
};

const languageNames: Record<string, string> = {
  python: "Python",
  javascript: "JavaScript",
  typescript: "TypeScript",
  rust: "Rust",
  go: "Go",
  java: "Java",
  c: "C",
  cpp: "C++",
  csharp: "C#",
  ruby: "Ruby",
  php: "PHP",
  swift: "Swift",
  kotlin: "Kotlin",
};

export function getLanguageLabel(lang: string): string {
  return languageNames[lang] ?? lang.charAt(0).toUpperCase() + lang.slice(1);
}
