import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/widgets/custom_app_bar_widget.dart';

import '../bloc/home/home_bloc.dart';
import '../widgets/category_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.goNamed('detail');
          },
          child: Icon(Icons.add, color: Colors.black),
        ),
        body: Column(
          children: [
            SizedBox(height: 20, child: Container(color: Colors.transparent)),
            CustomAppBar(), //CUSTOM APP BAR
            CategoryListWidget(), //CATEGORY LIST
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeStateLoadedAllData) {
                    //IF STATE NOTES IS EMPTY
                    if (state.notes.isEmpty) {
                      return Center(
                        child: Text(
                          "No Notes",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      );
                    } else {
                      //IF VIEW IS GRID
                      if (state.isGridView) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: state.notes.length,
                          itemBuilder: (context, index) {
                            final note = state.notes[index];
                            return Dismissible(
                              key: Key(note.id.toString()),
                              onDismissed: (_) {
                                context.read<HomeBloc>().add(
                                  HomeEventDeleteNote(noteEntity: note),
                                );
                              },
                              direction: DismissDirection.down,
                              child: InkWell(
                                onTap: () {
                                  //TODO EDIT NOTE EVENT
                                  context.goNamed('detail', extra: note);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.primaries[index %
                                            Colors.primaries.length],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.category?.name ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        note.title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(text: note.content),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 7,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: state.notes.length,
                          itemBuilder: (context, index) {
                            final note = state.notes[index];
                            return Dismissible(
                              key: Key(note.id.toString()),
                              onDismissed: (_) {
                                context.read<HomeBloc>().add(
                                  HomeEventDeleteNote(noteEntity: note),
                                );
                              },
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: ListTile(
                                onTap: () {
                                  //TODO EDIT NOTE EVENT
                                },
                                title: Text(note.title),
                                subtitle: Text(note.category?.name ?? ''),
                              ),
                            );
                          },
                        );
                      }
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
