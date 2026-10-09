# %%--------------------------------------------
import pandas as pd
caminho_arquivo_inicial = "music.xlsx"
# Mostra os nomes de todas as abas do arquivo
excel = pd.ExcelFile(caminho_arquivo_inicial)
print(excel.sheet_names)
#Obs: A primeira aba contém a tabela principal, a segunda aba contém um dicionário de dados e a terceira aba contém perguntas a serem respondidas nesta análise.

# %%--------------------------------------------
caminho_arquivo = "music_normalizado.xlsx"
# Mostra os nomes de todas as abas do arquivo
excel = pd.ExcelFile(caminho_arquivo)
print(excel.sheet_names)

#%%--------------------------------------------
import io
import pandas as pd

# 1. Carrega o arquivo Excel
caminho_arquivo = "music_normalizado.xlsx"

# Carrega cada aba
df_musicas = pd.read_excel(caminho_arquivo, sheet_name="Musicas")
df_artistas = pd.read_excel(caminho_arquivo, sheet_name="Artistas")
df_musica_artista = pd.read_excel(caminho_arquivo, sheet_name="Musica_Artista")

# 2. Seleciona apenas a 1ª, 2ª e 3ª coluna (índices 0, 1 e 2) da aba "Musicas"
colunas_1_2_3_musicas = df_musicas.iloc[:, [0, 1, 2]]

# 3. Seleciona apenas a 1ª e 2ª coluna (índices 0 e 1) da aba "Artistas"
colunas_1_2_artistas = df_artistas.iloc[:, [0, 1]]

# %%
