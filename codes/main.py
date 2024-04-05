import boto3 # Importa a biblioteca Boto3 para interagir com a AWS
import pandas as pd
from io import StringIO # Importa StringIO para manipular strings como arquivos
from dotenv import load_dotenv
import os

# Classe para interagir com o cliente S3
class S3Client:
    def __init__(self, access_key_id, secret_access_key):
        # Inicializa o cliente S3 com as credenciais fornecidas
        self.s3 = boto3.client("s3",
            aws_access_key_id=access_key_id,
            aws_secret_access_key=secret_access_key
        )
    
    # Método para obter o conteúdo de um objeto no S3
    def get_object_content(self, bucket_name, file_key):
        response = self.s3.get_object(Bucket=bucket_name, Key=file_key)
        return response['Body'].read().decode('utf-8')

# Classe para ler diferentes tipos de arquivos do S3 e convertê-los em DataFrames
class FileReader:
    def __init__(self, s3_client):
        self.s3_client = s3_client

    # Método para ler arquivo CSV do S3 e retornar um DataFrame
    def read_csv_to_df(self, bucket_name, file_key):
        content = self.s3_client.get_object_content(bucket_name, file_key)
        return pd.read_csv(StringIO(content))
    
    # Método para ler arquivo JSON do S3 e retornar um DataFrame
    def read_json_to_df(self, bucket_name, file_key):
        content = self.s3_client.get_object_content(bucket_name, file_key)
        return pd.read_json(content)
    
    # Método para ler arquivo TXT do S3 e retornar um DataFrame
    def read_txt_to_df(self, bucket_name, file_key):
        content = self.s3_client.get_object_content(bucket_name, file_key)
        return pd.read_csv(StringIO(content), sep='\t')

# Função principal do script
def main():
    # Carrega variáveis de ambiente do arquivo .env
    load_dotenv()
    s3_access_key_id = os.getenv("AWS_ACCESS_KEY_ID")
    
    s3_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY")

    bucket_name = os.getenv("BUCKET")

    csv_file_key = os.getenv("CSV_FILE_KEY")

    json_file_key = os.getenv("JSON_FILE_KEY")

    txt_file_key = os.getenv("TXT_FILE_KEY") 

    s3_client = S3Client(s3_access_key_id, s3_secret_access_key)

    file_reader = FileReader(s3_client)
    
    # Lê arquivos CSV e JSON do S3 e os converte em DataFrames
    df_equipment_sensors = file_reader.read_csv_to_df(bucket_name, csv_file_key)
    df_equipment = file_reader.read_json_to_df(bucket_name, json_file_key)

    # Lê arquivo TXT do S3, define um schema e converte em DataFrame
    df_equipment_failure_sensors = file_reader.read_txt_to_df(bucket_name, txt_file_key)

    # Define o schema para o DataFrame do arquivo TXT
    schema_df_equipment_failure_sensors = {
        'date':str,
        'status':str,
        'sensor':str,
        'info1':str,
        'info2':str,
        'info3':str
    }

    # Aplica o schema ao DataFrame do arquivo TXT
    df_equipment_failure_sensors.columns = schema_df_equipment_failure_sensors.keys()
    df_equipment_failure_sensors = df_equipment_failure_sensors.astype(schema_df_equipment_failure_sensors)
    
    # Salva os DataFrames convertidos em arquivos Parquet no GCP
    df_equipment_sensors.to_parquet(os.getenv("CSV_PATH_GCP"), compression='gzip', index=False)
    
    df_equipment.to_parquet(os.getenv("JSON_PATH_GCP"), compression='gzip', index=False)
    
    df_equipment_failure_sensors.to_parquet(os.getenv("TXT_PATH_GCP"), compression='gzip', index=False)

if __name__ == '__main__':
    main()