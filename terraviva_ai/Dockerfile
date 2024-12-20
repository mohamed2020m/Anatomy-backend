FROM python:3.10.0-slim

# Create app directory
WORKDIR /app

COPY ./requirements.txt ./

COPY ./ ./

# Install app dependencies
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 8000
CMD [ "python", "app.py" ]