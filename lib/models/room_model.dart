import 'dart:ui';

import 'package:tictactoe/core/constants/palette.dart';

enum GameLevel {
  easy,
  medium,
  hard;

  String get name {
    switch (this) {
      case GameLevel.easy:
        return 'Standard';
      case GameLevel.medium:
        return 'Medium';
      case GameLevel.hard:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  int get value {
    switch (this) {
      case GameLevel.easy:
        return 0;
      case GameLevel.medium:
        return 1;
      case GameLevel.hard:
        return 2;
      default:
        return -1;
    }
  }

  String get boardType {
    switch (this) {
      case GameLevel.easy:
        return '3 x 3';
      case GameLevel.medium:
        return '4 x 4';
      case GameLevel.hard:
        return '5 x 5';
      default:
        return 'Unknown level';
    }
  }

  int get boardSize {
    switch (this) {
      case GameLevel.easy:
        return 3;
      case GameLevel.medium:
        return 4;
      case GameLevel.hard:
        return 5;
      default:
        return -1;
    }
  }
}

enum BackgroundColor {
  red,
  green,
  blue,
  yellow,
  purple,
  orange;

  int get value {
    switch (this) {
      case BackgroundColor.red:
        return 0;
      case BackgroundColor.green:
        return 1;
      case BackgroundColor.blue:
        return 2;
      case BackgroundColor.yellow:
        return 3;
      case BackgroundColor.purple:
        return 4;
      case BackgroundColor.orange:
        return 5;
      default:
        return -1;
    }
  }

  Color get color {
    return Palette.roomColors[value];
  }
}

class RoomModel {
  final String id;
  final String title;

  /// Player 1 will be room creator
  final String player1Name;
  final String? player2Name;
  final bool isFinished;
  final String? winnerName;
  final int backgroundColor;
  final DateTime createdAt = DateTime.now();
  final int level;
  final List<String> moves;
  final int currentMove;

  RoomModel({
    required this.id,
    required this.title,
    required this.player1Name,
    this.player2Name,
    this.isFinished = false,
    this.winnerName,
    required this.backgroundColor,
    this.level = 0,
    required this.moves,
    required this.currentMove,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      title: json['title'],
      player1Name: json['player_1_name'],
      player2Name: json['player_2_name'],
      isFinished: json['is_finished'],
      winnerName: json['winner_name'],
      backgroundColor: json['background_color'],
      level: json['level'],
      moves: List<String>.from(json['moves']),
      currentMove: json['current_move'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'title': title,
      'player_1_name': player1Name,
      'player_2_name': player2Name,
      'is_finished': isFinished,
      'winner_name': winnerName,
      'background_color': backgroundColor,
      'created_at': createdAt.toIso8601String(),
      'level': level,
      'moves': moves,
      'current_move': currentMove,
    };
  }

  RoomModel copyWith({
    String? id,
    String? title,
    String? player1Name,
    String? player2Name,
    bool? isFinished,
    String? winnerName,
    int? backgroundColor,
    DateTime? createdAt,
    int? level,
    List<String>? moves,
    int? currentMove,
  }) {
    return RoomModel(
      id: id ?? this.id,
      title: title ?? this.title,
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
      isFinished: isFinished ?? this.isFinished,
      winnerName: winnerName ?? this.winnerName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      level: level ?? this.level,
      moves: moves ?? this.moves,
      currentMove: currentMove ?? this.currentMove,
    );
  }

  @override
  String toString() {
    return 'RoomModel(id: $id, title: $title, player1Uid: $player1Name, player2Uid: $player2Name, isFinished: $isFinished, winnerName: $winnerName, backgroundColor: $backgroundColor, createdAt: $createdAt, level: $level, moves: $moves, currentMove: $currentMove)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomModel &&
        other.id == id &&
        other.title == title &&
        other.player1Name == player1Name &&
        other.player2Name == player2Name &&
        other.isFinished == isFinished &&
        other.winnerName == winnerName &&
        other.backgroundColor == backgroundColor &&
        other.createdAt == createdAt &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        player1Name.hashCode ^
        player2Name.hashCode ^
        isFinished.hashCode ^
        winnerName.hashCode ^
        backgroundColor.hashCode ^
        createdAt.hashCode ^
        level.hashCode;
  }
}
