#!/bin/bash

declare -A LANGUAGES
LANGUAGES[1]="en|English|You are a lead system programmer. Analyze this git diff and write a clear, concise report: what changed, what methods were used, what technical debt was removed, what crutches did you fix (if any). Write briefly and to the point. Do not use Markdown, use plain text."

LANGUAGES[2]="ru|Russian|Ты — ведущий системный программист. Проанализируй этот git diff и напиши развернутый отчет: что изменилось, какие методы применил автор, от чего избавился, какие костыли исправил (Если они есть). Пиши кратко и по делу. Не используй Markdown, используй обычный текст."

LANGUAGES[3]="pl|Polish|Jesteś głównym programistą systemowym. Przeanalizuj ten git diff i napisz zrozumiały raport: co się zmieniło, jakie metody zastosował autor, z czego zrezygnował, jakie kule naprawiłeś (jeśli jakieś). Pisz zwięźle i na temat. Nie używaj Markdown, użyj zwykłego tekstu."
# LANGUAGES[4]="de|German|Schreibe den Bericht auf Deutsch. Kein Markdown."

echo "=== Installing Git-Explain ==="

echo "Select the language the AI will speak:"
for id in "${!LANGUAGES[@]}"; do
    IFS='|' read -r code label instr <<< "${LANGUAGES[$id]}"
    echo "$id - $label"
done
read -p "Enter your choice: " choice

if [[ -z "${LANGUAGES[$choice]}" ]]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

IFS='|' read -r lang_code lang_name lang_instr <<< "${LANGUAGES[$choice]}"

echo "Setting up environment..."
ENV_PATH="$HOME/.llm-env"
[ ! -d "$ENV_PATH" ] && python3 -m venv "$ENV_PATH"

$ENV_PATH/bin/pip install -U llm llm-groq

echo "--------------------------------------------------------"
echo "Need a Groq API key to work."
echo "Get it for free: https://console.groq.com/keys"
echo "--------------------------------------------------------"
$ENV_PATH/bin/llm keys set groq
$ENV_PATH/bin/llm models default groq-llama3.1-8b
BASHRC="$HOME/.bashrc"
sed -i '/# START GIT-EXPLAIN/,/# END GIT-EXPLAIN/d' "$BASHRC"
cat <<EOF >> "$BASHRC"

# START GIT-EXPLAIN
alias git-explain='_git_explain() {
    if [[ "\$1" == "-h" || "\$1" == "--help" ]]; then
        echo "Usage: git-explain [commit] [path]"
        echo "Example: git-explain HEAD tools"
        return
    fi
    local commit="\${1:-HEAD}"
    local path_to_check="\${2}"
    local sys_prompt="$lang_instr"
    local model="groq-llama3.1-8b"

    if [ -n "\$path_to_check" ]; then
        git diff "\$commit~1" "\$commit" -- "\$path_to_check" | head -c 20000 | $ENV_PATH/bin/llm -m "\$model" "\$sys_prompt"
    else
        git diff "\$commit~1" "\$commit" | head -c 20000 | $ENV_PATH/bin/llm -m "\$model" "\$sys_prompt"
    fi
}; _git_explain'
# END GIT-EXPLAIN
EOF
source ~/.bashrc
echo "=== Installation complete! ==="
echo "Restart your terminal or run: source ~/.bashrc"
echo "Now use: git-explain <commit> <path>"
