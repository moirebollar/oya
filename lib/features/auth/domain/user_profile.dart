import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.country,
    required this.language,
    this.displayName,
  });

  final String uid;
  final String email;
  final String country; // 'NL' | 'ES' | 'OTHER'
  final String language; // 'nl' | 'es' | 'en'
  final String? displayName;

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      email: data['email'] as String? ?? '',
      country: data['country'] as String? ?? 'OTHER',
      language: data['language'] as String? ?? 'en',
      displayName: data['displayName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'country': country,
        'language': language,
        if (displayName != null) 'displayName': displayName,
      };

  UserProfile copyWith({
    String? country,
    String? language,
    String? displayName,
  }) {
    return UserProfile(
      uid: uid,
      email: email,
      country: country ?? this.country,
      language: language ?? this.language,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object?> get props => [uid, email, country, language, displayName];
}
