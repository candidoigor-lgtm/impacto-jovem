from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/status', methods=['GET'])
def get_status():
    return jsonify({"status": "Backend rodando com sucesso!"})

if __name__ == '__main__':
    app.run(debug=True)
