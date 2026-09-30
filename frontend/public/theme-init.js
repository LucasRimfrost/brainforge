// Apply dark mode class before first paint to prevent FOUC.
// Loaded as a separate file (not inline) so it is allowed by the CSP `script-src 'self'`.
(function () {
  var theme = localStorage.getItem("theme");
  if (theme === "dark" || (!theme && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
    document.documentElement.classList.replace("light", "dark");
  }
})();
