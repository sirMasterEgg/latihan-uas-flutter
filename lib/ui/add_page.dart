import 'package:flutter/material.dart';
import 'package:latihanuas/config/firebase_auth_config.dart';
import 'package:latihanuas/models/catatan_model.dart';
import 'package:latihanuas/provider/catatan_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddPage extends StatefulWidget {
  static const routeName = '/add';
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _noteController = TextEditingController();
  final _auth = AuthConfig();
  final uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CatatanProvider>(context, listen: false);

      if(provider.getCatatan != null){
        _noteController.text = provider.getCatatan!.catatan;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final noteProvider = Provider.of<CatatanProvider>(context, listen: false);
          final note = _noteController.text;

          if (noteProvider.getCatatan != null) {
            print('update');
            print('update ${noteProvider.getCatatan!.id}');
            CatatanModel newNote = CatatanModel(
                id: noteProvider.getCatatan!.id,
                owner: _auth.user?.uid ?? '' ,
                catatan: note,
                dateCreated: DateTime.now().toString()
            );
            noteProvider.updateCatatan(newNote);
          } else {
            CatatanModel newNote = CatatanModel(
                id: uuid.v4(),
                owner: _auth.user?.uid ?? '' ,
                catatan: note,
                dateCreated: DateTime.now().toString()
            );
            noteProvider.addCatatan(newNote);
          }

          Navigator.pop(context); // Navigate back to the previous page
        },
        child: const Icon(Icons.check),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Add Your Note!', style: TextStyle(fontSize: 24)),
                TextField(
                  controller: _noteController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Write your note here...',
                    border: InputBorder.none,
                  ),
                  maxLines: 99,
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
