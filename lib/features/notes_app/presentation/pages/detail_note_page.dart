import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notesapp_bloc/DI/dependency_injection.dart';
import 'package:notesapp_bloc/core/utils/custom_formating_rules.dart';
import 'package:notesapp_bloc/core/utils/custom_text_controller.dart';
import 'package:notesapp_bloc/features/notes_app/domain/entities/note_entity.dart';

import '../bloc/detail/detail_bloc.dart';
import '../bloc/home/home_bloc.dart';

class DetailNotePage extends StatefulWidget {
  final NoteEntity? noteEntity;
  const DetailNotePage({super.key, this.noteEntity});

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  late TextEditingController titleController;
  late CustomTextController contentController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = CustomTextController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create:
            (context) =>
                DependencyInjection<DetailBloc>()
                  ..add(LoadNoteDetailEvent(noteEntity: widget.noteEntity)),
        child: BlocListener<DetailBloc, DetailState>(
          listener: (context, state) {
            if (state is NoteDetailLoadedState) {
              // Set nilai awal hanya sekali
              titleController.text = state.title;
              contentController.text = state.content;
            }
            if (state is NoteDetailSavedState) {
              context.read<HomeBloc>().add(HomeEventGetAllData());
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.goNamed('home');
                }
              });
            }
          },
          child: BlocBuilder<DetailBloc, DetailState>(
            builder: (context, state) {
              if (state is! NoteDetailLoadedState) {
                return const Center(child: CircularProgressIndicator());
              }

              titleController.text = state.title;
              contentController.text = state.content;

              return Scaffold(
                appBar: AppBar(
                  title: TextField(
                    controller: titleController,
                    decoration: InputDecoration(border: InputBorder.none),
                    onSubmitted: (v) {
                      context.read<DetailBloc>().add(ChangeTitleEvent(v));
                    },
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed:
                          () => context.read<DetailBloc>().add(
                            SaveNoteEvent(noteId: widget.noteEntity?.id),
                          ),
                      icon: Icon(Icons.save, color: Colors.white),
                    ),
                  ],
                ),
                bottomNavigationBar: PopupMenuButton(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  menuPadding: const EdgeInsets.symmetric(vertical: 5),
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  position: PopupMenuPosition.over,
                  onSelected: (int value) {
                    context.read<DetailBloc>().add(
                      ChangeSelectedCategoryEvent(categoryId: value),
                    );
                  },
                  itemBuilder: (BuildContext context) {
                    return state.categories.map((c) {
                      return PopupMenuItem(
                        value: c.id,
                        child: Text(
                          c.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.apply(color: Colors.black),
                        ),
                      );
                    }).toList();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              state.selectedCategory == null
                                  ? Text("Select Category")
                                  : Text(state.selectedCategory!.name),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            context.read<DetailBloc>().add(
                              ChangeSelectedCategoryEvent(categoryId: null),
                            );
                          },
                          child: Icon(Icons.block),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: Visibility(
                  visible: state.isContentEditMode,
                  child: FloatingActionButton(
                    onPressed: () {
                      focusNode.unfocus();
                      context.read<DetailBloc>().add(
                        ToggleEditModeEvent(
                          isEditMode: state.isContentEditMode,
                          newContent: contentController.text,
                        ),
                      );
                    },
                    child: Icon(Icons.check),
                  ),
                ),
                body: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                //TODO: ADD FORMATTING ACTION
                                _applyFormat(
                                  focusNode,
                                  contentController,
                                  CustomTextFormat.bold,
                                );
                              },
                              icon: Icon(Icons.format_bold),
                            ),
                            IconButton(
                              onPressed: () {
                                //TODO: ADD FORMATTING ACTION
                                _applyFormat(
                                  focusNode,
                                  contentController,
                                  CustomTextFormat.italic,
                                );
                              },
                              icon: Icon(Icons.format_italic),
                            ),
                            IconButton(
                              onPressed: () {
                                //TODO: ADD FORMATTING ACTION
                                _applyFormat(
                                  focusNode,
                                  contentController,
                                  CustomTextFormat.underline,
                                );
                              },
                              icon: Icon(Icons.format_underline),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Flexible(
                        child: SingleChildScrollView(
                          child:
                              state.isContentEditMode
                                  ? TextField(
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    controller: contentController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      hintText: "Buy 100 eggs",
                                    ),
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  )
                                  : InkWell(
                                    onTap: () {
                                      focusNode.requestFocus();
                                      if (state.title != titleController.text) {
                                        context.read<DetailBloc>().add(
                                          ChangeTitleEvent(
                                            titleController.text,
                                          ),
                                        );
                                      }
                                      context.read<DetailBloc>().add(
                                        ToggleEditModeEvent(
                                          isEditMode: state.isContentEditMode,
                                          newContent: contentController.text,
                                        ),
                                      );
                                    },
                                    child:
                                        state.content.isEmpty
                                            ? Text(
                                              "Tap to add content",
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.headlineMedium,
                                            )
                                            : SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                              child: RichText(
                                                text: contentController
                                                    .buildTextSpan(
                                                      context: context,
                                                      style:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleLarge,
                                                      withComposing: true,
                                                      showTags: false,
                                                    ),
                                              ),
                                            ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _applyFormat(
    FocusNode focusNode,
    CustomTextController contentController,
    CustomTextFormat s,
  ) {
    if (!focusNode.hasFocus) {
      return;
    }
    final selectionText = contentController.selection;
    //jika terselect
    if (selectionText.baseOffset != selectionText.extentOffset) {
      String curText = contentController.text.substring(
        selectionText.baseOffset,
        selectionText.extentOffset,
      );
      contentController.text = contentController.text.replaceRange(
        selectionText.baseOffset,
        selectionText.extentOffset,
        "[[${s.value}]]$curText[[/${s.value}]]",
      );
    } else {
      //JIKA TIDAK TERSELECT
      if (s == CustomTextFormat.bold) {
        contentController.text += "[[${s.value}]][[/${s.value}]]";
      }
      if (s == CustomTextFormat.italic) {
        contentController.text += "[[${s.value}]][[/${s.value}]]";
      }
      if (s == CustomTextFormat.underline) {
        contentController.text += "[[${s.value}]][[/${s.value}]]";
      }
      contentController.selection = TextSelection.fromPosition(
        TextPosition(offset: contentController.selection.baseOffset - 6),
      );
    }
  }
}
