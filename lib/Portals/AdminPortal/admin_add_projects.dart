import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class AddProjects extends StatefulWidget {
  @override
  _AddProjectsState createState() => _AddProjectsState();
}

class _AddProjectsState extends State<AddProjects> {
  final List<String> sessions = [
    '2024-2028',
    '2023-2027',
    '2022-2026',
    '2021-2025',
    '2020-2024',
    '2019-2023',
    '2018-2022',
    '2017-2021',
    '2016-2020',
    '2015-2019',
    '2014-2018',
    '2013-2017',
    '2012-2016',
    '2011-2015',
    '2010-2014',
  ];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _student1Controller = TextEditingController();
  final TextEditingController _student2Controller = TextEditingController();
  String? _uploadedFileUrl;
  bool _isUploading = false;
  String? _selectedSession;


  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _isUploading = true;
        });

        PlatformFile file = result.files.first;

        // Use the file path instead of file bytes
        if (file.path != null) {
          File localFile = File(file.path!);
          final fileBytes = await localFile.readAsBytes();

          String fileName = file.name;
          Reference storageReference = FirebaseStorage.instance.ref().child('project_files/$fileName');
          UploadTask uploadTask = storageReference.putData(fileBytes);

          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          setState(() {
            _uploadedFileUrl = downloadUrl;
            _isUploading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File uploaded successfully')),
          );
        } else {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to read file data. Please try another file.')),
          );
        }
      } else {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File upload canceled')),
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during file upload: $e')),
      );
      print('Error during file upload: $e');  // Log the error for debugging
    }
  }



  Future<void> _addProjectToFirebase() async {
    if (_formKey.currentState!.validate() && _uploadedFileUrl != null) {
      await FirebaseFirestore.instance.collection('PastProjects').add({
        'projectName': _projectTitleController.text,
        'Student1': _student1Controller.text,
        'Student2': _student2Controller.text,
        'supervisor': _supervisorController.text,
        'description': _descriptionController.text,
        'session': _selectedSession,
        'fileUrl': _uploadedFileUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project added successfully!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _uploadedFileUrl = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload a file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Add Project'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _projectTitleController,
                  decoration: InputDecoration(labelText: 'Project Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _supervisorController,
                  decoration: InputDecoration(labelText: 'Supervisor Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter supervisor name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _student1Controller,
                  decoration: InputDecoration(labelText: 'First Student'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Student name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _student2Controller,
                  decoration: InputDecoration(labelText: 'Second Student(optional)'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Project Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedSession,
                  items: sessions.map((String session) {
                    return DropdownMenuItem<String>(
                      value: session,
                      child: Text(session),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSession = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Session'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a session';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _pickAndUploadFile,
                  icon: Icon(Icons.upload_file),
                  label: Text(_isUploading ? 'Uploading...' : 'Upload Document'),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addProjectToFirebase,
                    child: Text('Add Project'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
