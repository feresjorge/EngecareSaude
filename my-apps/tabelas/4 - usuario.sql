CREATE TABLE usuario(
    cod_usuario                  serial                     NOT NULL,
    id_profissional_usuario      integer                    NOT NULL,
    login_usuario                character varying(45)      NOT NULL,
    senha_usuario                character varying(45)      NOT NULL,
    permissao_usuario            integer                    NOT NULL,
    status_usuario               integer                    DEFAULT 1,
	
    CONSTRAINT pk_usuario
        PRIMARY KEY (cod_usuario),

    CONSTRAINT fk_usuario_profissional
        FOREIGN KEY (id_profissional_usuario)
        REFERENCES profissional (cod_profissional)
);

-- PERMISSÕES
-- 1 - Administrador
-- 2 - Almoxarife Administrador
-- 3 - Almoxarife Usuário
-- 4 - Recepcionista



