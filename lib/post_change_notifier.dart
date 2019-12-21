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
        .mapLeftToFailure()
        .run()
        .then((value) => _setPostOrFailure(value));
    _setState(NotifierState.loaded);
  }
}

extension TaskX<T extends Either<Object, U>, U> on Task<T> {
  Task<Either<Failure, U>> mapLeftToFailure() {
    return this.map(
      (either) => either.leftMap((obj) {
        try {
          return obj as Failure;
        } catch (e) {
          throw obj;
        }
      }),
    );
  }
}
