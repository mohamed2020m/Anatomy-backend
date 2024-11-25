# Terraviva Quiz Generator

![PyPI - Version](https://img.shields.io/pypi/v/fastapi?label=fastapi)

**Note:** `I am using Python 3.10.0`

Currently, This project has two main components, 
- Generating description of an object 3D 
- and generation of a Quiz from a document.

## Configuration

- Create an account on [groq](https://console.groq.com/login)
- Create an API key.
- Copy the key and put it in the `.env`

Then you can run `pip install -r requirements.txt`


## Run project

To run the project, you can follow theses steps:

1. Create new virtual environments `python -m venv .venv`
2. Install dependencies: `pip install -r requirements.txt`
3. run `python app.py`

The project offers a gardio demo for quiz generation too. However, for `obj-to-text`are only accessible via api at the moment.

Note: Swagger documentation is accessible in `/docs`.

## TODO
- Working on `text-to-3d`
- Adding `image-to-3d`
- Adding authentication to the apis

## Author
2024 - @Terraviva Team



