-- Criação do banco de dados (se necessário, descomente a linha abaixo e o comando USE)
CREATE DATABASE SpotifyDB;
GO
USE SpotifyDB;
GO
-- ==========================================
-- DDL: CRIAÇÃO DAS TABELAS
-- ==========================================

-- 1. Tabela de Artistas
CREATE TABLE Artistas (
    artista_id INT PRIMARY KEY,
    nome_artista VARCHAR(255) NOT NULL
);

-- 2. Tabela de Músicas
CREATE TABLE Musicas (
    musica_id INT PRIMARY KEY,
    track_name VARCHAR(500),
    released_year INT,
    released_month INT,
    released_day INT,
    in_spotify_playlists INT,
    in_spotify_charts INT,
    streams BIGINT,
    in_apple_playlists INT,
    in_apple_charts INT,
    in_deezer_playlists VARCHAR(50), -- Algumas bases trazem números grandes ou vírgulas
    in_deezer_charts INT,
    in_shazam_charts VARCHAR(50),
    bpm INT,
    [key] VARCHAR(50),
    mode VARCHAR(50),
    danceability INT,
    valence INT,
    energy INT,
    acousticness INT,
    instrumentalness INT,
    liveness INT,
    speechiness INT,
    release_date DATE
);

-- 3. Tabela de Relacionamento (Música e Artista)
CREATE TABLE Musica_Artista (
    musica_id INT,
    artista_id INT,
    ordem_artista INT,
    PRIMARY KEY (musica_id, artista_id),
    FOREIGN KEY (musica_id) REFERENCES Musicas(musica_id),
    FOREIGN KEY (artista_id) REFERENCES Artistas(artista_id)
);


-- ==========================================
-- DQL: CONSULTAS DE ANÁLISE
-- ==========================================

-- 1. Listar as 10 músicas com o maior número de streams, incluindo o artista principal
SELECT TOP 10
    m.track_name,
    a.nome_artista AS artista_principal,
    m.streams
FROM Musicas m
JOIN Musica_Artista ma ON m.musica_id = ma.musica_id
JOIN Artistas a ON ma.artista_id = a.artista_id
WHERE ma.ordem_artista = 1
ORDER BY m.streams DESC;

-- 2. Artistas com mais músicas presentes no dataset
SELECT TOP 10
    a.nome_artista,
    COUNT(ma.musica_id) AS total_musicas
FROM Artistas a
JOIN Musica_Artista ma ON a.artista_id = ma.artista_id
GROUP BY a.nome_artista
ORDER BY total_musicas DESC;

-- 3. Média de BPM e Danceability agrupada por Ano de Lançamento
SELECT 
    released_year,
    AVG(CAST(bpm AS FLOAT)) AS media_bpm,
    AVG(CAST(danceability AS FLOAT)) AS media_danceability,
    COUNT(musica_id) AS total_musicas_ano
FROM Musicas
GROUP BY released_year
ORDER BY released_year DESC;

-- 4. Identificar parcerias (músicas com mais de um artista)
SELECT 
    m.track_name,
    COUNT(ma.artista_id) AS total_artistas
FROM Musicas m
JOIN Musica_Artista ma ON m.musica_id = ma.musica_id
GROUP BY m.musica_id, m.track_name
HAVING COUNT(ma.artista_id) > 1
ORDER BY total_artistas DESC, m.track_name;