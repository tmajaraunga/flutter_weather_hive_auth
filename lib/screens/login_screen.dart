import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;


  Future<void> _submitSignIn(bool register) async {
    setState(() { _loading = true; _error = null; });
    try {
      final auth = context.read<AuthService>();
      if (register) await auth.signUp(_email.text.trim(), _password.text.trim());
      else await auth.signIn(_email.text.trim(), _password.text.trim());
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                ),
                child: Center(child: Text('ProtoWeather', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold))),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
                    SizedBox(height: 8),
                    TextField(controller: _password, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
                    SizedBox(height: 16),
                    if (_error != null) Text(_error!, style: TextStyle(color: Colors.redAccent)),
                    Row(children: [
                      Expanded(child: ElevatedButton(onPressed: _loading?null:() => _submitSignIn(false), child: _loading?CircularProgressIndicator():Text('Sign in'))),
                      SizedBox(width: 10),
                      Expanded(child: OutlinedButton(onPressed: _loading?null:() => _submitSignIn(true), child: Text('Register'))),
                    ]),
                    Spacer(),
                    TextButton(onPressed: () => Navigator.pushNamed(context, '/items'), child: Text('Browse local items (sample JSON)'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}