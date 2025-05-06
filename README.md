# Pathwise

Pathwise is a simple app that helps you create a learning path using local AI models.  
Just type what you want to learn, and the app gives you clear steps to follow.

No cloud, no OpenAI — everything runs locally.

---

## How it works

- You type a learning goal (e.g. “I want to learn Flutter”)
- The app sends it to a local AI model using Ollama
- The model returns a list of steps
- You can check off each step as you make progress

---

## What you need

- [Ollama](https://ollama.com) installed
- A local AI model (like `gemma:2b` or `mistral`)
- Python 3 and Flask
- Flutter installed

---

## How to run it

### 1. Start Ollama

```bash
ollama run gemma:2b
ollama serve
```

### 2. Start the backend

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install flask requests flask-cors
flask run --port=5050
```

If you're running it in Chrome, make sure Flask allows CORS:

```python
from flask_cors import CORS
CORS(app)
```

### 3. Run the Flutter app

```bash
flutter pub get
flutter run -d macos   # or use -d chrome
```

---

## Backend config

In `app.py`, make sure this is set:

```python
OLLAMA_URL = "http://localhost:11434/api/generate"
MODEL = "gemma:2b"
```

You can also add:

```python
"num_predict": 200
```

to limit the length of the AI's response for faster results.

---

## Coming soon

- Save progress
- Export to PDF
- Mobile version
- Custom prompt editing

---

## License

MIT License © 2025 [Your Name]
