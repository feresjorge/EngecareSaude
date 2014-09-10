<%@ page import="java.sql.*"%>
<%@ page import="BD.GetDBConnection"%>

<resultLogin>
    <%!
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
    %><%
    String usuario = request.getParameter("usuario");
    String senha = request.getParameter("senha");
    String tipo = request.getParameter("tipo");
    
    String sql = "";
    
    if("root".equals(tipo)){
        sql = "SELECT * FROM root WHERE login_usuario = ? AND senha_usuario = md5(?)";
    } else if("user".equals(tipo)){
        sql = "SELECT * FROM usuario WHERE login_usuario = ? AND senha_usuario = md5(?)";
    }

    Connection connection = null;
    try {
        connection = GetDBConnection.getConnection();

        PreparedStatement ps = connection.prepareStatement(sql);

        ps.setString(1, usuario);
        ps.setString(2, senha);

        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            if(rs.getInt("status_usuario") == 1){
                %><result retorno="sucess" permissao="<%=rs.getInt("permissao_usuario")%>"/><%
            } else {
                %><result retorno="denied" permissao="-1"/><%
            }
        } else { 
            %><result retorno="fail" permissao="-1"/><%
        }
        
        rs.close();
        ps.close();
        connection.close();
    } catch (SQLException e) {
        String msg = "Erro ao tentar efetuar login.\n\nSQLException em login.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        %><exception><%=msg%></exception><%
    } catch (Exception e) {
        String msg = "Erro ao tentar efetuar login.\n\nException em login.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        %><exception><%=msg%></exception><%
    }
%>
</resultLogin>