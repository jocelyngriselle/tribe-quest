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
      create: (_) => CharacterEditCubit(character: character),
      child: CharacterEditView(character: character),
    );
  }
}

class CharacterEditView extends StatelessWidget {
  const CharacterEditView({
    Key? key,
    required this.character,
  }) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.characterEditAppBarTitle)),
      body: SafeArea(
        child: _CharacterEditForm(
          character: character,
        ),
      ),
    );
  }
}

class _CharacterEditForm extends StatefulWidget {
  const _CharacterEditForm({
    Key? key,
    required this.character,
  }) : super(key: key);
  final Character character;

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
        Hero(
          tag: widget.character.hashCode,
          child: CircleAvatar(
            radius: 100.0,
            backgroundImage: NetworkImage('https://i.pinimg.com/474x/3b/6b/a5/3b6ba5ac7fbd1a1478990856b8827c3e.jpg'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            autocorrect: false,
            controller: nameController..text = widget.character.name ?? 'Nom du personnage',
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
            CaracteristicRow(
              label: 'Health',
              value: context.watch<CharacterEditCubit>().state.health,
              increment: () => context.read<CharacterEditCubit>().incrementHealth(),
              decrease: () => context.read<CharacterEditCubit>().decreaseHealth(),
            ),
            CaracteristicRow(
              label: "Attack",
              value: context.watch<CharacterEditCubit>().state.attack,
              increment: () => context.read<CharacterEditCubit>().incrementAttack(),
              decrease: () => context.read<CharacterEditCubit>().decreaseAttack(),
            ),
            CaracteristicRow(
              label: "Defence",
              value: context.watch<CharacterEditCubit>().state.defence,
              increment: () => context.read<CharacterEditCubit>().incrementDefence(),
              decrease: () => context.read<CharacterEditCubit>().decreaseDefence(),
            ),
            CaracteristicRow(
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

class CaracteristicRow extends StatelessWidget {
  const CaracteristicRow({
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
