<%@page import="BD.GetDBConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>

<lote><%!
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
    
    /* Este método busca o próximo código de item de estoque disponível no banco e o retorna */
    int getProximoCodLote(Connection connection) {
        String sql = "SELECT NEXTVAL ('lote_cod_lote_seq')";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            rs.next();

            int proximoCodLote = rs.getInt(1);
            rs.close();
            
            return proximoCodLote;
        } catch (SQLException e) {
            String msg = "SQLException na função getProximoCodLote em setLote.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        } catch (Exception e) {
            String msg = "Ocorreu um erro ao verificar o próximo código livre para item de estoque: " + e.getMessage();
            System.out.println(msg);
            return 0;
        }
    }
    
    /* Método chamado para inserir um novo item de estoque ou atualizar um já existente. O tipo de modificação no banco depende da String acao ("insert" ou "update") */
    String insereOuAtualizaLote(Connection connection, int codLote, String numeroLote, String fabricanteLote, String dataFabricacaoLote, String dataValidadeLote, 
            String qtdeAtualLote, String estanteLote, String prateleiraLote, String outrasInformacoesLote, String idItemEstoque, String acao) {
        
        String sqlLote = "";

        SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
        java.util.Date dataUtil = null;
        java.sql.Date dataSql = null;
        
        if (acao.equals("insert")) {
            sqlLote = "INSERT INTO lote (id_item_estoque, numero_lote, fabricante_lote, data_fabricacao_lote, data_validade_lote, qtde_atual_lote, estante_lote, prateleira_lote, outras_informacoes_lote, cod_lote) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
        } else if (acao.equals("update")) {
            sqlLote = "UPDATE lote SET id_item_estoque = ?, numero_lote = ?, fabricante_lote = ?, data_fabricacao_lote = ?, data_validade_lote, qtde_atual_lote = ?, estante_lote = ?, prateleira_lote = ?, outras_informacoes_lote = ? WHERE cod_lote = ?;";
        }
        
        try {
            PreparedStatement stmt = connection.prepareStatement(sqlLote);

            stmt.setInt(1, Integer.parseInt(idItemEstoque));
            stmt.setString(2, numeroLote);
            stmt.setString(3, fabricanteLote);
            
            dataUtil = formatador.parse(dataFabricacaoLote);
            dataSql = new java.sql.Date(dataUtil.getTime());
            stmt.setDate(4, dataSql);
            
            dataUtil = formatador.parse(dataValidadeLote);
            dataSql = new java.sql.Date(dataUtil.getTime());
            stmt.setDate(5, dataSql);
            
            stmt.setInt(6, Integer.parseInt(qtdeAtualLote));
            stmt.setString(7, estanteLote);
            stmt.setString(8, prateleiraLote);
            stmt.setString(9, outrasInformacoesLote);
            stmt.setInt(10, codLote);
            
            stmt.executeUpdate();

            stmt.close();
            return "sucesso";
        } catch (SQLException e) {
            String msg = "Erro ao tentar persistir lote. \nSQLException em setLote.jsp: " + e.getMessage();
            //System.out.println(msg);
            return msg;
        } catch (Exception e) {
            String msg = "Erro ao tentar persistir lote. \nException em setLote.jsp: " + e.getMessage();
            //System.out.println(msg);
            return msg;
        }
    }
    %>
     
    <%
    /* parametros enviados da view para o JSP */
    String acao = request.getParameter("acao");
    String numeroLote = request.getParameter("numeroLote");
    String fabricanteLote = request.getParameter("fabricanteLote");
    String dataFabricacaoLote = request.getParameter("dataFabricacaoLote");
    String dataValidadeLote = request.getParameter("dataValidadeLote");
    String qtdeAtualLote = request.getParameter("qtdeAtualLote");
    String estanteLote = request.getParameter("estanteLote");
    String prateleiraLote = request.getParameter("prateleiraLote");
    String outrasInformacoesLote = request.getParameter("outrasInformacoesLote");
    String idItemEstoque = request.getParameter("idItemEstoque");
    String codLote = request.getParameter("codLote");
    
    idItemEstoque = "2";
    
    //TESTE
    /*System.out.println(acao);
    System.out.println(numeroLote);
    System.out.println(fabricanteLote);
    System.out.println(dataFabricacaoLote);
    System.out.println(dataValidadeLote);
    System.out.println(qtdeAtualLote);
    System.out.println(estanteLote);
    System.out.println(prateleiraLote);
    System.out.println(outrasInformacoesLote);
    System.out.println(idItemEstoque);
    System.out.println(codLote);*/
    
    /* converte strings com acento para padrão do Banco */
    fabricanteLote = toUTF8(fabricanteLote);
    outrasInformacoesLote = toUTF8(outrasInformacoesLote);
    
    Connection connection = GetDBConnection.getConnection();
    int idLote = 0;

    if ("insert".equals(acao)) {
        //se a ação for insert, procurar próximo código livre na tabela lote
        idLote = getProximoCodLote(connection);
        System.out.println(codLote);
        %><codigoInserido><%=codLote%></codigoInserido><%
    } else if ("update".equals(acao)) {
        //se a ação for update, utiliza o código de lote que veio da tela
        idLote = Integer.parseInt(codLote);
    }
    
    String retorno = insereOuAtualizaLote(connection, idLote, numeroLote, fabricanteLote, dataFabricacaoLote, dataValidadeLote, qtdeAtualLote, estanteLote, 
            prateleiraLote, outrasInformacoesLote, idItemEstoque, acao);
    
    if ("sucesso".equals(retorno)) {
        if ("insert".equals(acao)) { //lote inserido com sucesso
            %><result>INSERIDO</result><%
            //System.out.println("INSERIDO");
        } else if ("update".equals(acao)) { //lote atualizado com sucesso
            %><result>ATUALIZADO</result><%
            //System.out.println("ATUALIZADO");
        }
    } else {
        %><result><%=retorno%></result><% //exception ao tentar persistir lote
        //System.out.println("EXCEPTION");
    }
    %>
</lote>