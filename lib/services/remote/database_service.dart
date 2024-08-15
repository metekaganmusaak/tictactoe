import 'dart:async';

import 'package:get/get.dart';
import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/core/constants/app_errors.dart';
import 'package:tictactoe/models/room_model.dart';

typedef DBResponse = Future<Result<bool, AppErrors>>;
typedef FetchResponse = Future<Result<List<Map<String, dynamic>>, AppErrors>>;
typedef StreamResponse = Result<SupabaseStreamBuilder, AppErrors>;

abstract class IDatabaseService {
  DBResponse createRoom(RoomModel room);
  DBResponse deleteRoom(String roomId);
  DBResponse updateMovesByRoomId(String roomId, List<dynamic> moves);
  DBResponse updateWinnerName(String roomId, String? winnerName);
  DBResponse updateIsFinished(String roomId, bool isGameFinished);
  DBResponse updateRoomParticipant(String id, {required String username});
  DBResponse updateCurrentMoveByRoomId(
    String roomId, {
    required int currentMove,
  });

  FetchResponse getMoves(String roomId);
  StreamResponse listenRoomChanges(String roomId);
  StreamResponse fetchAllRooms();
  StreamResponse listenRoomById(String id);
}

class DatabaseService extends GetxService implements IDatabaseService {
  final SupabaseClient _db = Supabase.instance.client;

  @override
  DBResponse createRoom(RoomModel room) async {
    try {
      await _db.from('rooms').insert(room.toJson());
      return const Ok(true);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  DBResponse deleteRoom(String roomId) async {
    try {
      await _db.from('rooms').delete().eq('id', roomId);
      return const Ok(true);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  DBResponse updateMovesByRoomId(String roomId, List<dynamic> moves) async {
    try {
      await _db.from('rooms').update({
        'moves': moves,
      }).eq('id', roomId);

      return const Ok(true);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  DBResponse updateCurrentMoveByRoomId(
    String roomId, {
    required int currentMove,
  }) async {
    try {
      await _db.from('rooms').update({
        'current_move': currentMove,
      }).eq('id', roomId);
      return const Ok(true);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  DBResponse updateWinnerName(String roomId, String? winnerName) async {
    try {
      await _db.from('rooms').update({
        'winner_name': winnerName,
      }).eq('id', roomId);
      return const Ok(true);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  DBResponse updateIsFinished(String roomId, bool isGameFinished) async {
    try {
      await _db.from('rooms').update({
        'is_finished': isGameFinished,
      }).eq('id', roomId);
      return const Ok(true);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  DBResponse updateRoomParticipant(
    String id, {
    required String username,
  }) async {
    try {
      await _db.from('rooms').update({
        'player_2_name': username,
      }).eq('id', id);
      return const Ok(true);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  FetchResponse getMoves(String roomId) async {
    try {
      final response = await _db.from('rooms').select('moves').eq(
            'id',
            roomId,
          );

      return Ok(response);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  StreamResponse listenRoomChanges(String roomId) {
    try {
      final stream =
          _db.from('rooms').stream(primaryKey: ['id']).eq('id', roomId);

      return Ok(stream);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  StreamResponse fetchAllRooms() {
    try {
      final stream = _db
          .from('rooms')
          .stream(primaryKey: ['id'])
          .eq('is_finished', false)
          .order('created_at', ascending: false);

      return Ok(stream);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }

  @override
  StreamResponse listenRoomById(String id) {
    try {
      final response =
          _db.from('rooms').stream(primaryKey: ['id']).eq('id', id);
      return Ok(response);
    } catch (e) {
      return Err(AppErrors(ErrorsEnum.databaseError));
    }
  }
}
