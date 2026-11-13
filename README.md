# Studio ComfyUI worker

`runpod/worker-comfyui:5.10.0-flux1-dev-fp8 (Flux checkpoint inside, like production)` + Impact Pack, Impact Subpack (FaceDetailer) and Detail Daemon, plus the
`face_yolov8m.pt` face detector. GitHub Actions builds `ghcr.io/falinx/comfyui-worker-studio` on every push to main.
Models (Flux, LoRAs, Qwen) come from the RunPod network volume.
