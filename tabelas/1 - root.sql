CREATE TABLE root(
    cod_usuario          serial                     NOT NULL,
    login_usuario        character varying(45)      NOT NULL,
    senha_usuario        character varying(45)      NOT NULL,
    permissao_usuario    integer                    NOT NULL,
    status_usuario       integer                    DEFAULT 1,
	
    CONSTRAINT pk_root
        PRIMARY KEY (cod_usuario)
);

-- PERMISSÃO
-- 0 - root

INSERT INTO root (cod_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario)
VALUES (0, 'engecare', md5('engecare'), 0, 1);
