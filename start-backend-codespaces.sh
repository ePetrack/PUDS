#!/bin/bash
# Start PUDS Backend in Codespaces

cd backend

# Activate venv if it exists, create if not
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
else
    source venv/bin/activate
fi

echo "Starting PUDS Backend..."
echo "API Docs: Check Ports tab for forwarded URL + /api/docs"
echo ""
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
