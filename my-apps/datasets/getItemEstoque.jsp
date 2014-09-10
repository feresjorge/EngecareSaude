
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="BD.GetDBConnection"%>

<itens><%!
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
    %>
    
    <%
        String nomeItemEstoque = request.getParameter("nomeItemEstoque");
        String caseSensitive = request.getParameter("caseSensitive"); // pode assumir os valores LIKE ou ILIKE. LIKE = on, ILIKE = off
        String tipoPesquisa = request.getParameter("tipoPesquisa"); // todos / baixa / falta / vencendo / vencido
        
        System.out.println("nomeItemEstoque:  " + nomeItemEstoque);
        System.out.println("caseSensitive:  " + caseSensitive);
        System.out.println("tipoPesquisa:  " + tipoPesquisa);
        
        SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
        Date dataFabricacao = null;
        Date dataValidade = null;
        String textoGridVazia = null;

        if (nomeItemEstoque != "") {
            textoGridVazia = "A pesquisa por '" + nomeItemEstoque + "' não retornou nenhum resultado";
        } else {
            textoGridVazia = "A pesquisa não retornou nenhum resultado";
        }

        textoGridVazia = toISO88591(textoGridVazia);

        PreparedStatement ps = null;
        Connection connection = null;

        try {
            connection = GetDBConnection.getConnection();

            ps = connection.prepareStatement("");

            if ("".equals(nomeItemEstoque)) {
                if ("todos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT ie.*, SUM(l.qtde_atual_lote) as qtde_atual_item_estoque FROM item_estoque ie, lote l WHERE ie.cod_item_estoque = l.id_item_estoque GROUP BY ie.cod_item_estoque ORDER BY ie.nome_item_estoque;");
                } else if ("baixa".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE l.qtdeatual_lote < ie.qtdeminima_item_estoque ORDER BY l.dataval_lote ASC;");
                } else if ("falta".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE l.qtdeatual_lote = 0 ORDER BY l.dataval_lote ASC;");
                } else if ("vencendo".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE ((l.dataval_lote - CURRENT_DATE) >= 0) AND ((l.dataval_lote - CURRENT_DATE) <= 45) ORDER BY l.dataval_lote ASC;");
                } else if ("vencidos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE ((l.dataval_lote - CURRENT_DATE) < 0) ORDER BY l.dataval_lote ASC;");
                }
            } else {
                if ("todos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE ie.nome_item_estoque " + caseSensitive + " '%" + toUTF8(nomeItemEstoque) + "%' ORDER BY l.dataval_lote ASC;");
                } else if ("baixa".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE l.qtdeatual_lote < ie.qtdeminima_item_estoque AND ie.nome_item_estoque " + caseSensitive + " '%" + toUTF8(nomeItemEstoque) + "%' ORDER BY l.dataval_lote ASC;");
                } else if ("falta".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE l.qtdeatual_lote = 0 AND ie.nome_item_estoque " + caseSensitive + " '%" + toUTF8(nomeItemEstoque) + "%' ORDER BY l.dataval_lote ASC;");
                } else if ("vencendo".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE ((l.dataval_lote - CURRENT_DATE) >= 0) AND ((l.dataval_lote - CURRENT_DATE) <= 45) AND ie.nome_item_estoque " + caseSensitive + " '%" + toUTF8(nomeItemEstoque) + "%' ORDER BY l.dataval_lote ASC;");
                } else if ("vencidos".equals(tipoPesquisa)) {
                    ps = connection.prepareStatement("SELECT * FROM item_estoque ie, lote l WHERE ((l.dataval_lote - CURRENT_DATE) < 0) AND ie.nome_item_estoque " + caseSensitive + " '%" + toUTF8(nomeItemEstoque) + "%' ORDER BY l.dataval_lote ASC;");
                }
            }
            
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                %><item text="<%=textoGridVazia%>"/><%
            } else {
                do {
                    int c = 1;

                    int cod_item_estoque = rs.getInt("cod_item_estoque");
                    String nome_item_estoque = toISO88591(rs.getString("nome_item_estoque"));
                    String cod_silap_item_estoque = rs.getString("cod_silap_item_estoque");
                    int qtde_minima_item_estoque = rs.getInt("qtde_minima_item_estoque");
                    String tipo_item_estoque = rs.getString("tipo_item_estoque");
                    String unidade_medida_item_estoque = toISO88591(rs.getString("unidade_medida_item_estoque"));
                    String outras_informacoes_item_estoque = toISO88591(rs.getString("outras_informacoes_item_estoque"));
                    int qtde_atual_item_estoque = rs.getInt("qtde_atual_item_estoque");


                     /*dataFabricacao = rs.getDate("datafab_produto");
                     String dataFab = formatador.format(dataFabricacao);
                    StringEscapeUtils.escapeXml*/

                    String contadorItemEstoque = null;
                    if(c > 0 && c < 10){
                       contadorItemEstoque = "00" + String.valueOf(c);
                    } else if(c >= 10 && c < 100){
                       contadorItemEstoque = "0" + String.valueOf(c);
                    } else {
                       contadorItemEstoque = String.valueOf(c);
                    }
                    
                    String status;
                    String img_status;
                    
                    status = "normal";
                    img_status = "normal.png";
                    
                    %><item contador_item_estoque="<%=contadorItemEstoque%>" cod_item_estoque="<%=cod_item_estoque%>" nome_item_estoque="<%=nome_item_estoque%>" 
                        cod_silap_item_estoque="<%=cod_silap_item_estoque%>" qtde_minima_item_estoque="<%=qtde_minima_item_estoque%>" qtde_atual_item_estoque="<%=qtde_atual_item_estoque%>" tipo_item_estoque="<%=tipo_item_estoque%>" 
                        unidade_medida_item_estoque="<%=unidade_medida_item_estoque%>" outras_informacoes_item_estoque="<%=outras_informacoes_item_estoque%>" status="<%=status%>" img_status="<%=img_status%>" text="temRegistro"/><%
                        
                    c++;
                } while (rs.next());
            }
            rs.close();
            ps.close();
            connection.close();

        } catch (SQLException e) {
            String msg = "Erro ao tentar buscar item de estoque.\n\nSQLException em getItemEstoque.jsp: " + e.getMessage();
            System.out.println(msg);
            msg = toISO88591(msg);

            textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
            %><produto text="<%=textoGridVazia%>" error="Erro ao tentar buscar produto.\n\nSQLException em getItemEstoque.jsp"/><%
        } catch (Exception e) {
            String msg = "Erro ao tentar buscar item de estoque.\n\nException em getItemEstoque.jsp: " + e.getMessage();
            System.out.println(msg);
            msg = toISO88591(msg);

            textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
            %><produto text="<%=textoGridVazia%>" error="Erro ao tentar buscar item de estoque.\n\nException em getItemEstoque.jsp"/><%
        }
%></itens>