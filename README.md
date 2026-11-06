# ailearning

A shared notebook of Markdown notes about learning and working with AI: what we've learned, how-tos we follow, and Claude skills and prompts we reuse.

## Quick start

- **Looking for something?** Go to the [Index](#index) below. Every note in the repo is linked there.
- **Adding something?** Follow [Adding a note](#adding-a-note).
- **Using Claude Code here?** The working rules for this repo are in [CLAUDE.md](CLAUDE.md).

## Layout

| Folder | What goes there |
| --- | --- |
| [`notes/`](notes/) | Concepts, explanations and things we've learned |
| [`guides/`](guides/) | Step-by-step how-tos we actually follow |
| [`skills/`](skills/) | Claude Code skills and reusable prompts |

If a piece doesn't clearly fit, pick the closest folder: an explanation goes in `notes/`, a procedure in `guides/`, and anything you paste into Claude goes in `skills/`.

### Company folders in `skills/`

Skills written for a specific company go in a folder named after that company, e.g. `skills/qls/`. Skills that aren't tied to a company stay at the top of `skills/`.

```text
skills/
├── qls/                  ← QLS-specific skills
│   └── <skill-name>/
│       ├── SKILL.md      ← instructions Claude follows
│       └── references/   ← checklists, templates, standards it loads
└── <general-skill>/      ← not tied to a company
```

To use a skill in Claude Code, copy its folder to `~/.claude/skills/<skill-name>/` (all projects) or `.claude/skills/<skill-name>/` (one project), then invoke it with `/<skill-name>`.

To add a new company, create `skills/<company>/` using a short lowercase name.

## Adding a note

1. Create a `.md` file in the right folder (see [Layout](#layout)).
2. Review it together before it's committed. Every new or changed `.md` file is read and agreed first.
3. Once it's approved:
   1. Commit it.
   2. Add a link to it in the [Index](#index) below.
   3. Push to `origin/main`.

When a note turns out to be wrong or out of date, update it rather than adding a duplicate.

### Conventions

- **File names:** lowercase, words separated by hyphens, e.g. `notes/prompt-caching.md`.
- **One topic per file.** Start with a `# Title` and a sentence or two saying what the note covers.
- **Index entries:** `- [Title](folder/file.md) — one-line summary`, kept alphabetical within each section.

## Index

### Notes

_None yet._

### Guides

_None yet._

### Skills and prompts

#### General

_None yet._

#### QLS

- [qls-flow-builder](skills/qls/flow-builder/SKILL.md) — builds a Power Automate flow from an approved requirement: technical checklist, validation against QLS and Microsoft standards, build spec and review
- [qls-requirement-builder](skills/qls/requirement-builder/SKILL.md) — turns a problem or idea into an approved business requirement and recommends the solution type
