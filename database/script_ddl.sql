-- =====================================================================
-- PROJETO: Rede de Apoio a Pessoas em Recuperação de Vícios
-- MÓDULO : MVP - Criação das Tabelas
-- SGBD   : PostgreSQL 14+
-- NORMA  : Normalizado até a 3FN
-- =====================================================================

DROP SCHEMA IF EXISTS apoio CASCADE;
CREATE SCHEMA apoio;
SET search_path TO apoio;

-- ---------------------------------------------------------------------
-- 1. NÚCLEO DE IDENTIDADE
-- ---------------------------------------------------------------------

CREATE TABLE usuarios (
    id              SERIAL PRIMARY KEY,
    nome_exibicao   VARCHAR(80)  NOT NULL,
    email           VARCHAR(120) NOT NULL UNIQUE,
    senha_hash      VARCHAR(255) NOT NULL,
    papel           VARCHAR(20)  NOT NULL DEFAULT 'membro'
                    CHECK (papel IN ('membro','apoiador','conselheiro','admin')),
    ativo           BOOLEAN      NOT NULL DEFAULT TRUE,
    criado_em       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    atualizado_em   TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE perfis (
    id                     SERIAL PRIMARY KEY,
    usuario_id             INTEGER NOT NULL UNIQUE
                           REFERENCES usuarios(id) ON DELETE CASCADE,
    ano_nascimento         SMALLINT,
    cidade                 VARCHAR(80),
    estado                 CHAR(2),
    substancias_usadas     TEXT[],
    estagio_recuperacao    VARCHAR(30)
                           CHECK (estagio_recuperacao IN
                             ('pre_contemplacao','contemplacao','preparacao',
                              'acao','manutencao','recaida','recuperado')),
    iniciou_recuperacao_em DATE,
    idioma_preferido       VARCHAR(10) NOT NULL DEFAULT 'pt-BR'
);

CREATE TABLE consentimentos (
    id             SERIAL PRIMARY KEY,
    usuario_id     INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    finalidade     VARCHAR(40) NOT NULL
                   CHECK (finalidade IN
                     ('apoio_rede','mentoria','chat_llm','pesquisa','compartilhamento')),
    concedido      BOOLEAN NOT NULL,
    versao_termo   VARCHAR(20) NOT NULL,
    registrado_em  TIMESTAMPTZ NOT NULL DEFAULT now(),
    revogado_em    TIMESTAMPTZ,
    UNIQUE (usuario_id, finalidade, versao_termo)
);

-- ---------------------------------------------------------------------
-- 2. REDE DE APOIO
-- ---------------------------------------------------------------------

CREATE TABLE vinculos_apoio (
    id              SERIAL PRIMARY KEY,
    solicitante_id  INTEGER NOT NULL REFERENCES usuarios(id),
    apoiador_id     INTEGER NOT NULL REFERENCES usuarios(id),
    tipo_vinculo    VARCHAR(20) NOT NULL
                    CHECK (tipo_vinculo IN ('colega','mentor','padrinho','amigo')),
    situacao        VARCHAR(20) NOT NULL DEFAULT 'pendente'
                    CHECK (situacao IN ('pendente','ativo','pausado','encerrado')),
    iniciado_em     TIMESTAMPTZ NOT NULL DEFAULT now(),
    encerrado_em    TIMESTAMPTZ,
    motivo_fim      TEXT,
    CHECK (solicitante_id <> apoiador_id)
);

CREATE TABLE grupos_apoio (
    id              SERIAL PRIMARY KEY,
    nome            VARCHAR(120) NOT NULL,
    descricao       TEXT,
    modalidade      VARCHAR(15) NOT NULL
                    CHECK (modalidade IN ('online','presencial','hibrido')),
    temas           TEXT[],
    facilitador_id  INTEGER REFERENCES usuarios(id),
    aberto          BOOLEAN NOT NULL DEFAULT TRUE,
    max_membros     SMALLINT,
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE membros_grupo (
    id            SERIAL PRIMARY KEY,
    grupo_id      INTEGER NOT NULL REFERENCES grupos_apoio(id) ON DELETE CASCADE,
    usuario_id    INTEGER NOT NULL REFERENCES usuarios(id)    ON DELETE CASCADE,
    papel_membro  VARCHAR(20) NOT NULL DEFAULT 'membro'
                  CHECK (papel_membro IN ('membro','facilitador','observador')),
    entrou_em     TIMESTAMPTZ NOT NULL DEFAULT now(),
    saiu_em       TIMESTAMPTZ,
    UNIQUE (grupo_id, usuario_id)
);

CREATE TABLE sessoes_grupo (
    id             SERIAL PRIMARY KEY,
    grupo_id       INTEGER NOT NULL REFERENCES grupos_apoio(id) ON DELETE CASCADE,
    agendada_para  TIMESTAMPTZ NOT NULL,
    duracao_min    SMALLINT,
    local          VARCHAR(150),
    url_encontro   TEXT,
    anotacoes      TEXT,
    situacao       VARCHAR(15) NOT NULL DEFAULT 'agendada'
                   CHECK (situacao IN ('agendada','realizada','cancelada'))
);

-- ---------------------------------------------------------------------
-- 3. JORNADA DE RECUPERAÇÃO
-- ---------------------------------------------------------------------

CREATE TABLE planos_recuperacao (
    id           SERIAL PRIMARY KEY,
    usuario_id   INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    versao       INTEGER NOT NULL DEFAULT 1,
    metas        JSONB,
    gatilhos     TEXT[],
    estrategias  TEXT[],
    ativo        BOOLEAN NOT NULL DEFAULT TRUE,
    criado_por   INTEGER REFERENCES usuarios(id),
    criado_em    TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (usuario_id, versao)
);

CREATE TABLE marcos (
    id              SERIAL PRIMARY KEY,
    usuario_id      INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    tipo            VARCHAR(30) NOT NULL,
    rotulo          VARCHAR(120),
    valor_numerico  NUMERIC,
    alcancado_em    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE registros_diarios (
    id             SERIAL PRIMARY KEY,
    usuario_id     INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    humor          SMALLINT CHECK (humor BETWEEN 1 AND 10),
    nivel_fissura  SMALLINT CHECK (nivel_fissura BETWEEN 0 AND 10),
    horas_sono     NUMERIC(4,1),
    observacoes    TEXT,
    criado_em      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE eventos_risco (
    id             SERIAL PRIMARY KEY,
    usuario_id     INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    gravidade      VARCHAR(10) NOT NULL
                   CHECK (gravidade IN ('baixa','media','alta','critica')),
    tipo           VARCHAR(30) NOT NULL,
    detectado_por  VARCHAR(15) NOT NULL
                   CHECK (detectado_por IN ('proprio','colega','llm','conselheiro')),
    descricao      TEXT,
    escalado_para  INTEGER REFERENCES usuarios(id),
    resolvido_em   TIMESTAMPTZ,
    criado_em      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 4. CHATBOT (OLLAMA)
-- ---------------------------------------------------------------------

CREATE TABLE sessoes_chat (
    id              SERIAL PRIMARY KEY,
    usuario_id      INTEGER NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    modelo          VARCHAR(60) NOT NULL,
    iniciada_em     TIMESTAMPTZ NOT NULL DEFAULT now(),
    encerrada_em    TIMESTAMPTZ,
    sinalizada      BOOLEAN NOT NULL DEFAULT FALSE,
    resumo_contexto TEXT
);

CREATE TABLE mensagens (
    id                 SERIAL PRIMARY KEY,
    sessao_id          INTEGER NOT NULL REFERENCES sessoes_chat(id) ON DELETE CASCADE,
    remetente          VARCHAR(15) NOT NULL
                       CHECK (remetente IN ('usuario','assistente','sistema')),
    conteudo           TEXT NOT NULL,
    tokens             INTEGER,
    latencia_ms        INTEGER,
    rotulos_seguranca  TEXT[],
    criada_em          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 5. AUDITORIA
-- ---------------------------------------------------------------------

CREATE TABLE auditoria (
    id           SERIAL PRIMARY KEY,
    ator_id      INTEGER REFERENCES usuarios(id),
    acao         VARCHAR(20) NOT NULL,
    entidade     VARCHAR(40) NOT NULL,
    entidade_id  INTEGER,
    metadados    JSONB,
    criado_em    TIMESTAMPTZ NOT NULL DEFAULT now()
);
