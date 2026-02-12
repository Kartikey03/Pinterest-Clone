/// Minimal auth user entity for the domain layer.
///
/// Decoupled from Clerk's internal models so the domain layer
/// has zero dependency on any external SDK.
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

  /// Convenience getter for display name.
  String get displayName {
    final parts = [firstName, lastName].where((p) => p != null && p.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : email;
  }

  /// Returns the user's initials for avatar fallback.
  String get initials {
    if (firstName != null && firstName!.isNotEmpty) {
      final last =
          (lastName != null && lastName!.isNotEmpty) ? lastName![0] : '';
      return '${firstName![0]}$last'.toUpperCase();
    }
    return email[0].toUpperCase();
  }
}
