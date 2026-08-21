CREATE DATABASE IF NOT EXISTS impacto_jovem_db;
USE impacto_jovem_db;

-- Tabela de Logs e Interações do Chatbot
CREATE TABLE IF NOT EXISTS historico_chatbot (
    -- Identificação
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    
    -- Performance
    quantidade INT DEFAULT 0,
    valor DECIMAL(10, 2) DEFAULT 0.00,
    indicador VARCHAR(50),
    
    -- Temporalidade
    data DATE NOT NULL,
    horario TIME NOT NULL
);

-- Tabela de Métricas do Dashboard
CREATE TABLE IF NOT EXISTS metricas_dashboard (
    -- Identificação
    codigo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    
    -- Performance
    quantidade INT DEFAULT 0,
    valor DECIMAL(10, 2) DEFAULT 0.00,
    indicador VARCHAR(50),
    
    -- Temporalidade
    data DATE NOT NULL,
    horario TIME NOT NULL
);
