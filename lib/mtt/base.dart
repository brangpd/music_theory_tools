abstract class Answer {}

abstract class Question<TAnswer> {
  bool check(TAnswer answer);
}
