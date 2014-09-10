<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>


<contagem><%!
        /* Convers�o de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
        String toISO88591(String text) throws Exception {
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    %> 
    <%
        String cpf = request.getParameter("cpf");
               
        PreparedStatement ps = null;
        Connection connection = null;
        
        try {
            connection = GetDBConnection.getConnection();
            
            ps = connection.prepareStatement("SELECT COUNT (*) AS retorno FROM pessoa WHERE cpf_pessoa = '"+ cpf +"';");
            
            ResultSet rs = ps.executeQuery();
            rs.next();
            %><registros><%=rs.getInt(1)%></registros><%
                                
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException e) {
            String msg = "Erro ao tentar verificar duplicidade de pessoa.\n\nSQLException em getPessoaMesmoCPF.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }  catch (Exception e) {
            String msg = "Erro ao tentar verificar duplicidade de pessoa.\n\nException em getPessoaMesmoCPF.jsp: " + e.getMessage();
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }
    %></contagem>