<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<%@ include file="getPessoa.jsp"%>

<%!    /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        if("Indef.".equals(text)){
            return "";
        }else{
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    }
    
     String toUTF8(String text) throws Exception {
        if(text == null){
            return "";
        }else{ 
            byte p[] = text.getBytes("ISO-8859-1");
            return new String(p, 0, p.length, "UTF-8");
        }
    }
     
    int buscaDadoProfissional (Connection connection, String dado, int codProfissional) {
        String sqlPessoa = "SELECT ? FROM profissional WHERE cod_profissional = ?";
        String sqlAlterado = "";

        try {
            PreparedStatement ps = connection.prepareStatement(sqlPessoa);
            Statement sttm = null;
            ResultSet rs = null;
            ps.setString(1, dado);                
            ps.setInt(2, codProfissional);                
            sqlAlterado = ps.toString();
            
            sttm = connection.createStatement();
            rs = sttm.executeQuery(sqlAlterado);
            rs.next();
            int retorno = rs.getInt(1);
            
            return retorno;
        } catch (SQLException e) {
            String msg = "Erro ao tentar buscar dados de profissional.\n\nSQLException em getProfissional_Mehtodos.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        } catch (Exception e) {
            String msg = "Erro ao tentar buscar dados de profissional.\n\nException em getProfissional_Mehtodos.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        }
    }

    %>                      