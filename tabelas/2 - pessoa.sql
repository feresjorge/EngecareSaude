CREATE TABLE pessoa(
    cod_pessoa                     SERIAL                     NOT NULL,
    nome_pessoa                    CHARACTER VARYING(60)      NOT NULL,
    etnia_pessoa                   CHARACTER VARYING(30),
    sexo_pessoa                    CHARACTER(1),
    data_nascimento_pessoa         DATE,
    estado_civil_pessoa            CHARACTER VARYING(35),
    cpf_pessoa                     CHARACTER VARYING(15),
    rg_pessoa                      CHARACTER VARYING(15),
    naturalidade_pessoa            CHARACTER VARYING(60),
    nacionalidade_pessoa           CHARACTER VARYING(60),
    cep_pessoa                     CHARACTER VARYING(10),
    estado_pessoa                  CHARACTER VARYING(35),
    cidade_pessoa                  CHARACTER VARYING(35),
    bairro_pessoa                  CHARACTER VARYING(35),
    endereco_pessoa                CHARACTER VARYING(60),
    email_pessoa                   CHARACTER VARYING(45),
    telefone_pessoa                CHARACTER VARYING(15),
    celular_pessoa                 CHARACTER VARYING(15),
    fax_pessoa                     CHARACTER VARYING(15),
    caminho_foto_pessoa            CHARACTER VARYING(60),

    CONSTRAINT pk_pessoa
        PRIMARY KEY (cod_pessoa)
);
