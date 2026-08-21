def processar_prompt(mensagem_usuario):
    # Logica inicial do Engenheiro de Prompts
    return f"Processando: {mensagem_usuario}"
def processar_prompt(mensagem_usuario):

    mensagem = mensagem_usuario.lower()

    if "oi" in mensagem or "olá" in mensagem:
        return (
            "Olá! Eu sou o assistente do Impacto Jovem. "
            "Como posso ajudar você?"
        )

    if "ajuda" in mensagem:
        return (
            "Claro. Posso ajudar você a encontrar informações, "
            "orientações e serviços disponíveis no Impacto Jovem."
        )

    if "clinica" in mensagem or "clínica" in mensagem:
        return (
            "Posso ajudar você a encontrar informações sobre "
            "locais de acolhimento e atendimento."
        )

    if "droga" in mensagem or "vício" in mensagem:
        return (
            "Entendo. O mais importante é buscar apoio de pessoas "
            "de confiança e de profissionais especializados. "
            "Posso ajudar a encontrar informações sobre acolhimento."
        )

    return (
        "Entendi sua mensagem. Ainda estou aprendendo a responder "
        "essa pergunta. Tente explicar um pouco mais."
    )