import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/helper/add_todo.dart';
import 'package:todo/provider/theme/theme_provider.dart';
import 'package:todo/provider/todo/todo_pages.dart';
import 'package:todo/todo.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onAddPressed() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('New Task List'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter list name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isNotEmpty) {
                  ref.read(todoPageNotifierProvider.notifier).addList(title);
                }

                Navigator.of(context).pop(); // Close dialog

                final index = ref.read(todoPageNotifierProvider).length + 1;

                setState(() {
                  _currentIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final toggleTheme = ref.watch(themeNotifierProvider.notifier);

    final tabs = ref.watch(todoPageNotifierProvider);

    Widget buildTab({String? title, IconData? icon, required int index}) {
      return Container(
        decoration: BoxDecoration(
          border: _currentIndex == index
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary, // your desired border color
                    width: 2, // border thickness
                  ),
                )
              : null,
        ),
        child: title == null
            ? IconButton(
                onPressed: () => _onTabTapped(index),
                icon: Icon(
                  icon,
                  color: _currentIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
              )
            : TextButton(
                onPressed: () => _onTabTapped(index),
                child: Text(
                  title,
                  style: TextStyle(
                    color: _currentIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    fontWeight: _currentIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO App"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              toggleTheme.toggleTheme();
            },
            icon: themeMode == ThemeMode.light
                ? const Icon(Icons.light_mode)
                : const Icon(Icons.dark_mode),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48), // Slightly smaller
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity, // ensures full width
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // optional spacing
                  child: Row(
                    children: [
                      buildTab(icon: Icons.star, index: 0),
                      for (int i = 0; i < tabs.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: buildTab(title: tabs[i].title, index: i + 1),
                        ),
                      IconButton(
                        onPressed: _onAddPressed,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          Center(child: Text('fav')),
          for (int i = 0; i < tabs.length; i++) Todo(index: tabs[i].id),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodo(context, ref);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
