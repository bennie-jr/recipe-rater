FROM alpine:3.11 AS builder

WORKDIR /app

RUN apk update && \
    apk add --no-cache python3 python3-dev py3-pip build-base && \
    python3 -m venv /opt/venv && \
    source /opt/venv/bin/activate && \
    python3 -m pip install --upgrade pip && \
    rm -rf /var/cache/apk/*

# RUN python3.9 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt


FROM alpine:3.11 AS runner

WORKDIR /app

RUN apk update && \
    apk add --no-cache python3 && \
    apk add curl && \
    rm -rf /var/cache/apk/*

COPY --from=builder /opt/venv /opt/venv

COPY app/src .

ENV PATH="/opt/venv/bin:$PATH"

# ENV MONGO_URI="mongodb+srv://bensowahjr:kkkabobo@recipeniggas.oxjneke.mongodb.net/?retryWrites=true&w=majority"

EXPOSE 8085

CMD ["flask", "run", "--host=0.0.0.0", "--port", "8085"]




