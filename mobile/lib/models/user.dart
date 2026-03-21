class User {
  final String id;
  final String name;
  final String email;
  final String? nickname;
  final String? avatar;
  final String? familyId;
  final String? role; // "keeper" | "member" | null

  User({
    required this.id,
    required this.name,
    required this.email,
    this.nickname,
    this.avatar,
    this.familyId,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      nickname: json['nickname'],
      avatar: json['avatar'],
      familyId: json['family_id'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nickname': nickname,
      'avatar': avatar,
      'family_id': familyId,
      'role': role,
    };
  }

  // Helper getters
  bool get hasFamily => familyId != null;
  bool get isKeeper => role == 'keeper';
  bool get isMember => role == 'member';
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String? nickname;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.nickname,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (nickname != null) 'nickname': nickname,
    };
  }
}

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class UpdateProfileRequest {
  final String? nickname;
  final String? avatar;

  UpdateProfileRequest({
    this.nickname,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (nickname != null) json['nickname'] = nickname;
    if (avatar != null) json['avatar'] = avatar;
    return json;
  }
}
