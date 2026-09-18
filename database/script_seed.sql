-- 1. Quais usuários estão cadastrados no sistema?
SELECT
    id_usuario,
    nome_usuario,
    email_usuario,
    localizacao_usuario
FROM usuario;


-- 2. Quais serviços de saúde estão cadastrados?
SELECT
    id_servico,
    nome_servico,
    endereco_clinica,
    tipo_atendimento,
    horario_funcionamento
FROM servico_saude;


-- 3. Quais serviços oferecem atendimento sem estigma?
SELECT
    id_servico,
    nome_servico,
    endereco_clinica,
    atendimento_sem_estigma
FROM servico_saude
WHERE atendimento_sem_estigma = TRUE;


-- 4. Quais serviços atendem situações de urgência?
SELECT
    id_servico,
    nome_servico,
    endereco_clinica,
    atende_urgencia
FROM servico_saude
WHERE atende_urgencia = TRUE;


-- 5. Quais serviços possuem melhor avaliação?
SELECT
    id_servico,
    nome_servico,
    avaliacao_servico,
    quantidade_avaliacoes
FROM servico_saude
WHERE avaliacao_servico IS NOT NULL
ORDER BY avaliacao_servico DESC;


-- 6. Quais mensagens indicaram alerta de risco?
SELECT
    mensagem_usuario,
    resposta_chatbot,
    nivel_crise,
    alerta_risco,
    tipo_crise
FROM mensagem
WHERE alerta_risco = TRUE;


-- 7. Quais mensagens apresentam nível de crise maior ou igual a 3?
SELECT
    mensagem_usuario,
    nivel_crise,
    tipo_crise,
    alerta_risco
FROM mensagem
WHERE nivel_crise >= 3
ORDER BY nivel_crise DESC;


-- 8. Quais conversas foram registradas?
SELECT
    id_conversa,
    data_hora
FROM conversa
ORDER BY data_hora DESC;
