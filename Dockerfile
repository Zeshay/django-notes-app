#<-------stage one----->
FROM python:3 as builder
WORKDIR  /app

COPY requirements.txt . 

RUN pip install --prefix=/install -r  requirements.txt


#<------stage two------->



FROM python:3.10-slim 

WORKDIR /app

ENV PYTHONUNBUFFERED=1

COPY --from=builder /install /usr/local

COPY . .

EXPOSE 8000

CMD ["python","manage.py","runserver","0.0.0.0:8000"]


