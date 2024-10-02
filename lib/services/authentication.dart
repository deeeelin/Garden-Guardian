import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/log_in_method.dart';
import 'package:flutter_app/models/appUser.dart' as models;
import 'package:flutter_app/repositories/appUser_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AuthenticationService {
  final AppUserRepository _appUserRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationService({AppUserRepository? appUserRepository})
      : _appUserRepository = appUserRepository ?? AppUserRepository();

  /// Returns the user ID.
  Future<String?> signUp(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required XFile avatarFile}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      String userId = userCredential.user!.uid;
      _postSignUp(
        userId: userId,
        email: email,
        name: name,
        avatarFile: avatarFile,
        // logInMethods: [LogInMethod.emailAndPassword],
      );
      debugPrint('New email account created');

      return userId;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        final existingUserDoc = await _appUserRepository.getUserByEmail(email);
        if (existingUserDoc == null) {
          throw Exception('Email already in use but no user doc found');
        }

        if (existingUserDoc.logInMethods
            .contains(LogInMethod.emailAndPassword)) {
          if (context.mounted) {
            await _promptLogInInstead(context);
          }
          return null;
        } else if (existingUserDoc.logInMethods.contains(LogInMethod.google)) {
          // Link the existing Google account with the provided email and password
          final googleSignIn = GoogleSignIn();
          GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
          if (googleUser == null && context.mounted) {
            // Show dialog to inform the user why Google sign-in is needed
            bool shouldProceed = await _promptLinkEmailToGoogle(context);
            if (!shouldProceed) {
              return null; // User canceled the Google sign-in process
            }
            googleUser = await googleSignIn.signIn();
          }
          // Return null if the user cancels the sign-in process
          if (googleUser == null) return null;

          final googleAuth = await googleUser.authentication;
          final googleCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final user =
              (await _firebaseAuth.signInWithCredential(googleCredential))
                  .user!;

          // Check if the email matches the Google account email
          if (user.email == email) {
            // Link the existing Google account with the provided email and password
            final emailCredential = EmailAuthProvider.credential(
              email: email,
              password: password,
            );
            await user.linkWithCredential(emailCredential);
            debugPrint(
                'Email account linked to existing Google account: $email');

            _postSignUp(
              userId: user.uid,
              email: email,
              name: name,
              avatarFile: avatarFile,
              // logInMethods: [
              //   LogInMethod.google,
              //   LogInMethod.emailAndPassword,
              // ],
            );

            return user.uid;
          } else {
            throw Exception(
                'Email does not match Google account email while linking');
          }
        } else {
          throw Exception('Email already in use but no log in method found');
        }
      } else {
        throw Exception('${e.code}: ${e.message}');
      }
    }
  }

  /// Param `avatarUrl` and `avatarFile` cannot be both `null`.
  Future<void> _postSignUp({
    required String userId,
    required String email,
    required name,
    String? avatarUrl,
    XFile? avatarFile,
    // required List<LogInMethod> logInMethods,
  }) async {
    if (avatarFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('apps')
          .child('user_avatars')
          .child('$userId.jpg');
      if (kIsWeb) {
        await storageRef.putData(await avatarFile.readAsBytes());
      } else {
        await storageRef.putFile(File(avatarFile.path));
      }
      avatarUrl = await storageRef.getDownloadURL();
    }

    await _appUserRepository.createOrUpdateUser(models.appUser(
      id: userId,
      email: email,
      userName: name,
      avatarUrl: avatarUrl!,
      // logInMethods: logInMethods,
      cnt_drink: 0,
      cnt_plantNum: 0,
      cnt_plantType: 0,
      cnt_signin: 0,
      cnt_watering: 0
    ));
  }

  Future<void> _promptLogInInstead(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Email already in use'),
          content: const Text(
            'The email address you provided is already in use. Please log in instead.',
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _promptLinkEmailToGoogle(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Email already in use'),
              content: const Text(
                'The email address you provided is already in use. This may be due to an existing Google account using the same email address. Press Cancel to use another email address, or Proceed to log in with the Google account and link it with your password.',
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Proceed'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  // Future<void> verifyEmail() async {
  //   await _firebaseAuth.currentUser?.sendEmailVerification();
  // }

  // Future<void> updateEmail(String email) async {
  //   await _firebaseAuth.currentUser?.verifyBeforeUpdateEmail(email);
  // }

  // Future<void> resetPassword(String email) async {
  //   await _firebaseAuth.sendPasswordResetEmail(email: email);
  // }

  /// Returns the user ID.
  Future<String> logIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _postLogIn(userCredential.user!);

      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception('${e.code}: ${e.message}');
    }
  }

  Future<void> _postLogIn(User user) async {
    // force ID token refresh
    IdTokenResult idTokenResult = await user.getIdTokenResult(true);

    final isModerator = idTokenResult.claims?['isModerator'] ?? false;
    debugPrint('Logged in with state: isModerator=$isModerator');
  }

  /// Returns the user ID or `null` in case the log in process was aborted.
  Future<String?> logInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Return null if the user cancels the sign-in process
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if the email is already associated with an email account
      final googleEmail = googleUser.email;
      final existingUserDoc = await _appUserRepository.getUserByEmail(googleEmail);

      if (!context.mounted) return null;

      late User user;
      if (existingUserDoc == null) {
        // Email is not associated with any existing account, so create a new account
        user =
            (await _firebaseAuth.signInWithCredential(googleCredential)).user!;

        _postSignUp(
          userId: user.uid,
          email: googleEmail,
          name: googleUser.displayName ?? googleEmail.split('@').first,
          avatarUrl: googleUser.photoUrl ?? 'https://via.placeholder.com/150',
          // logInMethods: [LogInMethod.google],
        );
        debugPrint('New Google account created');
      } else {
        if (!existingUserDoc.logInMethods.contains(LogInMethod.google)) {
          // Email is already associated with an email account, so link it with the Google credential
          final password = await _promptLinkGoogleToEmail(context, googleEmail);
          if (password == null) {
            return null; // User cancelled the password prompt
          }

          user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: googleEmail,
            password: password,
          ))
              .user!;

          // Link the Google credential to the existing email account
          await user.linkWithCredential(googleCredential);
          debugPrint(
              'Google account linked to existing email account: $googleEmail');

          _postSignUp(
            userId: user.uid,
            email: googleEmail,
            name: existingUserDoc.userName, // No overwrite
            avatarUrl: existingUserDoc.avatarUrl, // No overwrite
            // logInMethods: [LogInMethod.emailAndPassword, LogInMethod.google],
          );
        } else {
          // Email account is already linked, proceed log in
          user = (await _firebaseAuth.signInWithCredential(googleCredential))
              .user!;
        }
      }

      _postLogIn(user);

      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception('${e.code}: ${e.message}');
    }
  }

  Future<String?> _promptLinkGoogleToEmail(
      BuildContext context, String email) async {
    TextEditingController passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Email already in use'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  children: [
                    const TextSpan(
                        text: 'The email address of your Google account:\n\n'),
                    TextSpan(
                      text: email,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                        text:
                            '\n\nhas already been used by an email account. To proceed, please log into the email account to link it with this Google account.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(passwordController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  /// Returns the user ID or `null` if the user is not logged in.
  String? checkAndGetLoggedInUserId() {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return null;

    user.reload();
    return _firebaseAuth.currentUser?.uid; // return new result
  }

  /// Returns a stream of boolean values indicating whether the user is logged in or not
  Stream<bool> authStateChanges() {
    return _firebaseAuth.idTokenChanges().map((user) => user != null);
  }
}
