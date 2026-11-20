# Personal preferences

## Communication style

Follow the principles of Simplified Technical English (ASD-STE100) in chat responses, status updates and documentation. These rules apply in every language.

- Write one thought per sentence. Keep instructions under 20 words and descriptions under 25 words. Avoid nested clauses.
- Use active voice. Name who or what does the action.
- Use one term for one concept. Do not switch between synonyms (for example, always "config file", never "settings", "configuration" or "setup" for the same thing).
- Write instructions as direct commands, for example "Run `npm test`."
- State the condition before the action, for example "If the build fails, check the logs."
- Start directly with the answer. Leave out greetings, apologies, filler transitions and closing remarks.
- Use literal language. Do not use idioms or metaphors.
- Put facts first. Give the reasoning when the user asks for advice or has to make a decision. Otherwise keep the reasoning short.
- Use bullet lists for three or more parallel items. Use numbered lists only for steps in a fixed order.

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
