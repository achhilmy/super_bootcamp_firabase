import 'package:firebase_superbootcamp/blocs/user_bloc/user_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPages extends StatefulWidget {
  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  // const MainPages({super.key});
  final TextEditingController namaController = TextEditingController();

  /// Selected Umur
  int selectedUmur = 18;

  @override
  void initState() {
    super.initState();

    /// Jalankan Users Fetch
    context.read<UserBloc>().add(UserFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Materi Cloud Firestore",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Field
            Row(
              children: [
                /// Dropdown Field untuk Umur
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    value: selectedUmur,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: List.generate(
                      99,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text("${index + 1}"),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedUmur = value;
                        });
                      }
                    },
                  ),
                ),

                /// Nama Field
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "Nama",
                      ),
                      controller: namaController,
                    ),
                  ),
                ),
              ],
            ),

            /// Button Kirim
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  context.read<UserBloc>().add(
                        UserAdded(
                          nama: namaController.text,
                          umur: selectedUmur,
                        ),
                      );
                },
                child: const Text("Kirim ke Firestore"),
              ),
            ),

            /// Daftar data yang ada di Firebase
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  shrinkWrap: true,
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final data = state.users[index];

                    return Text(
                      "${index + 1}. Umur : ${data['umur']}, Nama ${data['nama']}",
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
