import csv
from pathlib import Path
from collections import Counter

CSV_PADRAO = Path(__file__).resolve().parent / "impacto_jovem_exemplo.csv"


def carregar_dados(caminho=CSV_PADRAO):
    caminho = Path(caminho)
    with caminho.open("r", encoding="utf-8-sig", newline="") as arquivo:
        return list(csv.DictReader(arquivo))


def gerar_resumo(caminho=CSV_PADRAO):
    dados = carregar_dados(caminho)
    if not dados:
        return "O CSV está vazio."

    total = len(dados)
    clinicas = sorted({linha.get("clinica", "").strip() for linha in dados if linha.get("clinica")})
    risco = Counter(linha.get("risco_social", "Não informado") for linha in dados)
    sucesso = sum(linha.get("sucesso", "0") == "1" for linha in dados)
    desistencias = sum(linha.get("desistencia", "0") == "1" for linha in dados)

    return (
        f"Registros: {total}\n"
        f"Clínicas: {', '.join(clinicas) or 'Nenhuma'}\n"
        f"Sucessos registrados: {sucesso}\n"
        f"Desistências registradas: {desistencias}\n"
        f"Risco social: " + ", ".join(f"{k}={v}" for k, v in risco.items())
    )


def contexto_para_chatbot(caminho=CSV_PADRAO, limite=30):
    dados = carregar_dados(caminho)
    if not dados:
        return "Não há registros no CSV."

    campos = [
        "clinica", "idade", "sexo", "tempo_vicio_anos", "recaidas",
        "frequencia_atendimento", "desistencia", "sucesso", "empenho", "risco_social"
    ]

    linhas = []
    for item in dados[:limite]:
        partes = []
        for campo in campos:
            valor = item.get(campo, "")
            if valor != "":
                partes.append(f"{campo}={valor}")
        linhas.append("; ".join(partes))

    return "\n".join(linhas)


if __name__ == "__main__":
    print(gerar_resumo())
