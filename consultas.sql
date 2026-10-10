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