<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<listaCidades><%!
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
        String nomeCidade = request.getParameter("nomeCidade");
        String tipoPesquisa = request.getParameter("tipoPesquisa");
        nomeCidade = toUTF8(nomeCidade);

        PreparedStatement ps = null;
        Connection connection = null;
        
        try {
            connection = GetDBConnection.getConnection();
         
            ps = connection.prepareStatement("");
            
            if (nomeCidade == null) {
                if("todos".equals(tipoPesquisa)){
                    ps = connection.prepareStatement("SELECT * FROM cidade ORDER BY uf_cidade;");
                } else {
                    ps = connection.prepareStatement("SELECT * FROM cidade WHERE uf_cidade = '"+ tipoPesquisa +"';");
                }

            } else {
                if("todos".equals(tipoPesquisa)){
                    ps = connection.prepareStatement("SELECT * FROM cidade WHERE nome_cidade LIKE '%" + nomeCidade + "%' ORDER BY uf_cidade;");
                } else {
                    ps = connection.prepareStatement("SELECT * FROM cidade WHERE nome_cidade LIKE '%" + nomeCidade + "%' AND uf_cidade = '"+ tipoPesquisa +"';");
                }
            }
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                String cidade = rs.getString("nome_cidade");
                cidade = toISO88591(cidade);
                
                %><cidade cod_cidade="<%=rs.getInt("cod_cidade")%>" nome_cidade="<%=cidade%>" 
                        uf_cidade="<%=rs.getString("uf_cidade")%>"/><%
            }             
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException e) {
            String msg = "Ocorreu um erro ao tentar buscar cidade.\n\nSQLException em getCidades.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        } catch (Exception e) {
            String msg = "Ocorreu um erro ao tentar buscar cidade.\n\nException em getCidades.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }
%>
</listaCidades>