from flask import Flask, request
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "gemma:2b"  # Use a lightweight, fast model


@app.route("/generate", methods=["POST"])
def generate():
    goal = request.form.get("goal")
    if not goal:
        return "⚠️ No learning goal provided.", 400

    prompt = f"Create a clear step-by-step learning plan for: {goal}. Include short descriptions."

    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False,
        "num_predict": 150,  # Limit output for speed and reliability
    }

    try:
        response = requests.post(OLLAMA_URL, json=payload, timeout=25)
        response.raise_for_status()
        data = response.json()
        return data.get("response", "⚠️ No response from model.")

    except requests.exceptions.Timeout:
        return (
            "⚠️ The model took too long to respond. Try again with a shorter goal.",
            504,
        )

    except requests.exceptions.RequestException as e:
        return f"❌ Error communicating with Ollama: {e}", 502

    except Exception as e:
        return f"🔥 Internal server error: {e}", 500


# Optional: Preload the model for speed
def warm_up():
    try:
        print("🔁 Preloading model...")
        requests.post(
            OLLAMA_URL,
            json={"model": MODEL, "prompt": "Hi", "stream": False, "num_predict": 1},
            timeout=10,
        )
        print("✅ Model is ready.")
    except Exception as e:
        print("⚠️ Warm-up failed:", e)


if __name__ == "__main__":
    warm_up()
    app.run(port=5050)
