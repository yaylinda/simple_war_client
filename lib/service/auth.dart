import 'package:shared_preferences/shared_preferences.dart';

enum AuthState {
  LOGGED_IN,
  LOGGED_OUT
}

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state, String username);
}

class AuthStateProvider {

  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;

  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async {
    getUsername().then((value) {
      if (value.length == 0) {
        print('NOT LOGGED IN... username was not found');
        notify(AuthState.LOGGED_OUT, value);
      } else {
        print('IS LOGGED IN... username was found');
        notify(AuthState.LOGGED_IN, value);
      }
    });
  }

  Future<String> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username") ?? '';
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    for(var l in _subscribers) {
      if(l == listener)
        _subscribers.remove(l);
    }
  }

  void notify(AuthState state, String username) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state, username));
  }
}
