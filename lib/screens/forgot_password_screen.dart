import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_management_admin/models/reset_pass_model.dart';
import 'package:project_management_admin/screens/dashboard_screen.dart';
import 'package:project_management_admin/screens/project_details_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  var email;
  var id;

  ForgotPasswordScreen({required this.email, required this.id});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontoller = new TextEditingController();
  TextEditingController _passcontoller = new TextEditingController();
  TextEditingController _confirmpasscontoller = new TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    _emailcontoller.text = widget.email;
    print("${widget.email}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please Enter Your Email";
                  }
                  return null;
                },
                controller: _emailcontoller,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please Enter Password";
                  }
                  if (val.length < 6) {
                    return "Password Must Be at least 6 characters";
                  }
                  return null;
                },
                controller: _passcontoller,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please Enter Confirm Password";
                  }
                  return null;
                },
                controller: _confirmpasscontoller,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _validationform,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text("Update Password", style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validationform() {
    if (_formKey.currentState!.validate()) {
      String password = _passcontoller.text.toString();
      String confirmpass = _confirmpasscontoller.text.toString();
      if (password == confirmpass) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Password updated successfully ")));
        _resetPassword();
        Navigator.pop(context);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("password and confirm password should be same "),
          ),
        );
      }
    }
  }

  void _resetPassword() async{
    var url = Uri.parse("https://prakrutitech.xyz/batch_project/reset_password.php");

    var response = await http.post(
      url, body: {
        'request_id': widget.id,
      'new_password' : _confirmpasscontoller.text.toString()
      }
    );

    var jsonData = jsonDecode(response.body);
    ResetPassModel rpmodel = ResetPassModel.fromJson(jsonData);

    if(rpmodel.code == 404){
      print("Invalid request");
    }
    else if(rpmodel.code == 200){
      print("${rpmodel.message}");
    }
  }
}
