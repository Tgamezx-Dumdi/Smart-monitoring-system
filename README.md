# Smart System Monitor

A starter full-stack GitHub project for monitoring system health using a **Flutter mobile app** and a **Node.js backend**.

## Features
- Live system stats API
- Simulated CPU, memory, temperature, latency, and uptime data
- Alerts when values exceed thresholds
- Flutter dashboard UI
- Refresh button for polling data
- Clean project structure for future expansion

## Project Structure

```
smart_system_monitor/
├── backend/
│   ├── package.json
│   └── server.js
├── mobile/
│   ├── pubspec.yaml
│   └── lib/
│       └── main.dart
└── README.md
```

## Backend Setup

```bash
cd backend
npm install
npm start
```

Runs on:
- `http://localhost:3000/health`
- `http://localhost:3000/devices`

## Flutter Setup

Update the API base URL in `lib/main.dart`:

- Android emulator: `http://10.0.2.2:3000`
- iPhone simulator / macOS / web: `http://localhost:3000`
- Real device: use your computer's local IP, e.g. `http://192.168.1.10:3000`

Then run:

```bash
cd mobile
flutter pub get
flutter run
```

## API Response Example

`GET /health`

```json
{
  "name": "Main Server",
  "status": "warning",
  "cpu": 82,
  "memory": 68,
  "temperature": 74,
  "latency": 95,
  "uptimeHours": 123,
  "alerts": [
    "CPU usage is high",
    "Temperature above normal"
  ],
  "updatedAt": "2026-03-16T10:00:00.000Z"
}
```

## Good GitHub Improvements
- Add JWT login
- Add historical charting with `fl_chart`
- Add WebSocket real-time updates
- Add PostgreSQL or MongoDB
- Add Docker support
- Add multi-device monitoring
- Add push notifications

## Suggested Repo Name
`smart-system-monitor`

## Suggested Branch Name
`feature/smart-system-monitor-starter`
