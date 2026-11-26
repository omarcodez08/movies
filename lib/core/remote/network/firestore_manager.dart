import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies/data/model/user_model.dart';

class FirestoreManager {
  static UserModel? currentUser;

  static const String _webClientId =
      '189621243370-0so7ndn61p02ujgg1s7hk9rmm26rtsl2.apps.googleusercontent.com';

  static CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .withConverter<UserModel>(
      fromFirestore: (snapshot, options) =>
          UserModel.fromFireStore(snapshot.data()),
      toFirestore: (user, options) => user.toFireStore(),
    );
  }

  static Future<void> addUser(UserModel user) async {
    currentUser = user;
    await getUsersCollection().doc(user.id).set(user);
  }

  static Future<UserModel?> getUser() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final DocumentSnapshot<UserModel> doc =
    await getUsersCollection().doc(uid).get();
    currentUser = doc.data();
    return currentUser;
  }

  static Future<UserModel?> signInWithGoogle() async {
    try {
      debugPrint('GoogleSignIn: initializing...');
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(serverClientId: _webClientId);

      debugPrint('GoogleSignIn: opening account picker...');
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      debugPrint('GoogleSignIn: reading authentication...');
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message: 'Google Sign-In did not return an idToken.',
        );
      }

      debugPrint('GoogleSignIn: signing into FirebaseAuth...');
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        debugPrint('GoogleSignIn: Firebase user is null.');
        return null;
      }

      debugPrint('GoogleSignIn: checking Firestore user ${firebaseUser.uid}...');
      UserModel? existingUser = await getUser();
      if (existingUser == null) {
        final UserModel newUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email ?? '',
          phone: firebaseUser.phoneNumber ?? '',
          avatarId: 1,
        );
        await addUser(newUser);
        debugPrint('GoogleSignIn: created new Firestore user.');
        return newUser;
      }

      debugPrint('GoogleSignIn: loaded existing Firestore user.');
      return existingUser;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        debugPrint('GoogleSignIn: canceled by user.');
        return null;
      }
      debugPrint('GoogleSignInException: ${e.code} - ${e.description}');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('GoogleSignIn error: $e');
      debugPrint('$stackTrace');
      rethrow;
    }
  }
}