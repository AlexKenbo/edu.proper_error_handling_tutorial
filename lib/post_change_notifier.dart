import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:proper_error_handling_tutorial/post_service.dart';

enum NotifierState { initial, loading, loaded }

class PostChangeNotifier extends ChangeNotifier {
  final _postService = PostService();

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  Either<Failure, Post> _postOrFailure;
  Either<Failure, Post> get postOrFailure => _postOrFailure;
  void _setPostOrFailure(Either<Failure, Post> postOrFailure) {
    _postOrFailure = postOrFailure;
    notifyListeners();
  }

  void getOnePost() async {
    _setState(NotifierState.loading);
    await Task(() => _postService.getOnePost())
        .attempt()
        .map(
          (either) => either.leftMap((obj) {
            return obj as Failure;
          }),
        )
        .run()
        .then((value) => _setPostOrFailure(value));
    _setState(NotifierState.loaded);
  }
}
