INSERT INTO usuario (
    id_usuario,
    data_nascimento,
    data_cadastro,
    ultimo_acesso,
    email_usuario,
    senha,
    nome_usuario,
    localizacao_usuario
)
VALUES
(
    1,
    '2008-05-15',
    '2026-09-01 08:30:00',
    '2026-09-15 14:20:00',
    'usuario1@email.com',
    'senha_teste_123',
    'Ana',
    'Maringá - PR'
),
(
    2,
    '2007-11-20',
    '2026-09-02 10:00:00',
    '2026-09-14 16:45:00',
    'usuario2@email.com',
    'senha_teste_456',
    'Lucas',
    'Londrina - PR'
);


INSERT INTO servico_saude (
    endereco_clinica,
    atendimento_sem_estigma,
    id_servico,
    nome_servico,
    latitude,
    longitude,
    horario_funcionamento,
    atende_urgencia,
    quantidade_avaliacoes,
    avaliacao_servico,
    lista_posto_de_saude,
    mapa_servicos,
    tipo_atendimento
)
VALUES
(
    'Rua das Flores, 100',
    TRUE,
    1,
    'Unidade de Saúde Central',
    -23.42050000,
    -51.93330000,
    '08:00 - 18:00',
    TRUE,
    25,
    4.50,
    'Posto de Saúde Central',
    'Mapa da Unidade Central',
    'Presencial'
),
(
    'Avenida Brasil, 500',
    TRUE,
    2,
    'Centro de Atendimento à Saúde',
    -23.42100000,
    -51.93400000,
    '07:00 - 17:00',
    FALSE,
    18,
    4.20,
    'Posto de Saúde Norte',
    'Mapa da Unidade Norte',
    'Presencial e online'
);


-- 3. CHATBOTS
INSERT INTO chatbot (
    id_chatbot
)
VALUES
(1),
(2);


-- 4. CONVERSAS
INSERT INTO conversa (
    id_conversa,
    id_usuario,
    id_chatbot
)
VALUES
(
    1,
    1,
    1
),
(
    2,
    2,
    2
);


INSERT INTO mensagem (
    id_mensagem,
    id_conversa,
    data_hora,
    mensagem_usuario,
    resposta_chatbot,
    tecnica_respiracao,
    nivel_crise,
    alerta_risco,
    tipo_crise,
    historico_conversa
)
VALUES
(
    1,
    1,
    '2026-09-15 14:25:00',
    'Estou me sentindo muito ansiosa.',
    'Vamos realizar uma técnica de respiração.',
    'Respiração profunda e lenta.',
    2,
    FALSE,
    'Ansiedade',
    'Usuário relatou ansiedade.'
),
(
    2,
    2,
    '2026-09-14 16:50:00',
    'Estou passando por um momento difícil.',
    'Procure um serviço de saúde ou pessoa de confiança.',
    'Respiração controlada.',
    4,
    TRUE,
    'Crise emocional',
    'Usuário relatou situação de crise.'
);
