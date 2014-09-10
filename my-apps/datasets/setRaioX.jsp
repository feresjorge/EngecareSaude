<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<%!  
    /* Conversão de tipos para tratar caracteres com acento -- Openlaszlo -> Postgres */
    String toUTF8(String text) throws Exception{
        byte p[] = text.getBytes("ISO-8859-1");
        return new String(p, 0, p.length, "UTF-8");
    }
    
    /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception{
        byte p[] = text.getBytes("UTF-8");
        return new String(p, 0, p.length, "ISO-8859-1");
    } 
%><%

    String acao = request.getParameter("acao");
    String nome = request.getParameter("nome");
    String idade = request.getParameter("idade");
    String sexo = request.getParameter("sexo");
    String dataExame = request.getParameter("dataExame");
    String qtdeExames = request.getParameter("qtdeExames");
    String telEmergencia = request.getParameter("telEmergencia");
    String convenio = request.getParameter("convenio");
    String medicoSolicitante = request.getParameter("medicoSolicitante");
    String abdomen = request.getParameter("abdomen");
    String artOssos = request.getParameter("artOssos");
    String cavum = request.getParameter("cavum");
    String coluna = request.getParameter("coluna");
    String cranio = request.getParameter("cranio");
    String torax = request.getParameter("torax");
    String seiosFace = request.getParameter("seiosFace");
    String tamanhoExame = request.getParameter("tamanhoExame");
    String outrasInformacoes = request.getParameter("outrasInformacoes");

    nome = toUTF8(nome);
    convenio = toUTF8(convenio);
    medicoSolicitante = toUTF8(medicoSolicitante);
    outrasInformacoes = toUTF8(outrasInformacoes);

    String laudado = "N";

    SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
    Date data = null;
    java.sql.Date dataSql = null;


    String insert = "INSERT INTO exame_raiox (nome_paciente, idade_paciente, sexo_paciente, data_exame, "
            + "qtde_exames, tel_emerg, convenio, medico_solicitante, abdomen, art_ossos, cavum, coluna, cranio, torax, "
            + "seios_face, tamanho_exame, outras_informacoes, laudado) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

    Connection connection = null;
    PreparedStatement ps = null;

    try {
        connection = GetDBConnection.getConnection();

        if (acao.equals("insert")) {
            ps = connection.prepareStatement(insert);
            ps.setString(1, nome);
            ps.setInt(2, Integer.parseInt(idade));
            ps.setString(3, sexo);

            data = formatador.parse(dataExame);
            dataSql = new java.sql.Date(data.getTime());
            ps.setDate(4, dataSql);

            ps.setInt(5, Integer.parseInt(qtdeExames));
            ps.setString(6, telEmergencia);
            ps.setString(7, convenio);
            ps.setString(8, medicoSolicitante);
            ps.setString(9, abdomen);
            ps.setString(10, artOssos);
            ps.setString(11, cavum);
            ps.setString(12, coluna);
            ps.setString(13, cranio);
            ps.setString(14, torax);
            ps.setString(15, seiosFace);
            ps.setString(16, tamanhoExame);
            ps.setString(17, outrasInformacoes);
            ps.setString(18, laudado);
            ps.executeUpdate();

        %><result>sucess</result><%
    }

    ps.close();
    connection.close();

    } catch (SQLException e) {
        String msg = "Erro ao tentar persistir dados de raio-x.\n\nSQLException em setRaioX.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        %><result><%=msg%></result><%
    } catch (Exception e) {
        String msg = "Erro ao tentar persistir dados de raio-x.\n\nException em setRaioX.jsp: " + e.getMessage();
        System.out.println(msg);
        msg = toISO88591(msg);
        %><result><%=msg%></result><%
    }
    %>