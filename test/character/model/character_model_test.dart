import 'package:test/test.dart';
import 'package:tribe_quest/character/character.dart';

void main() {
  group('Character health', () {
    test('health should start at 10', () {
      expect(Character().health, 10);
    });

    test('health cant be incremented ', () {
      const skillPoints = 10;
      const health = 10;
      final character = Character(skillPoints: skillPoints, health: health);
      expect(character.skillPointDecrease(health), 2);
      expect(character.canIncrease(10), true);
      character.increaseHealth();
      expect(character.health, health + 1);
      expect(character.skillPoints, skillPoints - 1);
    });

    test('health cant be decremented ', () {
      const skillPoints = 10;
      const health = 10;
      final character = Character(skillPoints: skillPoints, health: health);
      expect(character.skillPointDecrease(health), 2);
      expect(character.canIncrease(10), true);
      character.decreaseHealth();
      expect(character.health, health - 1);
      expect(character.skillPoints, skillPoints + 1);
    });
  });
  group('Character attack', () {
    test('attack should start at 0', () {
      expect(Character().attack, 0);
    });

    test('attack cant be incremented ', () {
      const skillPoints = 10;
      const attack = 10;
      final character = Character(skillPoints: skillPoints, attack: attack);
      expect(character.skillPointDecrease(attack), 2);
      expect(character.canIncrease(10), true);
      character.increaseAttack();
      expect(character.attack, attack + 1);
      expect(character.skillPoints, skillPoints - 2);
    });

    test('attack cant be decremented ', () {
      const skillPoints = 10;
      const attack = 10;
      final character = Character(skillPoints: skillPoints, attack: attack);
      expect(character.skillPointDecrease(attack), 2);
      expect(character.canIncrease(10), true);
      character.decreaseAttack();
      expect(character.attack, attack - 1);
      expect(character.skillPoints, skillPoints + 2);
    });
  });

  group('Character defence', () {
    test('defence should start at 0', () {
      expect(Character().defence, 0);
    });

    test('defence cant be incremented ', () {
      const skillPoints = 10;
      const defence = 10;
      final character = Character(skillPoints: skillPoints, defence: defence);
      expect(character.skillPointDecrease(defence), 2);
      expect(character.canIncrease(10), true);
      character.increaseDefence();
      expect(character.defence, defence + 1);
      expect(character.skillPoints, skillPoints - 2);
    });

    test('defence cant be decremented ', () {
      const skillPoints = 10;
      const defence = 10;
      final character = Character(skillPoints: skillPoints, defence: defence);
      expect(character.skillPointDecrease(defence), 2);
      expect(character.canIncrease(10), true);
      character.decreaseDefence();
      expect(character.defence, defence - 1);
      expect(character.skillPoints, skillPoints + 2);
    });
  });

  group('Character magik', () {
    test('magik should start at 0', () {
      expect(Character().magik, 0);
    });

    test('defence cant be incremented ', () {
      const skillPoints = 10;
      const magik = 10;
      final character = Character(skillPoints: skillPoints, magik: magik);
      expect(character.skillPointDecrease(magik), 2);
      expect(character.canIncrease(10), true);
      character.increaseMagik();
      expect(character.magik, magik + 1);
      expect(character.skillPoints, skillPoints - 2);
    });

    test('magik cant be decremented ', () {
      const skillPoints = 10;
      const magik = 10;
      final character = Character(skillPoints: skillPoints, magik: magik);
      expect(character.skillPointDecrease(magik), 2);
      expect(character.canIncrease(10), true);
      character.decreaseMagik();
      expect(character.magik, magik - 1);
      expect(character.skillPoints, skillPoints + 2);
    });
  });
}
