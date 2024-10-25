import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../common/constants.dart';

class AddMaterial extends StatefulWidget {
  const AddMaterial({super.key});

  @override
  _AddMaterialState createState() => _AddMaterialState();
}

final baseUrl = dotenv.env[Constants.baseURL];

class _AddMaterialState extends State<AddMaterial> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _materialIdController = TextEditingController();
  final TextEditingController _materialCodeController = TextEditingController();
  final TextEditingController _materialDescriptionController =
      TextEditingController();
  final TextEditingController _materialQuantityController =
      TextEditingController();

  Future<void> addMaterial() async {
    final response = await http.post(
      Uri.parse('$baseUrl/material/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "Material_ID": _materialIdController.text,
        "Material_Code": _materialCodeController.text,
        "Material_Description": _materialDescriptionController.text,
        "Material_Quantity": _materialQuantityController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Material added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add material')),
      );
    }
  }

  @override
  void dispose() {
    _materialIdController.dispose();
    _materialCodeController.dispose();
    _materialDescriptionController.dispose();
    _materialQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Material')),
      body: Stack(
        children: <Widget>[
          // Background gradient
          Container(
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
          ),
          // White box container for form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _materialIdController,
                        decoration:
                            const InputDecoration(labelText: 'Material ID'),
                        validator: (value) {
                          final idPattern = RegExp(r'^\d{10}$');
                          if (value == null || !idPattern.hasMatch(value)) {
                            return 'Material ID must be a 10-digit number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _materialCodeController,
                        decoration:
                            const InputDecoration(labelText: 'Material Code'),
                        validator: (value) {
                          // Updated pattern to allow 10 or 11 characters
                          final codePattern = RegExp(r'^[A-Z0-9]{10,11}$');
                          if (value == null || !codePattern.hasMatch(value)) {
                            return 'Material Code must be a 10 or 11-character string of uppercase letters and numbers';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _materialDescriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Material Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Material Description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _materialQuantityController,
                        decoration: const InputDecoration(
                            labelText: 'Material Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Material Quantity';
                          }
                          final quantityPattern = RegExp(r'^\d+$');
                          if (!quantityPattern.hasMatch(value)) {
                            return 'Material Quantity must be a digit';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addMaterial();
                          }
                        },
                        child: const Text("Add Material"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
