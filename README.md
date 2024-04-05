# Data Engineering Interview Tech Case
Neste case, foram migrados os arquivos [equipment_failure_sensors.txt](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(15).png), [equipment_sensors.csv](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(13).png), [equipment.json](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(14).png) contendo dados de sensores de uma FPSO de um [bucket S3](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(12).png) da AWS para um bucket da GCP. A extração dos dados da AWS é feita através de uma [*Cloud Function*](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(11).png) da GCP, que roda de a cada 2 horas. Os dados que chegam à GCP estão no formato *.parquet*, visando uma melhor performance. 

Estando no storage da GCP, os dados alimentam external tables na *BigQuery* em uma camada "*raw*". Nessa camada os dados estão sem qualquer alteração ou tratamento.

Com uma consulta agendada pela própria *BigQuery*, os dados da camada *raw* são tratados, higienizados, os tipos das colunas alterados e enviados à camada *trusted*. Nessa camada optei por utilizar o "*OBT - One Big Table*", onde todos os dados das três tabelas originais estão presentes em uma [única tabela](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(2).png), visando facilitar as consultas finais.

Por fim, na camada *refined* é onde fica as tabelas utilizadas pelo time de *data analysis* e para construção de B.Is

Aqui está o [diagrama](https://github.com/rbsmotta/fpso-case/blob/main/images/diagram.png) da arquitetura proposta.

## Questões levantadas:
 
1. Total equipment failures that happened?
   [print](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(3).png) e [código](https://github.com/rbsmotta/fpso-case/blob/main/sql/question1.sql)

2. Which equipment name had most failures?
   [print](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(4).png) e [código](https://github.com/rbsmotta/fpso-case/blob/main/sql/question2.sql)
   
3. Average amount of failures across equipment group, ordered by the number of failures in ascending order?
   [print](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(5).png) e [código](https://github.com/rbsmotta/fpso-case/blob/main/sql/question3.sql)
   
4.  Rank the sensors which present the most number of errors by equipment name in an equipment group.
   [print](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(6).png) e [código](https://github.com/rbsmotta/fpso-case/blob/main/sql/question4.sql)

Para o versionamento do código, foi utilzado o [GIT](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(7).png), bem como para criar o repositório no [Github](https://github.com/rbsmotta/fpso-case/blob/main/images/Captura%20de%20Tela%20(8).png).
