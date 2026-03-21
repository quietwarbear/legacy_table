import 'user.dart';

class Family {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final String inviteCode;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  Family({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    required this.inviteCode,
    this.metadata,
    required this.createdAt,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    String? description = json['description'];
    if (description == null && json['metadata'] != null) {
      final metadata = json['metadata'];
      if (metadata is Map<String, dynamic>) {
        description = metadata['description'];
      }
    }
    
    return Family(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: description,
      ownerId: json['owner_id'] ?? '',
      inviteCode: json['invite_code'] ?? '',
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner_id': ownerId,
      'invite_code': inviteCode,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class CreateFamilyRequest {
  final String name;
  final String? description;

  CreateFamilyRequest({
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
    };
  }
}

class JoinFamilyRequest {
  final String inviteCode;

  JoinFamilyRequest({
    required this.inviteCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'invite_code': inviteCode,
    };
  }
}

class JoinFamilyResponse {
  final String message;
  final Family family;
  final User user;

  JoinFamilyResponse({
    required this.message,
    required this.family,
    required this.user,
  });

  factory JoinFamilyResponse.fromJson(Map<String, dynamic> json) {
    return JoinFamilyResponse(
      message: json['message'] ?? '',
      family: Family.fromJson(json['family'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class TransferKeeperRequest {
  final String newKeeperId;

  TransferKeeperRequest({
    required this.newKeeperId,
  });

  Map<String, dynamic> toJson() {
    return {
      'new_keeper_id': newKeeperId,
    };
  }
}
