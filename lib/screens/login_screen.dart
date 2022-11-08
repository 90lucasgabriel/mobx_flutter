import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_flutter/stores/login_store.dart';
import 'package:mobx_flutter/widgets/custom_icon_button.dart';
import 'package:mobx_flutter/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginStore loginStore;
  late ReactionDisposer disposer;

  @override
  void didChangeDependencies() {
    loginStore = Provider.of<LoginStore>(context);

    disposer = reaction(
      (_) => loginStore.isLoggedIn,
      (isLoggedIn) {
        if (isLoggedIn) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListScreen()));
        }
      },
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Observer(builder: (context) {
                      return CustomTextField(
                        hint: 'E-mail',
                        prefix: const Icon(Icons.account_circle),
                        textInputType: TextInputType.emailAddress,
                        onChanged: loginStore.setEmail,
                        enabled: !loginStore.isLoading,
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    Observer(builder: (context) {
                      return CustomTextField(
                        hint: 'Senha',
                        prefix: const Icon(Icons.lock),
                        obscure: loginStore.isPasswordHidden,
                        onChanged: loginStore.setPassword,
                        enabled: !loginStore.isLoading,
                        suffix: CustomIconButton(
                          radius: 32,
                          iconData: loginStore.isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onTap: loginStore.togglePasswordVisibility,
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    Observer(builder: (context) {
                      return SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: loginStore.loginOnPressed != null
                              ? () => loginStore.loginOnPressed!()
                              : null,
                          child: loginStore.isLoading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text('Login'),
                        ),
                      );
                    })
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
