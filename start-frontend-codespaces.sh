#!/bin/bash
# Start PUDS Frontend in Codespaces

cd frontend

# Install if needed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

echo "Starting PUDS Frontend..."
echo "Open the forwarded port 5173 in your browser!"
echo ""
npm run dev -- --host
