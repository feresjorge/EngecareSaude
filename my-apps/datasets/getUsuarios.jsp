<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<listaUsuarios><%!
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
        String nomeUsuario = request.getParameter("nomeUsuario");
        String tipoPesquisa = request.getParameter("tipoPesquisa");
        
        String textoGridVazia = null;
        
        if(nomeUsuario != ""){
            textoGridVazia = "A pesquisa por '" + nomeUsuario + "' não retornou nenhum resultado";
        } else {
            textoGridVazia = "A pesquisa não retornou nenhum resultado";
        }
        
        textoGridVazia = toISO88591(textoGridVazia);
        
        PreparedStatement ps = null;
        Connection connection = null;
        String sql = null;

        String status = null;
        String img_status = null;
        String permissao = null;
        String codPermissao = null;

        if (nomeUsuario == "") {
            if ("todos".equals(tipoPesquisa)) {
                sql = "SELECT cod_usuario, id_profissional_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario, area_profissional, funcao_profissional, nome_pessoa FROM usuario, profissional, pessoa WHERE id_profissional_usuario = cod_profissional AND id_pessoa_profissional = cod_pessoa ORDER BY status_usuario DESC;";
            } else if ("ativos".equals(tipoPesquisa)) {
                sql = "SELECT cod_usuario, id_profissional_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario, area_profissional, funcao_profissional, nome_pessoa FROM usuario, profissional, pessoa WHERE status_usuario = 1 AND id_profissional_usuario = cod_profissional AND id_pessoa_profissional = cod_pessoa ORDER BY cod_usuario ASC;";
            } else if ("inativos".equals(tipoPesquisa)) {
                sql = "SELECT cod_usuario, id_profissional_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario, area_profissional, funcao_profissional, nome_pessoa FROM usuario, profissional, pessoa WHERE status_usuario = 0 AND id_profissional_usuario = cod_profissional AND id_pessoa_profissional = cod_pessoa ORDER BY cod_usuario ASC;";
            }
        } else {
            if ("todos".equals(tipoPesquisa)) {
                sql = "SELECT cod_usuario, id_profissional_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario, area_profissional, funcao_profissional, nome_pessoa FROM usuario, profissional, pessoa WHERE login_usuario LIKE '%" + nomeUsuario + "%' AND id_profissional_usuario = cod_profissional AND id_pessoa_profissional = cod_pessoa ORDER BY status_usuario DESC;";
            } else if ("ativos".equals(tipoPesquisa)) {
                sql = "SELECT cod_usuario, id_profissional_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario, area_profissional, funcao_profissional, nome_pessoa FROM usuario, profissional, pessoa WHERE login_usuario LIKE '%" + nomeUsuario + "%' AND status_usuario = 1 AND id_profissional_usuario = cod_profissional AND id_pessoa_profissional = cod_pessoa ORDER BY cod_usuario ASC;";
            } else if ("inativos".equals(tipoPesquisa)) {
                sql = "SELECT cod_usuario, id_profissional_usuario, login_usuario, senha_usuario, permissao_usuario, status_usuario, area_profissional, funcao_profissional, nome_pessoa FROM usuario, profissional, pessoa WHERE login_usuario LIKE '%" + nomeUsuario + "%' AND status_usuario = 0 AND id_profissional_usuario = cod_profissional AND id_pessoa_profissional = cod_pessoa ORDER BY cod_usuario ASC;";
            }
        }

        try {
            connection = GetDBConnection.getConnection();

            ps = connection.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();
            
            if (!rs.next()) {
                %><usuario img_status="null" text="<%=textoGridVazia%>"/><%
            } else {
                do {
                    String nome = rs.getString("nome_pessoa");
                    nome = toISO88591(nome);

                    String area = rs.getString("area_profissional");
                    area = toISO88591(area);

                    String funcao = rs.getString("funcao_profissional");
                    funcao = toISO88591(funcao);

                    if (rs.getInt("status_usuario") == 0) {
                        status = "inativo";
                        img_status = "inativo.png";
                    } else if (rs.getInt("status_usuario") == 1) {
                        status = "ativo";
                        img_status = "ativo.png";
                    }

                    status = toISO88591(status);
                    img_status = toISO88591(img_status);
                    
                    if (rs.getInt("permissao_usuario") == 1) {
                        codPermissao = "1";
                        permissao = "Administrador Geral";
                    } else if (rs.getInt("permissao_usuario") == 2) {
                        codPermissao = "2";
                        permissao = "Administrador Almoxarife";
                    } else if (rs.getInt("permissao_usuario") == 3) {
                        codPermissao = "3";
                        permissao = "Usuário Almoxarife";
                    } else if (rs.getInt("permissao_usuario") == 4) {
                        codPermissao = "4";
                        permissao = "Recepcionista";
                    }
                    
                    permissao = toISO88591(permissao);
                    
                    int cod = rs.getInt("cod_usuario");
                    String codUsuario = null;
                    if(cod > 0 && cod < 10){
                       codUsuario = "00" + String.valueOf(cod);
                    } else if(cod >= 10 && cod < 100){
                       codUsuario = "0" + String.valueOf(cod);
                    } else {
                       codUsuario = String.valueOf(cod);
                    }

                    %><usuario cod_usuario="<%=codUsuario%>" profissional="<%=nome%>"
                     cod_profissional="<%=rs.getInt("id_profissional_usuario")%>" login_usuario="<%=rs.getString("login_usuario")%>" 
                     permissao_usuario="<%=permissao%>" cod_permissao_usuario="<%=codPermissao%>" status="<%=status%>" img_status="<%=img_status%>" 
                     area_profissional="<%=area%>" funcao_profissional="<%=funcao%>" text="temRegistro"/><%
                } while (rs.next());
             }
             rs.close();
             ps.close();
             connection.close();
         } catch (SQLException e) {
             String msg = "Erro ao tentar buscar usuario.\n\nSQLException em getUsuarios.jsp: " + e.getMessage();
             System.out.println(msg);
             msg = toISO88591(msg);
             
             textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
             %><usuario img_status="null" text="<%=textoGridVazia%>" error="Erro ao tentar buscar usuario.\n\nSQLException em getUsuarios.jsp"/><%
        } catch (Exception e) {
             String msg = "Erro ao tentar buscar usuario.\n\nException em getUsuarios.jsp: " + e.getMessage();
             System.out.println(msg);
             msg = toISO88591(msg);
             
             textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
             %><usuario img_status="null" text="<%=textoGridVazia%>" error="Erro ao tentar buscar usuario.\n\nException em getUsuarios.jsp"/><%
        }
    %>
</listaUsuarios>
