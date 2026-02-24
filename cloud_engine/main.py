from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
import json

app = FastAPI(title="Climora Cloud (FastAPI)")

class SyncData(BaseModel):
    user_id: str
    settings: dict

@app.get("/health")
async def health():
    return {"status": "active", "engine": "FastAPI"}

@app.post("/api/sync")
async def sync_settings(data: SyncData):
    # Process cloud sync logic here
    return {"message": "Cloud synchronization successful", "user_id": data.user_id}

@app.get("/api/recommendations/{vibe}")
async def get_recommendations(vibe: str):
    # Logic to return premium cloud-calculated song sequences
    recommendations = {
        "calm": ["Zen Garden", "Drift", "Serenity Now"],
        "energetic": ["Power Surge", "Electro Pulse", "Skyline"],
        "focus": ["Deep Work", "Binaural Flow", "Steady Beat"]
    }
    return {
        "vibe": vibe,
        "songs": recommendations.get(vibe, ["Ambient Alpha"]),
        "intensity": 0.95,
        "engine": "FastAPI-Bioluminescence-X"
    }

@app.get("/api/map/spots")
async def get_map_spots(lat: float, lon: float, vibe: str = "any"):
    """
    Returns realistic nearby POIs based on coordinates and current app vibe.
    In a real app, this would query a geo-database or Mapbox.
    """
    # Mock some dynamic results offset from the user's position
    spots = [
        {
            "id": "back_1",
            "name": f"Cloud {vibe.capitalize()} Zone",
            "latitude": lat + 0.002,
            "longitude": lon + 0.002,
            "vibe": vibe if vibe != "any" else "calm",
            "category": "Atmospheric Space"
        },
        {
            "id": "back_2",
            "name": "Bioluminescent Hub",
            "latitude": lat - 0.0015,
            "longitude": lon + 0.003,
            "vibe": "energetic",
            "category": "Experience"
        },
        {
            "id": "back_3",
            "name": "Deep Echo Point",
            "latitude": lat + 0.001,
            "longitude": lon - 0.0025,
            "vibe": "focus",
            "category": "Studio"
        }
    ]
    return {"status": "ok", "spots": spots}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
