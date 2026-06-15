from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/api/dados',超methods=['GET'])
def obter_dados():
    # Exemplo de resposta simulando dados do banco
    dados = {
        "status": "sucesso",
        "mensagem": "API do Projeto Integrador funcionando!"
    }
    return jsonify(dados), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
