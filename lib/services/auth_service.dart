import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  Future<User>? get currentUser {
    final user = _auth.currentUser;
    if (user != null) {
      return getUserData(user.uid);
    }
    return null;
  }

  // Sign up
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final userData = {
        'name': name,
        'email': email,
        'role': UserRole.BUYER.toString().split('.').last,
        'cart': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      // Get and return the created user
      return getUserData(userCredential.user!.uid);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return getUserData(userCredential.user!.uid);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user data from Firestore
  Future<User> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    
    final data = doc.data()!;
    return User.fromJson({
      '_id': doc.id,
      ...data,
      'createdAt': data['createdAt'].toDate().toIso8601String(),
      'updatedAt': data['updatedAt'].toDate().toIso8601String(),
    });
  }

  // Handle Firebase Auth errors
  String _handleAuthError(dynamic error) {
    if (error is firebase.FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled';
        case 'weak-password':
          return 'Password is too weak';
        case 'user-disabled':
          return 'User account has been disabled';
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Invalid password';
        default:
          return 'Authentication failed';
      }
    }
    return 'An error occurred';
  }
}