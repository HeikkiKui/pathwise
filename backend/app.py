from flask import Flask, request
import requests

from flask_cors import CORS

app = Flask(__name__)
CORS(app)

OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "gemma:2b"  # tai llama3, gemma, tms.


@app.route("/generate", methods=["POST"])
def generate():
    goal = request.form.get("goal")
    if not goal:
        return "Tavoitetta ei annettu", 400

    prompt = f"Luo vaiheittainen oppimispolku tavoitteelle: {goal}. Listaa selkeät vaiheet ja lyhyet selitykset."

    payload = {"model": MODEL, "prompt": prompt, "stream": False}

    response = requests.post(OLLAMA_URL, json=payload)
    data = response.json()
    return data.get("response", "Ei vastausta mallilta.")
