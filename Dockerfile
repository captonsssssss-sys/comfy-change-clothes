FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    wget \
    curl \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip

RUN pip3 install \
    torch==2.5.1 \
    torchvision==0.20.1 \
    torchaudio==2.5.1 \
    --index-url https://download.pytorch.org/whl/cu121

RUN git clone https://github.com/comfyanonymous/ComfyUI.git /root/ComfyUI

WORKDIR /root/ComfyUI

RUN pip3 install -r requirements.txt
RUN pip3 install gdown jupyterlab

# Custom nodes
WORKDIR /root/ComfyUI/custom_nodes

RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git
RUN git clone https://github.com/kijai/ComfyUI-KJNodes.git
RUN git clone https://github.com/chflame163/ComfyUI_LayerStyle.git
RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui.git
RUN git clone https://github.com/chrisgoringe/cg-use-everywhere.git

# Установка зависимостей custom nodes
RUN find /root/ComfyUI/custom_nodes -name requirements.txt -type f \
    -exec pip3 install -r {} \; || true

# Папки моделей и workflow
RUN mkdir -p \
    /root/ComfyUI/models/loras \
    /root/ComfyUI/models/text_encoders \
    /root/ComfyUI/models/vae \
    /root/ComfyUI/models/diffusion_models \
    /root/ComfyUI/user/default/workflows

# LoRA для переодевания
RUN gdown "https://drive.google.com/uc?id=1RjHqgUIg1O9xmLwUC-LXdStTTPqqppVE" \
    -O "/root/ComfyUI/models/loras/clothes_tryon_qwen-edit-lora.safetensors"

# Text encoder
RUN gdown "https://drive.google.com/uc?id=1cxt-emUAwU3oYTxaBYYn0b6yPjNje_RR" \
    -O "/root/ComfyUI/models/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"

# VAE
RUN gdown "https://drive.google.com/uc?id=1ePx6uMgnwnl6jDOGK2or1hZmOLZhRwkv" \
    -O "/root/ComfyUI/models/vae/qwen_image_vae.safetensors"

# Qwen Image Edit
RUN gdown "https://drive.google.com/uc?id=12q4Mg9k4WZMocPRoYGQdTIU7pDBDlx4H" \
    -O "/root/ComfyUI/models/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors"

# Lightning LoRA
RUN gdown "https://drive.google.com/uc?id=1sJgfpKsWN-AeNGPqaPKiHCm6bUhRf4Qo" \
    -O "/root/ComfyUI/models/loras/Qwen-Image-Edit-2509-Lightning-4steps-V1.0-bf16.safetensors"

# Workflow
COPY ["Change Clothes.json", "/root/ComfyUI/user/default/workflows/Change Clothes.json"]

# Стартовый скрипт для RunPod
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

WORKDIR /root/ComfyUI

EXPOSE 8188 8888

CMD ["/root/start.sh"]
