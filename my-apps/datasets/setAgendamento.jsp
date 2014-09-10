<%@page import="BD.GetDBConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="java.util.Date"%>

<agendamento><%!
     /* Conversão de tipos para tratar caracteres com acento  Openlaszlo  Postgres */
    String toUTF8(String text) throws Exception {
        byte p[] = text.getBytes("ISO-8859-1");
        return new String(p, 0, p.length, "UTF-8");
    }

    /* Conversão de tipos para tratar caracteres com acento  Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        byte p[] = text.getBytes("UTF-8");
        return new String(p, 0, p.length, "ISO-8859-1");
    }

    %><%
    
    String opcao = request.getParameter("acao");
    System.out.println("opcao " + opcao);
    String codAgendamento = request.getParameter("codAgendamento");
    System.out.println("codAgendamento "+codAgendamento);
    String codProfissional = request.getParameter("codProfissional");
    System.out.println("codProfissional "+codProfissional);
    String codPaciente = request.getParameter("codPaciente");
    System.out.println("codPaciente "+codPaciente);
    String dataAgendamento = request.getParameter("dataAgendamento");
    System.out.println(dataAgendamento);
    String horaAgendamento = request.getParameter("horaAgendamento");
    System.out.println(horaAgendamento);
    String observacaoAgendamento = request.getParameter("observacaoAgendamento");
    System.out.println("Observação "+observacaoAgendamento);
    String statusAgendamento = request.getParameter("statusAgendamento");
    System.out.println("status " + statusAgendamento);
       
    SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat formataHora = new SimpleDateFormat("HH:mm");

    Date data = null;
    java.sql.Date dataSql = null;
    
    Time hora = null;
    java.sql.Time horaSql = null;
    
    observacaoAgendamento = toUTF8(observacaoAgendamento);
    
    String sqlAgendamento = "";

    if (opcao.equals("insert")) {
        sqlAgendamento = "INSERT INTO agendamento (id_profissional_agendamento, id_paciente_agendamento, data_agendamento, hora_agendamento, observacao_agendamento, status_agendamento) values (?,?,?,?,?,?) ";
    }
    else if (opcao.equals("update")) {
        sqlAgendamento = "UPDATE agendamento SET id_profissional_agendamento= ?, id_paciente_agendamento = ?, data_agendamento = ?, hora_agendamento = ?, observacao_agendamento = ?, status_agendamento = ? WHERE cod_agendamento = ? ";
    }
    
    
    Connection connection = GetDBConnection.getConnection();
    connection.setAutoCommit(false);
    
    try {
        PreparedStatement stmt = connection.prepareStatement(sqlAgendamento);;
        System.out.println("depois do prepare statement");
        if (opcao.equals("insert")) {
            stmt.setInt(1, Integer.parseInt(codProfissional) );
            stmt.setInt(2, Integer.parseInt(codPaciente));
            
            data = formatador.parse(dataAgendamento);
            dataSql = new java.sql.Date(data.getTime());
            stmt.setDate(3, dataSql);

            data = formataHora.parse(horaAgendamento);
            hora = new Time(data.getTime());
            stmt.setTime(4, hora);

            stmt.setString(5,observacaoAgendamento);
            stmt.setInt(6,Integer.parseInt(statusAgendamento));
           
            System.out.println("STMT DE INSERÇÂO "+stmt);            
            
            System.out.println("Cheguei no insert agendamento do jsp");
            stmt.executeUpdate();
            connection.commit();
            %><result>Inserido</result><%
            System.out.println("Tudo ok na insercao de Agendamento\n\n");
               
        }else if (opcao.equals("update")) {
            stmt.setInt(1, Integer.parseInt(codProfissional ));
            stmt.setInt(2, Integer.parseInt(codPaciente));
            
            data = formatador.parse(dataAgendamento);
            dataSql = new java.sql.Date(data.getTime());
            stmt.setDate(3, dataSql);
            
            data = formataHora.parse(horaAgendamento);
            hora = new Time(data.getTime());
            stmt.setTime(4, hora);
            
            stmt.setString(5,observacaoAgendamento);
            stmt.setInt(6,Integer.parseInt(statusAgendamento));
            stmt.setInt(7,Integer.parseInt(codAgendamento));
            stmt.executeUpdate();
            connection.commit();
            System.out.println("Tudo ok na atualização de paciente ");
            %><result>Atualizado</result><%     
        }
        stmt.close();
        connection.close();
    }
    catch (SQLException e) {
        connection.rollback();
        String msg = "Erro ao tentar persistir dados de agendamento.\n\nSQLException em setAgendamento.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        %><result><%=msg%></result><%
                
    } catch (Exception e) {
        connection.rollback();
        String msg = "Erro ao tentar persistir dados de agendamento.\n\nException em setAgendamento.jsp: " + e.getMessage();
        msg = toISO88591(msg);
        System.out.println(msg);
        %><result><%=msg%></result><%
    }%>    

</agendamento>