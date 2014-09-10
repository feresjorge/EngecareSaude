<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<estoque><%!
    /* Conversão de tipos para tratar caracteres com acento  Openlaszlo -> Postgres */
    String toUTF8(String text) throws Exception {
        byte p[] = text.getBytes("ISO-8859-1");
        return new String(p, 0, p.length, "UTF-8");
    }

    /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        byte p[] = text.getBytes("UTF-8");
        return new String(p, 0, p.length, "ISO-8859-1");
    }
    %> 
    <%
        String nomeProduto = request.getParameter("nomeProduto");

        String tipoPesquisa = request.getParameter("itens");

        SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
        Date dataFabricacao = null;
        Date dataValidade = null;

        String textoGridVazia = null;

        if (nomeProduto != "") {
            textoGridVazia = "A pesquisa por '" + nomeProduto + "' não retornou nenhum resultado";
        } else {
            textoGridVazia = "A pesquisa não retornou nenhum resultado";
        }

        textoGridVazia = toISO88591(textoGridVazia);

        PreparedStatement ps = null;
        Connection connection = null;

        try {
            connection = GetDBConnection.getConnection();

            ps = connection.prepareStatement("");

            if (nomeProduto == "") {
                if ("todos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque ORDER BY dataval_produto ASC;");
                } else if ("baixa".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE qtdeatual_produto < qtdeminima_produto ORDER BY dataval_produto ASC;");
                } else if ("falta".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE qtdeatual_produto = 0 ORDER BY dataval_produto ASC;");
                } else if ("vencendo".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE ((dataval_produto-CURRENT_DATE) >= 0) AND ((dataval_produto-CURRENT_DATE) <= 45) ORDER BY dataval_produto ASC;");
                } else if ("vencidos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE ((dataval_produto-CURRENT_DATE) < 0) ORDER BY dataval_produto ASC;");
                }
            } else {
                if ("todos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE nome_produto LIKE '%" + toUTF8(nomeProduto) + "%' ORDER BY dataval_produto ASC;");
                } else if ("baixa".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE qtdeatual_produto < qtdeminima_produto AND nome_produto LIKE '%" + nomeProduto + "%' ORDER BY dataval_produto ASC;");
                } else if ("falta".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE qtdeatual_produto = 0 AND nome_produto LIKE '%" + nomeProduto + "%' ORDER BY dataval_produto ASC;");
                } else if ("vencendo".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE (dataval_produto-CURRENT_DATE) >= 0 AND (dataval_produto-CURRENT_DATE) <= 45 AND nome_produto LIKE '%" + nomeProduto + "%' ORDER BY dataval_produto ASC;");
                } else if ("vencidos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM estoque WHERE (dataval_produto-CURRENT_DATE) < 0 AND nome_produto LIKE '%" + nomeProduto + "%' ORDER BY dataval_produto ASC;");
                }
            }

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                %><produto text="<%=textoGridVazia%>"/><%
            } else {
                do {
                    String nome_produto = rs.getString("nome_produto");
                    nome_produto = toISO88591(nome_produto);

                    String fabricante_produto = rs.getString("fabricante_produto");
                    //fabricante_produto = toISO88591(fabricante_produto);

                    String tipo_produto = rs.getString("tipo_produto");
                    tipo_produto = toISO88591(tipo_produto);

                    String unidade_medida_produto = rs.getString("unidade_medida_produto");
                    unidade_medida_produto = toISO88591(unidade_medida_produto);

                    dataFabricacao = rs.getDate("datafab_produto");
                    String dataFab = formatador.format(dataFabricacao);

                    dataValidade = rs.getDate("dataval_produto");
                    String dataVal = formatador.format(dataValidade);

                    String outras_informacoes_produto = rs.getString("outras_informacoes_produto");
                    outras_informacoes_produto = toISO88591(outras_informacoes_produto);
                    
                    int cod = rs.getInt("cod_produto");
                    String codProduto = null;
                    if(cod > 0 && cod < 10){
                       codProduto = "00" + String.valueOf(cod);
                    } else if(cod >= 10 && cod < 100){
                       codProduto = "0" + String.valueOf(cod);
                    } else {
                       codProduto = String.valueOf(cod);
                    }

                    %><produto cod_produto="<%=codProduto%>" nome_produto="<%=nome_produto%>"
                             tipo_produto="<%=tipo_produto%>" unidade_medida_produto="<%=unidade_medida_produto%>" 
                             fabricante_produto="<%=StringEscapeUtils.escapeXml(fabricante_produto)%>" dataval_produto="<%=dataVal%>" 
                             datafab_produto="<%=dataFab%>" qtdeminima_produto="<%=rs.getInt("qtdeminima_produto")%>" 
                             qtdeatual_produto="<%=rs.getInt("qtdeatual_produto")%>" estante_produto="<%=rs.getString("estante_produto")%>"
                             prateleira_produto="<%=rs.getInt("prateleira_produto")%>" 
                             outras_informacoes_produto="<%=outras_informacoes_produto%>" text="temRegistro"/><%
                     } while (rs.next());
                 }
                 rs.close();
                 ps.close();
                 connection.close();
             } catch (SQLException e) {
                 String msg = "Erro ao tentar buscar produto.\n\nSQLException em getProdutos.jsp: " + e.getMessage();
                 System.out.println(msg);
                 msg = toISO88591(msg);

                 textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
    %><produto text="<%=textoGridVazia%>" error="Erro ao tentar buscar produto.\n\nSQLException em getProdutos.jsp"/><%
      } catch (Exception e) {
          String msg = "Erro ao tentar buscar produto.\n\nException em getProdutos.jsp: " + e.getMessage();
          System.out.println(msg);
          msg = toISO88591(msg);

          textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
    %><produto text="<%=textoGridVazia%>" error="Erro ao tentar buscar produto.\n\nException em getProdutos.jsp"/><%
          }
    %>
</estoque>