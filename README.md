# Sistema de Gestão Acadêmica - Pacotes PL/SQL

Este repositório contém o código de um conjunto de pacotes em PL/SQL que implementam operações relacionadas às entidades **Aluno**, **Disciplina** e **Professor**. O sistema foi desenvolvido para funcionar em um banco de dados Oracle e inclui procedimentos, funções e cursores.

## Estrutura do Repositório

O repositório contém:

- Um arquivo `.sql` com o código completo para criação dos pacotes e tabelas no banco de dados Oracle.
- Este arquivo `README.md`, que contém instruções para execução e um resumo dos pacotes implementados.

## Como Executar o Script no Oracle

Para executar o script no Oracle, siga os passos abaixo:

1. **Conecte-se ao banco de dados Oracle**
   - Se você estiver utilizando o **SQL Developer**, **SQL*Plus** ou **DBeaver**, conecte-se ao seu banco de dados Oracle com o usuário que tenha permissões adequadas para criar pacotes e tabelas.
   - Use as credenciais do seu banco de dados (usuário e senha) para a conexão.

2. **Execute o Script no Oracle**
   - No **SQL Developer**:
     - Abra o arquivo `.sql` que contém o código.
     - Selecione todo o conteúdo e clique em **Executar** ou pressione `F5`.
   - No **SQL*Plus**:
     - Abra o terminal e execute o seguinte comando para carregar o script:
       ```sql
       @caminho/do/arquivo.sql
       ```
     - Isso executará todas as instruções do script, criando as tabelas, pacotes e procedimentos.

3. **Habilitar Saída de Mensagens (DBMS_OUTPUT)**
   Para ver a saída de mensagens (como os resultados de `DBMS_OUTPUT.PUT_LINE`), ative o painel de saída no **SQL Developer** ou no **SQL*Plus**:
   
   - No **SQL Developer**, vá até o painel **DBMS Output** e clique em **Ativar**.
   - No **SQL*Plus**, execute o comando:
     ```sql
     SET SERVEROUTPUT ON;
     ```

4. **Testando o Sistema**
   - Após executar o script, você pode testar as funcionalidades chamando as procedures e funções conforme descrito na seção "Testes" abaixo.

---



### Pacote PKG_ALUNO

Este pacote contém operações relacionadas à gestão dos alunos.

- **Procedure `EXCLUIR_ALUNO(p_id_aluno IN NUMBER)`**: Exclui um aluno e todas as matrículas associadas ao aluno identificado pelo `id_aluno`.
- **Cursor `CUR_ALUNOS_MAIORES_18`**: Retorna os alunos maiores de 18 anos, listando seus nomes e datas de nascimento.
- **Cursor `CUR_ALUNOS_POR_CURSO(p_id_curso IN NUMBER)`**: Retorna os alunos matriculados em um curso específico, filtrando pelo `id_curso`.

### Pacote PKG_DISCIPLINA

Este pacote contém operações relacionadas à gestão das disciplinas.

- **Procedure `CADASTRAR_DISCIPLINA(nome VARCHAR2, descricao VARCHAR2, carga_horaria NUMBER)`**: Cadastra uma nova disciplina com os parâmetros nome, descrição e carga horária.
- **Cursor `CUR_TOTAL_ALUNOS_DISCIPLINA`**: Retorna as disciplinas que possuem mais de 10 alunos matriculados, exibindo o nome da disciplina e o número total de alunos.
- **Cursor `CUR_MEDIA_IDADE_DISCIPLINA(p_id_disciplina IN NUMBER)`**: Calcula a média de idade dos alunos matriculados em uma disciplina específica, filtrando pelo `id_disciplina`.
- **Procedure `LISTAR_ALUNOS_DISCIPLINA(p_id_disciplina IN NUMBER)`**: Lista os alunos matriculados em uma disciplina específica, filtrando pelo `id_disciplina`.

### Pacote PKG_PROFESSOR

Este pacote contém operações relacionadas à gestão dos professores e turmas.

- **Cursor `CUR_TOTAL_TURMAS_PROFESSOR`**: Retorna os professores que lecionam mais de uma turma, exibindo o nome do professor e o número de turmas que ele leciona.
- **Function `TOTAL_TURMAS_PROFESSOR(p_id_professor IN NUMBER)`**: Retorna o número total de turmas em que o professor identificado pelo `id_professor` está envolvido.
- **Function `PROFESSOR_DISCIPLINA(p_id_disciplina IN NUMBER)`**: Retorna o nome do professor responsável pela disciplina identificada pelo `id_disciplina`.

