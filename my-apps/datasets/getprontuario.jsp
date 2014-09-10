<%@ page import="BD.GetDBConnection"%>
<%@ page import="java.sql.*"%><prontuarios><%

    Connection connection = null;

    String pid = request.getParameter("pid");
    //String pid = "10002295";


    try {

        connection = GetDBConnection.getConnection();

        PreparedStatement ps = connection.prepareStatement("select * from prontuario_odontologico where pid_paciente= ? ");

        ps.setInt(1, Integer.parseInt(pid));

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

    %>

    <prontuario_odontologico pid="<%=rs.getInt("pid_paciente")%>" doencas="<%=rs.getString("doencas")%>"
                             tratamento="<%=rs.getString("tratamento")%>" gravida="<%=rs.getBoolean("gravida")%>"
                             amamenta="<%=rs.getBoolean("amamenta")%>" bebe="<%=rs.getBoolean("bebe")%>"
                             fuma="<%=rs.getBoolean("fuma")%>" medicacao="<%=rs.getString("medicacao")%>"
                             aomedico="<%=rs.getString("aomedico")%>" exame="<%=rs.getString("exame")%>" alteracao="<%=rs.getString("alteracao")%>"
                             operacao="<%=rs.getString("operacao")%>" hospitalizado="<%=rs.getString("hospitalizado")%>"
                             alergico="<%=rs.getString("alergico")%>" problemas_cicatrizacao="<%=rs.getBoolean("problemas_cicatrizacao")%>"
                             problemas_anestesia="<%=rs.getBoolean("problemas_anestesia")%>" anestesia_dentaria="<%=rs.getBoolean("anestesia_dentaria")%>"
                             reacao="<%=rs.getString("reacao")%>" urticaria="<%=rs.getBoolean("urticaria")%>" problema_pressao="<%=rs.getBoolean("problema_pressao")%>"
                             hemorragias="<%=rs.getBoolean("hemorragias")%>" sangra_muito_tempo="<%=rs.getBoolean("sangra_muito_tempo")%>"
                             custa_cicatrizar="<%=rs.getBoolean("custa_cicatrizar")%>" pressao_alterada="<%=rs.getString("pressao_alterada")%>"
                             extraiu="<%=rs.getString("extraiu")%>" doenca_grave="<%=rs.getString("doenca_grave")%>"
                             peso="<%=rs.getString("peso")%>" cirurgia_boca="<%=rs.getString("cirurgia_boca")%>"
                             gengiva_sangra="<%=rs.getString("gengiva_sangra")%>" tratamento_periodontal="<%=rs.getString("tratamento_periodontal")%>"
                             tratamento_endodontico="<%=rs.getString("tratamento_endodontico")%>" tratamento_ortodontico="<%=rs.getString("tratamento_ortodontico")%>"
                             dentista="<%=rs.getString("dentista")%>" escova_frenquencia="<%=rs.getString("escova_frequencia")%>"
                             fio_dental_frequencia="<%=rs.getString("fio_dental_frequencia")%>" escova_marca="<%=rs.getString("escova_marca")%>"
                             escova_resistencia="<%=rs.getString("escova_resistencia")%>" creme_dental_marca="<%=rs.getString("creme_dental_marca")%>"
                             drogas="<%=rs.getString("drogas")%>" protese="<%=rs.getBoolean("protese")%>" mau_halito="<%=rs.getBoolean("mau_halito")%>"
                             limpar_lingua="<%=rs.getBoolean("limpar_lingua")%>" aftas="<%=rs.getBoolean("aftas")%>" comer_habito="<%=rs.getBoolean("comer_habito")%>"

                             anemia="<%=rs.getBoolean("anemia")%>" asma="<%=rs.getBoolean("asma")%>" cancer="<%=rs.getBoolean("cancer")%>"
                             convulsao="<%=rs.getBoolean("convulsao")%>" depressao="<%=rs.getBoolean("depressao")%>" desmaio="<%=rs.getBoolean("desmaio")%>"
                             diabetes="<%=rs.getBoolean("diabetes")%>" epilepsia="<%=rs.getBoolean("epilepsia")%>" febre="<%=rs.getBoolean("febre")%>"
                             gastrite="<%=rs.getBoolean("gastrite")%>" glaucoma="<%=rs.getBoolean("glaucoma")%>" hemofilia="<%=rs.getBoolean("hemofilia")%>"
                             hemorragia="<%=rs.getBoolean("hemorragia")%>" hepatite="<%=rs.getBoolean("hepatite")%>" hipertensao="<%=rs.getBoolean("hipertensao")%>"
                             hipoglicemia="<%=rs.getBoolean("hipoglicemia")%>" hiv="<%=rs.getBoolean("hiv")%>" leucemia="<%=rs.getBoolean("leucemia")%>"
                             problemas_articulares="<%=rs.getBoolean("problemas_articulares")%>" problemas_cardiacos="<%=rs.getBoolean("problemas_cardiacos")%>"
                             problemas_tireoide="<%=rs.getBoolean("problemas_tireoide")%>" problemas_gastricos="<%=rs.getBoolean("problemas_gastricos")%>"
                             problemas_neurologicos="<%=rs.getBoolean("problemas_neurologicos")%>" problemas_renais="<%=rs.getBoolean("problemas_renais")%>"
                             problemas_respiratorios="<%=rs.getBoolean("problemas_respiratorios")%>" osteoporose="<%=rs.getBoolean("osteoporose")%>"
                             sinusite="<%=rs.getBoolean("sinusite")%>" sifilis="<%=rs.getBoolean("sifilis")%>" tuberculose="<%=rs.getBoolean("tuberculose")%>"
                             tumor="<%=rs.getBoolean("tumor")%>" ulcera="<%=rs.getBoolean("ulcera")%>" outros="<%=rs.getString("outros")%>"

                             observacoes_clinicas="<%=rs.getString("observacoes_clinicas")%>"
                             
                             plano1="<%=rs.getString("plano_tratamento1")%>" plano2="<%=rs.getString("plano_tratamento2")%>"
                             plano3="<%=rs.getString("plano_tratamento3")%>" plano_escolhido="<%=rs.getString("plano_tratamento_escolhido")%>"/><%
        }

            rs.close();
            ps.close();
            connection.close();

            } catch (SQLException e) {
                // escreve o erro no arquivo de log do Tomcat 6.0 (stdout.log)
                out.println("SQLException: " + e.getMessage() /* + "<BR>"*/);

            }

%>
</prontuarios>
