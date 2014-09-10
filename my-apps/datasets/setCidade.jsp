<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<cidade><%!
    /* Conversão de tipos para tratar caracteres com acento  Openlaszlo  Postgres */
    String toUTF8(String text) throws Exception {
        byte p[] = text.getBytes("ISO-8859-1");
        return new String(p, 0, p.length, "UTF-8");
    }

    /* Conversão de tipos para tratar caracteres com acento  Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        byte p[] = text.getBytes("UTF-8");
        return new String(p, 0, p.length, "ISO-8859-1");
    }
    %><%

        String acao = request.getParameter("acao");
        String nomeCidade = request.getParameter("nomeCidade");
        String codCidade = request.getParameter("codCidade");
        String uf = request.getParameter("uf");

        String sql = "";

        if (acao.equals("update")) {
            sql = "UPDATE cidade SET nome_cidade = ?, uf_cidade = ? WHERE cod_cidade = ? ";
        } else if (acao.equals("insert")) {
            sql = "INSERT INTO cidade (nome_cidade, uf_cidade) VALUES (?,?) ";
        } else if (acao.equals("delete")) {
            sql = "DELETE FROM cidade WHERE cod_cidade = ? ";
        }


        Connection connection = null;
        try {
            connection = GetDBConnection.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);

            if (acao.equals("update")) {
                nomeCidade = toUTF8(nomeCidade);
                
                stmt.setString(1, nomeCidade);
                stmt.setString(2, uf);
                stmt.setInt(3, Integer.parseInt(codCidade));
                
                stmt.executeUpdate();

                %><result>Atualizado</result><%
            } else if (acao.equals("insert")) {
                nomeCidade = toUTF8(nomeCidade);

                stmt.setString(1, nomeCidade);
                stmt.setString(2, uf);

                stmt.executeUpdate();
                %><result>Inserido</result><%
            } else if (acao.equals("delete")) {
                stmt.setInt(1, Integer.parseInt(codCidade));
                stmt.executeUpdate();
                %><result>Deletado</result><%
            }
            stmt.close();
            connection.close();

        } catch (SQLException e) {
            String msg = "Erro ao tentar persistir dados de cidade.\n\nSQLException em setCidade.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        } catch (Exception e) {
            String msg = "Erro ao tentar persistir dados de cidade.\n\nException em setCidade.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }
%></cidade>