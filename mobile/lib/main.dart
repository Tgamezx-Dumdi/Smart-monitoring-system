import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SmartMonitorApp());
}

class SmartMonitorApp extends StatelessWidget {
  const SmartMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'System Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Change this depending on your platform.
  static const String baseUrl = 'http://localhost:3000';

  Map<String, dynamic>? data;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchHealth();
  }

  Future<void> fetchHealth() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body) as Map<String, dynamic>;
          loading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load data: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Connection error: $e';
        loading = false;
      });
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'healthy':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart System Monitor'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchHealth,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (loading)
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(error!, style: const TextStyle(fontSize: 16)),
                ),
              )
            else if (data != null) ...[
              _HeaderCard(
                name: data!['name'] ?? 'Unknown Device',
                status: data!['status'] ?? 'unknown',
                updatedAt: data!['updatedAt'] ?? '',
                color: statusColor(data!['status'] ?? ''),
              ),
              const SizedBox(height: 16),
              _MetricCard(
                  title: 'CPU Usage',
                  value: '${data!['cpu']}%',
                  icon: Icons.memory),
              _MetricCard(
                  title: 'Memory Usage',
                  value: '${data!['memory']}%',
                  icon: Icons.storage),
              _MetricCard(
                  title: 'Temperature',
                  value: '${data!['temperature']}°C',
                  icon: Icons.thermostat),
              _MetricCard(
                  title: 'Latency',
                  value: '${data!['latency']} ms',
                  icon: Icons.network_ping),
              _MetricCard(
                  title: 'Uptime',
                  value: '${data!['uptimeHours']} hrs',
                  icon: Icons.timer),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alerts',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...(data!['alerts'] as List<dynamic>).isEmpty
                          ? [const Text('No active alerts')]
                          : (data!['alerts'] as List<dynamic>)
                              .map((alert) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.warning_amber_rounded),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(alert.toString())),
                                      ],
                                    ),
                                  ))
                              .toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: fetchHealth,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Data'),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String name;
  final String status;
  final String updatedAt;
  final Color color;

  const _HeaderCard({
    required this.name,
    required this.status,
    required this.updatedAt,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w600, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Updated: $updatedAt'),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
