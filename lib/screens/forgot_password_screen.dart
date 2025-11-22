import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontoller = new TextEditingController();
  TextEditingController _passcontoller = new TextEditingController();
  TextEditingController _confirmpasscontoller = new TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfromPassword = true;

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
                obscureText: _obscureConfromPassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfromPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfromPassword = !_obscureConfromPassword),
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
      String password=_passcontoller.text.toString();
      String confirmpass=_confirmpasscontoller.text.toString();
      if(password==confirmpass){
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login Succesfully ")));
      }else{
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("password and confrompassword should be same")));
      }
    }
  }
}
