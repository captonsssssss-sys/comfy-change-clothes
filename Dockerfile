FROM ghcr.io/captonsssssss-sys/comfy-change-clothes:latest

USER root

RUN pip3 install --no-cache-dir jupyterlab

# Создаём папки под новые модели
RUN mkdir -p \
    /root/ComfyUI/models/diffusion_models \
    /root/ComfyUI/models/text_encoders \
    /root/ComfyUI/models/loras \
    /root/ComfyUI/models/LLM \
    /root/ComfyUI/models/llm \
    /root/ComfyUI/models/SEEDVR2/dit \
    /root/ComfyUI/models/SEEDVR2/vae \
    /root/ComfyUI/custom_nodes/ComfyUI-SeedVR2_VideoUpscaler/models

# 1. Основная модель FireRed
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/diffusion_models/FireRed-Image-Edit-1.1_fp8mixed_comfy.safetensors" \
    "https://huggingface.co/cocorang/FireRed-Image-Edit-1.1-FP8_And_BF16/resolve/main/FireRed-Image-Edit-1.1_fp8mixed_comfy.safetensors"

# 2. Text encoder
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/text_encoders/qwen_2.5_vl_7b.safetensors" \
    "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b.safetensors"

# 3. Lightning LoRA
# Сохраняем под именем, которое прописано в workflow
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/loras/Qwen-Image-Lightning-8steps-V2.0 bf16.safetensors" \
    "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-8steps-V2.0-bf16.safetensors"

# 4. Real Life LoRA
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/loras/real_life_qwen.safetensors" \
    "https://huggingface.co/IntelligenceLab/Loras/resolve/main/real_life_qwen.safetensors"

# 5. Skin Fix LoRA
# Сохраняем под именем, которое ожидает workflow
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/loras/Skin_Fix_rank64.safetensors" \
    "https://huggingface.co/labai-llc/skin-fix/resolve/7a4b0556b3b578f030f200d00f3a2cd404217b00/skin_realism-248951.safetensors"

# 6. F2P LoRA
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/loras/Qwen-Image-Edit-F2P.safetensors" \
    "https://huggingface.co/landon2022/F2P/resolve/481bbee48d31b3d2db5ae649fe49c25f33d6e4c3/Qwen-Image-Edit-F2P.safetensors"

# 7. Локальная Qwen 3.5 LLM
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/LLM/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q8_0.gguf" \
    "https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive/resolve/main/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q8_0.gguf"

# 8. MMProj для Qwen 3.5
# Сохраняем под именем, прописанным в workflow
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/LLM/Qwen3.5-9B-mmproj-F16.gguf" \
    "https://huggingface.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive/resolve/main/mmproj-Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-BF16.gguf"

# Дополнительные ссылки на LLM-файлы для совместимости с разными llama_cpp nodes
RUN ln -sf \
    "/root/ComfyUI/models/LLM/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q8_0.gguf" \
    "/root/ComfyUI/models/llm/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive-Q8_0.gguf" \
    && ln -sf \
    "/root/ComfyUI/models/LLM/Qwen3.5-9B-mmproj-F16.gguf" \
    "/root/ComfyUI/models/llm/Qwen3.5-9B-mmproj-F16.gguf"

# 9. SeedVR2 DiT
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/SEEDVR2/dit/seedvr2_ema_7b_sharp_fp8_e4m3fn_mixed_block35_fp16.safetensors" \
    "https://huggingface.co/AInVFX/SeedVR2_comfyUI/resolve/main/seedvr2_ema_7b_sharp_fp8_e4m3fn_mixed_block35_fp16.safetensors"

# 10. SeedVR2 VAE
RUN wget --tries=10 --timeout=60 -O \
    "/root/ComfyUI/models/SEEDVR2/vae/ema_vae_fp16.safetensors" \
    "https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/ema_vae_fp16.safetensors"

# Дополнительные ссылки для SeedVR2
RUN ln -sf \
    "/root/ComfyUI/models/SEEDVR2/dit/seedvr2_ema_7b_sharp_fp8_e4m3fn_mixed_block35_fp16.safetensors" \
    "/root/ComfyUI/custom_nodes/ComfyUI-SeedVR2_VideoUpscaler/models/seedvr2_ema_7b_sharp_fp8_e4m3fn_mixed_block35_fp16.safetensors" \
    && ln -sf \
    "/root/ComfyUI/models/SEEDVR2/vae/ema_vae_fp16.safetensors" \
    "/root/ComfyUI/custom_nodes/ComfyUI-SeedVR2_VideoUpscaler/models/ema_vae_fp16.safetensors"

# Workflow
COPY ["NHUB CAROUSEL GEN.json", "/root/ComfyUI/user/default/workflows/NHUB CAROUSEL GEN.json"]

# Запуск RunPod
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

EXPOSE 8188 8888

CMD ["/root/start.sh"]
