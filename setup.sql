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

