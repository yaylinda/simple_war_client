import 'package:simple_war_client/models/user.dart';
import 'package:simple_war_client/rest_ds.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password)
        .then((User user) {
          _view.onLoginSuccess(user);
        })
        .catchError((Exception error) => _view.onLoginError(error.toString()));
  }

  doRegister(String username, String password, String email) {
    api.register(username, password, email)
        .then((User user) {
          _view.onLoginSuccess(user);
        })
        .catchError((Exception error) => _view.onLoginError(error.toString()));
  }
}