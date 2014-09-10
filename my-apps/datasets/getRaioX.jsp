<%@page import="java.util.ArrayList"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%><%@ page import="BD.GetDBConnection"%>

<exames>
    <%!
        /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
        String toISO88591(String text) throws Exception {
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    %> 
    <%
        String nome = request.getParameter("nome");
        String laudado = request.getParameter("laudado");
        laudado = laudado.toUpperCase();

        SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
        Date data = null;
        String dataExame = "";

        PreparedStatement ps = null;
        Connection connection = null;

        try {
            connection = GetDBConnection.getConnection();

            if (nome == null) {
                ps = connection.prepareStatement("SELECT * FROM exame_raiox WHERE laudado='" + laudado + "'");
            } else {
                ps = connection.prepareStatement("SELECT * FROM exame_raiox WHERE nome_paciente LIKE '%" + nome + "%' AND laudado='" + laudado + "'");
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String nome_paciente = rs.getString("nome_paciente");
                nome_paciente = toISO88591(nome_paciente);
                
                data = rs.getDate("data_exame");
                dataExame = formatador.format(data);
                
                String convenio = rs.getString("convenio");
                convenio = toISO88591(convenio);

                String outras_informacoes = rs.getString("outras_informacoes");
                outras_informacoes = toISO88591(outras_informacoes);

                String medico_solicitante = rs.getString("medico_solicitante");
                medico_solicitante = toISO88591(medico_solicitante);

                /* valores do banco, separados assim para montar a coluna Tipo de Exame da grid */
                String abdomen = rs.getString("abdomen");
                String artOssos = rs.getString("art_ossos");
                String cavum = rs.getString("cavum");
                String coluna = rs.getString("coluna");
                String cranio = rs.getString("cranio");
                String torax = rs.getString("torax");
                String seiosFace = rs.getString("seios_face");

                String tipoExame = "";

                if ("true".equals(abdomen)) {
                    tipoExame = tipoExame.concat("Abdômen");
                }
                if ("true".equals(artOssos)) {
                    if (tipoExame.length() > 0) {
                        tipoExame = tipoExame.concat(", ");
                    }
                    tipoExame = tipoExame.concat("Art. e Ossos Longos");
                }
                if ("true".equals(cavum)) {
                    if (tipoExame.length() > 0) {
                        tipoExame = tipoExame.concat(", ");
                    }
                    tipoExame = tipoExame.concat("Cavum");
                }
                if ("true".equals(coluna)) {
                    if (tipoExame.length() > 0) {
                        tipoExame = tipoExame.concat(", ");
                    }
                    tipoExame = tipoExame.concat("Coluna");
                }
                if ("true".equals(cranio)) {
                    if (tipoExame.length() > 0) {
                        tipoExame = tipoExame.concat(", ");
                    }
                    tipoExame = tipoExame.concat("Cranio");
                }
                if ("true".equals(torax)) {
                    if (tipoExame.length() > 0) {
                        tipoExame = tipoExame.concat(", ");
                    }
                    tipoExame = tipoExame.concat("Torax");
                }
                if ("true".equals(seiosFace)) {
                    if (tipoExame.length() > 0) {
                        tipoExame = tipoExame.concat(", ");
                    }
                    tipoExame = tipoExame.concat("Seios da Face");
                }

                tipoExame = toISO88591(tipoExame);

    %><grids id="<%=rs.getInt("cod_raiox")%>" nome="<%=nome_paciente%>" idade="<%=rs.getInt("idade_paciente")%>" 
           tel_emerg="<%=rs.getString("tel_emerg")%>" sexo_paciente="<%=rs.getString("sexo_paciente")%>"
           data_exame="<%=dataExame%>" qtde_exames="<%=rs.getInt("qtde_exames")%>" convenio="<%=convenio%>"  
           medico_solicitante="<%=medico_solicitante%>" tamanho_exame="<%=rs.getString("tamanho_exame")%>" 
           outras_informacoes="<%=outras_informacoes%>" abdomen="<%=abdomen%>"  art_ossos="<%=artOssos%>" 
           cavum="<%=cavum%>" coluna="<%=coluna%>" cranio="<%=cranio%>" torax="<%=torax%>" 
           seios_face="<%=seiosFace%>" tipo_exame="<%=tipoExame%>"/><%
               }
       rs.close();
       ps.close();
       connection.close();
     } catch (SQLException e) {
         String msg = "Erro ao tentar buscar raio-x.\n\nSQLException em getRaioX.jsp: " + e.getMessage();
         %><result><%=msg%></result><%
     } catch (Exception e) {
         String msg = "Erro ao tentar buscar raio-x.\n\nException em getRaioX.jsp: " + e.getMessage();
         %><result><%=msg%></result><%
     }
    %>
</exames>