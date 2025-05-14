# 📚 Pathwise

**Pathwise** is a local, offline-first learning path generator.  
It uses a local AI model (via [Ollama](https://ollama.com)) and a modern Flutter frontend to generate personalized step-by-step learning plans.

---

## 🧩 Features

- ✨ Input a learning goal (e.g. "I want to learn Rust")
- 🧠 Gets a detailed list of learning steps from a local LLM (Mistral, Gemma, etc.)
- ✅ Each step is checkable and expandable with more info
- 💾 Saves your progress locally (shared preferences)
- 🌙 Beautiful dark UI with gradient/bling design
- 🧑‍💻 Works offline — no OpenAI or cloud

---

## 🚀 How to Run Locally

### 1. Install Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) (macOS/web support)
- [Rust](https://www.rust-lang.org/tools/install)
- [Ollama](https://ollama.com) + a model (`gemma:2b` recommended)

---

### 2. Clone the Project

```bash
git clone https://github.com/HeikkiKui/pathwise.git
cd pathwise
```

---

### 3. Run the Rust Backend

```bash
cd pathwise-backend
cargo run
```

This starts a server at `http://localhost:5050` that sends prompts to your local Ollama model.

---

### 4. Run Ollama

```bash
ollama run gemma:2b
# Or for background serving:
ollama serve
```

Make sure the model is downloaded (`ollama pull gemma:2b` if needed).

---

### 5. Run the Flutter Frontend

```bash
cd ..
flutter pub get
flutter run -d macos
# Or:
flutter run -d chrome
```

---

## 📸 Screenshots

> _(Add screenshots later when your UI is finalized)_

---

## 🧠 How It Works

- Rust backend exposes a POST `/generate` route
- Sends prompt to `http://localhost:11434/api/generate` (Ollama)
- Parses AI response into structured steps
- Flutter displays them as expandable checklist

---

## ✅ Roadmap

- [x] Basic goal input
- [x] AI step generation via Ollama
- [x] Shared preferences for saving
- [x] Bling theme
- [ ] PDF export
- [ ] Mobile support (Android/iOS)
- [ ] Custom templates per learning type

---

## 🪪 License

MIT © [HeikkiKui](https://github.com/HeikkiKui)
