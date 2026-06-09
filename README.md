# Git-Explain

Git-Explain is your personal AI assistant, built right into your terminal. It analyzes changes in git diff and produces a human-readable report: what changed, what approaches were used, what workarounds were fixed, and whether there is technical debt.

It works quickly, concisely, and doesn't distract you from the code.

## Git-Explain feature
* **Terminal context:** No more copy-pasting code into chatbots. Get a breakdown of changes with a single command.
* **Deep analysis:** Using powerful models (Llama 3.1 8b) via Groq allows you to quickly analyze even complex commits.
* **Autonomous:** The script automatically configures the virtual environment and all dependencies without cluttering your system. * **Multilingual:** Choose which language the AI ​​will report in: Russian, English, or Polish.

## Installation
The script will do everything for you:

1. Download the repository:
```bash
git clone https://github.com/Mavox-ID/git-explain.git && cd git-explain

```

2. Make the file executable:
```bash
chmod +x git-explain.sh

```

3. Run the installer:
```bash
./git-explain.sh

```

*The installer will create a virtual environment in `~/.llm-env` and add an alias to your `.bashrc`.*
4. Update terminal settings:
```bash
source ~/.bashrc

```

## How to use

Simply run the command in any Git repository:

* **Analyze a commit (from the previous one to which you written):**
```bash
git-explain <commit_hash>

```

* **Analyze a specific file in a commit:**
```bash
git-explain <commit_hash> <path_to_file>

```

## Technologies

* **Core:** Bash script.
* **AI engine:** `llm` (Python) + Groq API.
* **Model:** Optimized `groq-llama3.1-8b`.
