<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="java.sql.*"%><%@ page import="logging.Logging"%><%@ page import="BD.GetDBConnection"%><%!
    int trataString(String s) {


        if (s == null) {
            return 0;
        }

        if (s.equals("")) {
            return 0;
        }

        return Integer.parseInt(s);
    }

    boolean trataStringBoolean(String s) {


        if (s.equals("true")) {
            return true;
        }

        return false;
    }


%><%

            String pid = request.getParameter("pid");
            String doencas = request.getParameter("doencas");
            String tratamento = request.getParameter("tratamento");
            String gravida = request.getParameter("gravida");
            String amamenta = request.getParameter("amamenta");
            String bebe = request.getParameter("bebe");
            String fuma = request.getParameter("fuma");
            String medicacao = request.getParameter("medicacao");
            String aomedico = request.getParameter("aomedico");
            String exame = request.getParameter("exame");
            String alteracao = request.getParameter("alteracao");
            String operacao = request.getParameter("operacao");
            String hospitalizado = request.getParameter("hospitalizado");
            String alergico = request.getParameter("alergico");
            String problemas_cicatrizacao = request.getParameter("problemas_cicatrizacao");
            String problemas_anestesia = request.getParameter("problemas_anestesia");
            String anestesia_dentaria = request.getParameter("anestesia_dentaria");
            String reacao = request.getParameter("reacao");
            String urticaria = request.getParameter("urticaria");
            String problema_pressao = request.getParameter("problema_pressao");
            String hemorragias = request.getParameter("hemorragias");
            String sangra_muito_tempo = request.getParameter("sangra_muito_tempo");
            String custa_cicatrizar = request.getParameter("custa_cicatrizar");
            String pressao_alterada = request.getParameter("pressao_alterada");
            String extraiu = request.getParameter("extraiu");
            String doenca_grave = request.getParameter("doenca_grave");
            String peso = request.getParameter("peso");
            String cirurgia_boca = request.getParameter("cirurgia_boca");
            String gengiva_sangra = request.getParameter("gengiva_sangra");
            String tratamento_periodontal = request.getParameter("tratamento_periodontal");
            String tratamento_endodontico = request.getParameter("tratamento_endodontico");
            String tratamento_ortodontico = request.getParameter("tratamento_ortodontico");
            String dentista = request.getParameter("dentista");
            String escova_frenquencia = request.getParameter("escova_frenquencia");
            String fio_dental_frequencia = request.getParameter("fio_dental_frequencia");
            String escova_marca = request.getParameter("escova_marca");
            String escova_resistencia = request.getParameter("escova_resistencia");
            String creme_dental_marca = request.getParameter("creme_dental_marca");
            String drogas = request.getParameter("drogas");
            String protese = request.getParameter("protese");
            String mau_halito = request.getParameter("mau_halito");
            String limpar_lingua = request.getParameter("limpar_lingua");
            String aftas = request.getParameter("aftas");
            String comer_habito = request.getParameter("comer_habito");

            String anemia = request.getParameter("anemia");
            String asma = request.getParameter("asma");
            String cancer = request.getParameter("cancer");
            String convulsao = request.getParameter("convulsao");
            String depressao = request.getParameter("depressao");
            String desmaio = request.getParameter("desmaio");
            String diabetes = request.getParameter("diabetes");
            String epilepsia = request.getParameter("epilepsia");
            String febre = request.getParameter("febre");
            String gastrite = request.getParameter("gastrite");
            String glaucoma = request.getParameter("glaucoma");
            String hemofilia = request.getParameter("hemofilia");
            String hemorragia = request.getParameter("hemorragia");
            String hepatite = request.getParameter("hepatite");
            String hipertensao = request.getParameter("hipertensao");
            String hipoglicemia = request.getParameter("hipoglicemia");
            String hiv = request.getParameter("hiv");
            String leucemia = request.getParameter("leucemia");
            String problemas_articulares = request.getParameter("problemas_articulares");
            String problemas_cardiacos = request.getParameter("problemas_cardiacos");
            String problemas_tireoide = request.getParameter("problemas_tireoide");
            String problemas_gastricos = request.getParameter("problemas_gastricos");
            String problemas_neurologicos = request.getParameter("problemas_neurologicos");
            String problemas_renais = request.getParameter("problemas_renais");
            String problemas_respiratorios = request.getParameter("problemas_respiratorios");
            String osteoporose = request.getParameter("osteoporose");
            String sinusite = request.getParameter("sinusite");
            String sifilis = request.getParameter("sifilis");
            String tuberculose = request.getParameter("tuberculose");
            String tumor = request.getParameter("tumor");
            String ulcera = request.getParameter("ulcera");
            String outros = request.getParameter("outros");

            String observacoes_clinicas = request.getParameter("observacoes_clinicas");

            String plano1 = request.getParameter("plano1");
            String plano2 = request.getParameter("plano2");
            String plano3 = request.getParameter("plano3");
            String plano_escolhido = request.getParameter("plano_escolhido");

            String sql = "SELECT * FROM prontuario_odontologico WHERE pid_paciente = ? ";
            String sql2 = "INSERT INTO prontuario_odontologico (pid_paciente, doencas, tratamento, gravida, amamenta,"
                    + " bebe, fuma, medicacao, aomedico, exame, alteracao, operacao, hospitalizado, alergico, problemas_cicatrizacao,"
                    + " problemas_anestesia, anestesia_dentaria, reacao, urticaria, problema_pressao, hemorragias, sangra_muito_tempo,"
                    + " custa_cicatrizar, pressao_alterada, extraiu, doenca_grave, peso, cirurgia_boca, gengiva_sangra,"
                    + " tratamento_periodontal, tratamento_endodontico, tratamento_ortodontico, dentista, escova_frequencia,"
                    + " fio_dental_frequencia, escova_marca, escova_resistencia, creme_dental_marca, drogas, protese,"
                    + " mau_halito, limpar_lingua, aftas, comer_habito, anemia, asma, cancer, convulsao, depressao,"
                    + " desmaio, diabetes, epilepsia, febre, gastrite, glaucoma, hemofilia, hemorragia, hepatite, hipertensao,"
                    + " hipoglicemia, hiv, leucemia, problemas_articulares, problemas_cardiacos, problemas_tireoide, problemas_gastricos,"
                    + " problemas_neurologicos, problemas_renais, problemas_respiratorios, osteoporose, sinusite, sifilis, tuberculose,"
                    + " tumor, ulcera, outros, observacoes_clinicas, plano_tratamento1, plano_tratamento2, plano_tratamento3, plano_tratamento_escolhido)" +
                      "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"
                      + " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            String sql3 = "UPDATE prontuario_odontologico SET doencas = ?, tratamento = ?, gravida = ?, amamenta = ?,"
                    + " bebe = ?, fuma = ?, medicacao= ?, aomedico= ?, exame= ?, alteracao= ?, operacao= ?, hospitalizado= ?, alergico= ?, problemas_cicatrizacao= ?,"
                    + " problemas_anestesia = ?, anestesia_dentaria = ?, reacao = ?, urticaria = ?, problema_pressao = ?, hemorragias = ?, sangra_muito_tempo = ?,"
                    + " custa_cicatrizar = ?, pressao_alterada = ?, extraiu = ?, doenca_grave = ?, peso = ?, cirurgia_boca = ?, gengiva_sangra = ?,"
                    + " tratamento_periodontal = ?, tratamento_endodontico = ?, tratamento_ortodontico = ?, dentista = ?, escova_frequencia = ?,"
                    + " fio_dental_frequencia = ?, escova_marca = ?, escova_resistencia = ?, creme_dental_marca = ?, drogas = ?, protese = ?,"
                    + " mau_halito = ?, limpar_lingua = ?, aftas = ?, comer_habito = ?, anemia = ?, asma = ?, cancer = ?, convulsao = ?, depressao = ?,"
                    + " desmaio = ?, diabetes = ?, epilepsia = ?, febre = ?, gastrite = ?, glaucoma = ?, hemofilia = ?, hemorragia = ?, hepatite = ?, hipertensao = ?,"
                    + " hipoglicemia = ?, hiv = ?, leucemia = ?, problemas_articulares = ?, problemas_cardiacos = ?, problemas_tireoide = ?, problemas_gastricos = ?,"
                    + " problemas_neurologicos = ?, problemas_renais = ?, problemas_respiratorios = ?, osteoporose = ?, sinusite = ?, sifilis = ?, tuberculose = ?,"
                    + " tumor = ?, ulcera = ?, outros = ?, observacoes_clinicas = ?, plano_tratamento1 = ?, plano_tratamento2 = ?, plano_tratamento3 = ?, plano_tratamento_escolhido = ?"
                    + " WHERE pid_paciente = ?";

            //String sql4 = "DELETE FROM profissionais WHERE cpf = ? ";

            Connection connection = null;
            PreparedStatement ps = null;

            try {

                connection = GetDBConnection.getConnection();// 2

                ps = connection.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(pid));
                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {


                    ps = connection.prepareStatement(sql2);

                    
                    ps.setInt(1, trataString(pid));

                    ps.setString(2, doencas);
                    ps.setString(3, tratamento);
                    ps.setBoolean(4, trataStringBoolean(gravida));
                    ps.setBoolean(5, trataStringBoolean(amamenta));
                    ps.setBoolean(6, trataStringBoolean(bebe));
                    ps.setBoolean(7, trataStringBoolean(fuma));
                    ps.setString(8, medicacao);
                    ps.setString(9, aomedico);
                    ps.setString(10, exame);
                    ps.setString(11, alteracao);
                    ps.setString(12, operacao);
                    ps.setString(13, hospitalizado);
                    ps.setString(14, alergico);
                    ps.setBoolean(15, trataStringBoolean(problemas_cicatrizacao));
                    ps.setBoolean(16, trataStringBoolean(problemas_anestesia));
                    ps.setBoolean(17, trataStringBoolean(anestesia_dentaria));
                    ps.setString(18, reacao);
                    ps.setBoolean(19, trataStringBoolean(urticaria));
                    ps.setBoolean(20, trataStringBoolean(problema_pressao));
                    ps.setBoolean(21, trataStringBoolean(hemorragias));
                    ps.setBoolean(22, trataStringBoolean(sangra_muito_tempo));
                    ps.setBoolean(23, trataStringBoolean(custa_cicatrizar));
                    ps.setString(24, pressao_alterada);
                    ps.setString(25, extraiu);
                    ps.setString(26, doenca_grave);
                    ps.setString(27, peso);
                    ps.setString(28, cirurgia_boca);
                    ps.setString(29, gengiva_sangra);
                    ps.setString(30, tratamento_periodontal);
                    ps.setString(31, tratamento_endodontico);
                    ps.setString(32, tratamento_ortodontico);
                    ps.setString(33, dentista);
                    ps.setString(34, escova_frenquencia);
                    ps.setString(35, fio_dental_frequencia);
                    ps.setString(36, escova_marca);
                    ps.setString(37, escova_resistencia);
                    ps.setString(38, creme_dental_marca);
                    ps.setString(39, drogas);
                    ps.setBoolean(40, trataStringBoolean(protese));
                    ps.setBoolean(41, trataStringBoolean(mau_halito));
                    ps.setBoolean(42, trataStringBoolean(limpar_lingua));
                    ps.setBoolean(43, trataStringBoolean(aftas));
                    ps.setBoolean(44, trataStringBoolean(comer_habito));

                    ps.setBoolean(45, trataStringBoolean(anemia));
                    ps.setBoolean(46, trataStringBoolean(asma));
                    ps.setBoolean(47, trataStringBoolean(cancer));
                    ps.setBoolean(48, trataStringBoolean(convulsao));
                    ps.setBoolean(49, trataStringBoolean(depressao));
                    ps.setBoolean(50, trataStringBoolean(desmaio));
                    ps.setBoolean(51, trataStringBoolean(diabetes));
                    ps.setBoolean(52, trataStringBoolean(epilepsia));
                    ps.setBoolean(53, trataStringBoolean(febre));
                    ps.setBoolean(54, trataStringBoolean(gastrite));
                    ps.setBoolean(55, trataStringBoolean(glaucoma));
                    ps.setBoolean(56, trataStringBoolean(hemofilia));
                    ps.setBoolean(57, trataStringBoolean(hemorragia));
                    ps.setBoolean(58, trataStringBoolean(hepatite));
                    ps.setBoolean(59, trataStringBoolean(hipertensao));
                    ps.setBoolean(60, trataStringBoolean(hipoglicemia));
                    ps.setBoolean(61, trataStringBoolean(hiv));
                    ps.setBoolean(62, trataStringBoolean(leucemia));
                    ps.setBoolean(63, trataStringBoolean(problemas_articulares));
                    ps.setBoolean(64, trataStringBoolean(problemas_cardiacos));
                    ps.setBoolean(65, trataStringBoolean(problemas_tireoide));
                    ps.setBoolean(66, trataStringBoolean(problemas_gastricos));
                    ps.setBoolean(67, trataStringBoolean(problemas_neurologicos));
                    ps.setBoolean(68, trataStringBoolean(problemas_renais));
                    ps.setBoolean(69, trataStringBoolean(problemas_respiratorios));
                    ps.setBoolean(70, trataStringBoolean(osteoporose));
                    ps.setBoolean(71, trataStringBoolean(sinusite));
                    ps.setBoolean(72, trataStringBoolean(sifilis));
                    ps.setBoolean(73, trataStringBoolean(tuberculose));
                    ps.setBoolean(74, trataStringBoolean(tumor));
                    ps.setBoolean(75, trataStringBoolean(ulcera));
                    ps.setString(76, outros);

                    ps.setString(77, observacoes_clinicas);

                    ps.setString(78, plano1);
                    ps.setString(79, plano2);
                    ps.setString(80, plano3);
                    ps.setString(81, plano_escolhido);




                    ps.executeUpdate();

                    //Logging.gravaLog("Profissional " + nome +  " registrado por " + create_id + ".");


                } else {

                    ps = connection.prepareStatement(sql3);

                    ps.setString(1, doencas);
                    ps.setString(2, tratamento);
                    ps.setBoolean(3, trataStringBoolean(gravida));
                    ps.setBoolean(4, trataStringBoolean(amamenta));
                    ps.setBoolean(5, trataStringBoolean(bebe));
                    ps.setBoolean(6, trataStringBoolean(fuma));
                    ps.setString(7, medicacao);
                    ps.setString(8, aomedico);
                    ps.setString(9, exame);
                    ps.setString(10, alteracao);
                    ps.setString(11, operacao);
                    ps.setString(12, hospitalizado);
                    ps.setString(13, alergico);
                    ps.setBoolean(14, trataStringBoolean(problemas_cicatrizacao));
                    ps.setBoolean(15, trataStringBoolean(problemas_anestesia));
                    ps.setBoolean(16, trataStringBoolean(anestesia_dentaria));
                    ps.setString(17, reacao);
                    ps.setBoolean(18, trataStringBoolean(urticaria));
                    ps.setBoolean(19, trataStringBoolean(problema_pressao));
                    ps.setBoolean(20, trataStringBoolean(hemorragias));
                    ps.setBoolean(21, trataStringBoolean(sangra_muito_tempo));
                    ps.setBoolean(22, trataStringBoolean(custa_cicatrizar));
                    ps.setString(23, pressao_alterada);
                    ps.setString(24, extraiu);
                    ps.setString(25, doenca_grave);
                    ps.setString(26, peso);
                    ps.setString(27, cirurgia_boca);
                    ps.setString(28, gengiva_sangra);
                    ps.setString(29, tratamento_periodontal);
                    ps.setString(30, tratamento_endodontico);
                    ps.setString(31, tratamento_ortodontico);
                    ps.setString(32, dentista);
                    ps.setString(33, escova_frenquencia);
                    ps.setString(34, fio_dental_frequencia);
                    ps.setString(35, escova_marca);
                    ps.setString(36, escova_resistencia);
                    ps.setString(37, creme_dental_marca);
                    ps.setString(38, drogas);
                    ps.setBoolean(39, trataStringBoolean(protese));
                    ps.setBoolean(40, trataStringBoolean(mau_halito));
                    ps.setBoolean(41, trataStringBoolean(limpar_lingua));
                    ps.setBoolean(42, trataStringBoolean(aftas));
                    ps.setBoolean(43, trataStringBoolean(comer_habito));                    

                    ps.setBoolean(44, trataStringBoolean(anemia));
                    ps.setBoolean(45, trataStringBoolean(asma));
                    ps.setBoolean(46, trataStringBoolean(cancer));
                    ps.setBoolean(47, trataStringBoolean(convulsao));
                    ps.setBoolean(48, trataStringBoolean(depressao));
                    ps.setBoolean(49, trataStringBoolean(desmaio));
                    ps.setBoolean(50, trataStringBoolean(diabetes));
                    ps.setBoolean(51, trataStringBoolean(epilepsia));
                    ps.setBoolean(52, trataStringBoolean(febre));
                    ps.setBoolean(53, trataStringBoolean(gastrite));
                    ps.setBoolean(54, trataStringBoolean(glaucoma));
                    ps.setBoolean(55, trataStringBoolean(hemofilia));
                    ps.setBoolean(56, trataStringBoolean(hemorragia));
                    ps.setBoolean(57, trataStringBoolean(hepatite));
                    ps.setBoolean(58, trataStringBoolean(hipertensao));
                    ps.setBoolean(59, trataStringBoolean(hipoglicemia));
                    ps.setBoolean(60, trataStringBoolean(hiv));
                    ps.setBoolean(61, trataStringBoolean(leucemia));
                    ps.setBoolean(62, trataStringBoolean(problemas_articulares));
                    ps.setBoolean(63, trataStringBoolean(problemas_cardiacos));
                    ps.setBoolean(64, trataStringBoolean(problemas_tireoide));
                    ps.setBoolean(65, trataStringBoolean(problemas_gastricos));
                    ps.setBoolean(66, trataStringBoolean(problemas_neurologicos));
                    ps.setBoolean(67, trataStringBoolean(problemas_renais));
                    ps.setBoolean(68, trataStringBoolean(problemas_respiratorios));
                    ps.setBoolean(69, trataStringBoolean(osteoporose));
                    ps.setBoolean(70, trataStringBoolean(sinusite));
                    ps.setBoolean(71, trataStringBoolean(sifilis));
                    ps.setBoolean(72, trataStringBoolean(tuberculose));
                    ps.setBoolean(73, trataStringBoolean(tumor));
                    ps.setBoolean(74, trataStringBoolean(ulcera));
                    ps.setString(75, outros);

                    ps.setString(76, observacoes_clinicas);

                    ps.setString(77, plano1);
                    ps.setString(78, plano2);
                    ps.setString(79, plano3);
                    ps.setString(80, plano_escolhido);

                    ps.setInt(81, trataString(pid));

                    ps.executeUpdate();

                }
                
                ps.close();
                connection.close();


            } catch (SQLException e) {
                // escreve o erro no arquivo de log do Tomcat 6.0 (stdout.log)
%><result><%out.println("SQLException: " + e.getMessage() /* + "<BR>"*/);

                Logging.gravaLog(e.getMessage());

    %></result><%

            }
    %>
