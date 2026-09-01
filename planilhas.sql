CREATE DATABASE sistema_saude;
USE sistema_saude;

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    data_nascimento DATE,
    data_cadastro DATETIME NOT NULL,
    ultimo_acesso DATETIME,
    email_usuario VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    nome_usuario VARCHAR(255) NOT NULL,
    localizacao_usuario VARCHAR(255) NOT NULL
);

CREATE TABLE Servicos_Saude (
    endereco_clinica VARCHAR(255) NOT NULL,
    atendimento_sem_estigma BOOLEAN NOT NULL,
    id_servico INT PRIMARY KEY,
    nome_servico VARCHAR(255) NOT NULL,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    horario_funcionamento VARCHAR(255) NOT NULL,
    atende_urgencia BOOLEAN NOT NULL,
    quantidade_avaliacoes INT NOT NULL,
    avaliacao_servico DECIMAL(3,2),
    lista_posto_de_saude VARCHAR(255) NOT NULL,
    mapa_servicos VARCHAR(255) NOT NULL,
    tipo_atendimento VARCHAR(255) NOT NULL
);

CREATE TABLE Chatbot (
    id_chatbot INT PRIMARY KEY
);

CREATE TABLE Conversa (
    id_conversa INT PRIMARY KEY NOT NULL,
    id_usuario INT NOT NULL,
    id_chatbot INT NOT NULL,

    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_chatbot) REFERENCES Chatbot(id_chatbot)
);

CREATE TABLE Mensagem (
    id_mensagem INT PRIMARY KEY NOT NULL,
    id_conversa INT NOT NULL,
    data_hora DATETIME NOT NULL,
    mensagem_usuario TEXT NOT NULL,
    resposta_chatbot TEXT,
    tecnica_respiracao TEXT,
    nivel_crise INT NOT NULL,
    alerta_risco BOOLEAN NOT NULL,
    tipo_crise TEXT,
    historico_conversa TEXT,

    FOREIGN KEY (id_conversa) REFERENCES Conversa(id_conversa)
);