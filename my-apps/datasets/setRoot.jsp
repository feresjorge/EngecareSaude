<%@page import="BD.GetDBConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="java.util.Date"%>

<usuario><%!
     /* Convers�o de tipos para tratar caracteres com acento  Openlaszlo  Postgres */
    String toUTF8(String text) throws Exception {
        byte p[] = text.getBytes("ISO-8859-1");
        return new String(p, 0, p.length, "UTF-8");
    }

    /* Convers�o de tipos para tratar caracteres com acento  Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        byte p[] = text.getBytes("UTF-8");
        return new String(p, 0, p.length, "ISO-8859-1");
    }

    %><%

        String opcao = request.getParameter("acao");
        
        String codUsuario = request.getParameter("codUsuario");
        
        String codProfissional = request.getParameter("codProfissional");
        String nomeUsuario = request.getParameter("nomeUsuario");
        String senhaUsuario = request.getParameter("senhaUsuario");
        String permissaoUsuario = request.getParameter("permissaoUsuario");
        String status = request.getParameter("status");
        
        String sql = "";

        if (opcao.equals("updateAdminComSenha")) {
            sql = "UPDATE usuario SET senha_usuario = md5(?), permissao_usuario = ?, status_usuario = ? WHERE cod_usuario = ? ";
        } else if (opcao.equals("updateAdminSemSenha")) {
            sql = "UPDATE usuario SET permissao_usuario = ?, status_usuario = ? WHERE cod_usuario = ? ";
        } else if(opcao.equals("updateUser")){
            sql = "UPDATE usuario SET senha_usuario = md5(?) WHERE cod_usuario = ? ";
        } else if (opcao.equals("insert")) {
            sql = "INSERT INTO usuario (id_profissional_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario) values (?,?,md5(?),?,?) ";
        } else if  (opcao.equals("delete")){
            sql = "DELETE FROM usuario WHERE cod_usuario = ? ";   
        }
        
        
        Connection connection = null;
        
        try {
            connection = GetDBConnection.getConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);
   
            if (opcao.equals("updateAdminComSenha")) {
                stmt.setString(1, senhaUsuario);
                stmt.setInt(2, Integer.parseInt(permissaoUsuario));
                stmt.setInt(3, Integer.parseInt(status));
                stmt.setInt(4, Integer.parseInt(codUsuario));
                
                stmt.executeUpdate();
                
                %><result>AtualizadoAdminComSenha</result><%
            } else if (opcao.equals("updateAdminSemSenha")) {
                stmt.setInt(1, Integer.parseInt(permissaoUsuario));
                stmt.setInt(2, Integer.parseInt(status));
                stmt.setInt(3, Integer.parseInt(codUsuario));
                
                stmt.executeUpdate();
                
                %><result>AtualizadoAdminSemSenha</result><%
            } else if(opcao.equals("updateUser")){
                stmt.setString(1, senhaUsuario);
                stmt.setInt(2, Integer.parseInt(codUsuario));
                
                stmt.executeUpdate();
                
                %><result>AtualizadoUser</result><%
            } else if (opcao.equals("insert")) {
                stmt.setInt(1, Integer.parseInt(codProfissional));
                stmt.setString(2, nomeUsuario);
                stmt.setString(3, senhaUsuario);
                stmt.setInt(4, Integer.parseInt(permissaoUsuario));
                stmt.setInt(5, Integer.parseInt(status));
                
                stmt.executeUpdate();
                
                %><result>Inserido</result><%
            } else if (opcao.equals("delete")) {
                stmt.setInt(1, Integer.parseInt(codUsuario));
                
                stmt.executeUpdate();
            %><result>Deletado</result><%
        }
        stmt.close();
        connection.close();

    } catch (SQLException e) {
        String msg = "Erro ao tentar persistir dados de superusu�rio.\n\nSQLException em setRoot.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        %><result><%=msg%></result><%
   } catch (Exception e) {
       String msg = "Erro ao tentar persistir dados de superusu�rio.\n\nException em setRoot.jsp: " + e.getMessage();
       System.out.println(msg);
       msg = toISO88591(msg);
       %><result><%=msg%></result><%
   }
%></usuario>