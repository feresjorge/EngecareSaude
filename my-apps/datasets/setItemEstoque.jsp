<%@page import="BD.GetDBConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>

<itemEstoque><%!
    /* Conversão de tipos para tratar caracteres especiais: Tela -->  Banco */
    String toUTF8(String text) throws Exception {
        if (("".equals(text)) || (text == null)) {
            return "...";
        } else {
            byte p[] = text.getBytes("ISO-8859-1");
            return new String(p, 0, p.length, "UTF-8");
        }
    }

    /* Conversão de tipos para tratar caracteres especiais: Banco -> Tela */
    String toISO88591(String text) throws Exception {
        byte p[] = text.getBytes("UTF-8");
        return new String(p, 0, p.length, "ISO-8859-1");
    }
    
    /* Este método conta quantos itens de estoque possuem o mesmo nome no banco de dados. Retorna SIM se já existe pelo menos um e NAO se o item não for 
    encontrado */
    String itemJaExiste(String nomeItemEstoque){        
        PreparedStatement ps = null;
        Connection connection = null;
        int contagem = 0;
        
        try {
            connection = GetDBConnection.getConnection();
            ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM item_estoque WHERE nome_item_estoque = '"+ nomeItemEstoque +"';");
            
            ResultSet rs = ps.executeQuery();
            rs.next();
            
            contagem = rs.getInt(1);      
            
            rs.close();
            ps.close();
            connection.close();
            
            return contagem == 0 ? "NAO" : "SIM"; //if (contagem == 0) return "NAO"; else return "SIM";
        } catch (SQLException e) {
            String msg = "Erro ao tentar verificar se o item de estoque já existe.\n\nSQLException em setItemEstoque.jsp: " + e.getMessage();
            return msg;
        }  catch (Exception e) {
            String msg = "Erro ao tentar verificar se o item de estoque já existe.\n\nException em setItemEstoque.jsp: " + e.getMessage();
            return msg;
        }
    }

    /* Este método busca o próximo código de item de estoque disponível no banco e o retorna */
    int getProximoCodItemEstoque(Connection connection) {
        String sql = "SELECT NEXTVAL ('item_estoque_cod_item_estoque_seq')";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            rs.next();

            int proximoCodItemEstoque = rs.getInt(1);
            rs.close();
            
            return proximoCodItemEstoque;
        } catch (SQLException e) {
            String msg = "SQLException na função getProximoCodItemEstoque em setItemEstoque.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        } catch (Exception e) {
            String msg = "Ocorreu um erro ao verificar o próximo código livre para item de estoque: " + e.getMessage();
            System.out.println(msg);
            return 0;
        }
    }
    
    /* Método chamado para inserir um novo item de estoque ou atualizar um já existente. O tipo de modificação no banco depende da String acao ("insert" ou "update") */
    String insereOuAtualizaItemEstoque(Connection connection, int codItemEstoque, String nomeItemEstoque, String codSilapItemEstoque, String qtdeMinimaItemEstoque, 
            String tipoItemEstoque, String unidadeMedidaItemEstoque, String outrasInformacoesItemEstoque, String acao) {
        String sqlItemEstoque = "";

        if (acao.equals("insert")) {
            sqlItemEstoque = "INSERT INTO item_estoque (nome_item_estoque, cod_silap_item_estoque, qtde_minima_item_estoque, tipo_item_estoque, unidade_medida_item_estoque, outras_informacoes_item_estoque, cod_item_estoque) VALUES (?, ?, ?, ?, ?, ?, ?);";
        } else if (acao.equals("update")) {
            sqlItemEstoque = "UPDATE item_estoque SET nome_item_estoque = ?, cod_silap_item_estoque = ?, qtde_minima_item_estoque = ?, tipo_item_estoque = ?, unidade_medida_item_estoque = ?, outras_informacoes_item_estoque = ? WHERE cod_item_estoque = ?;";
        }

        try {
            PreparedStatement stmt = connection.prepareStatement(sqlItemEstoque);

            stmt.setString(1, nomeItemEstoque);
            stmt.setString(2, codSilapItemEstoque);
            stmt.setInt(3, Integer.parseInt(qtdeMinimaItemEstoque));
            stmt.setString(4, tipoItemEstoque);
            stmt.setString(5, unidadeMedidaItemEstoque);
            stmt.setString(6, outrasInformacoesItemEstoque);
            stmt.setInt(7, codItemEstoque);

            stmt.executeUpdate();

            stmt.close();
            return "sucesso";
        } catch (SQLException e) {
            String msg = "Erro ao tentar persistir item de estoque. \nSQLException em setItemEstoque.jsp: " + e.getMessage();
            //System.out.println(msg);
            return msg;
        } catch (Exception e) {
            String msg = "Erro ao tentar persistir item de estoque. \nException em setItemEstoque.jsp: " + e.getMessage();
            //System.out.println(msg);
            return msg;
        }
    }
    %>

    <%
    /* campo de item_estoque necessário para verificação de já existência em banco */
    String nomeItemEstoque = request.getParameter("nomeItemEstoque");
    
    String acao = request.getParameter("acao");

    /* converte strings com acento para padrão do Banco */
    nomeItemEstoque = toUTF8(nomeItemEstoque);

    if(("NAO".equals(itemJaExiste(nomeItemEstoque)) && "insert".equals(acao)) || ("SIM".equals(itemJaExiste(nomeItemEstoque)) && "update".equals(acao))){
        /* campos restantes de item_estoque */
        String codItemEstoque = request.getParameter("codItemEstoque");
        String codSilapItemEstoque = request.getParameter("codSilapItemEstoque");
        String qtdeMinimaItemEstoque = request.getParameter("qtdeMinimaItemEstoque");
        String tipoItemEstoque = request.getParameter("tipoItemEstoque");
        String unidadeMedidaItemEstoque = request.getParameter("unidadeMedidaItemEstoque");
        String outrasInformacoesItemEstoque = request.getParameter("outrasInformacoesItemEstoque");

        // TESTE
        /*System.out.println("NomeItemEstoque: " + nomeItemEstoque);
        System.out.println("codSilapItemEstoque: " + codSilapItemEstoque);
        System.out.println("qtdeMinimaItemEstoque: " + qtdeMinimaItemEstoque);
        System.out.println("tipoItemEstoque: " + tipoItemEstoque);
        System.out.println("unidadeMedidaItemEstoque: " + unidadeMedidaItemEstoque);
        System.out.println("outrasInformacoesItemEstoque: " + outrasInformacoesItemEstoque);*/

        /* converte strings com acento para padrão do Banco */
        tipoItemEstoque = toUTF8(tipoItemEstoque);
        unidadeMedidaItemEstoque = toUTF8(unidadeMedidaItemEstoque);
        outrasInformacoesItemEstoque = toUTF8(outrasInformacoesItemEstoque);

        Connection connection = GetDBConnection.getConnection();
        int idItemEstoque = 0;

        if ("insert".equals(acao)) {
            //se a ação for insert, procurar próximo código livre na tabela item_estoque
            idItemEstoque = getProximoCodItemEstoque(connection);
            System.out.println(idItemEstoque);
            %><codigoInserido><%=idItemEstoque%></codigoInserido><%
        } else if ("update".equals(acao)) {
            //se a ação for update, utiliza o código de item de estoque que veio da tela
            idItemEstoque = Integer.parseInt(codItemEstoque);
        }

        String retorno = insereOuAtualizaItemEstoque(connection, idItemEstoque, nomeItemEstoque, codSilapItemEstoque, qtdeMinimaItemEstoque, tipoItemEstoque, unidadeMedidaItemEstoque, outrasInformacoesItemEstoque, acao);

        if ("sucesso".equals(retorno)) {
            if ("insert".equals(acao)) { //item inserido com sucesso
                %><result>INSERIDO</result><%
                //System.out.println("INSERIDO");
            } else if ("update".equals(acao)) { //item atualizado com sucesso
                %><result>ATUALIZADO</result><%
                //System.out.println("ATUALIZADO");
            }
        } else {
            %><result><%=retorno%></result><% //exception ao tentar persistir item
            //System.out.println("EXCEPTION");
        }  
    } else {
        %><result>JA_EXISTE</result><% //item já existe no banco
        //System.out.println("JA_EXISTE");
    }
    %>
</itemEstoque>