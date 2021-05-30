import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_quest/character/character.dart';
import 'package:tribe_quest/l10n/l10n.dart';

class CharacterEditPage extends StatelessWidget {
  CharacterEditPage({Key? key, Character? character})
      : character = character ?? Character(),
        super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterEditCubit(),
      child: const CharacterEditView(),
    );
  }
}

class CharacterEditView extends StatelessWidget {
  const CharacterEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    //final caracter = context.select((CharacterEditCubit cubit) => cubit.state);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.characterEditAppBarTitle)),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("name"),
            Column(
              children: [
                const _HealthRow(),
                Row(
                  children: [
                    Icon(
                      Icons.remove,
                    ),
                    Text("Stamina"),
                    Icon(
                      Icons.add,
                    ),
                  ],
                ),
              ],
            ),
            const _ButtonsRow(),
          ],
        ),
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  const _HealthRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final caracter = context.watch<CharacterEditCubit>().state;
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
          ),
          onPressed: () => context.read<CharacterEditCubit>().decreaseHealth(),
        ),
        Text('Health ${caracter.health}'),
        IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () => context.read<CharacterEditCubit>().incrementHealth(),
        ),
      ],
    );
  }
}

class _ButtonsRow extends StatelessWidget {
  const _ButtonsRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => context.read<CharacterEditCubit>().save(),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
