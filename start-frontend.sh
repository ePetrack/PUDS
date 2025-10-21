#!/bin/bash
# Start PUDS Frontend

echo "Starting PUDS Frontend..."
cd frontend

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Start the development server
echo "Starting SvelteKit dev server on http://localhost:5173"
npm run dev
