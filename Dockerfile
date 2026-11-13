# Studio photo worker: the official RunPod ComfyUI serverless worker + the custom nodes the studio uses.
# Same as production (worker-comfyui main, MODEL_TYPE flux1-dev-fp8 = the Flux checkpoint is IN the image). LoRAs/Qwen
# come from the network volume (sugrcq2pry). The small face-detector model is baked in, because the
# worker maps just the standard model folders from the volume.
FROM runpod/worker-comfyui:5.10.0-flux1-dev-fp8

# OpenCV system libraries (ultralytics pulls in opencv-python, which needs libGL)
RUN apt-get update && apt-get install -y --no-install-recommends libgl1 libglib2.0-0 && rm -rf /var/lib/apt/lists/*

# Face pass (FaceDetailer) = Impact Pack + Impact Subpack (UltralyticsDetectorProvider). Detail Daemon for later tests.
RUN comfy-node-install comfyui-impact-pack comfyui-impact-subpack comfyui-detail-daemon

# comfy-node-install put the Python deps in another environment (2026-11-13: worker log "No module named 'cv2'").
# Install every node's requirements into the venv ComfyUI actually runs (/opt/venv).
RUN for r in /comfyui/custom_nodes/*/requirements.txt; do \
      echo "== $r"; /opt/venv/bin/python -m pip install --no-cache-dir -r "$r" \
      || uv pip install --python /opt/venv/bin/python -r "$r"; \
    done && \
    (/opt/venv/bin/python -m pip install --no-cache-dir opencv-python-headless || \
     uv pip install --python /opt/venv/bin/python opencv-python-headless)

# Fail the build if the runtime venv cannot import what the nodes need
RUN /opt/venv/bin/python -c "import cv2, ultralytics, matplotlib, skimage, piexif; print('deps ok', cv2.__version__, ultralytics.__version__)"

# Face detector used by FaceDetailer (Bingsu/adetailer face_yolov8m.pt)
RUN mkdir -p /comfyui/models/ultralytics/bbox && \
    wget -q -O /comfyui/models/ultralytics/bbox/face_yolov8m.pt \
      https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt && \
    test -s /comfyui/models/ultralytics/bbox/face_yolov8m.pt
