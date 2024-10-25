import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../common/constants.dart';

class EditMaterial extends StatefulWidget {
  final String materialId;

  const EditMaterial({super.key, required this.materialId});

  @override
  _EditMaterialState createState() => _EditMaterialState();
}

final baseUrl = dotenv.env[Constants.baseURL];

class _EditMaterialState extends State<EditMaterial> {
  Map<String, dynamic>? material;
  bool isLoading = true;

  Future<void> fetchMaterial() async {
    final response =
        await http.get(Uri.parse('$baseUrl/material/${widget.materialId}'));
    if (response.statusCode == 200) {
      setState(() {
        material = json.decode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load material data')),
      );
    }
  }

  Future<void> updateMaterial() async {
    final response = await http.put(
      Uri.parse('$baseUrl/material/update-material/${widget.materialId}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "Material_Description": material!["Material_Description"],
        "Material_Quantity": material!["Material_Quantity"],
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Material updated successfully')),
      );

      // Add a delay of 5 seconds before navigating back
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update material')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMaterial();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Material')),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
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
                  TextFormField(
                    initialValue: material!["Material_Description"],
                    decoration: const InputDecoration(
                        labelText: 'Material Description'),
                    onChanged: (value) {
                      material!["Material_Description"] = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: material!["Material_Quantity"].toString(),
                    decoration:
                        const InputDecoration(labelText: 'Material Quantity'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      material!["Material_Quantity"] = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateMaterial,
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
