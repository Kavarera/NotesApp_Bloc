import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/home/home_bloc.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(180, 37, 36, 41),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.search, size: 30),
          VerticalDivider(
            color: Colors.white,
            thickness: 5,
            width: 20,
            indent: 20,
            endIndent: 0,
          ),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return TextField(
                  onChanged:
                      (value) => context.read<HomeBloc>().add(
                        HomeEventSearchNote(text: value),
                      ),
                  decoration: InputDecoration(
                    hintText: "Search note title",
                    border: InputBorder.none,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              },
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeStateLoadedAllData) {
                return IconButton(
                  onPressed: () {
                    context.read<HomeBloc>().add(ToggleEventViewMode());
                  },
                  icon:
                      state.isGridView
                          ? Icon(Icons.grid_view, size: 30)
                          : Icon(Icons.list, size: 30),
                );
              } else {
                return const Icon(Icons.error, size: 30);
              }
            },
          ),
        ],
      ),
    );
  }
}
