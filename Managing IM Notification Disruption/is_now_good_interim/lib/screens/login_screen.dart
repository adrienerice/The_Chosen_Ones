// import 'package:flutter/material.dart';

// import '/constants.dart';
// import '/components/rounded_button.dart';
// import '/screens/contacts_screen.dart';


// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   static const String id = 'login_screen';

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _auth = FirebaseAuth.instance;
//   String errorMessage = '';
//   late String _email;
//   late String _password; //TODO hash and salt!

//   @override
//   Widget build(BuildContext context) {
//     return LoadingProvider(
//       themeData: LoadingThemeData(),
//       child: Scaffold(
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Flexible(
//                 child: Hero(
//                   tag: 'logo',
//                   child: Container(
//                     height: 200.0,
//                     child: Image.asset('images/logo.png'),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 48.0,
//               ),
//               TextField(
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.emailAddress,
//                 onChanged: (value) {
//                   _email = value;
//                 },
//                 decoration: kTextFieldDecoration.copyWith(
//                   hintText: 'Enter your email',
//                 ),
//               ),
//               SizedBox(
//                 height: 8.0,
//               ),
//               TextField(
//                 textAlign: TextAlign.center,
//                 obscureText: true,
//                 onChanged: (value) {
//                   _password = value;
//                 },
//                 decoration: kTextFieldDecoration.copyWith(
//                   hintText: 'Enter your password.',
//                 ),
//               ),
//               SizedBox(
//                 height: 24.0,
//               ),
//               RoundedButton(
//                 text: 'Log In',
//                 color: Colors.lightGreenAccent,
//                 onPressed: () async {
//                   final snackBar = SnackBar(content: Text('Loading...'));
//                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   try {
//                     final user = await _auth.signInWithEmailAndPassword(
//                       email: _email,
//                       password: _password,
//                     );
//                   } catch (e) {
//                     //TODO catch bad login deets
//                     print(e);
//                     errorMessage = e.toString();
//                   }
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   Navigator.pop(context);
//                 },
//               ),
//               Text(errorMessage),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }