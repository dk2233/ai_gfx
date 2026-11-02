#!/bin/bash

if ! env | grep -q '^MODEL_DIR'; then 
    echo "NO MODEL DIR - please add one in .bashrc"
    exit 0
fi

if [ -f "$1" ]; then
    # Odczyt domyślnych wartości z nagłówka pliku (jeśli istnieją), z fallbackiem na zmienne środowiskowe lub standardowe
    RES_X=$(grep -E "^#\s*RES_X=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    RES_Y=$(grep -E "^#\s*RES_Y=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    STEPS=$(grep -E "^#\s*STEPS=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    CFG=$(grep -E "^#\s*CFG=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    SAMPLER=$(grep -E "^#\s*SAMPLER=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')
    SCHEDULER=$(grep -E "^#\s*SCHEDULER=" "$PROMPT_FILE" | cut -d'=' -f2 | tr -d '[:space:]')

    # Wartości zapasowe (fallback), gdy w pliku nie ma danej linii
    RES_X=${RES_X:-768}
    RES_Y=${RES_Y:-1024}
    STEPS=${STEPS:-8}
    CFG=${CFG:-1.5}
    SAMPLER=${SAMPLER:-euler}
    SCHEDULER=${SCHEDULER:-normal}

    # Właściwy prompt (pomiń linie zaczynające się od #, połącz resztę w jedną linię)
    PROMPT=$(grep -v "^#" "$PROMPT_FILE" | tr '\n' ' ')

else
    PROMPT="$1"
    MY_SEED=${2:-$RANDOM}
    RES_X=${3:-768} # Domyślnie 512, jeśli nie podasz drugiego argumentu
    RES_Y=${4:-1024} # Domyślnie 512, jeśli nie podasz drugiego argumentu
    STEPS=${STEPS:-25}
    EXTRA=$5
    STEPS=12
fi


echo $PROMPT
echo $MODEL_DIR
UPSCALE_MODEL="4x-UltraSharp"

sd-cli -m $MODEL_DIR/theTrualityEngine_trualityENGINEPRO_f32.gguf \
--cfg-scale 2.5 \
-H "$RES_Y" -W "$RES_X" \
--sampling-method euler_a \
--scheduler normal \
--steps $STEPS \
--embd-dir $EMBEDDINGS \
--lora-model-dir $LORAS \
--strength 0.3 \
-o "render_${RES_X}_$(date +%s)_${MY_SEED}.png" \
-n "Stable_Yogis_SD1.5_Negatives-neg, cropped, cut off, out of frame, head out of frame, body out of frame, half-body shot" \
-p "${PROMPT}, Stable_Yogis_SD1.5_Positives" \
-s $MY_SEED \
$EXTRA



