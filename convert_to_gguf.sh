#!/bin/bash

sd-cli -M convert -m $1.safetensors -o $1.gguf -v --type $2
