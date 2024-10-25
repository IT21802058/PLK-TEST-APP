import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // QR scanner import

import '../../common/constants.dart';
import 'editMaterial.dart';

class ViewMaterial extends StatefulWidget {
  const ViewMaterial({super.key});

  @override
  _ViewMaterialState createState() => _ViewMaterialState();
}

final baseUrl = dotenv.env[Constants.baseURL];

class _ViewMaterialState extends State<ViewMaterial> {
  List<dynamic> materials = [];
  List<dynamic> filteredMaterials = [];
  String? qrCodeResult; // Store QR code result

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Future<void> fetchMaterials() async {
    final response =
        await http.get(Uri.parse('$baseUrl/material/materiallist/'));
    if (response.statusCode == 200) {
      setState(() {
        materials = json.decode(response.body);
        filteredMaterials = materials;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something happend when fetching data')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  void _searchByQrCode(String materialCode) {
    setState(() {
      filteredMaterials = materials
          .where((material) => material['Material_Code'] == materialCode)
          .toList();
    });
  }

  // Method to open QR code scanner
  void _scanQRCode() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRViewExample(
          onQRViewCreated: (result) {
            setState(() {
              qrCodeResult = result;
              _searchByQrCode(qrCodeResult!); // Use scanned result to filter
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQRCode, // Scan QR code button
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 133, 224, 125),
              Color.fromARGB(255, 187, 251, 201),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              children: [
                // Scrollable table with vertical and horizontal scroll
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                              label: Text("Material ID",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Material Code",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Material Description",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Material Quantity",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text("Actions",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: filteredMaterials.map((material) {
                          return DataRow(
                            onSelectChanged: (selected) {
                              if (selected!) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditMaterial(
                                        materialId: material["_id"]),
                                  ),
                                ).then((_) {
                                  // Fetch materials again after returning
                                  fetchMaterials();
                                });
                              }
                            },
                            cells: [
                              DataCell(Text(material["Material_ID"])),
                              DataCell(Text(material["Material_Code"])),
                              DataCell(Text(material["Material_Description"])),
                              DataCell(Text(material["Material_Quantity"])),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await deleteMaterial(material["_id"]);
                                    fetchMaterials(); // Refresh list
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteMaterial(String id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/material/remove-material/$id'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Material removed successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error in Removing matterial')),
      );
    }
  }
}

// QR code scanner widget
class QRViewExample extends StatefulWidget {
  final void Function(String) onQRViewCreated;
  const QRViewExample({super.key, required this.onQRViewCreated});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      widget.onQRViewCreated(scanData.code!);
      Navigator.pop(context); // Close the scanner once QR code is scanned
    });
  }
}
