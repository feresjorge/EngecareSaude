<%@page import="BD.GetDBConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="java.util.Date"%>

<%@ include file="setPessoa.jsp"%>

<paciente><%!    

    /* Conversão de tipos para tratar caracteres com acento  Openlaszlo  Postgres */
    String toUTF8(String text) throws Exception {
        if (("".equals(text)) || (text == null)){
            return "Indef.";
        }else{
            byte p[] = text.getBytes("ISO-8859-1");
            return new String(p, 0, p.length, "UTF-8");
        }   
    }

    /* Conversão de tipos para tratar caracteres com acento  Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        byte p[] = text.getBytes("UTF-8");
        return new String(p, 0, p.length, "ISO-8859-1");
    }
    
    %><%
    String opcao = request.getParameter("acao");
    System.out.println("Opção " + opcao);
    String codPaciente = request.getParameter("codPaciente");
    System.out.println("cod Paciente " + codPaciente);
    String classificacao= request.getParameter("classificacao");
    System.out.println("classificacao " + classificacao);
    String tipoSanguineo = request.getParameter("tipoSanguineo");
    System.out.println("tipo Sanguineo" + tipoSanguineo);
    String numeroSus = request.getParameter("numeroSus");
    System.out.println("numeroSus" + numeroSus);
    String convenio= request.getParameter("convenio");
    System.out.println("convenio" + convenio);
    String pessoaContato= request.getParameter("pessoaContato");
    System.out.println("pessoaContato" + pessoaContato);
    String telPessoaContato= request.getParameter("telPessoaContato");
    System.out.println("telPessoaContato" + telPessoaContato);
    String codPessoa = request.getParameter("codPessoa");
    System.out.println("codPessa  " + codPessoa);
    String cpf = request.getParameter("cpf");
    System.out.println("cpf " + cpf);
    String rg = request.getParameter("rg");
    System.out.println("rg " + rg);
    String nome = request.getParameter("nome");
    System.out.println("nome " + nome);
    String apelido = request.getParameter("apelido");
    System.out.println("apelido" + apelido);
    String sexo= request.getParameter("sexo");
    System.out.println("sexo " + sexo);
    String naturalidade = request.getParameter("naturalidade");
    String nacionalidade = request.getParameter("nacionalidade");
    System.out.println("nacionalidade " + nacionalidade);
    String dataNascimento= request.getParameter("dataNascimento");
    System.out.println("datanasc " + dataNascimento);
    String etnia = request.getParameter("cor");
    System.out.println("etnia " + etnia);
    String estadoCivil = request.getParameter("estadoCivil");
    System.out.println("estadpCivil " + estadoCivil);
    String nomeMae = request.getParameter("nomeMae");
    System.out.println("mae " + nomeMae);
    String nomePai = request.getParameter("nomePai");
    System.out.println("pai " + nomePai);
    String religiao = request.getParameter("religiao");
    System.out.println("religiao " + religiao);
    String cep = request.getParameter("cep");
    System.out.println("cep " + cep);
    String endereco = request.getParameter("endereco");
    System.out.println("endereco " + endereco  );
    String bairro = request.getParameter("bairro");
    System.out.println("bairro " + bairro);
    String cidade = request.getParameter("cidade");
    System.out.println("cidade " + cidade);
    String estado = request.getParameter("estado");
    System.out.println("estado " + estado);
    String telefone = request.getParameter("telefone");
    System.out.println("telefone " + telefone);
    String celular = request.getParameter("celular");
    System.out.println("celular " + celular);
    String fax = request.getParameter("fax");
    System.out.println("fax " + fax);
    String email = request.getParameter("email");
    System.out.println("email " + email);
    String caminhoFoto = request.getParameter("caminhoFoto");
    System.out.println("foto " + caminhoFoto);
    
    String sqlPaciente = "";
    
    nome = toUTF8(nome);
    apelido = toUTF8(apelido);
    etnia= toUTF8(etnia);
    sexo = toUTF8(sexo);
    estadoCivil= toUTF8(estadoCivil);
    religiao= toUTF8(religiao);
    cpf = toUTF8(cpf);
    rg = toUTF8(rg);
    naturalidade = toUTF8(naturalidade);
    nacionalidade = toUTF8(nacionalidade);
    dataNascimento = toUTF8(dataNascimento);
    nomeMae= toUTF8(nomeMae);
    nomePai= toUTF8(nomePai);
    cep= toUTF8(cep);
    estado= toUTF8(estado);
    cidade= toUTF8(cidade);
    bairro= toUTF8(bairro);
    endereco= toUTF8(endereco);
    email= toUTF8(email);
    telefone= toUTF8(telefone);
    celular= toUTF8(celular);
    fax= toUTF8(fax);
    classificacao = toUTF8(classificacao);
    tipoSanguineo = toUTF8(tipoSanguineo);
    numeroSus = toUTF8(numeroSus);
    convenio = toUTF8(convenio);
    pessoaContato = toUTF8(pessoaContato);
    telPessoaContato = toUTF8(telPessoaContato);
    caminhoFoto = toUTF8(caminhoFoto);
        
    if (opcao.equals("insert")) {
        sqlPaciente = "INSERT INTO paciente (id_pessoa_paciente, apelido_paciente, classificacao_paciente, religiao_paciente, nome_mae_paciente, nome_pai_paciente, grupo_sanguineo_paciente, cartao_sus_paciente, convenio_paciente, pessoa_contato_paciente, tel_pessoa_contato_paciente " + ") values (?,?,?,?,?,?,?,?,?,?,?) ";
        System.out.println("sqlPaciente " + sqlPaciente);
    }

    if(opcao.equals("update")){
        sqlPaciente= "UPDATE paciente SET id_pessoa_paciente = ?, apelido_paciente = ?, classificacao_paciente = ?, religiao_paciente = ?, nome_mae_paciente = ?, nome_pai_paciente = ?, grupo_sanguineo_paciente = ?, cartao_sus_paciente = ?, convenio_paciente = ?, pessoa_contato_paciente = ?, tel_pessoa_contato_paciente = ? WHERE cod_paciente = ? ";
        System.out.println("sqlPaciente " + sqlPaciente);
    }
    
    Connection connection = GetDBConnection.getConnection();
    connection.setAutoCommit(false);
    try {
        PreparedStatement stmt = null;
        System.out.println("depois do prepare statement");
        if (opcao.equals("insert")) {
            // Procura proximo id de pessoa para insercao
            int resultProximoPessoa = proximoValorPessoaPInsercao(connection);
            if (resultProximoPessoa != 0) {//encontrou um numero valido
                //Insere em pessoa
                System.out.println("Data de Nascimento antes de passar para funcao " + dataNascimento);
                int resultInserePessoa = insereEAtualizaPessoa(connection, resultProximoPessoa, nome, etnia, sexo, dataNascimento, estadoCivil, cpf, rg, naturalidade, nacionalidade, cep, estado, cidade, bairro, endereco, email, telefone, celular, fax, caminhoFoto, opcao);
                if (resultInserePessoa == 1) {// Se tudo certo em inserção de pessoa ...
                    stmt = connection.prepareStatement(sqlPaciente);
                    
                    stmt.setInt(1, resultProximoPessoa);
                    stmt.setString(2, apelido);
                    stmt.setString(3, classificacao);
                    stmt.setString(4, religiao);
                    stmt.setString(5, nomeMae);
                    stmt.setString(6, nomePai);
                    stmt.setString(7, tipoSanguineo);
                    stmt.setString(8, numeroSus);
                    stmt.setString(9, convenio);
                    stmt.setString(10, pessoaContato);
                    stmt.setString(11, telPessoaContato);
                    
                    System.out.println("Cheguei no insert paciente do jsp");
                    stmt.executeUpdate();
                    connection.commit();
                    %><result>Inserido</result><%
                    System.out.println("Tudo ok na insercao de paciente\n\n");
                }else{
                    connection.rollback(); 
                    System.out.println(" Entrada na mensagem Erro de Inserção de pessoa no else jsp");
                    %><result>erroPessoa</result><%
                }
            }else {
                connection.rollback();
                System.out.println(" Entrada na mensagem Erro de busca do proximo paciente no else jsp");
                %><result>erroPaciente</result><%
            }
        }else if (opcao.equals("update")) {
            System.out.println("dentro de update no jsp\n");
                int codigoPessoa = Integer.parseInt(codPessoa);
                int resultAtualizaPessoa = insereEAtualizaPessoa(connection, codigoPessoa, nome, etnia, sexo, dataNascimento, estadoCivil, cpf, rg, naturalidade, nacionalidade, cep, estado, cidade, bairro, endereco, email, telefone, celular, fax, caminhoFoto, opcao);
                if (resultAtualizaPessoa == 1) {
                    stmt = connection.prepareStatement(sqlPaciente);

                    stmt.setInt(1, codigoPessoa);
                    stmt.setString(2, apelido);
                    stmt.setString(3, classificacao);
                    stmt.setString(4, religiao);
                    stmt.setString(5, nomeMae);
                    stmt.setString(6, nomePai);
                    stmt.setString(7, tipoSanguineo);
                    stmt.setString(8, numeroSus);
                    stmt.setString(9, convenio);
                    stmt.setString(10, pessoaContato);
                    stmt.setString(11, telPessoaContato);
                    stmt.setInt(12, Integer.parseInt(codPaciente));
                    System.out.println(" cheguei aqui "  );
                    stmt.executeUpdate();
                    connection.commit();
                    System.out.println("Tudo ok na atualização de paciente ");
                    %><result>Atualizado</result><%
                    
                }else{
                    connection.rollback();
                    System.out.println(" Entrada na mensagem Erro de atualização de pessoa no else jsp");
                    %><result>erroPessoa</result><%
                }
        }
        stmt.close();
        connection.close();
    }catch (SQLException e) {
        connection.rollback();
        String msg = "Erro ao tentar persistir dados de paciente.\n\nSQLException em setPaciente.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        %><result><%=msg%></result><%
                
    } catch (Exception e) {
        connection.rollback();
        String msg = "Erro ao tentar persistir dados de paciente.\n\nException em setPaciente.jsp: " + e.getMessage();
        msg = toISO88591(msg);
        System.out.println(msg);
        %><result><%=msg%></result><%
    }%>    
</paciente>