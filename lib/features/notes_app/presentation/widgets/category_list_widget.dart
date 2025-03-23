import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/bloc/home/home_bloc.dart';
import 'package:notesapp_bloc/features/notes_app/presentation/widgets/add_category_widget.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      height: MediaQuery.of(context).size.height * 0.1,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeStateLoadedAllData) {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                var category = state.categories.elementAt(index);
                if (category.id == -1) {
                  return ElevatedButton(
                    onPressed: () {
                      _showAddCategoryDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.white),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        Text(
                          category.name,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else {
                  if (category.id == -2) {
                    return InkWell(
                      onTap: () {
                        if (category.id == -2) {
                          //TODO Dispatch event to reset notes
                          context.read<HomeBloc>().add(
                            HomeEventSelectCategoryFilter(
                              selectedFilterCategory: category,
                            ),
                          );
                          // context.read<HomeBloc>().add(HomeEventGetAllData());
                        } else {}
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 5,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Text(category.name),
                      ),
                    );
                  } else {
                    return Dismissible(
                      key: Key(category.id.toString()),
                      direction: DismissDirection.up,
                      onDismissed: (_) {
                        context.read<HomeBloc>().add(
                          HomeEventDeleteCategory(categoryId: category.id!),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          context.read<HomeBloc>().add(
                            HomeEventSelectCategoryFilter(
                              selectedFilterCategory: category,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 5,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Text(category.name),
                        ),
                      ),
                    );
                  }
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialogWidget(),
    );
  }
}
