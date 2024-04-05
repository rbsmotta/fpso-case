# Data Engineering Interview Tech Case
Neste case, foram migrados dados de sensores de uma FPSO de um bucket S3 da AWS para um bucket da GCP. Os dados que chegam à GCP estão no formato *.parquet*, visando uma melhor performance.
Estando no storage da GCP, os dados alimentam external tables na *BigQuery*

1. Total equipment failures that happened?

2. Which equipment name had most failures?

3. Average amount of failures across equipment group, ordered by the number of failures in ascending order?

4.  Rank the sensors which present the most number of errors by equipment name in an equipment group.

### Recommendations: 

>- Use OOP to structure your pipeline.
>- Use PEP or Black coding style.
>- Use a GIT provider for code versioning.
>- Diagram of your resolution(s).

### Plus:

>- Tests.
>- Simulate a streaming pipeline.
>- Dockerize your app.
>- Orchestration architecture.
