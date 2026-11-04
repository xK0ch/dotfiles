# Personal preferences

## Writing style

- Never use em-dashes (the long dash, U+2014) or en-dashes (U+2013) in any output: chat responses, code comments, documentation, README files, commit messages, HTML or Markdown content.
- Do not use the HTML entities `&mdash;` or `&ndash;` either.
- Use commas, parentheses, colons, or periods instead.
- This rule applies regardless of language (German, English, etc.).

## Code style

- Never write comments in files that belong to a software project: source code, scripts, build, CI and deployment files (Dockerfiles, compose files, Jenkinsfiles and similar), project configuration (YAML, JSON, package or framework config), CSS and SCSS, HTML templates. This includes doc comments.
- Write code that explains itself instead: descriptive names for variables, functions, classes and files, and small well-named functions or constants wherever logic would otherwise need an explanation.
- Exception: personal settings files for programs on the user's own machine, such as the config files in a dotfiles repo (for example `MangoHud.conf`, shell, editor or terminal settings). They are opened and tweaked by hand, so comments that label sections or explain options are welcome there. Never remove them.
- Do not add comments when editing existing project files. Leave existing comments in place unless the user asks to remove them.
- Lines that tools need to work, such as a shebang or a linter directive, are not comments in this sense.

## Shell commands

- When giving the user commands that open a file for editing, locally or on a server, always use `vim` (or `sudo vim`), never `nano` or another editor.
- On systems that might not have vim yet (for example a fresh Debian), include its installation first (`apt install -y vim`).
- Non-interactive edits with `tee`, heredocs or `sed` are fine; this rule is about editing a file by hand.

## Git workflow

- Never run `git add`, `git commit`, or `git push` on your own. This rule applies to every project, including this one.
- The only exception is when the user explicitly asks for a commit or push in their current message. Permission given in a previous turn does not carry over: a fresh request is required each time.
- Never commit or push using a Claude identity. All commits must use the user's own git author identity (name and email as configured in their global git config). Never add `Co-Authored-By: Claude` or similar lines that would make Claude appear as a contributor in the repository.
