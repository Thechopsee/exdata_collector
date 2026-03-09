#!/bin/bash
cd "$(dirname "$0")"
python3 -m pip install flask flask-sqlalchemy --break-system-packages
