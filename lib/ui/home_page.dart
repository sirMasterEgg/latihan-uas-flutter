import 'package:flutter/material.dart';
import 'package:latihanuas/config/firebase_auth_config.dart';
import 'package:latihanuas/provider/catatan_provider.dart';
import 'package:latihanuas/ui/add_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _auth = AuthConfig();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      syncData();
    });
  }

  void syncData() async {
    final provider = Provider.of<CatatanProvider>(context, listen: false);


  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatatanProvider>(context, listen: true);

    if (_searchController.text == '') {
      provider.fetchCatatan();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<CatatanProvider>(
            builder: (BuildContext context, CatatanProvider provider, Widget? child) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Long press to delete, tap to edit'),
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Logout', style: TextStyle(color: Colors.red)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[100]
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                  ),
                  controller: _searchController,
                  onChanged: (value){
                    provider.filterCatatan(value);
                  },
                ),
                Expanded(
                  child: provider.filteredCatatans.isNotEmpty ? ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(provider.filteredCatatans[index].catatan),
                          subtitle: Text(provider.filteredCatatans[index].dateCreated),
                          onTap: () {
                            provider.setCatatan(provider.filteredCatatans[index]);
                            Navigator.of(context).pushNamed(AddPage.routeName);
                          },
                          onLongPress: () {
                            provider.removeCatatan(provider.filteredCatatans[index]);
                          },
                        ),
                      );
                    },
                    itemCount: provider.filteredCatatans.length,
                  ) : const Center(child: Text('Tidak ada catatan'))
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

}
