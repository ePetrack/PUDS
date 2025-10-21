#!/bin/bash
# PUDS Codespaces Quick Setup

echo "========================================="
echo "PUDS MVP - Codespaces Setup"
echo "========================================="
echo ""

# Backend setup
echo "[1/4] Setting up backend..."
cd backend
python -m venv venv
source venv/bin/activate
pip install --upgrade pip --quiet
pip install -r requirements.txt
cd ..
echo "✓ Backend setup complete"
echo ""

# Frontend setup
echo "[2/4] Setting up frontend..."
cd frontend
npm install
cd ..
echo "✓ Frontend setup complete"
echo ""

echo "========================================="
echo "✓ Setup Complete!"
echo "========================================="
echo ""
echo "To start PUDS:"
echo ""
echo "Terminal 1 - Backend:"
echo "  cd backend"
echo "  source venv/bin/activate"
echo "  python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000"
echo ""
echo "Terminal 2 - Frontend:"
echo "  cd frontend"
echo "  npm run dev -- --host"
echo ""
echo "Then open the forwarded port 5173 in your browser!"
echo ""
