import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_quest/character/character.dart';

class CharacterFightPage extends StatelessWidget {
  const CharacterFightPage({
    Key? key,
    required this.character,
    required this.opponent,
  }) : super(key: key);

  final Character character;
  final Character opponent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CharacterFightCubit>(
      create: (context) => CharacterFightCubit(
        character: character,
        opponent: opponent,
      )..fight(),
      child: const _CharacterFightView(),
    );
  }
}

class _CharacterFightView extends StatelessWidget {
  const _CharacterFightView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cubit = context.read<CharacterFightCubit>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(_cubit.initialCharacter.imgUrl!),
            ),
            Text(
              '${_cubit.initialCharacter.name} VS ${_cubit.initialOpponent.name}',
            ),
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(_cubit.initialOpponent.imgUrl!),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton(
            key: const Key('characterListView_add_floatingActionButton'),
            onPressed: () => Navigator.of(context).popUntil(
              (route) => route.isFirst,
            ),
            // TODO descativate this button when fight ended
            child: const Text('NEXT'),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CharacterFightCubit, CharacterFightState>(
          builder: (context, state) {
            if (state is CharacterFighEndedState) {
              final winner = (state as CharacterFighEndedState).winner;
              final rounds = (state as CharacterFighEndedState).rounds;
              return Stack(
                children: [
                  ListView.separated(
                    itemCount: rounds.length,
                    itemBuilder: (
                      context,
                      index,
                    ) =>
                        _RoundItem(round: rounds[index]),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: winner.hashCode,
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundImage: NetworkImage(
                          winner?.imgUrl! ?? '',
                        ), // TODO better
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'VICTORY',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                  ),
                ],
              );
            } else if (state is CharacterFightingState) {
              final rounds = state.rounds;
              return ListView.separated(
                itemCount: rounds.length,
                itemBuilder: (
                  context,
                  index,
                ) =>
                    _RoundItem(round: rounds[index]),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black.withOpacity(0.5),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class _RoundItem extends StatelessWidget {
  const _RoundItem({
    Key? key,
    required this.round,
  }) : super(key: key);

  final Round round;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: _FighterTile(
            character: round.character,
          ),
        ),
        Flexible(
          flex: 1,
          child: _RoundTile(
            round: round,
          ),
        ),
        Flexible(
          flex: 3,
          child: _FighterTile(
            character: round.opponent,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _FighterTile extends StatelessWidget {
  const _FighterTile({
    Key? key,
    required this.character,
    this.textAlign,
  }) : super(key: key);

  final Character character;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    const iconSize = 14.0;
    return ListTile(
      title: Text(
        '${character.name} ',
        textAlign: textAlign ?? TextAlign.start,
      ),
      subtitle: RichText(
        textAlign: textAlign ?? TextAlign.start,
        text: TextSpan(
          children: [
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
          ],
        ),
      ),
    );
  }
}

class _RoundTile extends StatelessWidget {
  const _RoundTile({
    Key? key,
    required this.round,
  }) : super(key: key);

  final Round round;

  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.orange,
                  size: iconSize,
                ),
              ),
              TextSpan(
                text: '${round.opponentHealthRemoved} ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${round.characterHealthRemoved} ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const WidgetSpan(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.orange,
                  size: iconSize,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
