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
    final _cubit = context.watch<CharacterFightCubit>();
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
          if (_cubit.state is CharacterFighEndedState)
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CharacterListPage(),
                ),
              ),
              child: const Text('NEXT'),
            ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CharacterFightCubit, CharacterFightState>(
          builder: (context, state) {
            if (state is CharacterFighEndedState) {
              final imgUrl = state.winner == null ? 'https://picsum.photos/200' : (state.winner!.imgUrl ?? Character.defaultImgUrl);
              return Stack(
                children: [
                  ListView.separated(
                    itemCount: state.rounds.length,
                    itemBuilder: (
                      context,
                      index,
                    ) =>
                        _RoundItem(
                      round: state.rounds[index],
                      index: index,
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: state.winner.hashCode,
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundImage: NetworkImage(
                          imgUrl,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      state.winner != null ? 'WIN' : 'DRAW',
                      style: Theme.of(context).textTheme.headline3?.copyWith(
                            color: Colors.white,
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
                    _RoundItem(
                  round: rounds[index],
                  index: index,
                ),
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
    required this.index,
  }) : super(key: key);

  final Round round;
  final int index;

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
        if (index != 0)
          Flexible(
            flex: 1,
            child: _RoundTile(
              round: round,
              index: index,
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
    required this.index,
  }) : super(key: key);

  final Round round;
  final int index;

  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    return Column(
      children: [
        Text(
          'ROUND $index',
          style: Theme.of(context).textTheme.caption,
        ),
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
