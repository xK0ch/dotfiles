---
name: humanizer
description: Write or rewrite prose for human readers so it does not read like AI-generated text, in German or English. Use for emails, customer messages, offers, letters, website copy, social media posts, bios, cover letters and similar texts that the user will send or publish. This includes visible text inside code: headings, paragraphs, button labels, form hints, error messages for end users and meta descriptions in HTML, templates or components (for example Angular templates or JSX), also when the task as a whole is to write code. Also use when the user asks to humanize, de-AI, polish or make a text sound natural, or types /humanizer. Do not use for program logic, code comments, commit messages, technical documentation or chat replies to the user.
---

# Humanizer

Write text that a careful human writer could have written. The goal is clear, specific, natural prose, not a trick to beat AI detectors. Detectors are unreliable, so never promise a detector score.

## Relation to CLAUDE.md

- The rules in `~/.claude/CLAUDE.md` always win.
- The Simplified Technical English rules in CLAUDE.md cover chat replies, status updates and documentation. They do not cover the texts this skill is for. Here, sentence length and structure follow the target reader and the medium.

## Text inside code

- Apply this skill only to the text that end users see, for example the content of HTML elements, `alt` and `title` attributes, meta descriptions and user-facing strings in components or translation files.
- Do not change identifiers, CSS classes, routes, keys or markup structure.
- Code comments follow CLAUDE.md, not this skill.

## Text from other people

- Keep text from other people exactly as it is. This includes text from a client, quotes and existing content in a file.
- This also applies to dashes and to every other pattern in this skill. Do not change them unless the user asks for it.
- Only rewrite what the user asks you to rewrite.

## Workflow

1. Find out the reader, the medium and the register. In German, keep the form of address that the user or the existing text uses (du or Sie). If it is unclear, ask.
2. Write or rewrite the text.
3. Check the draft against every list below. Fix each hit.
4. Read the result once more as the reader would. Cut everything that the reader does not need.
5. Give the user the final text only. Do not add a list of what you changed unless the user asks.

## Vocabulary to avoid

Replace these words with plain, concrete words, or delete them. A single use in a fitting context is fine. Clusters of them are the problem.

English:

- delve, dive into, deep dive, tapestry, testament, realm, landscape, journey, beacon
- leverage, harness, unlock, unleash, empower, elevate, foster, streamline, navigate (when nothing is navigated)
- robust, seamless, cutting-edge, game-changer, pivotal, crucial, vital, paramount, multifaceted, holistic, vibrant, bustling, intricate, meticulous, nuanced
- showcase, underscore, highlight (as a verb for "shows"), boast (for "has")
- Additionally, Furthermore, Moreover, Notably, Importantly, Ultimately (at sentence start)

German:

- eintauchen, Tauchen wir ein, Reise (when nothing travels), Landschaft (in the abstract sense)
- nahtlos, maßgeschneidert, ganzheitlich, innovativ, zukunftsweisend, wegweisend, bahnbrechend, vielschichtig, facettenreich, lebendig, pulsierend
- spannend, faszinierend, beeindruckend (as filler praise)
- entscheidend, unerlässlich, von zentraler Bedeutung, eine wichtige Rolle spielen
- Darüber hinaus, Des Weiteren, Zudem, Nicht zuletzt (at sentence start, in series)
- Mehrwert bieten, auf das nächste Level heben, Potenzial entfalten, in der heutigen schnelllebigen Welt

## Phrases to avoid

- Openers that announce instead of say: "It's important to note that", "It's worth mentioning", "Let's explore", "Es ist wichtig zu beachten", "Es sei darauf hingewiesen".
- Closers that repeat: "In conclusion", "In summary", "Overall", "Zusammenfassend lässt sich sagen", "Abschließend", "Alles in allem".
- Negative parallelisms: "It's not just X, it's Y", "Not only X, but also Y", "Es geht nicht nur um X, sondern um Y", "Nicht nur X, sondern auch Y". Say Y directly.
- Chatbot leftovers: "Certainly!", "Great question", "I hope this helps", "Let me know if you have any questions", "Gerne!", "Ich hoffe, das hilft", "Bei Fragen stehe ich jederzeit zur Verfügung" (unless the user's own emails use it).
- Vague attribution: "experts say", "studies show", "many believe", "Experten sind sich einig", "Studien zeigen". Name the source or remove the claim.
- Inflated significance: "plays a pivotal role in", "stands as a testament to", "marks a significant milestone", "leaves a lasting legacy", "setzt neue Maßstäbe".
- Trailing participle clauses that add fake analysis: "..., highlighting the importance of X", "..., reflecting a broader trend", "..., was die Bedeutung von X unterstreicht".

## Structure

- Do not force groups of three. Use the number of items that the content has.
- Vary sentence length and paragraph length. Some paragraphs can be one sentence.
- Do not start every paragraph the same way.
- Use headings and bullet lists only when the medium needs them. Emails, letters and posts are usually plain paragraphs.
- No introduction that restates the question and no conclusion that restates the body.
- No "Challenges and Opportunities" or "Herausforderungen und Chancen" sections unless the content really is about that.
- Use sentence case in headings, not Title Case (English). German follows normal German capitalization.

## Tone

- Be specific. Replace general claims with a fact, a number, a name or an example. If you have no specific detail, write a shorter text.
- Do not inflate small things. A website update is not "a journey", a new feature is not "a game-changer".
- No empty positivity and no hedging on both sides. State an opinion when the text needs one.
- Do not stack hedges: "may potentially", "could possibly", "könnte unter Umständen eventuell".
- Use the active voice and name who does what, unless the passive voice is clearly more natural.

## Formatting

- Never use em-dashes (U+2014) or en-dashes (U+2013) in text you write yourself. This includes the HTML entities `&mdash;` and `&ndash;` in HTML or Markdown content.
- Use commas, parentheses, colons or periods instead.
- The dash rule applies in every language.
- No emojis unless the user or the medium asks for them.
- Avoid bold text in the middle of sentences. Bold only the few words a reader must not miss.
- Use straight or typographically correct quotes for the language, consistently. In German use „ and “ when the rest of the text does.

## Final check

Before you give the text to the user, confirm each point:

- No word or phrase from the lists above, except single uses that are clearly the best word.
- No em-dash and no en-dash.
- No intro or outro that only repeats the content.
- Every general claim has a concrete detail or is removed.
- The text matches the reader, the medium and the register (du or Sie).
