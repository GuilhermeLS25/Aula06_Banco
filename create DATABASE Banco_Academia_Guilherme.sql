-- ============================================================================
-- [LIVRO] BANCO DE DADOS DA ACADEMIA
--
-- [COMO NAVEGAR] Use Ctrl+F e pesquise um marcador entre colchetes:
-- [CAPITULO 05] leva aos filtros; [TEMA: LIKE] leva ao exemplo de LIKE.
-- [ATENCAO] destaca um detalhe importante sobre o exemplo correspondente.
--
-- [SUMARIO]
-- [CAPITULO 01] Preparar o banco: CREATE DATABASE, USE
-- [CAPITULO 02] Criar tabelas e entender regras: PRIMARY KEY, IDENTITY, UNIQUE, CHECK, DEFAULT e FOREIGN KEY
-- [CAPITULO 03] Inserir dados: INSERT INTO, VALUES
-- [CAPITULO 04] Consultar e ordenar: SELECT, AS, TOP, ORDER BY
-- [CAPITULO 05] Filtrar: WHERE, AND, OR, IN, LIKE
-- [CAPITULO 06] Alterar: UPDATE, SET, WHERE
-- [CAPITULO 07] Excluir: DELETE, WHERE
-- [CAPITULO 08] Texto e datas: UPPER, LOWER, LEN, CONCAT, FORMAT, DATEDIFF
-- [CAPITULO 09] Resumir: COUNT, AVG, MAX, MIN
-- [CAPITULO 10] Valores ausentes: NULL, ISNULL, CONVERT
-- [CAPITULO 11] Agrupar resultados: GROUP BY, HAVING, ORDER BY
-- [CAPITULO 12] Relacionar tabelas: INNER JOIN, ON
--
-- [INDICE RAPIDO] SELECT consulta; WHERE filtra; ORDER BY ordena;
-- INSERT insere; UPDATE altera; DELETE exclui; COUNT/AVG/MAX/MIN resumem.
-- [ATENCAO] O arquivo executa de cima para baixo. Reexecutar CREATE ou INSERT
-- pode gerar erros porque os objetos ou registros já existem.
-- ============================================================================

-- ============================================================================
-- [CAPITULO 01] PREPARAR O BANCO DE DADOS
-- ============================================================================

-- [TEMA: CREATE DATABASE]
CREATE DATABASE Banco_Academia_GuilhermeL;

-- ----------------------------------------------------------------------------
-- [TEMA: USE] Define em qual banco as próximas instruções serão executadas.
USE Banco_Academia_GuilhermeL;

-- ----------------------------------------------------------------------------
-- [TEMA: SYS.DATABASES] Consulta a lista de bancos disponíveis.
SELECT   name AS NomeDoBanco
FROM     sys.databases
ORDER BY name;

-- ============================================================================
-- [CAPITULO 02] CRIAR TABELAS E ENTENDER REGRAS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: PROFESSORES]
CREATE TABLE Professores (
    IdProfessor   INT           IDENTITY (1, 1) PRIMARY KEY,
    Nome          VARCHAR (100) NOT NULL,
    Email         VARCHAR (100) NOT NULL UNIQUE,
    Especialidade VARCHAR (100) NOT NULL
);

-- ----------------------------------------------------------------------------
-- [TEMA: IDENTITY, PRIMARY KEY, UNIQUE, NOT NULL]
-- Cursos: cada curso guarda o IdProfessor responsável.
CREATE TABLE Cursos (
    IdCurso      INT           IDENTITY (1, 1) PRIMARY KEY, --IDENTITY para auto incremento do IdCurso
    NomeCurso    VARCHAR (100) NOT NULL UNIQUE, -- UNIQUE para não permitir cursos duplicados
    CargaHoraria INT           NOT NULL CHECK (CargaHoraria > 0
                                               AND CargaHoraria <= 200), --  CHECK para validar a carga horária
    IdProfessor  INT           NOT NULL,
    Ativo        BIT           DEFAULT 1 NOT NULL -- DEFAULT para definir o valor padrão como 1 (ativo)
);

-- ----------------------------------------------------------------------------
-- [TEMA: CHECK, DEFAULT, DATE]
-- Alunos: dados de identificação, turma e situação de atividade.
CREATE TABLE Alunos (
    IdAluno        INT           IDENTITY (1, 1) PRIMARY KEY, --IDENTITY para auto incrementar o IdAluno
    Nome           VARCHAR (100) NOT NULL,
    Email          VARCHAR (100) NOT NULL UNIQUE, --UNIQUE para não permitir emails duplicados
    Turma          VARCHAR (50)  NOT NULL,
    DataNascimento DATE          NOT NULL CHECK (DataNascimento < GETDATE()), -- CHECK para validar a data de nascimento
    Ativo          BIT           CONSTRAINT DF_Alunos_Ativo DEFAULT 1 NOT NULL --DEFAULT para definir o valor padrão como 1 (ativo)
);

-- ----------------------------------------------------------------------------
-- [TEMA: LISTAR TABELAS]
-- Esta consulta usa INFORMATION_SCHEMA para listar as tabelas existentes.
-- [ATENCAO] Matriculas ainda não foi criada e, por isso, não aparece na lista.
SELECT   Table_NAME
FROM     information_schema.tables
WHERE    table_type = 'BASE TABLE'
ORDER BY Table_NAME;

-- ----------------------------------------------------------------------------
-- [TEMA: SYS.TABLES] Outra forma de listar tabelas pelo catálogo do SQL Server.
SELECT Name
FROM   sys.tables;

-- ----------------------------------------------------------------------------
-- [TEMA: FOREIGN KEY, UNIQUE, DEFAULT, NULL]
-- Matrículas relaciona alunos e cursos e armazena os dados da matrícula.
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

-- ============================================================================
-- [CAPITULO 03] INSERIR DADOS DE EXEMPLO
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: INSERT INTO, VALUES]
-- Primeiro são inseridos os dados usados pelas matrículas como referência.
INSERT  INTO Professores (
    Nome,
    Email,
    Especialidade
)
VALUES                   ('Ana Martins', 'ana.martins@academia.com', 'Banco de Dados'),
                         ('Carlos Ribeiro', 'carlos.ribeiro@academia.com', 'Programação'),
                         ('Fernanda Lima', 'fernanda.lima@academia.com', 'Desenvolvimento Web'),
                         ('Rafael Souza', 'rafael.souza@academia.com', 'Redes de Computadores');

-- ----------------------------------------------------------------------------
-- [EXEMPLO: INSERIR CURSOS]
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

-- ----------------------------------------------------------------------------
-- [EXEMPLO: INSERIR ALUNOS]
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

-- ----------------------------------------------------------------------------
-- [EXEMPLO: INSERIR MATRICULAS]
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

-- ============================================================================
-- [CAPITULO 04] CONSULTAR E ORDENAR RESULTADOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: SELECT *] Exibe todas as colunas e linhas da tabela Professores.
SELECT *
FROM   Professores;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONSULTAR CURSOS]
SELECT *
FROM   Cursos;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONSULTAR ALUNOS]
SELECT *
FROM   Alunos;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONSULTAR MATRICULAS]
SELECT *
FROM   Matriculas;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONSULTAR PROFESSORES]
SELECT *
FROM   Professores;

-- ----------------------------------------------------------------------------
-- [TEMA: SELECT COLUNAS] Seleciona apenas as colunas necessárias.
SELECT Nome,
       Email
FROM   Professores;

-- ----------------------------------------------------------------------------
-- [TEMA: AS] Define nomes alternativos para as colunas no resultado.
SELECT Nome AS NomeDoAluno,
       Turma AS Sala
FROM   Alunos;

-- ----------------------------------------------------------------------------
-- [TEMA: ORDER BY, ASC, DESC] Ordena os alunos pelo nome.
SELECT   Nome,
         Turma
FROM     Alunos
ORDER BY Nome ASC; -- ASC: crescente (padrão); DESC: decrescente.

-- ----------------------------------------------------------------------------
-- [TEMA: TOP] Limita a quantidade de linhas; aqui são os 5 primeiros por nome.
SELECT   TOP 5 Nome,
               Turma,
               DataNascimento
FROM     Alunos
ORDER BY Nome;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONFERIR CONSULTA] Reconsulta todos os dados dos alunos.
SELECT *
FROM   Alunos;

-- ============================================================================
-- [CAPITULO 05] FILTRAR RESULTADOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: WHERE / IGUALDADE] Restringe as linhas; aqui a turma deve ser 2INFO-A.
SELECT Nome,
       Turma
FROM   Alunos
WHERE  Turma = '2INFO-A';

-- ----------------------------------------------------------------------------
-- [TEMA: AND] Todas as condições precisam ser verdadeiras.
SELECT Nome,
       Turma,
       DataNascimento
FROM   Alunos
WHERE  Turma = '2INFO-A'
       AND DataNascimento > '2008-01-01'; --OU SEJA, SELECIONE OS NOMES, TURMAS E DATAS DE NASCIMENTO DOS ALUNOS ONDE A TURMA SEJA IGUAL A '2INFO-A' E A DATA DE NASCIMENTO SEJA MAIOR QUE '2008-01-01'

-- ----------------------------------------------------------------------------
-- [TEMA: OR] Basta que pelo menos uma das condições seja verdadeira.
SELECT Nome,
       Turma
FROM   Alunos
WHERE  Turma = '2INFO-A'
       OR DataNascimento > '2008-01-01'; -- Retorna quem atende a pelo menos uma das condições.

-- ----------------------------------------------------------------------------
-- [TEMA: IN] Verifica se o valor corresponde a qualquer item da lista.
SELECT Nome,
       Turma
FROM   Alunos
WHERE  Turma IN ('2INFO-A', '2INFO-B'); --OU SEJA, SELECIONE OS NOMES E TURMAS DOS ALUNOS ONDE A TURMA SEJA IGUAL A `2INFO-A` OU `2INFO-B`

-- ----------------------------------------------------------------------------
-- [TEMA: LIKE] % representa qualquer sequência e _ representa um caractere.
SELECT Nome,
       Email
FROM   Alunos
WHERE  Nome LIKE '%es'; -- Neste exemplo, seleciona nomes terminados em "es".

-- ============================================================================
-- [CAPITULO 06] ALTERAR DADOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: UPDATE, SET, WHERE] Altera valores das linhas que atendem à condição.
UPDATE Alunos
SET    Turma = '2INFO-B'
WHERE  IdAluno = 3; -- Altera a turma do aluno cujo IdAluno é 3.

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONFERIR ALTERACAO DO ALUNO]
SELECT *
FROM   Alunos; -- Verifica se a alteração foi realizada com sucesso

-- ----------------------------------------------------------------------------
-- [EXEMPLO: ATUALIZAR NOTA E STATUS DA MATRICULA]
UPDATE Matriculas
SET    NotaFinal       = 7.5,
       StatusMatricula = 'Concluída'
WHERE  IdAluno = 2
       AND IdCurso = 3; -- Altera a nota e o status dessa matrícula.

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONSULTAR ALUNOS]
SELECT *
FROM   Alunos;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONSULTAR TODAS AS MATRICULAS]
SELECT *
FROM   Matriculas; -- Verifica se a alteração foi realizada com sucesso

-- ----------------------------------------------------------------------------
-- [EXEMPLO: FILTRAR UMA MATRICULA]
SELECT *
FROM   Matriculas
WHERE  IdAluno = 2
       AND IdCurso = 3; -- Verifica se a alteração foi realizada com sucesso

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONFERIR ALUNOS]
SELECT *
FROM   Alunos;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: UPDATE EM VARIAS LINHAS] Desativa os alunos da turma 2INFO-B.
UPDATE Alunos
SET    Ativo = 0
WHERE  Turma = '2INFO-B'; -- Desativa todos os alunos da turma

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONFERIR ALUNOS DESATIVADOS]
SELECT *
FROM   Alunos;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: REATIVAR REGISTROS] Ativa os alunos da turma 2INFO-B.
UPDATE Alunos
SET    Ativo = 1
WHERE  Turma = '2INFO-B'; -- Ativa todos os alunos da turma

-- ============================================================================
-- [CAPITULO 07] EXCLUIR DADOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: DELETE, WHERE] Remove as linhas que atendem à condição.
-- [ATENCAO] A chave estrangeira pode impedir a exclusão se o aluno tiver matrículas.
DELETE Alunos
WHERE  IdAluno = 1; -- Exclui o aluno com IdAluno igual a 1

-- ============================================================================
-- [CAPITULO 08] TRABALHAR COM TEXTO E DATAS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: UPPER, LOWER, LEN, CONCAT, FORMAT, DATEDIFF]
-- Alterar caixa, contar e combinar texto; formatar datas e estimar diferenças.
SELECT Nome,
       UPPER(Nome) AS NomeMaiusculo, -- Converte o nome para maiúsculo
       LOWER(Nome) AS NomeMinusculo, -- Converte o nome para minúsculo
       LEN(Nome) AS QuantidedeDeCaracteres, -- Conta a quantidade de caracteres do nome
       CONCAT(Nome, ' - ', Turma) AS NomeETurma, -- Concatena o nome e a turma
       FORMAT(DataNascimento, 'dd/MM/yyyy') AS DataNascimentoFormatada, -- Formata a data de nascimento para o formato dd/MM/yyyy
       DATEDIFF(YEAR, DataNascimento, GETDATE()) AS IdadeAproximada -- Estima a idade em anos; não confere se o aniversário já ocorreu neste ano.
FROM   Alunos;

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONFERIR EXCLUSAO] Reconsulta os alunos após a exclusão solicitada.
SELECT *
FROM   Alunos;

-- ============================================================================
-- [CAPITULO 09] RESUMIR RESULTADOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: COUNT] Conta linhas da tabela.
SELECT COUNT(*) AS QuantidadeDeAlunos
FROM   Alunos; -- Conta a quantidade de alunos cadastrados

-- [ATENCAO] O alias sugere matrículas com nota, mas COUNT(*) conta todas as linhas;
-- esta consulta não filtra NotaFinal IS NOT NULL.
SELECT COUNT(*) AS QuantidadeDeMatriculasComNota
FROM   Matriculas;

-- ----------------------------------------------------------------------------
-- [TEMA: AVG, MAX, MIN] Resume as notas preenchidas; valores NULL são ignorados.
SELECT AVG(NotaFinal) AS MediaDasNotas,
       MAX(NotaFinal) AS MaiorNota,
       MIN(NotaFinal) AS MenorNota
FROM   Matriculas;

-- ============================================================================
-- [CAPITULO 10] TRATAR VALORES AUSENTES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: NULL, ISNULL, CONVERT] Substitui NULL por texto e converte a nota.
SELECT IdMatricula,
       ISNULL(CONVERT (VARCHAR (10), NotaFinal), 'Sem Nota') AS NotaFinal,
       StatusMatricula
FROM   Matriculas;

-- ============================================================================
-- [CAPITULO 11] AGRUPAR RESULTADOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: GROUP BY] Agrupa os alunos por turma e conta quantos há em cada uma.
SELECT   Turma,
         COUNT(*) AS QuantidadeDeAlunos
FROM     Alunos
GROUP BY Turma; -- Agrupa os alunos por turma e conta a quantidade de alunos em cada turma.

-- ----------------------------------------------------------------------------
-- [EXEMPLO: CONTAGEM DE ALUNOS POR TURMA]
-- Conta alunos por turma e ordena da turma mais numerosa para a menos numerosa.
SELECT   Turma,
         COUNT(*) AS QuantidadeDeAlunos
FROM     aluno
GROUP BY Turma -- Agrupa os alunos pela turma.
ORDER BY QuantidadeDeAlunos DESC; -- Mostra primeiro as turmas com mais alunos.

-- ----------------------------------------------------------------------------
-- [TEMA: HAVING] Filtra grupos depois do GROUP BY; aqui, cursos com duas ou mais matrículas.
SELECT   IdCurso,
         COUNT(*) AS QuantidadeDeMatriculas
FROM     Matriculas
GROUP BY IdCurso
HAVING   COUNT(*) >= 2 -- Mantém cursos com duas ou mais matrículas.
ORDER BY QuantidadeDeMatriculas DESC; -- Ordena pelos cursos com mais matrículas.

-- ============================================================================
-- [CAPITULO 12] RELACIONAR TABELAS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- [TEMA: INNER JOIN, ON]
-- INNER JOIN retorna registros correspondentes nas tabelas; ON define como relacioná-los.
SELECT   a.Nome AS NomeDoAluno,
         c.NomeCurso AS NomeDoCurso,
         m.NotaFinal,
         m.StatusMatricula
FROM     Matriculas AS m
         INNER JOIN
         aluno AS a
         ON m.IdAluno = a.IdAluno -- Associa cada matrícula ao aluno correspondente.
         INNER JOIN
         Cursos AS C
         ON m.IdCurso = c.IdCurso -- Associa cada matrícula ao curso correspondente.
ORDER BY a.Nome; -- Ordena o resultado pelo nome do aluno.

-- ----------------------------------------------------------------------------
-- [EXEMPLO: RELACIONAR MATRICULA, ALUNO E CURSO]
-- [ATENCAO] Esta consulta usa o alias c, mas ainda não tem um JOIN de Cursos.
SELECT a.Nome AS Aluno,
       a.turma,
       c.nomeCurso AS Curso,
       m.NotaFinal,
       m.StatusMatricula
FROM   Matriculas AS m
       INNER JOIN
       aluno AS a
       ON m.IdAluno = a.IdAluno;
