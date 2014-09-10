<%@page import="java.util.Date"%> 
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<%@ include file="getProfissional_Mehtodos.jsp"%>
<%@ include file="getPaciente_Mehtodos.jsp"%>

<agendamentos>
    <%
    SimpleDateFormat formataHora = new SimpleDateFormat("HH:mm");   
    
    String opcao = request.getParameter("opcao");
    String data = request.getParameter("dataAgendamento");
    String sqlAgendamento = "";
    String nomePaciente = "";
    String nomeProfissionalAgendamento = "";
    String areaProfissional = "";
    String dataAgendamento = "";
    String horaAgendamento = "";
    String horaEData = "";
    Date dataAgen = null; 
    
    String textoGridVazia = null; 
        
    if(opcao.equals("Todos")){
        sqlAgendamento = "SELECT * FROM (agendamento INNER JOIN (paciente INNER JOIN pessoa ON id_pessoa_paciente = cod_pessoa)ON id_paciente_agendamento = cod_paciente) INNER JOIN profissional ON id_profissional_agendamento = cod_profissional ORDER BY cod_agendamento ;";
        textoGridVazia = "A pesquisa não retornou nenhum resultado";
    }else if(opcao.equals("Paciente")){
        nomePaciente = request.getParameter("nomePaciente");
        nomePaciente = toUTF8(nomePaciente);
        textoGridVazia = "A pesquisa por '" + nomePaciente + "' não retornou nenhum resultado";
        sqlAgendamento = "SELECT * FROM (agendamento INNER JOIN (paciente INNER JOIN pessoa ON id_pessoa_paciente = cod_pessoa)ON id_paciente_agendamento = cod_paciente) INNER JOIN profissional ON id_profissional_agendamento = cod_profissional WHERE nome_pessoa LIKE ? ORDER BY cod_agendamento; ";
    }else if(opcao.equals("Profissional")){
        nomeProfissionalAgendamento = request.getParameter("nomeProfissional");
        nomeProfissionalAgendamento = toUTF8(nomeProfissionalAgendamento);
        textoGridVazia = "A pesquisa por '" + nomeProfissionalAgendamento + "' não retornou nenhum resultado";
        sqlAgendamento = "SELECT * FROM (agendamento INNER JOIN (profissional INNER JOIN pessoa ON id_pessoa_profissional = cod_pessoa)ON id_profissional_agendamento = cod_profissional) INNER JOIN paciente ON id_paciente_agendamento = cod_paciente WHERE nome_pessoa LIKE ? ORDER BY cod_agendamento; ";
    }else if(opcao.equals("Area")){
        areaProfissional = request.getParameter("areaProfissional");
        areaProfissional = toUTF8(areaProfissional);
        textoGridVazia = "A pesquisa por '" + areaProfissional + "' não retornou nenhum resultado";
        sqlAgendamento = "SELECT * FROM (agendamento INNER JOIN (paciente INNER JOIN pessoa ON id_pessoa_paciente = cod_pessoa)ON id_paciente_agendamento = cod_paciente) INNER JOIN profissional ON id_profissional_agendamento = cod_profissional WHERE area_profissional LIKE ? ORDER BY cod_agendamento; ";        
    }else if(opcao.equals("TodosAndData")){
        dataAgendamento = request.getParameter("dataAgendamento");
        dataAgendamento = toUTF8(dataAgendamento);
        textoGridVazia = "A pesquisa por agendamentos para a data '" + dataAgendamento + "' não retornou nenhum resultado";
        sqlAgendamento = "SELECT * FROM ((agendamento INNER JOIN (paciente INNER JOIN pessoa ON id_pessoa_paciente = cod_pessoa)ON id_paciente_agendamento = cod_paciente ) INNER JOIN profissional ON id_profissional_agendamento = cod_profissional )where data_agendamento = ? ORDER BY cod_agendamento; ";
    }else if(opcao.equals("PacienteAndData")){
        dataAgendamento = request.getParameter("dataAgendamento");
        dataAgendamento = toUTF8(dataAgendamento);
        nomePaciente = request.getParameter("nomePaciente");
        nomePaciente = toUTF8(nomePaciente);
        textoGridVazia = "A pesquisa pelo paciente '" + nomePaciente + "' para a data '" + dataAgendamento +"' não retornou nenhum resultado";
        sqlAgendamento = "SELECT * FROM ((agendamento INNER JOIN (paciente INNER JOIN pessoa ON id_pessoa_paciente = cod_pessoa)ON id_paciente_agendamento = cod_paciente) INNER JOIN profissional ON id_profissional_agendamento = cod_profissional )WHERE nome_pessoa LIKE ? AND data_agendamento = ? ORDER BY cod_agendamento; ";
    }else if(opcao.equals("ProfissionalAndData")){
        dataAgendamento = request.getParameter("dataAgendamento");
        dataAgendamento = toUTF8(dataAgendamento);
        nomeProfissionalAgendamento = request.getParameter("nomeProfissional");
        nomeProfissionalAgendamento = toUTF8(nomeProfissionalAgendamento);
        textoGridVazia = "A pesquisa pelo profissional '" + nomeProfissionalAgendamento + "' para a data '" + dataAgendamento +"' não retornou nenhum resultado";
        sqlAgendamento = "SELECT * FROM ((agendamento INNER JOIN (profissional INNER JOIN pessoa ON id_pessoa_profissional = cod_pessoa)ON id_profissional_agendamento = cod_profissional) INNER JOIN paciente ON id_paciente_agendamento = cod_paciente ) WHERE nome_pessoa LIKE ? AND data_agendamento = ? ORDER BY cod_agendamento; ";
    }else if(opcao.equals("AreaAndData")){
        dataAgendamento = request.getParameter("dataAgendamento");
        dataAgendamento = toUTF8(dataAgendamento);
        areaProfissional = request.getParameter("areaProfissional");
        areaProfissional = toUTF8(areaProfissional);
        textoGridVazia = "A pesquisa pelo area de atuação '" + nomePaciente + "' para a data '" + dataAgendamento +"' não retornou nenhum resultado";
        sqlAgendamento = "SELECT * FROM ((agendamento INNER JOIN (paciente INNER JOIN pessoa ON id_pessoa_paciente = cod_pessoa)ON id_paciente_agendamento = cod_paciente) INNER JOIN profissional ON id_profissional_agendamento = cod_profissional )WHERE area_profissional LIKE ? AND data_agendamento = ? ORDER BY cod_agendamento; ";        
    }
    
    textoGridVazia = toISO88591(textoGridVazia);
    Connection con = null;
    java.sql.Date dataSql = null;
    try {
        con = GetDBConnection.getConnection();
        if(opcao.equals("Paciente")){
            PreparedStatement pst = con.prepareStatement(sqlAgendamento);
            pst.setString(1, "'%"+nomePaciente+"%'");  
            sqlAgendamento = pst.toString();
            pst.close();
        }else if(opcao.equals("Profissional")){
            PreparedStatement pst = con.prepareStatement(sqlAgendamento);
            pst.setString(1, "'%"+nomeProfissionalAgendamento+"%'");  
            sqlAgendamento = pst.toString();
            pst.close();
        }else if(opcao.equals("Area")){
            PreparedStatement pst = con.prepareStatement(sqlAgendamento);
            pst.setString(1, "'%"+areaProfissional+"%'");  
            sqlAgendamento = pst.toString();
            pst.close();
        }else if(opcao.equals("TodosAndData")){
            PreparedStatement pst = con.prepareStatement(sqlAgendamento);
            dataAgen = formatador.parse(dataAgendamento); 
            dataSql = new java.sql.Date(dataAgen.getTime());
            pst.setString(1, "'"+dataSql.toString() +"'"); 
            sqlAgendamento = pst.toString();
            pst.close();
        }else if(opcao.equals("PacienteAndData")){
            PreparedStatement pst = con.prepareStatement(sqlAgendamento);
            pst.setString(1, "'%"+nomePaciente+"%'"); 
            dataAgen = formatador.parse(dataAgendamento); 
            dataSql = new java.sql.Date(dataAgen.getTime());
            pst.setString(2, "'"+dataSql.toString() +"'");             
            sqlAgendamento = pst.toString();
            pst.close();
        }else if(opcao.equals("ProfissionalAndData")){
            PreparedStatement pst = con.prepareStatement(sqlAgendamento);
            pst.setString(1, "'%"+nomeProfissionalAgendamento+"%'"); 
            dataAgen = formatador.parse(dataAgendamento); 
            dataSql = new java.sql.Date(dataAgen.getTime());
            pst.setString(2, "'"+dataSql.toString() +"'"); 
            sqlAgendamento = pst.toString();
            pst.close();
        }else if(opcao.equals("AreaAndData")){
            PreparedStatement pst = con.prepareStatement(sqlAgendamento);
            pst.setString(1, "'%"+areaProfissional+"%'");  
            dataAgen = formatador.parse(dataAgendamento); 
            dataSql = new java.sql.Date(dataAgen.getTime());
            pst.setString(2, "'"+dataSql.toString() +"'"); 
            sqlAgendamento = pst.toString();
            pst.close();
        }
        
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(sqlAgendamento);
        retornoPessoa paciente = new retornoPessoa();
        retornoPessoa profissional = new retornoPessoa();               

        if (!rs.next()) {
            %><agendamento img_status="null" text="<%=textoGridVazia%>"/><%
        } else {
            do {
                //Dados de Agendamento
                dataAgen = rs.getDate("data_agendamento");
                if (dataAgen == null){
                    dataAgendamento = "";
                }else{
                    dataAgendamento = formatador.format(dataAgen);
                }

                Time hora = rs.getTime("hora_agendamento"); 
                if (hora == null){
                    horaAgendamento = "";
                }else{
                    horaAgendamento = formataHora.format(hora);
                }
                
                horaEData = dataAgendamento + "\n" + horaAgendamento;

                String observacao = rs.getString("observacao_agendamento");
                observacao = toISO88591(observacao);
                String statusAgendamento = null;
                String img_statusAgendamento = null;
                if(rs.getInt("status_agendamento") == 0){
                    statusAgendamento = "a_agendado";
                    img_statusAgendamento = "agendado.png";
                } else if (rs.getInt("status_agendamento") == 1){
                    statusAgendamento = "b_remarcado";
                    img_statusAgendamento = "remarcado.png";
                } else if (rs.getInt("status_agendamento") == 2){
                    statusAgendamento = "c_pendente";
                    img_statusAgendamento = "pendente.png";
                } else if (rs.getInt("status_agendamento") == 3){
                    statusAgendamento = "d_cancelado";
                    img_statusAgendamento = "cancelado.png";
                } else{
                    statusAgendamento = "e_finalizado";
                    img_statusAgendamento = "sucesso_ico.png";
                }
                statusAgendamento = toISO88591(statusAgendamento);
                img_statusAgendamento = toISO88591(img_statusAgendamento);

                //Dados de Paciente
                if(opcao.equals("Profissional") || opcao.equals("ProfissionalAndData") ){
                    int codPaciente = rs.getInt("id_paciente_agendamento");
                    int codPessoaPaciente = buscaDadoPaciente (con, "id_pessoa_Paciente",codPaciente);
                    paciente.getPessoa(con, codPessoaPaciente);
                }else{
                    int codPessoaPaciente = rs.getInt("id_pessoa_paciente");
                    paciente.getPessoa(con, codPessoaPaciente);
                }

                if (paciente.erro == 1) {
                        paciente.erro = 0;
                        System.out.println("Erro na busca de pessoa");
                        break;
                }else{
                    paciente.nome = toISO88591(paciente.nome);
                    paciente.cor = toISO88591(paciente.cor);
                    paciente.sexo = toISO88591(paciente.sexo);
                    if(paciente.dataNascimento == null){
                        paciente.dataNascimento = "";
                    }else{
                        paciente.dataNascimento = toISO88591(paciente.dataNascimento);
                    }
                    paciente.estadoCivil = toISO88591(paciente.estadoCivil);
                    paciente.cpf = toISO88591(paciente.cpf);
                    paciente.rg = toISO88591(paciente.rg);
                    paciente.naturalidade = toISO88591(paciente.naturalidade);
                    paciente.nacionalidade = toISO88591(paciente.nacionalidade);
                    paciente.cep = toISO88591(paciente.cep);
                    paciente.estado = toISO88591(paciente.estado);
                    paciente.cidade = toISO88591(paciente.cidade);
                    paciente.bairro = toISO88591(paciente.bairro);
                    paciente.endereco = toISO88591(paciente.endereco);
                    paciente.email = toISO88591(paciente.email);
                    paciente.telefone = toISO88591(paciente.telefone);
                    paciente.celular = toISO88591(paciente.celular);
                    paciente.fax = toISO88591(paciente.fax);
                    paciente.foto = toISO88591(paciente.foto);
                    String apelido = rs.getString("apelido_paciente");
                    apelido = toISO88591(apelido);
                    String classificacao = rs.getString("classificacao_paciente");
                    classificacao = toISO88591(classificacao);
                    String religiao = rs.getString("religiao_paciente");
                    religiao = toISO88591(religiao);
                    String nomeMae = rs.getString("nome_mae_paciente");
                    nomeMae = toISO88591(nomeMae);
                    String nomePai = rs.getString("nome_pai_paciente");
                    nomePai = toISO88591(nomePai);
                    String tipoSanguineo = rs.getString("grupo_sanguineo_paciente");
                    tipoSanguineo = toISO88591(tipoSanguineo);
                    String numeroSus = rs.getString ("cartao_sus_paciente");
                    numeroSus = toISO88591(numeroSus);
                    String convenio = rs.getString("convenio_paciente");
                    convenio = toISO88591(convenio);
                    String pessoaContato = rs.getString("pessoa_contato_paciente");
                    pessoaContato = toISO88591(pessoaContato);
                    String telPessoaContato = rs.getString("tel_pessoa_contato_paciente");
                    telPessoaContato = toISO88591(telPessoaContato);

                    //Dados de Profissional
                    if(opcao.equals("Profissional") || opcao.equals("ProfissionalAndData") ){
                        int codPessoaProfissional = rs.getInt("id_pessoa_profissional");
                        profissional.getPessoa(con, codPessoaProfissional);
                    }else{
                        int codProfissional = rs.getInt("id_profissional_agendamento");
                        int codPessoaProfissional = buscaDadoProfissional (con, "id_pessoa_Profissional",codProfissional);
                        profissional.getPessoa(con, codPessoaProfissional);
                    }
                    if (profissional.erro == 1) {
                            profissional.erro = 0;
                            break;
                    }else{
                        profissional.nome = toISO88591(profissional.nome);
                        profissional.cor = toISO88591(profissional.cor);
                        profissional.sexo = toISO88591(profissional.sexo);
                        if(profissional.dataNascimento == null){
                            profissional.dataNascimento = "";
                        }else{
                            profissional.dataNascimento = toISO88591(profissional.dataNascimento);
                        }
                        profissional.estadoCivil = toISO88591(profissional.estadoCivil);
                        profissional.cpf = toISO88591(profissional.cpf);
                        profissional.rg = toISO88591(profissional.rg);
                        profissional.naturalidade = toISO88591(profissional.naturalidade);
                        profissional.nacionalidade = toISO88591(profissional.nacionalidade);
                        profissional.cep = toISO88591(profissional.cep);
                        profissional.estado = toISO88591(profissional.estado);
                        profissional.cidade = toISO88591(profissional.cidade);
                        profissional.bairro = toISO88591(profissional.bairro);
                        profissional.endereco = toISO88591(profissional.endereco);
                        profissional.email = toISO88591(profissional.email);
                        profissional.telefone = toISO88591(profissional.telefone);
                        profissional.celular = toISO88591(profissional.celular);
                        profissional.fax = toISO88591(profissional.fax);
                        profissional.foto = toISO88591(profissional.foto);
                        String ctps = rs.getString("ctps_profissional");
                        ctps = toISO88591(ctps);
                        String numSiape = rs.getString("num_siape_profissional");
                        numSiape = toISO88591(numSiape);
                        String area = rs.getString ("area_profissional");
                        area = toISO88591(area);
                        String funcao = rs.getString("funcao_profissional");
                        funcao = toISO88591(funcao);
                        String statusProfissional = null;
                        String img_statusProfissional = null;
                        if(rs.getInt("status_profissional") == 0){
                            statusProfissional = "inativo";
                            img_statusProfissional = "status_ocupado_img.png";
                        } else if (rs.getInt("status_profissional") == 1){
                            statusProfissional = "ativo";
                            img_statusProfissional = "status_livre_img.png";
                        }
                        statusProfissional = toISO88591(statusProfissional);
                        img_statusProfissional = toISO88591(img_statusProfissional);
                        
                        int cod = rs.getInt("cod_agendamento");
                        String codAgendamento = null;
                        if(cod > 0 && cod < 10){
                           codAgendamento = "00" + String.valueOf(cod);
                        } else if(cod >= 10 && cod < 100){
                           codAgendamento = "0" + String.valueOf(cod);
                        } else {
                           codAgendamento = String.valueOf(cod);
                        }

                        %><agendamento codAgendamento="<%=codAgendamento%>" idProfissionalAgendamento="<%=rs.getInt("id_profissional_agendamento")%>" 
                              idPacienteAgendamento="<%=rs.getInt("id_paciente_agendamento")%>" idPessoaProfissional="<%=profissional.codigoPessoa%>"  dataAgendamento="<%=dataAgendamento%>" horaAgendamento="<%=horaAgendamento%>"
                              dataEHoraAgendamento ="<%=horaEData%>" observacaoAgendamento="<%=observacao%>" statusAgendamento="<%=statusAgendamento%>" img_statusAgendamento="<%=img_statusAgendamento%>" 
                              ctpsProfissional="<%=ctps%>" numSiapeProfissional="<%=numSiape%>" nomeProfissional="<%=profissional.nome%>" idPessoaPaciente="<%=paciente.codigoPessoa%>"  
                              corProfissional="<%=profissional.cor%>" sexoProfissional="<%=profissional.sexo%>" dataNascimentoProfissional="<%=profissional.dataNascimento%>"
                              estadoCivilProfissional="<%=profissional.estadoCivil%>" cpfProfissional="<%=profissional.cpf%>" rgProfissional="<%=profissional.rg%>" 
                              naturalidadeProfissional="<%=profissional.naturalidade%>" nacionalidadeProfissional="<%=profissional.nacionalidade%>" 
                              enderecoProfissional="<%=profissional.endereco%>" bairroProfissional="<%=profissional.bairro%>" cidadeProfissional="<%=profissional.cidade%>" 
                              estadoProfissional="<%=profissional.estado%>" cepProfissional="<%=profissional.cep%>" emailProfissional="<%=profissional.email%>" 
                              telefoneProfissional="<%=profissional.telefone%>" celularProfissional="<%=profissional.celular%>" faxProfissional="<%=profissional.fax%>" 
                              areaProfissional="<%=area%>" funcaoProfissional="<%=funcao%>" img_statusProfissional="<%=img_statusProfissional%>"
                              statusProfissional="<%=statusProfissional%>" apelidoPaciente="<%=apelido%>" classificacaoPaciente="<%=classificacao%>" 
                              religiaoPaciente="<%=religiao%>" tipoSanguineoPaciente="<%=tipoSanguineo%>" nomePaciente="<%=paciente.nome%>" corPaciente="<%=paciente.cor%>" 
                              sexoPaciente="<%=paciente.sexo%>" dataNascimentoPaciente="<%=paciente.dataNascimento%>" estadoCivilPaciente="<%=paciente.estadoCivil%>" 
                              cpfPaciente="<%=paciente.cpf%>" rgPaciente="<%=paciente.rg%>" naturalidadePaciente="<%=paciente.naturalidade%>" 
                              nacionalidadePaciente="<%=paciente.nacionalidade%>" nomeMaePaciente="<%=nomeMae%>" nomePaiPaciente="<%=nomePai%>" enderecoPaciente="<%=paciente.endereco%>" 
                              bairroPaciente="<%=paciente.bairro%>" cidadePaciente="<%=paciente.cidade%>" estadoPaciente="<%=paciente.estado%>" cepPaciente="<%=paciente.cep%>"
                              emailPaciente="<%=paciente.email%>" telefonePaciente="<%=paciente.telefone%>" celularPaciente="<%=paciente.celular%>" faxPaciente="<%=paciente.fax%>"
                              numeroSusPaciente="<%=numeroSus%>" convenioPaciente="<%=convenio%>" pessoaContatoPaciente="<%=pessoaContato%>" 
                              telPessoaContatoPaciente="<%=telPessoaContato%>" valorStatusAgendamento="<%=rs.getInt("status_agendamento")%>" text="temRegistro"/><%
                    } 
                } 
            }while (rs.next());
        }   
        con.close();
    } catch (SQLException e) {
        String msg = "Ocorreu um erro ao tentar buscar agendamento.\n\nSQLException em getAgendamento.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        
        textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
        %><agendamento img_status="null" text="<%=textoGridVazia%>" error="Erro ao tentar buscar agendamento.\n\nSQLException em getAgendamento.jsp"/><%
    } catch (Exception e) {
        String msg = "Ocorreu um erro ao tentar buscar agendamento\n\nException em getAgendamento.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        
        textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
        %><agendamento img_status="null" text="<%=textoGridVazia%>" error="Erro ao tentar buscar agendamento.\n\nException em getAgendamento.jsp"/><%
    }       
    %>
</agendamentos>