/// Each class inheriting from `TestWidgets` must:
/// * be a private class
/// * have a public variable to give access to methods of the private class
/// The name of this variable must equals the class name (and follow dart naming conventions)
///
/// **Example:**
/// ```
/// final myWonderfulWidget = _MyWonderfulWidget();
/// class _MyWonderfulWidget implements TestWidgets {}
/// ```
///
abstract class TestWidgets {
  Future<void> pumpItUp() async {}
}
