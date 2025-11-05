#!/bin/bash
echo "Tao moi truong ao (virtual environment) trong thu muc 'venv'..."
python3 -m venv venv

echo "Kich hoat moi truong ao..."
source venv/bin/activate

echo "Cai dat cac thu vien can thiet tu requirements.txt..."
pip install -r requirements.txt

echo "Hoan tat! Ban co the chay script bang cach:"
echo "source venv/bin/activate"
echo "python main/seeding.py"