#!/bin/bash

if ! env | grep -q '^MODEL_DIR'; then 
    echo "NO MODEL DIR - please add one in .bashrc"
    exit 0
fi
PROMPT_FILE="$1"
if [ -f "$1" ]; then
    # Odczyt domyślnych wartości z nagłówka pliku (jeśli istnieją), z fallbackiem na zmienne środowiskowe lub standardowe
    RES_X=$(grep -E "^#\s*RES_X=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    RES_Y=$(grep -E "^#\s*RES_Y=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    STEPS=$(grep -E "^#\s*STEPS=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    CFG=$(grep -E "^#\s*CFG=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    SAMPLER=$(grep -E "^#\s*SAMPLER=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    SCHEDULER=$(grep -E "^#\s*SCHEDULER=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    MY_SEED=$(grep -E "^#\s*SEED=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    MODEL_NAME=$(grep -E "^#\s*MODEL_NAME=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    EXTRA=$(grep -E "^#\s*EXTRA=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')



    # Wartości zapasowe (fallback), gdy w pliku nie ma danej linii
    echo $RES_X, $RES_Y
    RES_X=${RES_X:-768}
    RES_Y=${RES_Y:-1024}
    STEPS=${STEPS:-8}
    CFG=${CFG:-1.5}
    SAMPLER=${SAMPLER:-euler}
    SCHEDULER=${SCHEDULER:-normal}
    MY_SEED=${2:-$RANDOM}
    MODEL_NAME=${MODEL_NAME:-theTrualityEngine_trualityENGINEPRO_f32.gguf}

    # Właściwy prompt (pomiń linie zaczynające się od #, połącz resztę w jedną linię)
    PROMPT=$(grep -v "^#" "$PROMPT_FILE" | tr '\n' ' ')

else
    PROMPT="$1"
    MY_SEED=${2:-$RANDOM}
    RES_X=${3:-768} # Domyślnie 512, jeśli nie podasz drugiego argumentu
    RES_Y=${4:-1024} # Domyślnie 512, jeśli nie podasz drugiego argumentu
    STEPS=${STEPS:-12}
    SCHEDULER=normal 
    MODEL_NAME=theTrualityEngine_trualityENGINEPRO_f32.gguf
    CFG=2.0
    EXTRA=$5
fi


echo $PROMPT
echo $MODEL_DIR
echo $MODEL_NAME
echo "steps: $STEPS"
UPSCALE_MODEL="4x-UltraSharp"

sd-cli -m $MODEL_DIR/$MODEL_NAME \
--cfg-scale $CFG \
-H "$RES_Y" \
-W "$RES_X" \
--sampling-method $SAMPLER \
--scheduler $SCHEDULER \
--steps $STEPS \
--embd-dir $EMBEDDINGS \
--lora-model-dir $LORAS \
--strength 0.3 \
-o "render_${RES_X}_$(date +%s)_${MY_SEED}.png" \
-n "Stable_Yogis_SD1.5_Negatives-neg, cropped, cut off, out of frame, head out of frame, body out of frame, half-body shot" \
-p "${PROMPT}, Stable_Yogis_SD1.5_Positives" \
-s $MY_SEED \
$EXTRA



