<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
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
        String tipoPesquisa = request.getParameter("itens");
               
        PreparedStatement ps = null;
        Connection connection = null;
        
        try {
            connection = GetDBConnection.getConnection();
         
            ps = connection.prepareStatement("");
            
            if("todos".equals(tipoPesquisa)){
                ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM estoque;");
            } else if("baixa".equals(tipoPesquisa)){
                ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM estoque WHERE qtdeatual_produto < qtdeminima_produto;");
            } else if("falta".equals(tipoPesquisa)){
                ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM estoque WHERE qtdeatual_produto = 0;");
            } else if("vencendo".equals(tipoPesquisa)){
                ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM estoque WHERE ((dataval_produto-CURRENT_DATE) >= 0) AND ((dataval_produto-CURRENT_DATE) <= 45);");
            } else if("vencidos".equals(tipoPesquisa)){
                ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM estoque WHERE ((dataval_produto-CURRENT_DATE) < 0);");
            }
            
            ResultSet rs = ps.executeQuery();
            rs.next();
            %><registros><%=rs.getInt(1)%></registros><%
                                
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException e) {
            String msg = "Erro ao tentar obter informações sobre item de estoque.\n\nSQLException em getQtdeRegistros.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }  catch (Exception e) {
            String msg = "Erro ao tentar obter informações sobre item de estoque.\n\nException em getQtdeRegistros.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }
    %></contagem>