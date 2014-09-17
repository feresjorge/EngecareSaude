CREATE TABLE profissional(
    cod_profissional                           SERIAL                     NOT NULL,
    id_pessoa_profissional                     BIGINT                     NOT NULL,
    ctps_profissional                          CHARACTER VARYING(30),
    num_siape_profissional                     CHARACTER VARYING(6)       NOT NULL,
    area_profissional                          CHARACTER VARYING(25)      NOT NULL,
    funcao_profissional                        CHARACTER VARYING(25)      NOT NULL,
    status_profissional                        INTEGER                    DEFAULT 1,

    CONSTRAINT pk_profissional
        PRIMARY KEY (cod_profissional),

    CONSTRAINT fk_profissional_pessoa
        FOREIGN KEY (id_pessoa_profissional)
        REFERENCES pessoa (cod_pessoa)
);
