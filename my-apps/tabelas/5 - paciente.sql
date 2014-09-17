CREATE TABLE paciente(
    cod_paciente                           serial                      NOT NULL,
    id_pessoa_paciente                     bigint                      NOT NULL,
    apelido_paciente                       character varying(30),
    classificacao_paciente                 character varying(30),
    religiao_paciente                      character varying(30),
    nome_mae_paciente                      character varying(60),
    nome_pai_paciente                      character varying(60),
    grupo_sanguineo_paciente               character(3),
    cartao_sus_paciente                    character varying(20),
    convenio_paciente                      character varying(45),
    pessoa_contato_paciente                character varying(60),
    tel_pessoa_contato_paciente            character varying(15),
  
    CONSTRAINT pk_paciente
        PRIMARY KEY (cod_paciente),

    CONSTRAINT fk_paciente_pessoa
        FOREIGN KEY (id_pessoa_paciente)
        REFERENCES pessoa (cod_pessoa)
)
