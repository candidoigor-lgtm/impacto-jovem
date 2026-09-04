import os
import requests

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://127.0.0.1:11434/api/chat")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3.2")

SYSTEM_PROMPT = """
Você é o assistente do projeto Impacto Jovem.
Responda em português do Brasil, de forma acolhedora, clara e objetiva.
Use somente os dados fornecidos no contexto do CSV quando a pergunta for sobre os dados.
Nunca invente clínicas, endereços, horários, números ou estatísticas.
Não forneça instruções para consumir, obter, fabricar ou esconder drogas.
Quando a pessoa demonstrar uma situação de risco, incentive a procura de um adulto de confiança ou de um serviço profissional de saúde e, em emergência, o serviço de emergência local.
""".strip()


def perguntar_ollama(mensagem, contexto="", historico=None):
    historico = historico or []

    prompt = mensagem
    if contexto:
        prompt = (
            "CONTEXTO DOS DADOS DO PROJETO:\n"
            f"{contexto}\n\n"
            "PERGUNTA DO USUÁRIO:\n"
            f"{mensagem}"
        )

    messages = [{"role": "system", "content": SYSTEM_PROMPT}]
    messages.extend(historico[-8:])
    messages.append({"role": "user", "content": prompt})

    payload = {
        "model": OLLAMA_MODEL,
        "messages": messages,
        "stream": False,
        "options": {"temperature": 0.2}
    }

    try:
        response = requests.post(OLLAMA_URL, json=payload, timeout=120)
        response.raise_for_status()
        data = response.json()
        return data.get("message", {}).get("content", "Não recebi uma resposta do Ollama.")
    except requests.exceptions.ConnectionError:
        return (
            "Não consegui conectar ao Ollama. Verifique se o Ollama está aberto e se "
            f"o modelo '{OLLAMA_MODEL}' está disponível."
        )
    except requests.exceptions.Timeout:
        return "O Ollama demorou para responder. Tente novamente em alguns segundos."
    except requests.RequestException as erro:
        return f"Não foi possível consultar o Ollama: {erro}"
