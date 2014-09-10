<%@page import="BD.GetDBConnection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="java.util.Date"%>

<%!    
    SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");

    int proximoValorPessoaPInsercao(Connection connection) {
        String sqlPessoa = "SELECT NEXTVAL ('pessoa_cod_pessoa_seq')";
        System.out.println("Antes do try de proximo valor pessoa\n");
        try {
            PreparedStatement stmt = connection.prepareStatement(sqlPessoa);
            ResultSet rs = stmt.executeQuery();
            System.out.println("antes de dar next de proximo valor pessoa\n");
            rs.next();
            System.out.println("Depois de dar next de proximo valor pessoa\n");
            int retorno = rs.getInt(1);
            System.out.println("Depois retorno de proximo valor pessoa\n");
            stmt.close();
            rs.close();
            System.out.println("retorno do valor de pessoa no nextval é: " + retorno);
            return retorno;
        } catch (SQLException e) {
            String msg = "SQLException em Proximo next val pessoa: " + e.getMessage();
            System.out.println("erro : " + msg);
            return 0;
        } catch (Exception e) {
            String msg = "Ocorreu um erro ao verificar proximo  next valPessoa: " + e.getMessage();
            System.out.println("erro: " + msg);
            return 0;
        }
    }

    int insereEAtualizaPessoa(Connection connection, int codPessoa, String nome, String etnia, String sexo, String dataNascimento, String estadoCivil, String cpf, String rg, String naturalidade, String nacionalidade, String cep, String estado, String cidade, String bairro, String endereco, String email, String telefone, String celular, String fax, String caminhoFoto, String opcao) {
        System.out.println("data Nascimento dentro da funcao de inserir e Atualizar : " + dataNascimento );
        String sqlPessoa = "";
        if (opcao.equals("insert")) {
            sqlPessoa = "INSERT INTO pessoa (nome_pessoa, etnia_pessoa, sexo_pessoa, data_nascimento_pessoa, estado_civil_pessoa, cpf_pessoa, rg_pessoa, naturalidade_pessoa, nacionalidade_pessoa, cep_pessoa, estado_pessoa, cidade_pessoa, bairro_pessoa, endereco_pessoa, email_pessoa, telefone_pessoa, celular_pessoa, fax_pessoa, caminho_foto_pessoa, cod_pessoa) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";
            System.out.println("sqlPessoa " + sqlPessoa);
        }
        else if (opcao.equals("update")) {
            sqlPessoa = "UPDATE pessoa SET nome_pessoa = ?, etnia_pessoa = ?, sexo_pessoa = ?, data_nascimento_pessoa = ?, estado_civil_pessoa = ?, cpf_pessoa = ?, rg_pessoa = ?, naturalidade_pessoa = ?, nacionalidade_pessoa = ?, cep_pessoa = ?, estado_pessoa = ?, cidade_pessoa = ?, bairro_pessoa = ?, endereco_pessoa = ?, email_pessoa = ?, telefone_pessoa = ?, celular_pessoa = ?, fax_pessoa = ?, caminho_foto_pessoa = ? WHERE cod_pessoa = ? ";
            System.out.println("sqlPessoa " + sqlPessoa);
        }
        Date data = null;
        java.sql.Date dataSql = null;
        try {
            PreparedStatement stmt = connection.prepareStatement(sqlPessoa);
            data = new Date();
            
            stmt.setString(1, nome);
            stmt.setString(2, etnia);
            stmt.setString(3, sexo);
            
            System.out.println("cheguei antes de data nascimento, com valor " + dataNascimento);
            
            if(! "Indef.".equals(dataNascimento)){
                data = formatador.parse(dataNascimento);
                dataSql = new java.sql.Date(data.getTime());
                stmt.setDate(4, dataSql);
            }else{
                stmt.setDate(4, null);
            }
            stmt.setString(5, estadoCivil);
            stmt.setString(6, cpf);
            stmt.setString(7, rg);
            stmt.setString(8, naturalidade);
            stmt.setString(9, nacionalidade);
            stmt.setString(10, cep);
            stmt.setString(11, estado);
            stmt.setString(12, cidade);
            stmt.setString(13, bairro);
            stmt.setString(14, endereco);
            stmt.setString(15, email);
            stmt.setString(16, telefone);
            stmt.setString(17, celular);
            stmt.setString(18, fax);
            stmt.setString(19, caminhoFoto);
            stmt.setInt(20, codPessoa);
            
            stmt.executeUpdate();
            
            if(opcao.equals("insert")){
                System.out.println("Tudo OK na inserção de pessoa\n");
            }else if(opcao.equals("update")){
                System.out.println("Tudo OK na atualizacao de pessoa\n");
            }
            stmt.close();
            return 1;
        } catch (SQLException e) {
            String msg = "Erro ao tentar persistir dados de pessoa.\n\nSQLException em setPessoa.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        } catch (Exception e) {
            String msg = "Erro ao tentar persistir dados de pessoa.\n\nException em setPessoa.jsp: " + e.getMessage();
            System.out.println(msg);
            return 0;
        }
    }
    %>