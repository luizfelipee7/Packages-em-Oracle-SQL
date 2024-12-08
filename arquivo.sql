


CREATE TABLE aluno (
    id_aluno NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    data_nascimento DATE NOT NULL
);


CREATE TABLE disciplina (
    id_disciplina NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(255),
    carga_horaria NUMBER NOT NULL
);


CREATE TABLE professor (
    id_professor NUMBER PRIMARY KEY,
    nome VARCHAR2(100) NOT NULL
);


CREATE TABLE turma (
    id_turma NUMBER PRIMARY KEY,
    id_professor NUMBER NOT NULL,
    id_disciplina NUMBER NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES professor(id_professor),
    FOREIGN KEY (id_disciplina) REFERENCES disciplina(id_disciplina)
);


CREATE TABLE matricula (
    id_matricula NUMBER PRIMARY KEY,
    id_aluno NUMBER NOT NULL,
    id_disciplina NUMBER NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    FOREIGN KEY (id_disciplina) REFERENCES disciplina(id_disciplina)
);


INSERT INTO aluno (id_aluno, nome, data_nascimento) VALUES (1, 'João Silva', TO_DATE('2000-05-15', 'YYYY-MM-DD'));
INSERT INTO aluno (id_aluno, nome, data_nascimento) VALUES (2, 'Maria Oliveira', TO_DATE('2005-07-20', 'YYYY-MM-DD'));
INSERT INTO aluno (id_aluno, nome, data_nascimento) VALUES (3, 'Pedro Souza', TO_DATE('1998-03-10', 'YYYY-MM-DD'));


INSERT INTO disciplina (id_disciplina, nome, descricao, carga_horaria) VALUES (1, 'Matemática', 'Cálculo e álgebra', 60);
INSERT INTO disciplina (id_disciplina, nome, descricao, carga_horaria) VALUES (2, 'História', 'História geral e do Brasil', 40);


INSERT INTO professor (id_professor, nome) VALUES (1, 'Carlos Mendes');
INSERT INTO professor (id_professor, nome) VALUES (2, 'Ana Lima');


INSERT INTO turma (id_turma, id_professor, id_disciplina) VALUES (1, 1, 1);
INSERT INTO turma (id_turma, id_professor, id_disciplina) VALUES (2, 2, 2);


INSERT INTO matricula (id_matricula, id_aluno, id_disciplina) VALUES (1, 1, 1);
INSERT INTO matricula (id_matricula, id_aluno, id_disciplina) VALUES (2, 2, 1);
INSERT INTO matricula (id_matricula, id_aluno, id_disciplina) VALUES (3, 3, 2);








CREATE OR REPLACE PACKAGE PKG_ALUNO AS
    PROCEDURE EXCLUIR_ALUNO(p_id_aluno IN NUMBER);
    CURSOR CUR_ALUNOS_MAIORES_18 IS
        SELECT nome, data_nascimento
        FROM aluno
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;
    CURSOR CUR_ALUNOS_POR_CURSO(p_id_curso IN NUMBER) IS
        SELECT a.nome
        FROM aluno a
        JOIN matricula m ON a.id_aluno = m.id_aluno
        WHERE m.id_curso = p_id_curso;
END PKG_ALUNO;


CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
    PROCEDURE EXCLUIR_ALUNO(p_id_aluno IN NUMBER) IS
    BEGIN
        DELETE FROM matricula WHERE id_aluno = p_id_aluno;
        DELETE FROM aluno WHERE id_aluno = p_id_aluno;
    END EXCLUIR_ALUNO;
END PKG_ALUNO;



CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    PROCEDURE CADASTRAR_DISCIPLINA(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER);
    CURSOR CUR_TOTAL_ALUNOS_DISCIPLINA IS
        SELECT d.nome, COUNT(m.id_aluno) AS total_alunos
        FROM disciplina d
        JOIN matricula m ON d.id_disciplina = m.id_disciplina
        GROUP BY d.nome
        HAVING COUNT(m.id_aluno) > 10;
    CURSOR CUR_MEDIA_IDADE_DISCIPLINA(p_id_disciplina IN NUMBER) IS
        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media_idade
        FROM aluno a
        JOIN matricula m ON a.id_aluno = m.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;
    PROCEDURE LISTAR_ALUNOS_DISCIPLINA(p_id_disciplina IN NUMBER);
END PKG_DISCIPLINA;


CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
    PROCEDURE CADASTRAR_DISCIPLINA(p_nome IN VARCHAR2, p_descricao IN VARCHAR2, p_carga_horaria IN NUMBER) IS
    BEGIN
        INSERT INTO disciplina (nome, descricao, carga_horaria) VALUES (p_nome, p_descricao, p_carga_horaria);
    END CADASTRAR_DISCIPLINA;

    PROCEDURE LISTAR_ALUNOS_DISCIPLINA(p_id_disciplina IN NUMBER) IS
        CURSOR alunos_cursor IS
            SELECT a.nome
            FROM aluno a
            JOIN matricula m ON a.id_aluno = m.id_aluno
            WHERE m.id_disciplina = p_id_disciplina;
        v_aluno_nome aluno.nome%TYPE;
    BEGIN
        OPEN alunos_cursor;
        LOOP
            FETCH alunos_cursor INTO v_aluno_nome;
            EXIT WHEN alunos_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_aluno_nome);
        END LOOP;
        CLOSE alunos_cursor;
    END LISTAR_ALUNOS_DISCIPLINA;
END PKG_DISCIPLINA;

CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
    CURSOR CUR_TOTAL_TURMAS_PROFESSOR IS
        SELECT p.nome, COUNT(t.id_turma) AS total_turmas
        FROM professor p
        JOIN turma t ON p.id_professor = t.id_professor
        GROUP BY p.nome
        HAVING COUNT(t.id_turma) > 1;
    FUNCTION TOTAL_TURMAS_PROFESSOR(p_id_professor IN NUMBER) RETURN NUMBER;
    FUNCTION PROFESSOR_DISCIPLINA(p_id_disciplina IN NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;


CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
    FUNCTION TOTAL_TURMAS_PROFESSOR(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total
        FROM turma
        WHERE id_professor = p_id_professor;
        RETURN v_total;
    END TOTAL_TURMAS_PROFESSOR;

    FUNCTION PROFESSOR_DISCIPLINA(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_nome_professor VARCHAR2(100);
    BEGIN
        SELECT p.nome
        INTO v_nome_professor
        FROM professor p
        JOIN turma t ON p.id_professor = t.id_professor
        WHERE t.id_disciplina = p_id_disciplina;
        RETURN v_nome_professor;
    END PROFESSOR_DISCIPLINA;
END PKG_PROFESSOR;



