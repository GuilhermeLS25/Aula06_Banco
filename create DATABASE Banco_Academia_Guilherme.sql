CREATE DATABASE Banco_Academia_GuilhermeL;

USE Banco_Academia_GuilhermeL;

SELECT   name AS NomeDoBanco
FROM     sys.databases
ORDER BY name;

CREATE TABLE Professores (
    IdProfessor   INT           IDENTITY (1, 1) PRIMARY KEY,
    Nome          VARCHAR (100) NOT NULL,
    Email         VARCHAR (100) NOT NULL UNIQUE,
    Especialidade VARCHAR (100) NOT NULL
);

CREATE TABLE Cursos (
    IdCurso      INT           IDENTITY (1, 1) PRIMARY KEY, --IDENTITY para auto incremento do IdCurso
    NomeCurso    VARCHAR (100) NOT NULL UNIQUE, -- UNIQUE para não permitir cursos duplicados
    CargaHoraria INT           NOT NULL CHECK (CargaHoraria > 0
                                               AND CargaHoraria <= 200), --  CHECK para validar a carga horária
    IdProfessor  INT           NOT NULL,
    Ativo        BIT           DEFAULT 1 NOT NULL -- DEFAULT para definir o valor padrão como 1 (ativo)
);

CREATE TABLE Alunos (
    IdAluno        INT           IDENTITY (1, 1) PRIMARY KEY, --IDENTITY para auto incrementar o IdAluno
    Nome           VARCHAR (100) NOT NULL,
    Email          VARCHAR (100) NOT NULL UNIQUE, --UNIQUE para não permitir emails duplicados
    Turma          VARCHAR (50)  NOT NULL,
    DataNascimento DATE          NOT NULL CHECK (DataNascimento < GETDATE()), -- CHECK para validar a data de nascimento
    Ativo          BIT           CONSTRAINT DF_Alunos_Ativo DEFAULT 1 NOT NULL --DEFAULT para definir o valor padrão como 1 (ativo)
);

-- visualizar as tabelas do banco de dados Banco_Academia_GuilhermeL
SELECT   Table_NAME
FROM     information_schema.tables
WHERE    table_type = 'BASE TABLE'
ORDER BY Table_NAME;

SELECT Name
FROM   sys.tables;

CREATE TABLE matriculas (
    IdMatricula     INT            IDENTITY (1, 1) PRIMARY KEY, -- IDENTITY para auto incremento do IdMatricula
    IdAluno         INT            NOT NULL,
    IdCurso         INT            NOT NULL,
    DataMatricula   DATE           CONSTRAINT DF_Matriculas_Data DEFAULT (CONVERT (DATE, GETDATE())) NOT NULL, -- DEFAULT para definir a data atual como padrão
    NotaFinal       DECIMAL (5, 2) NULL CHECK (NotaFinal BETWEEN 0 AND 10), -- CHECK para validar a nota final entre 0 e 10
    StatusMatricula VARCHAR (20)   CONSTRAINT DF_Matriculas_Status DEFAULT 'Ativa', -- DEFAULT para definir o status como 'Ativa'
    CONSTRAINT UQ_Matriculas_AlunoCurso UNIQUE (IdAluno, IdCurso), -- UNIQUE para não permitir duplicidade de matrícula para o mesmo aluno e curso
    CONSTRAINT FK_Matriculas_Alunos FOREIGN KEY (IdAluno) REFERENCES Alunos (IdAluno), -- FOREIGN KEY para referenciar a tabela Alunos
    CONSTRAINT FK_Matriculas_Cursos FOREIGN KEY (IdCurso) REFERENCES Cursos (IdCurso) -- FOREIGN KEY para referenciar a tabela Cursos
);

INSERT  INTO Professores (
    Nome,
    Email,
    Especialidade
)
VALUES                   ('Ana Martins', 'ana.martins@academia.com', 'Banco de Dados'),
                         ('Carlos Ribeiro', 'carlos.ribeiro@academia.com', 'Programação'),
                         ('Fernanda Lima', 'fernanda.lima@academia.com', 'Desenvolvimento Web'),
                         ('Rafael Souza', 'rafael.souza@academia.com', 'Redes de Computadores');

INSERT  INTO Cursos (
    NomeCurso,
    CargaHoraria,
    IdProfessor
)
VALUES              ('Banco de Dados Inicial', 40, 1),
                    ('SQL Server Essencial', 36, 1),
                    ('Lógica de Programação', 40, 2),
                    ('JavaScript para Jovens', 32, 2),
                    ('HTML e CSS', 30, 3),
                    ('Fundamentos de Redes', 24, 4);

INSERT  INTO Alunos (
    Nome,
    Email,
    Turma,
    DataNascimento
)
VALUES              ('Alice Pereira', 'alice.pereira@escola.com', '2INFO-A', '2008-03-14'),
                    ('Bruno Alves', 'bruno.alves@escola.com', '2INFO-A', '2008-07-22'),
                    ('Camila Rocha', 'camila.rocha@escola.com', '2INFO-A', '2008-01-30'),
                    ('Diego Santos', 'diego.santos@escola.com', '2INFO-B', '2007-11-09'),
                    ('Elisa Nunes', 'elisa.nunes@escola.com', '2INFO-B', '2008-05-18'),
                    ('Felipe Costa', 'felipe.costa@escola.com', '2INFO-B', '2008-09-02'),
                    ('Gabriela Melo', 'gabriela.melo@escola.com', '2INFO-C', '2007-12-12'),
                    ('Henrique Luz', 'henrique.luz@escola.com', '2INFO-C', '2008-06-28'),
                    ('Isabela Torres', 'isabela.torres@escola.com', '2INFO-C', '2008-02-06'),
                    ('João Mendes', 'joao.mendes@escola.com', '2INFO-C', '2007-08-25');

INSERT  INTO Matriculas (
    IdAluno,
    IdCurso,
    DataMatricula,
    NotaFinal,
    StatusMatricula
)
VALUES                  (1, 1, '2026-02-03', 8.50, 'Concluída'),
                        (1, 5, '2026-02-03', 9.00, 'Concluída'),
                        (2, 1, '2026-02-03', 7.00, 'Concluída'),
                        (2, 3, '2026-02-04', 8.00, 'Ativa'),
                        (3, 2, '2026-02-04', 9.50, 'Concluída'),
                        (3, 4, '2026-02-04', NULL, 'Ativa'),
                        (4, 3, '2026-02-05', 6.50, 'Concluída'),
                        (5, 5, '2026-02-05', 8.50, 'Concluída'),
                        (6, 6, '2026-02-06', NULL, 'Ativa'),
                        (7, 1, '2026-02-06', 7.50, 'Concluída'),
                        (8, 2, '2026-02-07', 10.00, 'Concluída'),
                        (8, 6, '2026-02-07', 8.00, 'Concluída'),
                        (9, 4, '2026-02-08', NULL, 'Ativa'),
                        (9, 5, '2026-02-08', 9.00, 'Concluída'),
                        (10, 3, '2026-02-09', 7.00, 'Concluída'),
                        (10, 2, '2026-02-09', NULL, 'Ativa');

SELECT *
FROM   Professores;

SELECT *
FROM   Cursos;

SELECT *
FROM   Alunos;

SELECT *
FROM   Matriculas;

SELECT *
FROM   Professores;

SELECT Nome,
       Email
FROM   Professores;

-- Apelido para deixar o titulo mais claro
SELECT Nome AS NomeDoAluno,
       Turma AS Sala
FROM   Alunos;

--CONSULTA POR ORDEM ALAFABÉTICA--
SELECT   Nome,
         Turma
FROM     Alunos
ORDER BY Nome ASC; -- ASC PARA ORDEM CRESENTE (PADRÃO) E DESECE PARA A ORDEM DECRESCENTE

--OS CINCO PRIEMIROS REGISTROS DE ALUNOS CADASTRADOS
SELECT   TOP 5 Nome,
               Turma,
               DataNascimento
FROM     Alunos
ORDER BY Nome;

SELECT *
FROM   Alunos;

-- FILTROS COM WHERE 
--WHERE FILTRA AS LINHAS. LEIA A CONSULTA COMO UMA FRASE: "SELECIONE OS NOMES E TURMAS DOS ALUNOS ONDE A TURMA SEJA IGUAL A 2INFO-A"
--IGUAL A
SELECT Nome,
       Turma
FROM   Alunos
WHERE  Turma = '2INFO-A';

--DIFERENTE DE 
SELECT Nome,
       Turma,
       DataNascimento
FROM   Alunos
WHERE  Turma = '2INFO-A'
       AND DataNascimento > '2008-01-01'; --OU SEJA, SELECIONE OS NOMES, TURMAS E DATAS DE NASCIMENTO DOS ALUNOS ONDE A TURMA SEJA IGUAL A '2INFO-A' E A DATA DE NASCIMENTO SEJA MAIOR QUE '2008-01-01'

-- OR PELO O MENOS UMA CONDIÇÃO DEVE SER VERDADEIRA
SELECT Nome,
       Turma
FROM   Alunos
WHERE  Turma = '2INFO-A'
       OR DataNascimento > '2008-01-01'; --OU SEJA, SELECIONE OS NOMES, TURMAS E DATAS DE NASCIMENTO DOSALUNOS ONDE A TURMA SEJA MAIOR '2INFO-A' E A DATA DE NASCIMENTO SEJA MAIOR QUE '2008-01-01'

--IN: Versão mais curta para varios valores
SELECT Nome,
       Turma
FROM   Alunos
WHERE  Turma IN ('2INFO-A', '2INFO-B'); --OU SEJA, SELECIONE OS NOMES E TURMAS DOS ALUNOS ONDE A TURMA SEJA IGUAL A `2INFO-A` OU `2INFO-B`

--LIKE: % SIGNIFICA "QUALQUER QUANTIDADE DE CARACTERES" E _ SIGNIFICA "QUALQUER CARACTERE"
SELECT Nome,
       Email
FROM   Alunos
WHERE  Nome LIKE '%es'; --OU SEJA, SELECIONE OS NOMES E EMAILS DOS ALUNOS ONDE O EMAIL TERMINA COM '@escola.com'

-- Atualizando Dados com UPDATE
-- UPDATE: Atualiza os dados de uma tabela. A sintaxe básica é: UPDATE nome_da_tabela SET nome_da_colunas = novo_valor WHERE condição
UPDATE Alunos
SET    Turma = '2INFO-B'
WHERE  IdAluno = 3; -- Altera a turma do aluno com IdAluno igual a 3 para '2INFO-B'

SELECT *
FROM   Alunos; -- Verifica se a alteração foi realizada com sucesso

UPDATE Matriculas
SET    NotaFinal       = 7.5,
       StatusMatricula = 'Concluída'
WHERE  IdAluno = 2
       AND IdCurso = 3; -- Altera a nota final e o status da matrícula com IdMatricula igual a 4