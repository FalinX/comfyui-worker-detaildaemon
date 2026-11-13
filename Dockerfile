# Studio photo worker: the official RunPod ComfyUI serverless worker + the custom nodes the studio uses.
# Same as production (worker-comfyui main, MODEL_TYPE flux1-dev-fp8 = the Flux checkpoint is IN the image). LoRAs/Qwen
# come from the network volume (sugrcq2pry). The small face-detector model is baked in, because the
# worker maps just the standard model folders from the volume.
FROM runpod/worker-comfyui:5.10.0-flux1-dev-fp8

# Face pass (FaceDetailer) = Impact Pack + Impact Subpack (UltralyticsDetectorProvider). Detail Daemon for later tests.
RUN comfy-node-install comfyui-impact-pack comfyui-impact-subpack comfyui-detail-daemon

# Face detector used by FaceDetailer (Bingsu/adetailer face_yolov8m.pt)
RUN mkdir -p /comfyui/models/ultralytics/bbox && \
    wget -q -O /comfyui/models/ultralytics/bbox/face_yolov8m.pt \
      https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt && \
    test -s /comfyui/models/ultralytics/bbox/face_yolov8m.pt
