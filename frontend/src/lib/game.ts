export const difficultyConfig: Record<
  string,
  { label: string; class: string }
> = {
  easy: {
    label: "Easy",
    class:
      "bg-green-100 text-green-800 border-green-200 dark:bg-green-500/10 dark:text-green-400 dark:border-green-500/20",
  },
  medium: {
    label: "Medium",
    class:
      "bg-amber-100 text-amber-800 border-amber-200 dark:bg-yellow-500/10 dark:text-yellow-400 dark:border-yellow-500/20",
  },
  hard: {
    label: "Hard",
    class:
      "bg-red-100 text-red-800 border-red-200 dark:bg-red-500/10 dark:text-red-400 dark:border-red-500/20",
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
