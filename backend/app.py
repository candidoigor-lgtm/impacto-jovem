from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "projeto": "Impacto Jovem",
        "status": "Online",
        "mensagem": "API do sistema de Inteligência Artificial funcionando com sucesso!"
    }), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
