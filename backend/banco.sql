CREATE TABLE registro_projeto (
    -- Chave Primária
    codigo INT PRIMARY KEY,
    
    -- Identificação
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    
    -- Performance
    quantidade INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    indicador VARCHAR(50),
    
    -- Temporalidade
    data DATE NOT NULL,
    horario TIME NOT NULL
);
