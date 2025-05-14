use actix_cors::Cors;
use actix_web::{App, HttpResponse, HttpServer, post, web};
use reqwest::Client;
use serde::{Deserialize, Serialize};

#[derive(Deserialize)]
struct GenerateForm {
    goal: String,
}

#[derive(Serialize)]
struct OllamaRequest {
    model: String,
    prompt: String,
    stream: bool,
    num_predict: u32,
}

#[derive(Deserialize)]
struct OllamaResponse {
    response: String,
}

#[post("/generate")]
async fn generate(form: web::Form<GenerateForm>) -> HttpResponse {
    let prompt = format!(
        "You are an expert teacher. The user wants to learn: {}.\n\n\
Generate exactly 10 clear steps. Format **each step exactly** like this:\n\n\
Step 1: [Short title here]\n\
Description: [One or two sentence explanation here.]\n\n\
Step 2: [Title]\n\
Description: [Explanation]\n\n\
...continue this pattern until Step 10. Do not skip any steps or end early.",
        form.goal
    );

    let payload = OllamaRequest {
        model: "llama3".to_string(), // you can change this to "mistral" or "gemma:2b"
        prompt,
        stream: false,
        num_predict: 500,
    };

    let client = Client::new();
    match client
        .post("http://localhost:11434/api/generate")
        .json(&payload)
        .send()
        .await
    {
        Ok(res) => match res.json::<OllamaResponse>().await {
            Ok(json) => {
                println!("🧠 Full Ollama response:\n{}", json.response); // For debugging
                HttpResponse::Ok()
                    .content_type("text/plain")
                    .body(json.response)
            }
            Err(_) => HttpResponse::InternalServerError().body("Invalid response from Ollama"),
        },
        Err(_) => HttpResponse::InternalServerError().body("Failed to reach Ollama"),
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("🚀 Starting Rust backend on http://localhost:5050");
    HttpServer::new(|| App::new().wrap(Cors::permissive()).service(generate))
        .bind(("127.0.0.1", 5050))?
        .run()
        .await
}
