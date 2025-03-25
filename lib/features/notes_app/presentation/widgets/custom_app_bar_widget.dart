import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/home/home_bloc.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _isGridView = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _searchController.dispose();
    _isGridView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(180, 37, 36, 41),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.search, size: 30),
          const SizedBox(
            height: 30,
            child: VerticalDivider(
              color: Colors.white,
              thickness: 2,
              width: 20,
            ),
          ),
          Expanded(
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is HomeStateLoadedAllData) {
                  _isGridView.value = state.isGridView;
                }
              },
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<HomeBloc>().add(
                    HomeEventSearchNote(text: value),
                  );
                },
                decoration: const InputDecoration(
                  hintText: "Search note title...",
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isGridView,
            builder: (context, isGrid, child) {
              return IconButton(
                onPressed: () {
                  context.read<HomeBloc>().add(ToggleEventViewMode());
                },
                icon: Icon(isGrid ? Icons.grid_view : Icons.list, size: 30),
              );
            },
          ),
        ],
      ),
    );
  }
}
