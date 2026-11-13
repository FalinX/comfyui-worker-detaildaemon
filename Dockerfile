# Studio photo worker: the official RunPod ComfyUI serverless worker + the custom nodes the studio uses.
# Models stay on the network volume (sugrcq2pry); only the small face-detector model is baked in, because the
# worker maps just the standard model folders from the volume.
FROM runpod/worker-comfyui:5.10.0-base

# Face pass (FaceDetailer) = Impact Pack + Impact Subpack (UltralyticsDetectorProvider). Detail Daemon for later tests.
RUN comfy-node-install comfyui-impact-pack comfyui-impact-subpack comfyui-detail-daemon

# Face detector used by FaceDetailer (Bingsu/adetailer face_yolov8m.pt)
RUN mkdir -p /comfyui/models/ultralytics/bbox && \
    wget -q -O /comfyui/models/ultralytics/bbox/face_yolov8m.pt \
      https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt && \
    test -s /comfyui/models/ultralytics/bbox/face_yolov8m.pt
