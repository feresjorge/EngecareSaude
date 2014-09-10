<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<profissional><%!    /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */

    String toISO88591(String text) throws Exception {
        if ("Indef.".equals(text)) {
            return "";
        } else {
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    }

    %><%
        String codProfissional = request.getParameter("codProfissional");

        PreparedStatement ps = null;
        Connection connection = null;

        try {
            connection = GetDBConnection.getConnection();

            ps = connection.prepareStatement("SELECT nome_pessoa, area_profissional, funcao_profissional FROM pessoa INNER JOIN profissional "
                    + "ON id_pessoa_profissional = cod_pessoa AND cod_profissional = " + codProfissional + ";");

            ResultSet rs = ps.executeQuery();


            while (rs.next()) {
                String nome = rs.getString("nome_pessoa");
                nome = toISO88591(nome);
                
                String area = rs.getString("area_profissional");
                area = toISO88591(area);
                
                String funcao = rs.getString("funcao_profissional");
                funcao = toISO88591(funcao);

    %><dados nome="<%=nome%>" area="<%=area%>" funcao="<%=funcao%>"/><%

                  }
                  rs.close();
                  ps.close();
                  connection.close();

              } catch (SQLException e) {
                  String msg = "Erro ao tentar buscar dados de profissional.\n\nSQLException em getProfissionalDados.jsp: " + e.getMessage();
                  System.out.println(msg);
              } catch (Exception e) {
                  String msg = "Erro ao tentar buscar dados de profissional.\n\nException em getProfissionalDados.jsp: " + e.getMessage();
                  System.out.println(msg);
              }
    %>
</profissional>