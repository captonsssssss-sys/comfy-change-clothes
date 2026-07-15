#!/usr/bin/env bash
set -e

COMFY="/root/ComfyUI"

mkdir -p \
  "$COMFY/models/diffusion_models" \
  "$COMFY/models/text_encoders" \
  "$COMFY/models/loras" \
  "$COMFY/models/LLM" \
  "$COMFY/models/SEEDVR2/dit" \
  "$COMFY/models/SEEDVR2/vae"

download_if_missing() {
  url="$1"
  path="$2"

  if [ ! -f "$path" ]; then
    echo "Downloading: $(basename "$path")"
    wget --tries=10 --timeout=60 -O "$path" "$url"
  else
    echo "Already exists: $(basename "$path")"
  fi
}

download_if_missing \
  "https://huggingface.co/cocorang/FireRed-Image-Edit-1.1-FP8_And_BF16/resolve/main/FireRed-Image-Edit-1.1_fp8mixed_comfy.safetensors" \
  "$COMFY/models/diffusion_models/FireRed-Image-Edit-1.1_fp8mixed_comfy.safetensors"

download_if_missing \
  "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b.safetensors" \
  "$COMFY/models/text_encoders/qwen_2.5_vl_7b.safetensors"

download_if_missing \
  "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-8steps-V2.0-bf16.safetensors" \
  "$COMFY/models/loras/Qwen-Image-Lightning-8steps-V2.0 bf16.safetensors"

download_if_missing \
  "https://huggingface.co/IntelligenceLab/Loras/resolve/main/real_life_qwen.safetensors" \
  "$COMFY/models/loras/real_life_qwen.safetensors"

download_if_missing \
  "https://huggingface.co/labai-llc/skin-fix/resolve/7a4b0556b3b578f030f200d00f3a2cd404217b00/skin_realism-248951.safetensors" \
  "$COMFY/models/loras/Skin_Fix_rank64.safetensors"

download_if_missing \
  "https://huggingface.co/landon2022/F2P/resolve/481bbee48d31b3d2db5ae649fe49c25f33d6e4c3/Qwen-Image-Edit-F2P.safetensors" \
  "$COMFY/models/loras/Qwen-Image-Edit-F2P.safetensors"

download_if_missing \
  "https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q8_0.gguf" \
  "$COMFY/models/LLM/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q8_0.gguf"

download_if_missing \
  "https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive/resolve/main/mmproj-Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-BF16.gguf" \
  "$COMFY/models/LLM/Qwen3.5-9B-mmproj-F16.gguf"

download_if_missing \
  "https://huggingface.co/AInVFX/SeedVR2_comfyUI/resolve/main/seedvr2_ema_7b_sharp_fp8_e4m3fn_mixed_block35_fp16.safetensors" \
  "$COMFY/models/SEEDVR2/dit/seedvr2_ema_7b_sharp_fp8_e4m3fn_mixed_block35_fp16.safetensors"

download_if_missing \
  "https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/ema_vae_fp16.safetensors" \
  "$COMFY/models/SEEDVR2/vae/ema_vae_fp16.safetensors"

jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.allow_origin='*' \
  --ServerApp.root_dir='/root' &

cd "$COMFY"

exec python3 main.py \
  --listen 0.0.0.0 \
  --port 8188
