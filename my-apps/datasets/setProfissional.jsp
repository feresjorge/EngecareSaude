<%@page import="BD.GetDBConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="java.util.Date"%>

<%@ include file="setPessoa.jsp"%>

<profissional><%!    
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
    //SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
    
    %><%
    
    String opcao = request.getParameter("acao");
    System.out.println("Opção " + opcao);
    
    //dados necessários para persistir um PROFISSIONAL
    String codProfissional = request.getParameter("codProfissional");
    System.out.println("cod Profissional " + codProfissional);
    String codPessoa = request.getParameter("codPessoa");
    System.out.println("codPessa  " + codPessoa);
    String ctps = request.getParameter("ctps");
    System.out.println("ctps " + ctps);
    String numSiape = request.getParameter("numeroSiape");
    System.out.println("siape " + numSiape);
    String area = request.getParameter("area");
    System.out.println("area " + area);
    String funcao = request.getParameter("funcao");
    System.out.println("funcao " + funcao);
    String status = request.getParameter("status");
    System.out.println("funcao " + funcao);
    
    //dados necessários para persistir uma PESSOA
    String nome = request.getParameter("nome");
    System.out.println("nome " + nome);
    String etnia = request.getParameter("etnia");
    System.out.println("etnia " + etnia);
    String sexo= request.getParameter("sexo");
    System.out.println("sexo " + sexo);
    String dataNascimento= request.getParameter("dataNascimento");
    System.out.println("datanasc " + dataNascimento);
    String estadoCivil = request.getParameter("estadoCivil");
    System.out.println("estadoCivil " + estadoCivil);
    String cpf = request.getParameter("cpf");
    System.out.println("cpf " + cpf);
    String rg = request.getParameter("rg");
    System.out.println("rg " + rg);
    String naturalidade = request.getParameter("naturalidade");
    System.out.println("naturalidade " + naturalidade);
    String nacionalidade = request.getParameter("nacionalidade");
    System.out.println("nacionalidade " + nacionalidade);
    String cep = request.getParameter("cep");
    System.out.println("cep " + cep);
    String estado = request.getParameter("estado");
    System.out.println("estado " + estado);
    String cidade = request.getParameter("cidade");
    System.out.println("cidade " + cidade);
    String bairro = request.getParameter("bairro");
    System.out.println("bairro " + bairro);
    String endereco = request.getParameter("endereco");
    System.out.println("endereco " + endereco  );
    String email = request.getParameter("email");
    System.out.println("email " + email);
    String telefone = request.getParameter("telefone");
    System.out.println("telefone " + telefone);
    String celular = request.getParameter("celular");
    System.out.println("celular " + celular);
    String fax = request.getParameter("fax");
    System.out.println("fax " + fax);
    
    String caminhoFoto = request.getParameter("caminhoFoto");
    System.out.println("foto " + caminhoFoto);
    
    String sqlProfissional = "";
    
    nome = toUTF8(nome);
    etnia= toUTF8(etnia);
    sexo = toUTF8(sexo);
    estadoCivil= toUTF8(estadoCivil);
    cpf = toUTF8(cpf);
    rg = toUTF8(rg);
    naturalidade = toUTF8(naturalidade);
    nacionalidade = toUTF8(nacionalidade);
    dataNascimento = toUTF8(dataNascimento);
    cep= toUTF8(cep);
    estado= toUTF8(estado);
    cidade= toUTF8(cidade);
    bairro= toUTF8(bairro);
    endereco= toUTF8(endereco);
    email= toUTF8(email);
    telefone= toUTF8(telefone);
    celular= toUTF8(celular);
    fax= toUTF8(fax);
    ctps = toUTF8(ctps);
    numSiape = toUTF8(numSiape);
    area = toUTF8(area);
    funcao = toUTF8(funcao);
    caminhoFoto = toUTF8(caminhoFoto);

    if (opcao.equals("insert")) {
        sqlProfissional = "INSERT INTO profissional (id_pessoa_profissional, ctps_profissional, num_siape_profissional, area_profissional, funcao_profissional, status_profissional) values (?, ?, ?, ?, ?, ?) ";
        System.out.println("sqlProfissional " + sqlProfissional);
    }

    if(opcao.equals("update")){
        sqlProfissional = "UPDATE profissional SET id_pessoa_profissional = ?, ctps_profissional = ?, num_siape_profissional = ?, area_profissional = ?, funcao_profissional = ?, status_profissional = ? WHERE cod_profissional = ? ";
        System.out.println("sqlProfissional " + sqlProfissional);
    }

    Connection connection = null;
    System.out.println("Antes do try profissional\n");
    try {
        connection = GetDBConnection.getConnection();
        PreparedStatement stmt = null;
        System.out.println("depois do prepare statement");
        if (opcao.equals("insert")) {
            // Procura proximo id de pessoa para insercao
            int resultProximoPessoa = proximoValorPessoaPInsercao(connection);
            if (resultProximoPessoa != 0) {//encontrou um numero valido
                //Insere em pessoa
                int resultInserePessoa = insereEAtualizaPessoa(connection, resultProximoPessoa, nome, etnia, sexo, dataNascimento, estadoCivil, cpf, rg, naturalidade, nacionalidade, cep, estado, cidade, bairro, endereco, email, telefone, celular, fax, caminhoFoto, opcao);
                if (resultInserePessoa == 1) {// Se tudo certo em inserção de pessoa ...
                    stmt = connection.prepareStatement(sqlProfissional);
                    
                    
                    stmt.setInt(1, resultProximoPessoa); 
                    stmt.setString(2, ctps);                                                                               
                    stmt.setString(3, numSiape);
                    stmt.setString(4, area);
                    stmt.setString(5, funcao);
                    stmt.setInt(6, Integer.parseInt(status));
                    
                    System.out.println("Cheguei no insert profissional do jsp");
                    stmt.executeUpdate();
                    %><result>Inserido</result><%
                    System.out.println("Tudo ok na insercao de profissional\n\n");
                }else{
                    System.out.println(" Entrada na mensagem Erro de Inserção de pessoa no else jsp");
                    %><result>erroPessoa</result><%
                }
            }else {
                System.out.println(" Entrada na mensagem Erro de busca do proximo profissional no else jsp");
                %><result>erroProfissional</result><%
            }
        }else if (opcao.equals("update")) {
            System.out.println("dentro de update no jsp\n");
                int codigoPessoa = Integer.parseInt(codPessoa);
                int resultAtualizaPessoa = insereEAtualizaPessoa(connection, codigoPessoa, nome, etnia, sexo, dataNascimento, estadoCivil, cpf, rg, naturalidade, nacionalidade, cep, estado, cidade, bairro, endereco, email, telefone, celular, fax, caminhoFoto, opcao);
                if (resultAtualizaPessoa == 1) {
                    stmt = connection.prepareStatement(sqlProfissional);
                    
                    stmt.setInt(1, codigoPessoa);
                    stmt.setString(2, ctps);
                    stmt.setString(3, numSiape);
                    stmt.setString(4, area);
                    stmt.setString(5, funcao);
                    stmt.setInt(6, Integer.parseInt(status));
                    stmt.setInt(7, Integer.parseInt(codProfissional));
                    System.out.println("Cheguei no update profissional do jsp");
                    stmt.executeUpdate();
                    %><result>Atualizado</result><%
                    System.out.println("Tudo ok na atualização de profissional");
                }else{
                    System.out.println(" Entrada na mensagem Erro de atualização de pessoa no else jsp");
                    %><result>erroPessoa</result><%
                }
        }
        
        stmt.close();
        connection.close();
        
    } catch (SQLException e) {
        String msg = "Erro ao tentar persistir dados de profissional.\n\nSQLException em setProfissional.jsp: " + e.getMessage();
        msg = toISO88591(msg);
        %><result><%=msg%></result><%
                
    } catch (Exception e) {
        String msg = "Erro ao tentar persistir dados de profissional.\n\nException em setProfissional.jsp: " + e.getMessage();
        msg = toISO88591(msg);
        %><result><%=msg%></result><%
    }%>
</profissional>