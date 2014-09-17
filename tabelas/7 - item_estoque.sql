CREATE TABLE item_estoque (
    cod_item_estoque                      serial                     NOT NULL,
    nome_item_estoque                     character varying(45)      NOT NULL,
    cod_silap_item_estoque                character varying(15)      NOT NULL,
    qtde_minima_item_estoque               integer                    NOT NULL,
    tipo_item_estoque                     character varying(30)      NOT NULL,
    unidade_medida_item_estoque           character varying(20)      NOT NULL,
    outras_informacoes_item_estoque       character varying(256),
  
    CONSTRAINT pk_item_estoque
        PRIMARY KEY (cod_item_estoque)
);

-- INSERT INTO item_estoque (nome_item_estoque, cod_silap_item_estoque, qtdeminima_item_estoque, tipo_item_estoque, unidade_medida_item_estoque, outras_informacoes_item_estoque) VALUES (?, ?, ?, ?, ?, ?);
-- INSERT INTO item_estoque (nome_item_estoque, cod_silap_item_estoque, qtdeminima_item_estoque, tipo_item_estoque, unidade_medida_item_estoque, outras_informacoes_item_estoque) VALUES ('alcool', '030.100.012.001', 100, 'Biossegurança', 'BN - Bobina', 'Nenhum comentário adicionado.');

-- UPDATE item_estoque SET nome_item_estoque = ?, cod_silap_item_estoque = ?, qtdeminima_item_estoque = ?, tipo_item_estoque = ?, unidade_medida_item_estoque = ?, outras_informacoes_item_estoque = ? WHERE cod_item_estoque = ?;
-- DROP TABLE item_estoque;

-- SELECT * FROM item_estoque;