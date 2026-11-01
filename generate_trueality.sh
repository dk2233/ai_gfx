#!/bin/bash

if [ -f "$1" ]; then
    PROMPT="$(cat "$1" | tr '\n' ' ')" # Zamienia ewentualne łamanie linii na spacje
else
    PROMPT="$1"
fi
MY_SEED=${2:-$RANDOM}
RES_X=${3:-768} # Domyślnie 512, jeśli nie podasz drugiego argumentu
RES_Y=${4:-1024} # Domyślnie 512, jeśli nie podasz drugiego argumentu
STEPS=${STEPS:-25}
EXTRA=$5
STEPS=12

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



