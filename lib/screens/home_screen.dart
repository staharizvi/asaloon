// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'payment_screen.dart';
import 'tryon_screen.dart';
import '/models/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of available services
  final List<Service> services = [
    Service(id: '1', name: 'HAIR CUT', price: 30.0),
    Service(id: '2', name: 'FACIAL', price: 45.0),
    Service(id: '3', name: 'KERATIN', price: 80.0),
    Service(id: '4', name: 'SHAVE', price: 20.0),
  ];

  // Controller for date input
  final TextEditingController _dateController = TextEditingController();

  // Calculate total cost based on selected services
  double get totalCost {
    return services
        .where((service) => service.isSelected)
        .fold(0, (sum, service) => sum + service.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Title
              const Center(
                child: Text(
                  'AI Saloon',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Upcoming Appointments Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'UPCOMING APPOINTMENTS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppointmentCard(
                      stylist: 'John Doe',
                      dateTime: 'Jan 20, 2025 10:00 AM',
                    ),
                    const SizedBox(height: 8),
                    AppointmentCard(
                      stylist: 'Jane Smith',
                      dateTime: 'Jan 22, 2025 2:00 PM',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Book Appointment Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BOOK AN APPOINTMENT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side - Dropdowns and Payment
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              // Stylist Dropdown
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                                hint: const Text('Select Stylist'),
                                items: const [
                                  DropdownMenuItem(value: '1', child: Text('John Doe')),
                                  DropdownMenuItem(value: '2', child: Text('Jane Smith')),
                                ],
                                onChanged: (value) {},
                              ),
                              const SizedBox(height: 12),

                              // Time Slot Dropdown
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                                hint: const Text('Select Time Slot'),
                                items: const [
                                  DropdownMenuItem(value: '1', child: Text('10:00 AM')),
                                  DropdownMenuItem(value: '2', child: Text('11:00 AM')),
                                ],
                                onChanged: (value) {},
                              ),
                              const SizedBox(height: 12),

                              // Date Input
                              TextFormField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  labelText: 'Select Date',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _dateController.text = pickedDate.toString().split(' ')[0];
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 12),

                              // Total and Pay Button
                              Row(
                                children: [
                                  Text(
                                    'TOTAL COST: \$${totalCost.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: totalCost > 0
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const PaymentScreen(),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: const Text('PAY NOW'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right side - Services Checklist
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: services.map((service) {
                              return CheckboxListTile(
                                title: Text(service.name),
                                value: service.isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    service.isSelected = value ?? false;
                                  });
                                },
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                subtitle: Text('\$${service.price.toStringAsFixed(2)}'),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Try On Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TryOnScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('TRY ON'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String stylist;
  final String dateTime;

  const AppointmentCard({
    super.key,
    required this.stylist,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(stylist),
          Text(dateTime),
        ],
      ),
    );
  }
}