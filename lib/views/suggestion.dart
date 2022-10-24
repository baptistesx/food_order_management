import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/suggestion/suggestion.dart';
import 'package:fom/blocs/suggestion/suggestion_events.dart';
import 'package:fom/blocs/suggestion/suggestion_states.dart';
import 'package:fom/models/suggestion.dart';
import 'package:fom/theme/themes.dart';
import 'package:fom/widgets/custom_appbar.dart';
import 'package:fom/widgets/custom_snackbar_error_content.dart';
import 'package:url_launcher/url_launcher.dart';

class SuggestionPage extends StatefulWidget {
  static const String routeName = '/suggestion';

  const SuggestionPage({Key? key}) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    textController.dispose();

    super.dispose();
  }

  String? _validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return 'Merci de remplir ce champ';
    }
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(text)) {
      return 'Mauvais format';
    }
    return null;
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Avançons ensemble!')),
      body: BlocListener<SuggestionBloc, SuggestionState>(
        listener: (BuildContext context, SuggestionState state) {
          if (state is SuggestionSentState) {
            const SnackBar snackBar = SnackBar(
              backgroundColor: Colors.green,
              content: CustomSnackBarErrorContent(
                'Suggestion envoyée avec succès, merci!',
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pop(context);
          } else if (state is SuggestionErrorState) {
            final SnackBar snackBar = SnackBar(
              backgroundColor: context.theme.errorColor,
              content: CustomSnackBarErrorContent(
                state.message,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Un bug? Une suggestion?',
                    style: context.theme.textTheme.headline4,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Faites nous en part afin d\'améliorer continuellement l\'application.',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Remplissez ce formulaire ou écrivez nous par mail à l\'adresse suivante: ',
                      ),
                      TextButton(
                        onPressed: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'contact@ludyb.fr',
                            query: encodeQueryParameters(<String, String>{
                              'subject': 'Suggestion pour la POM app',
                              'body': textController.text,
                            }),
                          );

                          await launchUrl(emailLaunchUri);
                        },
                        child: const Text('contact@ludyb.fr'),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Votre nom',
                            labelText: 'Votre nom*',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Merci de remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Votre email',
                            labelText: 'Votre email*',
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          minLines: 8,
                          maxLines: 20,
                          controller: textController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Votre message',
                            labelText: 'Votre message*',
                          ),
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 20) {
                              return 'Merci de remplir ce champ avec un minimum d\'informations';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<SuggestionBloc>().add(
                                    SendSuggestionEvent(
                                      Suggestion(
                                        userName: nameController.text,
                                        email: emailController.text
                                            .trim()
                                            .toLowerCase(),
                                        body: textController.text,
                                      ),
                                    ),
                                  );
                            }
                          },
                          child: const Text('Envoyer'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
