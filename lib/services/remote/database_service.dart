import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/models/room_model.dart';

class DatabaseService extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> createRoom(RoomModel room) async {
    await supabase.from('rooms').insert(room.toJson());
  }

  Future<void> finishGame(String roomId) async {
    await supabase.from('rooms').delete().eq('id', roomId);
  }

  updateMovesByRoomId(String roomId, List<String> moves) async {
    await supabase.from('rooms').update({
      'moves': moves,
    }).eq('id', roomId);
  }

  Future<List<dynamic>> getMoves(String roomId) async {
    final response = await supabase.from('rooms').select('moves').eq(
          'id',
          roomId,
        );

    return response.first['moves'] as List<dynamic>;
  }

  SupabaseStreamBuilder fetchAllRooms() {
    return supabase
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('is_finished', false)
        .order('created_at', ascending: false);
  }

  SupabaseStreamBuilder listenRoomById(String id) {
    return supabase.from('rooms').stream(primaryKey: ['id']).eq('id', id);
  }

  Future<void> updateRoomParticipant(
    String id, {
    required String username,
  }) async {
    await supabase.from('rooms').update({
      'player_2_name': username,
    }).eq('id', id);
  }
}
