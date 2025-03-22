#!/bin/bash
# ------------------------------------------------------
# Setup:
# ------------------------------------------------------

# 1. Dependencies:
# - yad version 13.0 (GTK+ 3.24.38) or newer
#     To upgrade YAD to the latest version, refer to:
#       https://github.com/sonic2kk/steamtinkerlaunch/issues/98#issuecomment-706558925
#     To upgrade YAD for syntax highlighting, refer to:
#       https://github.com/v1cont/yad#building-git-version
# - jq version jq-1.6
# - curl version 7.88.1

# 2. Ensure the script is executable:
# chmod +x groq
# This allows launching the program from command line and program launchers.

# 3. File location where scripts are kept:
# Note: Ensure this path is in your $PATH variable to execute commands from here.
cd /home/user/.local/bin

# 4. Variable Options:
export yad_source_view="TRUE" # Check with `yad --about` for "Built with GtkSourceView"
export yad_source_view_options="--lang=markdown --theme=Cobalt --line-hl"
export yad_height="768"
export yad_width="900"
export yad_editor_font="Monospace 11"
export yad_splitter="---------------------------------------------------------------------------------"
export yad_send_emoji="🔴"
export groq_API_Key="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" # https://console.groq.com/playground

# Sets up local files in your script folder on first run:
models="gemma-7b-it
llama3-70b-8192
llama3-8b-8192
mixtral-8x7b-32768"

if [ ! -f ".all_models" ]; then
    echo "file \".all_models\" doesn't exist, creating local files..."
    echo "$models" > .all_models
    cat ".all_models" | head -1 > .last_chosen_model
    echo "i am the system prompt" > .system_prompt
    echo "5000" > .max_tokens
    echo "FALSE" > .clear_after
    echo "FALSE" > .loop_models
fi

models_file=$(cat .all_models)
GROQ_MODELS_Array=($models_file)
last_chosen_model=$(cat .last_chosen_model)
system_prompt=$(cat .system_prompt)
max_tokens=$(cat .max_tokens)
clear_after=$(cat .clear_after)
loop_models=$(cat .loop_models)
GROQ_MODELS=("$last_chosen_model" "${GROQ_MODELS_Array[@]/$last_chosen_model/}")
MODELS=$(echo "${GROQ_MODELS[*]/%/\\!}" | sed 's/ //g' | sed 's/\\!$//' | sed 's/\\!$//' | sed 's/\\!\\!/\\!/g')

function openai_response {

  local model="$1"
  local model=$(cat .last_chosen_model)
  local prompt="$2"
  local system_prompt="$3"
  local max_tokens="$4"

  local response=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $groq_API_Key" \
    -d "$(jq -n --arg model "$model" --arg prompt "$prompt" --arg system_prompt "$system_prompt" '{messages: [{role: "system", content: $system_prompt},{role: "user", content: $prompt}], model: "'$model'", temperature: 1, max_tokens: '$max_tokens', top_p: 1, stream: false, stop: null}')" \
    https://api.groq.com/openai/v1/chat/completions)
  echo "$response" | jq -r .choices[0].message.content

  echo "$yad_splitter"

  echo -en "# $model\n# "

  echo "$response" | jq -r .usage[] | cut -c -8 | tr '\n' '|' | sed 's/$/[prompt] [completion] [total]/g' | sed 's/|\[/ [/g'

  echo -e "  $yad_splitter"

}

export -f openai_response

export fpipe=$(mktemp -u --tmpdir openai.XXXXXXXX)
mkfifo "$fpipe"

trap "rm -f $fpipe" EXIT

KEY=$RANDOM

function display_openai_response {

  local model=$1
  local prompt=$2
  local system_prompt="$3"
  local max_tokens="$4"
  local clear_after="$5"
  local loop_models="$6"

  if [[ "$loop_models" == "TRUE" ]]; then
    bash llm_model_loop.sh
    local model=$(cat .last_chosen_model)
  else
    echo "$model" > .last_chosen_model
  fi

  if [[ "$clear_after" == "TRUE" ]]; then
    clear_response
  fi

  echo "$system_prompt" > .system_prompt
  echo "$max_tokens" > .max_tokens
  echo "$clear_after" > .clear_after
  echo "$loop_models" > .loop_models

  local response=$(openai_response "$model" "$prompt" "$system_prompt" "$max_tokens" "$loop_models")
  echo "
$response" >> "$fpipe"

}

export -f display_openai_response

exec 3<> $fpipe

function clear_response {
  echo -e '\f' >> "$fpipe"
}
export -f clear_response

if [[ -n "${@// /}" ]]; then
  bash -c "display_openai_response $last_chosen_model \"$*\" \"$system_prompt\" $max_tokens $clear_after $loop_models" &
  prompt_fill="$@"
else
  prompt_fill=""
fi

yad --focus-field=2 --align-buttons --plug=$KEY --tabnum=1 --form \
  --columns=2 \
  --field="Model:CB" "$MODELS" \
  --field="Prompt" "$prompt_fill" \
  --field="$yad_send_emoji Send:FBTN" 'bash -c "display_openai_response %1 %2 %4 %5 %6 %7"' \
  --field="System:CBE" "$system_prompt" \
  --field="Max Tokens:NUM" ''$max_tokens'!1000..30000!1000' \
  --field="Clear After:CHK" $clear_after \
  --field="Loop Models:CHK" $loop_models \
  &

if [[ $yad_source_view == "TRUE" ]]; then
  source_view_options="$yad_source_view_options"
else
  source_view_options=""
fi

yad --plug=$KEY --editable \
 --tabnum=2 --text-info --tail \
 --margins=20 --wrap \
 --fontname="$yad_editor_font" $source_view_options \
  <&3 &

yad --focused=1 --borders=15 --center --no-buttons --paned --key=$KEY \
  --width=$yad_width --height=$yad_height

exec 3>&-
