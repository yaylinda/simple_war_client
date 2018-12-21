import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_war_client/service/auth.dart';
import 'package:simple_war_client/screens/home_screen.dart';
import 'package:simple_war_client/screens/login_screen_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_war_client/models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password, _email;
  User user;

  LoginScreenPresenter _presenter;

  RegisterScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doRegister(_username, _password, _email);
    }
  }

  void _login() {
    Navigator.pushReplacementNamed(_ctx, "/login");
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state, String username) {
    if(state == AuthState.LOGGED_IN)
      Navigator.pushReplacement(_ctx, new MaterialPageRoute(builder: (BuildContext context) => new HomeScreen(username: username)));
  }

  @override
  Widget build(BuildContext context) {

    _ctx = context;

    var registerBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("REGISTER"),
      color: Colors.amber,
    );

    var loginBtn = new RaisedButton(
      onPressed: _login,
      child: new Text("LOGIN"),
      color: Colors.green,
    );

    var registerForm = new Column(
      children: <Widget>[
        new Text(
          "Register",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _email = val,
                  decoration: new InputDecoration(labelText: "Email Address"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : registerBtn,
        loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: new AppBar(title: new Text("Simple War")),
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: registerForm,
                height: 400.0,
                width: 300.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    this.user = user;
    setUsername(user.username).then((result) {
      setState(() => _isLoading = false);
      var authStateProvider = new AuthStateProvider();
      authStateProvider.notify(AuthState.LOGGED_IN, user.username);
    });
  }

  Future<bool> setUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("username", username);
  }
}
