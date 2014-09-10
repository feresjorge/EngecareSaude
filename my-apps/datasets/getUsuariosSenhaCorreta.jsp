<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<contagem><%!
        /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
        String toISO88591(String text) throws Exception {
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    %> 
    <%
        String codUsuario = request.getParameter("codUsuario");
        String senha = request.getParameter("senha");
               
        PreparedStatement ps = null;
        Connection connection = null;
        
        try {
            connection = GetDBConnection.getConnection();

            ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM usuario WHERE cod_usuario = " + codUsuario + " AND senha_usuario = md5('" + senha +"');");
                
            ResultSet rs = ps.executeQuery();
            rs.next();
            %><registros><%=rs.getInt(1)%></registros><%
                                
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException e) {
            String msg = "Erro ao tentar validar senha de usuário.\n\nSQLException em getUsuarioSenhaCorreta.jsp: " + e.getMessage();
            System.out.println(msg);
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        } catch (Exception e) {
            String msg = "Erro ao tentar validar senha de usuário.\n\nException em getUsuarioSenhaCorreta.jsp: " + e.getMessage();
            System.out.println(msg);
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }
    %></contagem>