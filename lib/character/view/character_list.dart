import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/l10n/l10n.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharactersCubit()..getCharacters(),
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
      body: BlocBuilder<CharactersCubit, CharactersState>(builder: (context, state) {
        if (state is CharactersLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CharactersErrorState) {
          return Center(
            child: Icon(Icons.close),
          );
        } else if (state is CharactersLoadedState) {
          final characters = state.characters;

          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) => _CharacterListItem(
              character: characters[index],
            ),
          );
        } else {
          return Container();
        }
      }),
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

class _CharacterListItem extends StatelessWidget {
  const _CharacterListItem({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterEditPage(
              character: character,
            ),
          ),
        );
      },
      title: Text("${character.name}"),
      subtitle: Text("10 victoires"),
      leading: Hero(
        tag: character.hashCode,
        child: CircleAvatar(
          backgroundImage: NetworkImage('https://i.pinimg.com/474x/3b/6b/a5/3b6ba5ac7fbd1a1478990856b8827c3e.jpg'),
        ),
      ),
    );
  }
}
