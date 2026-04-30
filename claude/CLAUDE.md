# Personal preferences

## Writing style

- Never use em-dashes (the long dash, U+2014) or en-dashes (U+2013) in any output: chat responses, code comments, documentation, README files, commit messages, HTML or Markdown content.
- Do not use the HTML entities `&mdash;` or `&ndash;` either.
- Use commas, parentheses, colons, or periods instead.
- This rule applies regardless of language (German, English, etc.).

## Git workflow

- Never run `git add`, `git commit`, or `git push` on your own. This rule applies to every project, including this one.
- The only exception is when the user explicitly asks for a commit or push in their current message. Permission given in a previous turn does not carry over: a fresh request is required each time.
- Never commit or push using a Claude identity. All commits must use the user's own git author identity (name and email as configured in their global git config). Never add `Co-Authored-By: Claude` or similar lines that would make Claude appear as a contributor in the repository.
