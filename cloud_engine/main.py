from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
import json
import re
from typing import List, Optional

app = FastAPI(title="Climora Cloud (FastAPI)")

# --- Mock Data ---

mock_places_db = [
    {"place_id": "p1", "name": "Sweet Delights", "types": ["bakery", "dessert_shop"], "price_level": 2, "latitude": 12.9716, "longitude": 77.5946},
    {"place_id": "p2", "name": "The Chocolate Room", "types": ["cafe", "dessert_shop"], "price_level": 3, "latitude": 12.9720, "longitude": 77.5950},
    {"place_id": "p3", "name": "Cafe Coffee Day", "types": ["cafe"], "price_level": 2, "latitude": 12.9700, "longitude": 77.5960},
    {"place_id": "p4", "name": "Sri Krishna Sweets", "types": ["sweet_shop"], "price_level": 1, "latitude": 12.9730, "longitude": 77.5940},
    {"place_id": "p5", "name": "Pizza Hut", "types": ["restaurant"], "price_level": 3, "latitude": 12.9740, "longitude": 77.5920},
]

mock_user_history = {
    "user123": {
        "place_history": [
            {"placeId": "p4", "visitStatus": "visited", "moodImprovementTag": True},
            {"placeId": "p1", "visitStatus": "liked", "moodImprovementTag": True},
        ],
        "preferences": {
            "preferred_place_types": ["sweet_shop", "bakery"]
        }
    }
}


# --- Pydantic Models ---

class SyncData(BaseModel):
    user_id: str
    settings: dict

class Location(BaseModel):
    latitude: float
    longitude: float

class RecommendationRequest(BaseModel):
    user_id: str
    text: str
    location: Location

class PlaceRecommendation(BaseModel):
    place_id: str
    name: str
    distance: float
    estimated_cost_range: str
    reason: str

# --- Helper Functions ---

def extract_intent_entities(text: str) -> dict:
    """Extracts budget and craving from the user's text query."""
    budget_match = re.search(r"(\d+)\s*rupees", text, re.IGNORECASE)
    budget = int(budget_match.group(1)) if budget_match else None

    craving = None
    if "sweet" in text.lower():
        craving = "sweet"
    elif "snack" in text.lower():
        craving = "snack"
    elif "tea" in text.lower() or "coffee" in text.lower():
        craving = "beverage"
    elif "meal" in text.lower():
        craving = "meal"

    return {"budget": budget, "craving": craving, "intent": "find_place"}

def get_place_types_for_craving(craving: str) -> List[str]:
    """Returns Google Places API types for a given craving."""
    if craving == "sweet":
        return ["bakery", "dessert_shop", "sweet_shop", "cafe"]
    if craving == "snack":
        return ["cafe", "bakery", "restaurant"]
    if craving == "beverage":
        return ["cafe"]
    if craving == "meal":
        return ["restaurant"]
    return []

def calculate_distance(loc1: Location, loc2_lat: float, loc2_lon: float) -> float:
    """Calculates distance in km (simplified)."""
    return abs(loc1.latitude - loc2_lat) * 111 + abs(loc1.longitude - loc2_lon) * 111


# --- FastAPI Endpoints ---

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

@app.post("/api/places/recommend", response_model=List[PlaceRecommendation])
async def get_place_recommendations(request: RecommendationRequest):
    """
    Provides personalized place recommendations based on user query.
    """
    # 1. NLP to extract intent and entities
    entities = extract_intent_entities(request.text)
    budget = entities.get("budget")
    craving = entities.get("craving")
    
    if not craving:
        raise HTTPException(status_code=400, detail="Could not understand your craving from the query.")

    # 2. Query Google Places API (mocked)
    place_types = get_place_types_for_craving(craving)
    
    # Filter places by type
    candidate_places = [p for p in mock_places_db if any(pt in p["types"] for pt in place_types)]

    # 3. Apply budget and location filters
    recommendations = []
    for place in candidate_places:
        # Budget check (price_level 1=$ cheap, 2=$$ moderate, 3=$$$ expensive)
        if budget:
            # Simple logic: budget < 300 -> price_level 1, < 600 -> 1,2, > 600 -> 1,2,3
            if budget < 300 and place["price_level"] > 1:
                continue
            if budget < 600 and place["price_level"] > 2:
                continue
        
        distance = calculate_distance(request.location, place["latitude"], place["longitude"])
        
        # Filter by radius (e.g., 5km)
        if distance > 5.0:
            continue
            
        recommendations.append({
            "place": place,
            "distance": distance
        })

    # 4. Personalize and Rank
    user_data = mock_user_history.get(request.user_id)
    
    def rank_key(item):
        score = 0
        place = item["place"]
        
        # Higher score for places that improved mood
        if user_data and any(h["placeId"] == place["place_id"] and h.get("moodImprovementTag") for h in user_data["place_history"]):
            score += 10
            item["reason"] = "You've enjoyed this place before!"
        
        # Higher score for preferred place types
        if user_data and any(pt in user_data["preferences"]["preferred_place_types"] for pt in place["types"]):
            score += 5
            if "reason" not in item:
                item["reason"] = "It's one of your preferred types of places."

        # Lower score for higher distance
        score -= item["distance"]
        
        return score

    recommendations.sort(key=rank_key, reverse=True)

    # 5. Format output
    output = []
    for item in recommendations[:5]: # Return top 5
        place = item["place"]
        cost_map = {1: "₹", 2: "₹₹", 3: "₹₹₹"}
        output.append(PlaceRecommendation(
            place_id=place["place_id"],
            name=place["name"],
            distance=round(item["distance"], 2),
            estimated_cost_range=cost_map.get(place["price_level"], "N/A"),
            reason=item.get("reason", "A great option nearby.")
        ))

    # In a real app, you would also save the interaction record here.

    return output


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
