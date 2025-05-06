#!/bin/bash

# Aktivoi virtuaaliympäristö
source venv/bin/activate

# Aseta Flaskin käynnistystiedosto
export FLASK_APP=app.py

# Aja Flask-serveri
flask run --port=5050
