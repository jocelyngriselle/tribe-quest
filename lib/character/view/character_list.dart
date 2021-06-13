import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_quest/auth/auth.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/l10n/l10n.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CharactersCubit>(
          create: (_) => CharactersCubit()..getCharacters(),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(),
        ),
      ],
      child: const CharacterListView(),
    );
  }
}

class CharacterListView extends StatelessWidget {
  const CharacterListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CharactersCubit, CharactersState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.characterListAppBarTitle),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  context.read<AuthenticationBloc>().add(SignOut());
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Icon(Icons.power_settings_new),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: _buildContent(context, state),
        ),
        floatingActionButton: _buildFloatingActionButton(context, state),
      );
    });
  }

  FloatingActionButton? _buildFloatingActionButton(
    BuildContext context,
    CharactersState state,
  ) {
    if (state is CharactersLoadedState && state.characters.length < 10) {
      return FloatingActionButton(
        key: const Key('characterListView_add_floatingActionButton'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterEditPage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context, CharactersState state) {
    if (state is CharactersLoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CharactersErrorState) {
      return const Center(
        child: Icon(Icons.close),
      );
    } else if (state is CharactersLoadedState) {
      final characters = state.characters;

      return ListView.separated(
        itemCount: characters.length,
        itemBuilder: (context, index) => _CharacterListItem(
          character: characters[index],
        ),
        separatorBuilder: (context, index) => Divider(
          color: Colors.black.withOpacity(0.5),
        ),
      );
    } else {
      return Container();
    }
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
    const iconSize = 14.0;
    return Dismissible(
      key: Key(character.hashCode.toString()),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await context.read<CharactersCubit>().remove(character);
      },
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterDetailPage(
                character: character,
              ),
            ),
          );
        },
        title: Text('${character.name} '),
        subtitle: RichText(
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.star,
                  color: Colors.blue,
                  size: iconSize,
                ),
              ),
              TextSpan(
                text: '${character.skillPoints} ',
                style: Theme.of(context).textTheme.caption,
              ),
              const WidgetSpan(
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: iconSize,
                ),
              ),
              TextSpan(
                text: '${character.health} ',
                style: Theme.of(context).textTheme.caption,
              ),
              const WidgetSpan(
                child: Icon(
                  Icons.bolt,
                  color: Colors.orange,
                  size: iconSize,
                ),
              ),
              TextSpan(
                text: '${character.attack} ',
                style: Theme.of(context).textTheme.caption,
              ),
              const WidgetSpan(
                child: Icon(
                  Icons.shield,
                  color: Colors.brown,
                  size: iconSize,
                ),
              ),
              TextSpan(
                text: '${character.defence} ',
                style: Theme.of(context).textTheme.caption,
              ),
              const WidgetSpan(
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.green,
                  size: 12,
                ),
              ),
              TextSpan(
                text: '${character.magik} ',
                style: Theme.of(context).textTheme.caption,
              ),
              TextSpan(
                text: ' - ${character.fights.length} fights',
                style: Theme.of(context).textTheme.caption,
              ),
              TextSpan(
                text: ' - ${character.rank - 1} wins',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
        leading: Hero(
          tag: character.hashCode,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              character.imgUrl ?? Character.defaultImgUrl,
            ),
          ),
        ),
      ),
    );
  }
}
