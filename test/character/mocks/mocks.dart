import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tribe_quest/auth/auth.dart';
import 'package:tribe_quest/character/character.dart';

class MockCharacterService extends Mock implements CharacterService {}

class MockAuthService extends Mock implements AuthenticationService {}

class MockCharacterEditCubit extends MockCubit<CharacterEditState> implements CharacterEditCubit {}
