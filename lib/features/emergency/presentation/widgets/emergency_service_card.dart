// =====================================================
// features/emergency/presentation/widgets/service_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/emergency_service_entity.dart';
import '../../domain/entities/emergency_number_entity.dart';

class EmergencyServiceCard extends StatelessWidget {
  final EmergencyServiceEntity service;

  const EmergencyServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to detail screen if needed
          // Navigator.push(context, ...);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon, name, and priority badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryIcon(service.category),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (service.contactHours != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                service.contactHours!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (service.priority <= 5)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'PRIORITY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              // Description
              if (service.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  service.description!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],

              // Coverage info
              if (service.coverageName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      service.coverageName!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Phone Numbers
              if (service.numbers.isNotEmpty)
                ...service.numbers.map(
                  (number) => _buildNumberButton(context, number),
                ),

              // Tags
              if (service.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: service.tags
                      .take(3)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String category) {
    IconData icon;
    Color color;

    switch (category) {
      case 'police':
        icon = Icons.local_police;
        color = Colors.blue;
        break;
      case 'fire':
        icon = Icons.local_fire_department;
        color = Colors.orange;
        break;
      case 'ambulance':
        icon = Icons.local_hospital;
        color = Colors.red;
        break;
      case 'sar':
        icon = Icons.sailing;
        color = Colors.cyan;
        break;
      case 'disaster':
        icon = Icons.warning;
        color = Colors.amber;
        break;
      case 'utility':
        icon = Icons.bolt;
        color = Colors.yellow[700]!;
        break;
      case 'hotline':
        icon = Icons.phone;
        color = Colors.green;
        break;
      case 'medical':
        icon = Icons.medical_services;
        color = Colors.teal;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildNumberButton(
    BuildContext context,
    EmergencyNumberEntity number,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _makeCall(number.value, number.type),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(
                _getNumberIcon(number.type),
                color: Colors.green[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (number.label != null)
                      Text(
                        number.label!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    Text(
                      number.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (number.notes != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        number.notes!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (number.available247 == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '24/7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                _getActionIcon(number.type),
                color: Colors.green[700],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNumberIcon(String type) {
    switch (type) {
      case 'whatsapp':
        return Icons.chat_bubble;
      case 'sms':
        return Icons.message;
      case 'fax':
        return Icons.print;
      case 'voip':
      case 'sip':
        return Icons.video_call;
      default:
        return Icons.phone;
    }
  }

  IconData _getActionIcon(String type) {
    switch (type) {
      case 'whatsapp':
        return Icons.send;
      case 'sms':
        return Icons.send;
      default:
        return Icons.call;
    }
  }

  Future<void> _makeCall(String value, String type) async {
    Uri? uri;

    switch (type) {
      case 'whatsapp':
        // Remove all non-numeric characters except +
        final cleanNumber = value.replaceAll(RegExp(r'[^\d+]'), '');
        uri = Uri.parse('https://wa.me/$cleanNumber');
        break;
      case 'sms':
        uri = Uri(scheme: 'sms', path: value);
        break;
      case 'voice':
      default:
        uri = Uri(scheme: 'tel', path: value);
        break;
    }

    await launchUrl(uri);
  }
}
