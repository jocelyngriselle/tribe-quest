import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/l10n/l10n.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterCubit(),
      child: const CharacterListView(),
    );
  }
}

class CharacterListView extends StatelessWidget {
  const CharacterListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.characterListAppBarTitle)),
      body: Center(child: Container()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key('characterListView_add_floatingActionButton'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterEditPage(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
