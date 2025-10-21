@echo off
REM Start PUDS Frontend (Windows)

echo Starting PUDS Frontend...
cd frontend

REM Check if node_modules exists
if not exist "node_modules\" (
    echo Installing dependencies...
    npm install
)

REM Start the development server
echo Starting SvelteKit dev server on http://localhost:5173
npm run dev
