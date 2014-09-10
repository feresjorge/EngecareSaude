<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="java.sql.*"%>
<%@ page import="logging.Logging"%>
<%@ page import="BD.GetDBConnection"%>


<%!
    SimpleDateFormat formatador = new SimpleDateFormat("dd/MM/yyyy");
    public class retornoPessoa {
        public int codigoPessoa;
        public String nome;
        public String cor;
        public String sexo;
        public String dataNascimento;
        public String estadoCivil;
        public String cpf;
        public String rg;
        public String naturalidade;
        public String nacionalidade;
        public String endereco;
        public String bairro;
        public String cidade;
        public String estado;
        public String cep;
        public String email;
        public String telefone;
        public String celular;
        public String fax;
        public String foto;
        public int erro = 0;

        public void getPessoa(Connection connection, int idPessoa) {
            String sqlPessoa = "SELECT * FROM pessoa where cod_pessoa = ?;";
            
            try {
                PreparedStatement ps = connection.prepareStatement(sqlPessoa);
                String sqlAlterado = "";
                Statement sttm = null;
                ResultSet rs = null;
                ps.setInt(1, idPessoa);                
                sqlAlterado = ps.toString();
                sttm = connection.createStatement();
                rs = sttm.executeQuery(sqlAlterado);
                rs.next();
                
                System.out.println("cheguei aqui teste " + sqlAlterado);
                this.codigoPessoa = rs.getInt("cod_pessoa");
                this.nome = rs.getString("nome_pessoa");
                this.cor = rs.getString("etnia_pessoa");
                this.sexo = rs.getString("sexo_pessoa");
                Date data= rs.getDate("data_nascimento_pessoa");
                
                if (data == null){
                    this.dataNascimento = "";
                }else{
                    this.dataNascimento = formatador.format(data);
                }  
                this.estadoCivil = rs.getString("estado_civil_pessoa");
                this.cpf = rs.getString("cpf_pessoa");
                this.rg = rs.getString("rg_pessoa");
                this.naturalidade = rs.getString("naturalidade_pessoa");
                this.nacionalidade = rs.getString("nacionalidade_pessoa");
                this.cep = rs.getString("cep_pessoa");
                this.estado = rs.getString("estado_pessoa");
                this.cidade = rs.getString("cidade_pessoa");
                this.bairro = rs.getString("bairro_pessoa");
                this.endereco = rs.getString("endereco_pessoa");
                this.email = rs.getString("email_pessoa");
                this.telefone = rs.getString("telefone_pessoa");
                this.celular = rs.getString("celular_pessoa");
                this.fax = rs.getString("fax_pessoa");
                this.foto = rs.getString("caminho_foto_pessoa"); 
                this.erro = 0; 
                ps.close();
                sttm.close();
                rs.close();
                
            } catch (SQLException e) {
                System.out.println("Erro ao tentar buscar dados de pessoa.\n\nSQLException em getPessoa.jsp: " + e.getMessage());
                this.erro = 1;
            } catch (Exception e) {
                System.out.println("Erro ao tentar buscar dados de pessoa.\n\nException em getPessoa.jsp: " + e.getMessage());
                this.erro = 1;
            }
        }
    }

    %>