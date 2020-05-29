FROM registry.redhat.io/ubi8/ubi-minimal

RUN microdnf install python3; microdnf clean all

RUN python3 -m venv /opt/venv

COPY src/requirements.txt .
COPY src/requirements ./requirements

ENV PATH="/opt/venv/bin:$PATH"

RUN pip install -r requirements.txt

RUN mkdir /django

ENV PORT=8000

EXPOSE 8000

WORKDIR /django

ADD src /django

RUN python manage.py makemigrations

CMD ["/django/runapp.sh"]