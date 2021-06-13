import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_quest/character/character.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: _CharacterEditForm(
          character: character,
        ),
      ),
    );
  }
}

class _CharacterEditForm extends StatelessWidget {
  const _CharacterEditForm({
    Key? key,
    required this.character,
  }) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CharacterEditCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            initialValue: character.name,
            key: const Key('characterEditForm_nameInput_textField'),
            autocorrect: false,
            onChanged: cubit.nameChanged,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: 'name',
            ),
          ),
        ),
        BlocBuilder<CharacterEditCubit, CharacterEditState>(
          builder: (context, state) {
            final editingCharacter = state.character;
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
                  icon: const Icon(
                    Icons.star,
                    color: Colors.blue,
                  ),
                ),
                CaracteristicRow(
                  label: 'Health',
                  value: health,
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  increment: editingCharacter.canIncreaseHealth() ? cubit.incrementHealth : null,
                  decrease: context.read<CharacterEditCubit>().canDecreaseHealth() ? cubit.decrementHealth : null,
                ),
                CaracteristicRow(
                  label: 'Attack',
                  value: attack,
                  icon: const Icon(
                    Icons.bolt,
                    color: Colors.orange,
                  ),
                  increment: editingCharacter.canIncrease(attack) ? cubit.incrementAttack : null,
                  decrease: context.read<CharacterEditCubit>().canDecreaseAttack() ? cubit.decreaseAttack : null,
                ),
                CaracteristicRow(
                  label: 'Defence',
                  value: defence,
                  icon: const Icon(
                    Icons.shield,
                    color: Colors.black,
                  ),
                  increment: editingCharacter.canIncrease(defence) ? cubit.incrementDefence : null,
                  decrease: context.read<CharacterEditCubit>().canDecreaseDefence() ? cubit.decreaseDefence : null,
                ),
                CaracteristicRow(
                  label: 'Magik',
                  value: magik,
                  icon: const Icon(
                    Icons.auto_awesome,
                    color: Colors.green,
                  ),
                  increment: editingCharacter.canIncrease(magik) ? cubit.incrementMagik : null,
                  decrease: context.read<CharacterEditCubit>().canDecreaseMagik() ? cubit.decreaseMagik : null,
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
              child: const Text(
                'CANCEL',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<CharacterEditCubit>().save();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CharacterListPage(),
                  ),
                );
              },
              child: const Text(
                'SAVE',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CaracteristicRow extends StatelessWidget {
  const CaracteristicRow({
    Key? key,
    this.decrease,
    this.increment,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? decrease;
  final VoidCallback? increment;
  final String label;
  final int value;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: IconButton(
        key: Key('characterEditView_increment${label}_floatingActionButton'),
        icon: Icon(
          Icons.add,
          color: increment == null ? Colors.transparent : Theme.of(context).primaryColor,
        ),
        onPressed: increment,
      ),
      leading: IconButton(
        icon: Icon(
          Icons.remove,
          color: decrease == null ? Colors.transparent : Theme.of(context).primaryColor,
        ),
        onPressed: decrease,
      ),
      title: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(
            width: 20,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
