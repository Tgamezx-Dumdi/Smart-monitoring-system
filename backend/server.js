const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

const devices = [
  { id: 1, name: 'Main Server', location: 'Server Room A' },
  { id: 2, name: 'Backup Server', location: 'Server Room B' },
  { id: 3, name: 'Chiller Controller', location: 'Plant Floor' }
];

function rand(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function buildHealth(name) {
  const cpu = rand(25, 95);
  const memory = rand(30, 90);
  const temperature = rand(35, 85);
  const latency = rand(12, 140);
  const uptimeHours = rand(20, 720);

  const alerts = [];
  if (cpu > 80) alerts.push('CPU usage is high');
  if (memory > 85) alerts.push('Memory usage is critical');
  if (temperature > 70) alerts.push('Temperature above normal');
  if (latency > 100) alerts.push('Network latency is high');

  let status = 'healthy';
  if (alerts.length >= 2) {
    status = 'critical';
  } else if (alerts.length === 1) {
    status = 'warning';
  }

  return {
    name,
    status,
    cpu,
    memory,
    temperature,
    latency,
    uptimeHours,
    alerts,
    updatedAt: new Date().toISOString()
  };
}

app.get('/', (req, res) => {
  res.json({ message: 'Smart System Monitor API is running' });
});

app.get('/devices', (req, res) => {
  res.json(devices);
});

app.get('/health', (req, res) => {
  res.json(buildHealth('Main Server'));
});

app.get('/health/:id', (req, res) => {
  const id = Number(req.params.id);
  const device = devices.find((d) => d.id === id);

  if (!device) {
    return res.status(404).json({ error: 'Device not found' });
  }

  res.json(buildHealth(device.name));
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
