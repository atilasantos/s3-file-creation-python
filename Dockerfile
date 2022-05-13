FROM python:3.9 AS Builder

COPY requirements.txt requirements.txt
RUN pip install --user -r requirements.txt

FROM python:3.9-slim
COPY --from=Builder /root/.local /root/.local
COPY src src
WORKDIR /src

ENTRYPOINT ["python3","run.py"]