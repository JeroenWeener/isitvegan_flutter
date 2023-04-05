import 'package:get_it/get_it.dart';

/// Represents a collection components that should be registered with the
/// Inversion of Control container.
class Components {
  /// Constructs the component collection accepting a list of components
  /// describing the package.
  const Components({
    required this.components,
  });

  /// List of components that are available within this package.
  final List<Component> components;

  /// Registers all components with the Inversion of Control container.
  void registerAll() {
    for (final Component component in components) {
      component.register();
    }
  }
}

/// A base class for components that are capable of registering themselves with
/// the Inversion of Control container.
abstract class Component {
  /// Creates a new component.
  const Component();

  /// Registers the component with the Inversion of Control container.
  void register();
}

/// A component that will register it self as an instance component. This means
/// each time the component is requested from the Inversion of Control container
/// a new instance of that component is returned.
class Factory<T extends Object> extends Component {
  /// Creates a new `Factory` component.
  const Factory(
    this._factoryFunc, {
    String? instanceName,
  }) : _instanceName = instanceName;

  final FactoryFunc<T> _factoryFunc;
  final String? _instanceName;

  @override
  void register() {
    GetIt.instance.registerFactory<T>(
      _factoryFunc,
      instanceName: _instanceName,
    );
  }
}

/// A component that will register it self as an asynchronous singleton. This
/// means that the component is created only once and created the first time it
/// is requested.
class SingletonAsync<T extends Object> extends Component {
  /// Creates a new `SingletonAsync` component.
  const SingletonAsync(
    this._factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    DisposingFunc<T>? dispose,
  })  : _instanceName = instanceName,
        _dependsOn = dependsOn,
        _signalsReady = signalsReady,
        _dispose = dispose;

  final FactoryFuncAsync<T> _factoryFunc;
  final String? _instanceName;
  final Iterable<Type>? _dependsOn;
  final bool? _signalsReady;
  final DisposingFunc<T>? _dispose;

  @override
  void register() {
    GetIt.instance.registerSingletonAsync<T>(
      _factoryFunc,
      instanceName: _instanceName,
      dependsOn: _dependsOn,
      signalsReady: _signalsReady,
      dispose: _dispose,
    );
  }
}
