<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<contagem><%!
        SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat formataHora= new SimpleDateFormat("HH:mm");
        /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
        String toISO88591(String text) throws Exception {
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    %> 
    <%
        String profissional = request.getParameter("profissional");
        System.out.println("TESTE profissional "+ profissional);
        String paciente = request.getParameter("paciente");
        System.out.println("TESTE paciente "+ paciente);
        String dataAgendamento = request.getParameter("data");
        System.out.println("TESTE data "+ dataAgendamento);
        String horaAgendamento = request.getParameter("hora");
        System.out.println("TESTE hora "+ horaAgendamento);
        String codigoAgendamento = request.getParameter("codAgendamento");
        System.out.println("TESTE codigo Agend "+ codigoAgendamento);
               
        PreparedStatement ps = null;
        Connection connection = null;
        Date data = null;
        Time hora = null;
        java.sql.Date dataSql = null;
        String sql = "";
        
        data = formatador.parse(dataAgendamento);
        dataSql = new java.sql.Date(data.getTime());
        
        data = formataHora.parse(horaAgendamento);
        hora = new Time(data.getTime());
        try {
            connection = GetDBConnection.getConnection();
            ps = connection.prepareStatement("SELECT COUNT (*) FROM (SELECT * FROM agendamento INNER JOIN profissional ON id_profissional_agendamento = cod_profissional WHERE  cod_profissional = ? and data_agendamento = ? and hora_agendamento = ? ) as RETORNO;");
            ps.setInt(1, Integer.parseInt(profissional)); 
            ps.setDate(2, dataSql);
            ps.setTime(3, hora);
            System.out.println("sql de contagem " + ps);
            ResultSet rs = ps.executeQuery();
            rs.next();
            
            if(rs.getInt(1)!= 0){
                System.out.println("contagem de profissionais " + rs.getInt(1) );
                %><registros>profissionalOcupado</registros><%
            }else{
                if("".equals(codigoAgendamento) ){
                    ps = connection.prepareStatement("SELECT COUNT (*) FROM (SELECT * FROM agendamento INNER JOIN paciente ON id_paciente_agendamento = cod_paciente WHERE  cod_paciente= ? and data_agendamento = ? and hora_agendamento = ?) as RETORNO;");
                    ps.setInt(1, Integer.parseInt(paciente));                
                    ps.setDate(2, dataSql);
                    ps.setTime(3,hora);
                }else{
                    ps = connection.prepareStatement("SELECT COUNT (*) FROM (SELECT * FROM agendamento INNER JOIN paciente ON id_paciente_agendamento = cod_paciente WHERE  cod_paciente= ? and data_agendamento = ? and hora_agendamento = ? and cod_agendamento != ?) as RETORNO;");
                    ps.setInt(1, Integer.parseInt(paciente));                
                    ps.setDate(2, dataSql);
                    ps.setTime(3,hora);
                    ps.setInt(4, Integer.parseInt(codigoAgendamento)); 
                }
                System.out.println(ps.toString());
                ResultSet rt = ps.executeQuery();
                rt.next();
                if(rt.getInt(1)!= 0){
                    %><registros>pacienteEmConsulta</registros><%
                    rt.close();
                }else{
                    %><registros>agendamentoPermitido</registros><%
                    rt.close();
                }
            }
            rs.close();
            ps.close();
            connection.close();
        } catch (SQLException e) {
            String msg = "Ocorreu um erro ao tentar validar agendamento.\n\nSQLException em getAgendamentoMesmoHorario.jsp: " + e.getMessage();
            System.out.println(msg);
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }  catch (Exception e) {
            String msg = "Ocorreu um erro ao tentar validar agendamento.\n\nException em getAgendamentoMesmoHorario.jsp: " + e.getMessage();
            System.out.println(msg);
            msg = toISO88591(msg);
            %><result><%=msg%></result><%
        }
    %></contagem>