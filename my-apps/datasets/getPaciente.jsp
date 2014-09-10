<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<%@ include file="getPessoa.jsp"%>

<pacientes><%!    /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        if("Indef.".equals(text)){
            return "";
        }else{
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    }
    
     String toUTF8(String text) throws Exception {
        byte p[] = text.getBytes("ISO-8859-1");
        return new String(p, 0, p.length, "UTF-8");
    }
    %> 

    <%
        String nomePaciente = request.getParameter("nomePaciente");
        String textoGridVazia = null;
        
        if(nomePaciente !=""){
            textoGridVazia = "A pesquisa por '" + nomePaciente + "' não retornou nenhum resultado";
            nomePaciente = toUTF8(nomePaciente);
        } else {
            textoGridVazia = "A pesquisa não retornou nenhum resultado";
        }
        
        textoGridVazia = toISO88591(textoGridVazia);
        
        Date data = null;
        PreparedStatement ps = null;
        Connection connection = null;
        
        String selectPaciente = "";
        if(nomePaciente == ""){
            selectPaciente = "SELECT * FROM paciente ORDER BY cod_paciente;";   
        }else{
            //Copia todos os dados de um paciente com um determinado nome
            selectPaciente = "SELECT * FROM paciente WHERE id_pessoa_paciente IN ( SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE ? ) ORDER BY cod_paciente;";   
        }
        
        try {
            connection = GetDBConnection.getConnection();
            if(nomePaciente != ""){
                PreparedStatement sttm = connection.prepareStatement(selectPaciente);
                sttm.setString(1, "'%"+nomePaciente+"%'");  
                selectPaciente = sttm.toString();
                sttm.close();
            }
            
            Statement stmt = connection.createStatement();

            ResultSet rs = stmt.executeQuery(selectPaciente);
            
            retornoPessoa pessoa = new retornoPessoa();
                       
            if (!rs.next()) {
                %><paciente text="<%=textoGridVazia%>"/><%
            } else {
                do {
                    int codPessoa = rs.getInt("id_pessoa_paciente");

                    pessoa.getPessoa(connection, codPessoa);
                    pessoa.nome = toISO88591(pessoa.nome);
                    pessoa.cor = toISO88591(pessoa.cor);
                    pessoa.sexo = toISO88591(pessoa.sexo);
                    if(pessoa.dataNascimento == null){
                        pessoa.dataNascimento = "";
                    }else{
                        pessoa.dataNascimento = toISO88591(pessoa.dataNascimento);
                    }
                    pessoa.estadoCivil = toISO88591(pessoa.estadoCivil);
                    pessoa.cpf = toISO88591(pessoa.cpf);
                    pessoa.rg = toISO88591(pessoa.rg);
                    pessoa.naturalidade = toISO88591(pessoa.naturalidade);
                    pessoa.nacionalidade = toISO88591(pessoa.nacionalidade);
                    pessoa.cep = toISO88591(pessoa.cep);
                    pessoa.estado = toISO88591(pessoa.estado);
                    pessoa.cidade = toISO88591(pessoa.cidade);
                    pessoa.bairro = toISO88591(pessoa.bairro);
                    pessoa.endereco = toISO88591(pessoa.endereco);
                    pessoa.email = toISO88591(pessoa.email);
                    pessoa.telefone = toISO88591(pessoa.telefone);
                    pessoa.celular = toISO88591(pessoa.celular);
                    pessoa.fax = toISO88591(pessoa.fax);
                    pessoa.foto = toISO88591(pessoa.foto);

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

                    if (pessoa.erro == 1) {
                        pessoa.erro = 0;
                        System.out.println("Erro na busca de pessoa");
                        break;
                    }
                    
                    int cod = rs.getInt("cod_paciente");
                    String codPaciente = null;
                    if(cod > 0 && cod < 10){
                       codPaciente = "00" + String.valueOf(cod);
                    } else if(cod >= 10 && cod < 100){
                       codPaciente = "0" + String.valueOf(cod);
                    } else {
                       codPaciente = String.valueOf(cod);
                    }

                    %><paciente   codPaciente="<%=codPaciente%>" idPessoa="<%=codPessoa%>" apelidoPaciente="<%=apelido%>" classificacaoPaciente="<%=classificacao%>" 
                      religiaoPaciente="<%=religiao%>" tipoSanguineoPaciente="<%=tipoSanguineo%>" nomePaciente="<%=pessoa.nome%>" corPaciente="<%=pessoa.cor%>" 
                      sexoPaciente="<%=pessoa.sexo%>" dataNascimentoPaciente="<%=pessoa.dataNascimento%>" estadoCivilPaciente="<%=pessoa.estadoCivil%>" 
                      cpfPaciente="<%=pessoa.cpf%>" rgPaciente="<%=pessoa.rg%>" naturalidadePaciente="<%=pessoa.naturalidade%>" nacionalidadePaciente="<%=pessoa.nacionalidade%>" 
                      nomeMaePaciente="<%=nomeMae%>" nomePaiPaciente="<%=nomePai%>" enderecoPaciente="<%=pessoa.endereco%>" 
                      bairroPaciente="<%=pessoa.bairro%>" cidadePaciente="<%=pessoa.cidade%>" estadoPaciente="<%=pessoa.estado%>" cepPaciente="<%=pessoa.cep%>"
                      emailPaciente="<%=pessoa.email%>" telefonePaciente="<%=pessoa.telefone%>" celularPaciente="<%=pessoa.celular%>" faxPaciente="<%=pessoa.fax%>"
                      numeroSusPaciente="<%=numeroSus%>" convenioPaciente="<%=convenio%>" pessoaContatoPaciente="<%=pessoaContato%>" 
                      telPessoaContatoPaciente="<%=telPessoaContato%>" text="temRegistro"/><%

                  } while (rs.next());
              }
            
              rs.close();
              stmt.close();
              connection.close();

        } catch (SQLException e) {
             String msg = "Erro ao tentar buscar paciente.\n\nSQLException em getPaciente.jsp: " + e.getMessage();
             System.out.println(msg);
             msg = toISO88591(msg);
             
             textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
             %><paciente text="<%=textoGridVazia%>" error="Erro ao tentar buscar paciente.\n\nSQLException em getPaciente.jsp"/><%
        } catch (Exception e) {
             String msg = "Erro ao tentar buscar paciente.\n\nException: " + e.getMessage();
             System.out.println(msg);
             msg = toISO88591(msg);
             
             textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
             %><paciente text="<%=textoGridVazia%>" error="Erro ao tentar buscar paciente.\n\nException em getPaciente.jsp"/><%
        }
    %>
</pacientes>