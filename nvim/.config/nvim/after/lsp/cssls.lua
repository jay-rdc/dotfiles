local css_lint_rules = {
  lint = {
    unknownAtRules = "ignore",
  },
}
return {
  settings = {
    css = css_lint_rules,
    scss = css_lint_rules,
  },
}
