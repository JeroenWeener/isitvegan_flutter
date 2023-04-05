/// Defines an application specific business rule according to the Clean
/// Architecture philosophy (see https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).
abstract class UseCase<TResult, TParam> {
  /// Executes the use case and applies the defined business rules to the
  /// supplied [param] business object.
  ///
  /// Defining a `call` method as part of the class allows the class to be
  /// called like a function as shown in the example below (see also https://dart.dev/guides/language/language-tour#callable-classes).
  ///
  /// ```dart
  /// class Greeting {
  ///   const Greeting(this._greeting);
  ///
  ///   final String _greeting;
  ///
  ///   String call(String name) {
  ///     return '$_greeting $name!';
  ///   }
  /// }
  ///
  ///
  /// void main() {
  ///   Greeting hello = Greeting('Hello');
  ///   print(hello('Baseflow'));
  /// }
  /// ```
  TResult call(TParam param);
}
