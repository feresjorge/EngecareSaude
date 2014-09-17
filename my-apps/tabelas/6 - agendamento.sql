CREATE TABLE agendamento(
    cod_agendamento                        serial                     NOT NULL,
    id_profissional_agendamento            bigint                     NOT NULL,
    id_paciente_agendamento                bigint                     NOT NULL,
    data_agendamento                       date                       NOT NULL,
    hora_agendamento                       time without time zone     NOT NULL,
    observacao_agendamento                 character varying(100)     NOT NULL,
    status_agendamento                     integer                    NOT NULL DEFAULT 0,

    CONSTRAINT pk_agendamento
        PRIMARY KEY (cod_agendamento),

    CONSTRAINT fk_agendamento_profissional 
        FOREIGN KEY (id_profissional_agendamento)
        REFERENCES profissional (cod_profissional),
    
    CONSTRAINT fk_agendamento_paciente
        FOREIGN KEY (id_paciente_agendamento)
        REFERENCES paciente (cod_paciente)
);
