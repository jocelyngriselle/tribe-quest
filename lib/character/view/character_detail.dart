import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tribe_quest/character/character.dart';

class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterDetailCubit(character: character),
      child: _CharacterDetailView(character: character),
    );
  }
}

class _CharacterDetailView extends StatelessWidget {
  const _CharacterDetailView({
    Key? key,
    required this.character,
  }) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name ?? Character.defaultName),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
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
              child: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final opponent = await context.read<CharacterDetailCubit>().getOpponent(
                character,
              );
          if (opponent == null) {
            const snackBar = SnackBar(
              content: Text('No opponent found!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterFightPage(
                  character: character,
                  opponent: opponent,
                ),
              ),
            );
          }
        },
        child: const Text('FIGHT'),
      ),
      body: SafeArea(
        child: _CharacterDetail(
          character: character,
        ),
      ),
    );
  }
}

class _CharacterDetail extends StatelessWidget {
  const _CharacterDetail({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        if (character.imgUrl != null)
          Hero(
            tag: character.hashCode,
            child: CircleAvatar(
              radius: 100.0,
              backgroundImage: NetworkImage(character.imgUrl!),
            ),
          ),
        const SizedBox(
          height: 20,
        ),
        _SkillsRow(character: character),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Match history',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: character.fights.length,
            itemBuilder: (context, index) => _FightListItem(
              fight: character.fights[index],
            ),
            separatorBuilder: (context, index) => Divider(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillsRow extends StatelessWidget {
  const _SkillsRow({
    Key? key,
    required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
    const iconSize = 24.0;
    final textStyle = Theme.of(context).textTheme.headline5;
    return RichText(
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
            style: textStyle,
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
            style: textStyle,
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
            style: textStyle,
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
            style: textStyle,
          ),
          const WidgetSpan(
            child: Icon(
              Icons.auto_awesome,
              color: Colors.green,
              size: iconSize,
            ),
          ),
          TextSpan(
            text: '${character.magik} ',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class _FightListItem extends StatelessWidget {
  const _FightListItem({
    Key? key,
    required this.fight,
  }) : super(key: key);

  final Fight fight;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd-MM-yyyy  HH:mm');
    final dateFormatted = formatter.format(fight.date);
    return ListTile(
      title: Text(
        '${fight.victory ? 'Win' : 'Loose'} VS ${fight.opponentName}',
      ),
      subtitle: Text(
        dateFormatted,
      ),
    );
  }
}
