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

  doLogin(String username, String password) async {
    try {
      User user = await api.login(username, password);
      _view.onLoginSuccess(user);
    } on Exception catch(error) {
      _view.onLoginError(error.toString());
    }
  }

  doRegister(String username, String password, String email) async {
    try {
      User user = await api.register(username, password, email);
      _view.onLoginSuccess(user);
    } on Exception catch(error) {
      _view.onLoginError(error.toString());
    }
  }
}