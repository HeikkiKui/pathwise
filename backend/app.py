from flask import Flask, request
import requests
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests if needed (e.g., Chrome/Web)

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "gemma:2b"  # or "mistral"


@app.route("/generate", methods=["POST"])
def generate():
    goal = request.form.get("goal")
    if not goal:
        return "No learning goal provided", 400

    prompt = f"""
You are a learning path assistant. The user wants to learn: {goal}

Create a clear step-by-step guide. Format each step exactly like this:

Step 1: [Short title here]
Description: [One or two sentence description here]

Step 2: ...
Description: ...

Avoid Markdown, headings, or bullets. Output plain text only.
""".strip()

    payload = {
        "model": MODEL,
        "prompt": prompt,
        "stream": False,
        "options": {"num_predict": 500},
    }

    response = requests.post(OLLAMA_URL, json=payload)
    data = response.json()
    return data.get("response", "No response from model")
