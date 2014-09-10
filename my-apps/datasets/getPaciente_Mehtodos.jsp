<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<%!    
    int buscaDadoPaciente (Connection connection, String dado, int codPaciente) {
        String sqlPessoa = "SELECT ? FROM paciente WHERE cod_paciente = ?";
        String sqlAlterado = "";
        System.out.println("Antes do try de BUSCA dado paciente \n");
        try {
            PreparedStatement ps = connection.prepareStatement(sqlPessoa);
            Statement sttm = null;
            ResultSet rs = null;
            ps.setString(1, dado);                
            ps.setInt(2, codPaciente);                
            sqlAlterado = ps.toString();
            System.out.println("sqlAlterado de busca dado paciente " + sqlAlterado);
            sttm = connection.createStatement();
            rs = sttm.executeQuery(sqlAlterado);
            rs.next();
            int retorno = rs.getInt(1);
            System.out.println("retorno do valor de pessoa de busca ddo rpofisional é: " + retorno);
            return retorno;
        } catch (SQLException e) {
            String msg = "Erro ao tentar buscar dados de paciente.\n\nSQLException em getPaciente_Mehtodos.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        } catch (Exception e) {
            String msg = "Erro ao tentar buscar dados de paciente.\n\nException em getPaciente_Mehtodos.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        }
    }

    %>                      