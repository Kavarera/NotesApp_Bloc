import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/home/home_bloc.dart';

class AddCategoryDialogWidget extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  AddCategoryDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(137, 37, 37, 37),
          border: Border.all(
            color: const Color.fromARGB(255, 104, 104, 104),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Add New Category",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                hintText: "Category Name",
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(color: Colors.black),
              controller: controller,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.read<HomeBloc>().add(
                  HomeEventAddCategory(categoryName: controller.text),
                );
                Navigator.of(context).pop();
              },
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
