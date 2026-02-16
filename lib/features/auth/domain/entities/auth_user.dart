/*
 * Minimal auth user entity decoupled from Clerk SDK for the domain layer.
 */

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? imageUrl;

  String get displayName {
    final parts = [firstName, lastName].where((p) => p != null && p.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : email;
  }

  String get initials {
    if (firstName != null && firstName!.isNotEmpty) {
      final last =
          (lastName != null && lastName!.isNotEmpty) ? lastName![0] : '';
      return '${firstName![0]}$last'.toUpperCase();
    }
    return email[0].toUpperCase();
  }
}
