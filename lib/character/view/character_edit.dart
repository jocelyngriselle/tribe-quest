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
    final cubit = context.read<CharacterEditCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(
          tag: widget.character.hashCode,
          child: const CircleAvatar(
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
        StreamBuilder<Character>(
          stream: context.watch<CharacterEditCubit>().state.characterStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) return const SizedBox();
            final editingCharacter = snapshot.data!;
            final health = editingCharacter.health;
            final magik = editingCharacter.magik;
            final defence = editingCharacter.defence;
            final attack = editingCharacter.attack;
            final skillPoints = editingCharacter.skillPoints;
            return Column(
              children: [
                CaracteristicRow(
                  label: 'Skills points',
                  value: skillPoints,
                ),
                CaracteristicRow(
                  label: 'Health',
                  value: health,
                  increment: editingCharacter.canIncreaseHealth() ? cubit.incrementHealth : null,
                ),
                CaracteristicRow(
                  label: 'Attack',
                  value: attack,
                  increment: editingCharacter.canIncrease(attack) ? cubit.incrementAttack : null,
                ),
                CaracteristicRow(
                  label: 'Defence',
                  value: defence,
                  increment: editingCharacter.canIncrease(defence) ? cubit.incrementDefence : null,
                ),
                CaracteristicRow(
                  label: 'Magik',
                  value: magik,
                  increment: editingCharacter.canIncrease(magik) ? cubit.incrementMagik : null,
                ),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.read<CharacterEditCubit>().reset();
              },
              child: Text(
                'Annuler',
                style: Theme.of(context).textTheme.button,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<CharacterEditCubit>().save(
                      name: nameController.text,
                    );
                const snackBar = SnackBar(content: Text('Saved!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
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
    return ListTile(
      trailing: increment != null
          ? IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: increment,
            )
          : SizedBox(),
      title: Text(
        label,
        style: Theme.of(context).textTheme.headline6,
      ),
      leading: Text(
        value.toString(),
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: Colors.grey,
            ),
      ),
    );
  }
}
