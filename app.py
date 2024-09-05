import os
from fastapi import FastAPI
from diffusers import StableDiffusionPipeline
import torch

app = FastAPI()

# Load model
model_path = "/app/model/dreamshaper_8.safetensors"
pipe = StableDiffusionPipeline.from_single_file(model_path, torch_dtype=torch.float16)
pipe = pipe.to("cuda")

@app.get("/")
async def root():
    return {"message": "dreamshaper is up"}

@app.post("/generate")
async def generate_image(prompt: str):
    image = pipe(prompt).images[0]
    
    # Save image
    output_path = "output.png"
    image.save(output_path)
    
    return {"message": "Image generated", "file_path": output_path}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)