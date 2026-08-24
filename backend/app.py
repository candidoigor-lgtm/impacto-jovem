from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "projeto": "Impacto Jovem",
        "status": "Online",
        "mensagem": "API do sistema de Inteligência Artificial funcionando com sucesso!"
    }), 200

from flask import Flask, jsonify, request
from chatbot import processar_prompt

app = Flask(__name__)


@app.route("/", methods=["GET"])
def home():
    return jsonify({
        "projeto": "Impacto Jovem",
        "status": "Online",
        "mensagem": "API do sistema funcionando com sucesso!"
    }), 200


@app.route("/chat", methods=["POST"])
def chat():

    dados = request.get_json()

    mensagem = dados.get("mensagem", "")

    if not mensagem:
        return jsonify({
            "erro": "Mensagem não informada"
        }), 400

    resposta = processar_prompt(mensagem)

    return jsonify({
        "mensagem": mensagem,
        "resposta": resposta
    }), 200


if __name__ == "__main__":
    app.run(
        debug=True,
        port=5000
    )