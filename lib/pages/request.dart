import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List<dynamic> events = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('http://98.83.195.141:3029/api/eventos'));
    if (response.statusCode == 200) {
      setState(() {
        events = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos Solicitados'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Column(
                  children: [
                    _eventItem(
                      event['imagen'],
                      event['nombre'],
                      event['lugar']
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
    );
  }

  Widget _eventItem(String imagePath, String name, String location) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 47, 43, 173),
          width: 6.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
            },
            child: Image.network(
              imagePath,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            name,
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 7.0),
          Text(location),
        ],
      ),
    );
  }
}

class BuyTicket extends StatelessWidget {
  final String eventId;

  const BuyTicket({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprar Entradas'),
      ),
      body: Center(
        child: Text('Compra de entradas para el evento con ID: $eventId'),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RequestPage(),
  ));
}
