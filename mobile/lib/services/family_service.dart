import '../config/api_config.dart';
import '../models/family.dart';
import '../models/user.dart';
import 'api_client.dart';

// Re-export TransferKeeperRequest for convenience
export '../models/family.dart' show TransferKeeperRequest;

class FamilyService {
  final ApiClient _apiClient;

  FamilyService(this._apiClient);

  /// Create a new family
  Future<Family> createFamily(CreateFamilyRequest request) async {
    final response = await _apiClient.post(
      ApiConfig.families,
      data: request.toJson(),
    );
    return Family.fromJson(response.data);
  }

  /// Join a family using invite code
  Future<JoinFamilyResponse> joinFamily(JoinFamilyRequest request) async {
    final response = await _apiClient.post(
      ApiConfig.joinFamily,
      data: request.toJson(),
    );
    return JoinFamilyResponse.fromJson(response.data);
  }

  /// Get family details by ID
  Future<Family> getFamily(String familyId) async {
    final response = await _apiClient.get(ApiConfig.familyById(familyId));
    return Family.fromJson(response.data);
  }

  /// Update family (keeper only)
  Future<Family> updateFamily(String familyId, CreateFamilyRequest request) async {
    final response = await _apiClient.put(
      ApiConfig.familyById(familyId),
      data: request.toJson(),
    );
    return Family.fromJson(response.data);
  }

  /// Get family members
  Future<List<User>> getFamilyMembers(String familyId) async {
    final response = await _apiClient.get(ApiConfig.familyMembers(familyId));
    final List<dynamic> membersJson = response.data;
    return membersJson.map((json) => User.fromJson(json)).toList();
  }

  /// Remove a member from family (keeper only)
  Future<void> removeMember(String familyId, String userId) async {
    await _apiClient.delete(
      '${ApiConfig.familyMembers(familyId)}/$userId',
    );
  }

  /// Leave family (member can leave their own family)
  /// Regular members can leave immediately. Keeper can only leave if they are the only member, or after transferring keeper role.
  Future<void> leaveFamily(String familyId) async {
    await _apiClient.delete(
      ApiConfig.leaveFamily(familyId),
    );
  }

  /// Transfer keeper role to another member
  /// Only the current keeper can transfer their role
  Future<void> transferKeeper(String familyId, TransferKeeperRequest request) async {
    await _apiClient.put(
      ApiConfig.transferKeeper(familyId),
      data: request.toJson(),
    );
  }
}
