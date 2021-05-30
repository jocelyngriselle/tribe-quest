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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.characterEditAppBarTitle)),
      body: SafeArea(
        child: _CharacterEditForm(),
      ),
    );
  }
}

class _CharacterEditForm extends StatefulWidget {
  const _CharacterEditForm({
    Key? key,
  }) : super(key: key);

  @override
  _CharacterEditFormState createState() => _CharacterEditFormState();
}

class _CharacterEditFormState extends State<_CharacterEditForm> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            autocorrect: false,
            controller: nameController,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Name of the character',
            ),
          ),
        ),
        Column(
          children: [
            _CaracteristicRow(
              label: 'Health',
              value: context.watch<CharacterEditCubit>().state.health,
              increment: () => context.read<CharacterEditCubit>().incrementHealth(),
              decrease: () => context.read<CharacterEditCubit>().decreaseHealth(),
            ),
            _CaracteristicRow(
              label: "Attack",
              value: context.watch<CharacterEditCubit>().state.attack,
              increment: () => context.read<CharacterEditCubit>().incrementAttack(),
              decrease: () => context.read<CharacterEditCubit>().decreaseAttack(),
            ),
            _CaracteristicRow(
              label: "Defence",
              value: context.watch<CharacterEditCubit>().state.defence,
              increment: () => context.read<CharacterEditCubit>().incrementDefence(),
              decrease: () => context.read<CharacterEditCubit>().decreaseDefence(),
            ),
            _CaracteristicRow(
              label: "Magik",
              value: context.watch<CharacterEditCubit>().state.magik,
              increment: () => context.read<CharacterEditCubit>().incrementMagik(),
              decrease: () => context.read<CharacterEditCubit>().decreaseMagik(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Annuler',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            ElevatedButton(
              onPressed: () => context.read<CharacterEditCubit>().save(
                    name: nameController.text,
                  ),
              child: Text(
                'Sauvegarder',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }
}

class _CaracteristicRow extends StatelessWidget {
  const _CaracteristicRow({
    Key? key,
    this.decrease,
    this.increment,
    required this.label,
    required this.value,
  }) : super(key: key);

  final VoidCallback? decrease;
  final VoidCallback? increment;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.remove,
          ),
          onPressed: decrease,
        ),
        Text(
          '$label $value',
          style: Theme.of(context).textTheme.headline6,
        ),
        IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: increment,
        ),
      ],
    );
  }
}
