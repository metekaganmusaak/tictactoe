import 'package:get/get.dart';

extension LocalizeIt on Tr {
  String get tr => name.tr;
}

enum Tr {
  /// HomeView Translations
  tictactoe(
    toEnglish: 'Tic Tac Toe',
    toTurkish: 'XOX',
  ),
  thereAreNoAvailableRooms(
    toEnglish: 'There are no available rooms',
    toTurkish: 'Mevcut oda yok',
  ),

  createGameRoom(
    toEnglish: 'Create Room',
    toTurkish: 'Oda Oluştur',
  ),

  pleaseEnterYourNameToSee(
    toEnglish:
        'Please enter your name to see available game rooms in the lobby',
    toTurkish: 'Lobi\'deki mevcut oda listesini görmek için adınızı girin',
  ),

  hintName(
    toEnglish: 'eg: John Doe',
    toTurkish: 'örn: Ahmet Yılmaz',
  ),

  save(
    toEnglish: 'Save',
    toTurkish: 'Kaydet',
  ),

  youCanNotJoinThisRoom(
    toEnglish: 'You can not join this room! All seats are taken.',
    toTurkish: 'Bu odaya katılamazsınız! Tüm koltuklar dolu.',
  ),

  join(
    toEnglish: 'Join',
    toTurkish: 'Katıl',
  ),

  /// CreateGame Translations
  createGame(
    toEnglish: 'Create Game',
    toTurkish: 'Oyun Oluştur',
  ),

  create(
    toEnglish: 'Create',
    toTurkish: 'Oluştur',
  ),

  roomName(
    toEnglish: 'Room Name',
    toTurkish: 'Oda Adı',
  ),

  roomNameHint(
    toEnglish: 'eg: My Room',
    toTurkish: 'örn: Benim Odam',
  ),

  gameColor(toEnglish: 'Game Color', toTurkish: 'Oyun Rengi'),

  gameMode(toEnglish: 'Game Mode', toTurkish: 'Oyun Modu'),

  participants(toEnglish: 'Participants', toTurkish: 'Katılımcılar'),
  ;

  final String toTurkish;
  final String toEnglish;

  const Tr({required this.toTurkish, required this.toEnglish});
}

class LocalizationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          for (Tr value in Tr.values) ...{value.name: value.toEnglish}
        },
        'tr': {
          for (Tr value in Tr.values) ...{value.name: value.toTurkish}
        },
      };

  static final List<String> supportedLanguageCodes = ['en', 'tr'];
}
