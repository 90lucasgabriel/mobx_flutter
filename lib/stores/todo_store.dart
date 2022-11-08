import 'package:mobx/mobx.dart';

part 'todo_store.g.dart';

class TodoStore = _TodoStoreBase with _$TodoStore;

abstract class _TodoStoreBase with Store {
  String title = '';

  _TodoStoreBase({
    required this.title,
  });

  @observable
  bool done = false;

  @action
  void toggleDone() => done = !done;
}
