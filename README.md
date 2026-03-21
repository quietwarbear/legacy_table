# Legacy Table

Where family recipes live forever.

## Project Structure

```
legacy_table/
├── frontend/    # React web app (Vercel)
├── backend/     # FastAPI server (Railway)
└── mobile/      # Flutter app (iOS & Android)
```

## Frontend (React)

```bash
cd frontend
npm install
npm start
```

## Backend (FastAPI)

```bash
cd backend
pip install -r requirements.txt
cp sample.env .env   # fill in your values
uvicorn server:app --reload
```

## Mobile (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```
