import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  // Validate Methods
  bool _userNameValidate(final value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    int letterCount = 0;
    int digitCount = 0;

    for (final c in value.runes) {
      if (RegExp(r'[a-zA-z]').hasMatch(String.fromCharCode(c))) {
        letterCount++;
      } else if (RegExp(r'\d').hasMatch(String.fromCharCode(c))) {
        digitCount++;
      }
    }
    return letterCount >= 3 && digitCount >= 3;
  }

  bool _confirmPWDValidate(final pwdValue, final confirmValue) {
    return pwdValue == confirmValue;
  }

  bool _emailValidate(final value) {
    return (value != null) && !value.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _pwdController = TextEditingController();
    final _confirmPwdController = TextEditingController();
    final _emailController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Username TextForm
                TextFormField(
                  validator: (value) {
                    if (!_userNameValidate(value)) {
                      return 'Username is invalid';
                    }
                    return null;
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'userName',
                  ),
                ),
                const SizedBox(height: 12.0),
                //PWD TextForm
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the password';
                    }
                    return null;
                  },
                  controller: _pwdController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 12.0),
                //Confirm PWD TextForm
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the password';
                    } else if (!_confirmPWDValidate(
                        _pwdController.text, value)) {
                      return 'Confirm Password doesn\'t match Password';
                    }
                    return null;
                  },
                  controller: _confirmPwdController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Confirm Password',
                  ),
                ),
                const SizedBox(height: 12.0),
                //Email TextForm
                TextFormField(
                  validator: (value) {
                    if (!_emailValidate(value)) {
                      return 'Please enter Email Address';
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Email Address',
                  ),
                ),
                const SizedBox(height: 12.0),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 118, 220, 198)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // TODO : MAKE POP MESSAGE
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: const Text('Sign UP'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
