/*
 * Riverpod notifier managing user boards (local-only storage).
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/entities/photo.dart';
import '../../domain/entities/board.dart';

class BoardsNotifier extends StateNotifier<List<Board>> {
  BoardsNotifier()
    : super([
        const Board(
          id: 'default-favorites',
          name: 'Favorites',
          description: 'My favorite pins',
        ),
        const Board(
          id: 'default-inspiration',
          name: 'Inspiration',
          description: 'Ideas and inspiration',
        ),
        const Board(
          id: 'default-travel',
          name: 'Travel Goals',
          description: 'Places I want to visit',
        ),
      ]);

  void createBoard(String name, {String description = ''}) {
    final board = Board(
      id: 'board-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
    );
    state = [...state, board];
  }

  void deleteBoard(String boardId) {
    state = state.where((b) => b.id != boardId).toList();
  }

  void addPinToBoard(String boardId, Photo photo) {
    state = [
      for (final board in state)
        if (board.id == boardId)
          Board(
            id: board.id,
            name: board.name,
            description: board.description,
            coverPhoto: photo,
            pinCount: board.pinCount + 1,
            isPrivate: board.isPrivate,
          )
        else
          board,
    ];
  }
}

final boardsProvider = StateNotifierProvider<BoardsNotifier, List<Board>>((
  ref,
) {
  return BoardsNotifier();
});
