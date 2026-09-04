from flask import Flask, jsonify, request
from pathlib import Path
import importlib.util

from cliente_ollama import perguntar_ollama

BASE = Path(__file__).resolve().parent
CSV_PATH = BASE / "impacto_jovem_exemplo.csv"

spec = importlib.util.spec_from_file_location("analise_dados", BASE / "analise de dados.py")
analise_dados = importlib.util.module_from_spec(spec)
spec.loader.exec_module(analise_dados)

app = Flask(__name__)


@app.after_request
def cors(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    return response


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "projeto": "Impacto Jovem",
        "status": "Online",
        "ia": "Ollama",
        "modelo": "configurado por OLLAMA_MODEL"
    })


def receber_mensagem():
    dados = request.get_json(silent=True) or {}
    mensagem = str(dados.get("mensagem", "")).strip()
    if not mensagem:
        return None, jsonify({"erro": "Mensagem não informada"}), 400
    return mensagem, None, None


@app.route("/chat", methods=["POST"])
def chat():
    mensagem, erro, status = receber_mensagem()
    if erro:
        return erro, status

    contexto = analise_dados.contexto_para_chatbot(CSV_PATH)
    resposta = perguntar_ollama(mensagem, contexto)
    return jsonify({"mensagem": mensagem, "resposta": resposta})


@app.route("/chat-servicos", methods=["POST"])
def chat_servicos():
    mensagem, erro, status = receber_mensagem()
    if erro:
        return erro, status

    dados = analise_dados.carregar_dados(CSV_PATH)
    clinicas = sorted({linha.get("clinica", "").strip() for linha in dados if linha.get("clinica")})
    contexto = (
        "Este é o chatbot de serviços. O CSV atual contém os nomes de clínicas/serviços "
        "e indicadores de atendimento. Não invente endereço, horário ou tipo de atendimento "
        "que não esteja no CSV.\n\n"
        f"Clínicas/serviços registrados: {', '.join(clinicas) or 'Nenhum'}\n\n"
        + analise_dados.contexto_para_chatbot(CSV_PATH)
    )
    resposta = perguntar_ollama(mensagem, contexto)
    return jsonify({"mensagem": mensagem, "resposta": resposta})


@app.route("/dados", methods=["GET"])
def dados():
    return jsonify({
        "resumo": analise_dados.gerar_resumo(CSV_PATH),
        "registros": analise_dados.carregar_dados(CSV_PATH)
    })


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)
