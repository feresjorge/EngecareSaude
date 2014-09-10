<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>

<%@ include file="getPessoa.jsp"%>

<profissionais><%!    /* Conversão de tipos para tratar caracteres com acento -- Postgres -> Openlaszlo */
    String toISO88591(String text) throws Exception {
        if("Indef.".equals(text)){
            return "";
        }else{
            byte p[] = text.getBytes("UTF-8");
            return new String(p, 0, p.length, "ISO-8859-1");
        }
    }
    
     String toUTF8(String text) throws Exception {
        byte p[] = text.getBytes("ISO-8859-1");
        return new String(p, 0, p.length, "UTF-8");
    }
    %><%
        String textoGridVazia = null;
        
        String nomeProfissional = request.getParameter("nomeProfissional");
        
        
        if(nomeProfissional !=""){
            nomeProfissional = toUTF8(nomeProfissional);
            textoGridVazia = "A pesquisa por '" + nomeProfissional + "' não retornou nenhum resultado";
        } else {
            textoGridVazia = "A pesquisa não retornou nenhum resultado";
        }
        textoGridVazia = toISO88591(textoGridVazia);
        
        String tipoPesquisa = request.getParameter("tipoPesquisa");
        tipoPesquisa = toUTF8(tipoPesquisa);
        
        String areaSelecionada = request.getParameter("areaSelecionada");
        areaSelecionada = toUTF8(areaSelecionada);
        
        Connection connection = null;

        String selectProfissional = "";

        if(nomeProfissional == ""){
            if("Todas as Áreas".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                        // seleciona disponives para usuario
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional
                        selectProfissional = "SELECT * FROM profissional ORDER BY cod_profissional;";
                }
            } else if("Serviço Odontológico".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional e agendamento
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"'ORDER BY cod_profissional;";
                }
            } else if("Serviço Psicológico".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional e agendamento
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"'ORDER BY cod_profissional;";
                }
            } else if("Informática".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"'ORDER BY cod_profissional;";
                }
            } else if("Recepção".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"'ORDER BY cod_profissional;";
                }
            }
        }else if(nomeProfissional != ""){
            if("Todas as Áreas".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                        // seleciona disponives para usuario
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional
                        selectProfissional = "SELECT * FROM profissional WHERE id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' )  ORDER BY cod_profissional ;";
                }
            } else if("Serviço Odontológico".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional e agendamento
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }
            } else if("Serviço Psicológico".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional e agendamento
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional ;";
                }
            } else if("Informática".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }
            } else if("Recepção".equals(areaSelecionada)){
                if("semUsuario".equals(tipoPesquisa)){
                    //selectParaUsuario(busca todos profissionais do setor odontologico sem usuario)
                    selectProfissional = "SELECT * FROM profissional WHERE cod_profissional NOT IN (SELECT id_profissional_usuario FROM usuario) AND area_profissional = '"+ areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }else if ("todosProfissionais".equals(tipoPesquisa)){
                        // lista todos profissionais para Profissional
                    selectProfissional = "SELECT * FROM profissional WHERE area_profissional = '" + areaSelecionada +"' AND id_pessoa_profissional IN (SELECT cod_pessoa FROM pessoa WHERE nome_pessoa LIKE '%"+nomeProfissional+"%' ) ORDER BY cod_profissional;";
                }
            }
        }
        
        try {
            connection = GetDBConnection.getConnection();
            
            Statement stmt = connection.createStatement();

            ResultSet rs = stmt.executeQuery(selectProfissional);
            
            retornoPessoa pessoa = new retornoPessoa();
            
            if (!rs.next()) {
                %><profissional img_status="null" text="<%=textoGridVazia%>"/><%
            } else {
                do {
                    int codPessoa = rs.getInt("id_pessoa_profissional");

                    pessoa.getPessoa(connection, codPessoa);
                    pessoa.nome = toISO88591(pessoa.nome);
                    pessoa.cor = toISO88591(pessoa.cor);
                    pessoa.sexo = toISO88591(pessoa.sexo);
                    
                    if(pessoa.dataNascimento == null){
                        pessoa.dataNascimento = "";
                    }else{
                        pessoa.dataNascimento = toISO88591(pessoa.dataNascimento);
                    }
                    
                    pessoa.estadoCivil = toISO88591(pessoa.estadoCivil);
                    pessoa.cpf = toISO88591(pessoa.cpf);
                    pessoa.rg = toISO88591(pessoa.rg);
                    pessoa.naturalidade = toISO88591(pessoa.naturalidade);
                    pessoa.nacionalidade = toISO88591(pessoa.nacionalidade);
                    pessoa.cep = toISO88591(pessoa.cep);
                    pessoa.estado = toISO88591(pessoa.estado);
                    pessoa.cidade = toISO88591(pessoa.cidade);
                    pessoa.bairro = toISO88591(pessoa.bairro);
                    pessoa.endereco = toISO88591(pessoa.endereco);
                    pessoa.email = toISO88591(pessoa.email);
                    pessoa.telefone = toISO88591(pessoa.telefone);
                    pessoa.celular = toISO88591(pessoa.celular);
                    pessoa.fax = toISO88591(pessoa.fax);
                    pessoa.foto = toISO88591(pessoa.foto);

                    String ctps = rs.getString("ctps_profissional");
                    ctps = toISO88591(ctps);
                    
                    String numSiape = rs.getString("num_siape_profissional");
                    numSiape = toISO88591(numSiape);
                    
                    String area = rs.getString ("area_profissional");
                    area = toISO88591(area);
                    
                    String funcao = rs.getString("funcao_profissional");
                    //funcao = toISO88591(funcao);

                    if (pessoa.erro == 1) {
                        pessoa.erro = 0;
                        System.out.println("Erro na busca de pessoa");
                        break;
                    }

                    String status = null;
                    String img_status = null;

                    if(rs.getInt("status_profissional") == 0){
                        status = "inativo";
                        img_status = "inativo.png";
                    } else if (rs.getInt("status_profissional") == 1){
                        status = "ativo";
                        img_status = "ativo.png";
                    }

                    status = toISO88591(status);
                    img_status = toISO88591(img_status);
                    
                    int cod = rs.getInt("cod_profissional");
                    String codProfissional = null;
                    if(cod > 0 && cod < 10){
                       codProfissional = "00" + String.valueOf(cod);
                    } else if(cod >= 10 && cod < 100){
                       codProfissional = "0" + String.valueOf(cod);
                    } else {
                       codProfissional = String.valueOf(cod);
                    }

                    %><profissional codProfissional="<%=codProfissional%>" idPessoa="<%=codPessoa%>" 
                      ctpsProfissional="<%=ctps%>" numSiapeProfissional="<%=numSiape%>" 
                      nomeProfissional="<%=pessoa.nome%>" corProfissional="<%=pessoa.cor%>" 
                      sexoProfissional="<%=pessoa.sexo%>" dataNascimentoProfissional="<%=pessoa.dataNascimento%>"
                      estadoCivilProfissional="<%=pessoa.estadoCivil%>" cpfProfissional="<%=pessoa.cpf%>" 
                      rgProfissional="<%=pessoa.rg%>" naturalidadeProfissional="<%=pessoa.naturalidade%>" 
                      nacionalidadeProfissional="<%=pessoa.nacionalidade%>" enderecoProfissional="<%=pessoa.endereco%>" 
                      bairroProfissional="<%=pessoa.bairro%>" cidadeProfissional="<%=pessoa.cidade%>" 
                      estadoProfissional="<%=pessoa.estado%>" cepProfissional="<%=pessoa.cep%>" 
                      emailProfissional="<%=pessoa.email%>" telefoneProfissional="<%=pessoa.telefone%>" 
                      celularProfissional="<%=pessoa.celular%>" faxProfissional="<%=pessoa.fax%>" 
                      areaProfissional="<%=area%>" funcaoProfissional="<%=StringEscapeUtils.escapeXml(funcao)%>" 
                      img_status="<%=img_status%>" status="<%=status%>" text="temRegistro"/><%
                  } while (rs.next());
               }
              rs.close();
              stmt.close();
              connection.close();

          } catch (SQLException e) {
             String msg = "Erro ao tentar buscar profissional.\n\nSQLException em getProfissional.jsp: " + e.getMessage();
             System.out.println(msg);
             msg = toISO88591(msg);
             
             textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
             %><profissional img_status="null" text="<%=textoGridVazia%>" error="Erro ao tentar buscar profissional.\n\nSQLException em getProfissional.jsp"/><%
          } catch (Exception e) {
             String msg = "Erro ao tentar buscar profissional.\n\nException em getProfissional.jsp: " + e.getMessage();
             System.out.println(msg);
             msg = toISO88591(msg);
             
             textoGridVazia = "Ocorreu um erro, favor entrar em contato com o administrador.";
             %><profissional img_status="null" text="<%=textoGridVazia%>" error="Erro ao tentar buscar profissional.\n\nException em getProfissional.jsp"/><%
          }
    %>
</profissionais>