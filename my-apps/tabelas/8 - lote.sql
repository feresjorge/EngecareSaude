CREATE TABLE lote (
    cod_lote                              serial                     NOT NULL,
    id_item_estoque                       bigint                     NOT NULL,
    numero_lote                           character varying(45),
    fabricante_lote                       character varying(45)      NOT NULL,
    data_fabricacao_lote                          date                       NOT NULL,
    data_validade_lote                          date                       NOT NULL,
    qtde_atual_lote                        integer                    NOT NULL,
    estante_lote                          character varying(3),
    prateleira_lote                       character varying(3),
    outras_informacoes_lote               character varying(256),
  
    CONSTRAINT pk_lote
        PRIMARY KEY (cod_lote),

    CONSTRAINT fk_lote_item_estoque
        FOREIGN KEY (id_item_estoque)
        REFERENCES item_estoque (cod_item_estoque)
);

-- INSERT INTO lote (id_item_estoque, numero_lote, fabricante_lote, datafab_lote, dataval_lote, qtdeatual_lote, estante_lote, prateleira_lote, outras_informacoes_lote) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
-- UPDATE lote SET id_item_estoque = ?, numero_lote = ?, fabricante_lote = ?, datafab_lote = ?, dataval_lote, qtdeatual_lote = ?, estante_lote = ?, prateleira_lote = ?, outras_informacoes_lote = ? WHERE cod_lote = ?;
-- DROP TABLE lote;