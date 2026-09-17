import os
import shutil

def corrigir_estrutura():
    # 1. Corrigir nomes errados do __init__.py no Chatbot e Dashboard
    correcoes_init = {
        "backend/chatbot/__init.py__": "backend/chatbot/__init__.py",
        "backend/dashboard/__init.py": "backend/dashboard/__init__.py"
    }
    
    for antigo, novo in correcoes_init.items():
        if os.path.exists(antigo):
            os.rename(antigo, novo)
            print(f"[CORRIGIDO] {antigo} -> {novo}")

    # 2. Mover o sobre.html para dentro da pasta paginas/
    sobre_antigo = "frontend/sobre.html"
    sobre_novo = "frontend/paginas/sobre.html"
    
    if os.path.exists(sobre_antigo):
        # Garante que a pasta paginas existe
        os.makedirs("frontend/paginas", exist_ok=True)
        shutil.move(sobre_antigo, sobre_novo)
        print(f"[MOVIDO] {sobre_antigo} -> {sobre_novo}")

    # 3. Padronizar nomes com espaços (Snake Case)
    correcoes_nomes = {
        "Planilha sem título - Página1.csv": "planilha_sem_titulo_pagina1.csv",
        "banco-dados/LETICIA MARCELA DUTRA SANCHES - Dicionário de Dados.xlsx": 
        "banco-dados/leticia_marcela_dutra_sanches_dicionario_de_dados.xlsx"
    }

    for antigo, novo in correcoes_nomes.items():
        if os.path.exists(antigo):
            os.rename(antigo, novo)
            print(f"[PADRONIZADO] {antigo} -> {novo}")

if __name__ == "__main__":
    corrigir_estrutura()
    print("\nEstrutura mapeada e corrigida com sucesso!")
