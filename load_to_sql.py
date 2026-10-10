import pandas as pd
from sqlalchemy import create_engine
import urllib

# 1. Ligar ao SQL Server
SERVER = 'sqlserver_db,1433'
DATABASE = 'SpotifyDB'
USERNAME = 'sa'
PASSWORD = 'SuaSenhaForte123'

params = urllib.parse.quote_plus(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};"
    f"SERVER={SERVER};"
    f"DATABASE={DATABASE};"
    f"UID={USERNAME};"
    f"PWD={PASSWORD}"
)

# Adição do fast_executemany=True para otimizar a inserção em lote
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}", fast_executemany=True)

ARQUIVO_EXCEL = "music_normalizado.xlsx"

print("Lendo o arquivo Excel...")
df_artistas = pd.read_excel(ARQUIVO_EXCEL, sheet_name='Artistas')
df_musicas = pd.read_excel(ARQUIVO_EXCEL, sheet_name='Musicas')
df_musica_artista = pd.read_excel(ARQUIVO_EXCEL, sheet_name='Musica_Artista')

# Correção: O Pandas converte colunas com NaN para float64.
# A conversão para 'Int64' garante compatibilidade com o BIGINT do SQL Server.
df_musicas['streams'] = df_musicas['streams'].astype('Int64')

# Certifique-se de ter rodado o consultas.sql no banco ANTES de iniciar a inserção
try:
    print("Inserindo dados na tabela 'Artistas'...")
    df_artistas.to_sql('Artistas', con=engine, if_exists='append', index=False)
    
    print("Inserindo dados na tabela 'Musicas'...")
    df_musicas.to_sql('Musicas', con=engine, if_exists='append', index=False)
    
    print("Inserindo dados na tabela 'Musica_Artista'...")
    df_musica_artista.to_sql('Musica_Artista', con=engine, if_exists='append', index=False)
    
    print("Carga concluída com sucesso!")
except Exception as e:
    print(f"Ocorreu um erro durante a carga dos dados: {e}")