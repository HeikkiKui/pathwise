# 📚 Pathwise

**Pathwise** is an AI-powered app that generates personalized step-by-step learning paths based on your goal — completely offline using local models like Gemma or Mistral via [Ollama](https://ollama.com).  
Built with ❤️ using Flutter + Flask.

---

## ✨ Features

- 🧠 Generates clear learning steps using local LLMs (via Ollama)
- 📋 Interactive checklist for tracking progress
- 💾 Automatically saves your progress locally (restores on next launch)
- 🔐 Fully private and offline — no OpenAI, no cloud
- 💻 Works on macOS & Web (Android/iOS optional)
- 🎨 Clean dark UI with responsive design
- ⚙️ Easy to run with no account needed

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/your-user/pathwise.git
cd pathwise
```

### 2. Install and run Ollama

Install Ollama: <https://ollama.com>  
Then start a fast model:

```bash
ollama run gemma:2b
ollama serve
```

---

### 3. Run the Flask backend

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install flask requests flask-cors
python app.py
```

Backend will run at: <http://localhost:5050>

---

### 4. Run the Flutter frontend

```bash
flutter pub get
flutter run -d macos
# or:
flutter run -d chrome
```

---

## 💡 How It Works

- Backend sends your goal to Ollama (local model)
- Model returns a learning plan
- Flutter displays interactive steps with checkboxes
- Progress is saved locally using `shared_preferences`

---

## 🧪 Tech Stack

- **Frontend**: Flutter
- **Backend**: Flask (Python)
- **AI Model**: Ollama (Gemma or Mistral)
- **Local Storage**: shared_preferences

---

## 📄 License

MIT License © 2025 Heikki Kuittinen

---

## 📦 Download

Build it locally or get it from [GitHub Releases](https://github.com/your-user/pathwise/releases) (coming soon)
