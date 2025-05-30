import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/helper/card.dart';
import 'package:todo/provider/todo/todo_pages.dart';

class Todo extends ConsumerStatefulWidget {
  const Todo({super.key, required this.index});

  final String index;
  @override
  ConsumerState<Todo> createState() => _TodoState();
}

class _TodoState extends ConsumerState<Todo> {
  void _tapSettings(BuildContext context, String listId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // full width
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  // TODO: Rename List
                },
                child: const Text('Rename List'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed:
                    listId ==
                        'default' //TODO:change logic of deleting all completed tasks
                    ? null
                    : () {
                        // TODO:Delete all completed tasks
                      },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey; // Disabled text color
                    }
                    return Theme.of(
                      context,
                    ).colorScheme.primary; // Normal text color
                  }),
                ),
                child: const Text('Delete all completed tasks'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: listId == 'default'
                    ? null
                    : () {
                        // TODO: Delete List
                      },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey; // Disabled text color
                    }
                    return Theme.of(
                      context,
                    ).colorScheme.primary; // Normal text color
                  }),
                ),
                child: const Text('Delete List'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //getting tab title from provider
    final tabInfo = ref
        .watch(todoPageNotifierProvider)
        .where((element) => element.id == widget.index)
        .first;
    return RefreshIndicator(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              //Incomplete Tasks card
              CustomCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          tabInfo.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            //pass todo list id not page index
                            _tapSettings(context, tabInfo.id);
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                    Text(tabInfo.id),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onRefresh: () async {
        Future.delayed(Duration(seconds: 2));

        //TODO: refresh
      },
    );
  }
}
