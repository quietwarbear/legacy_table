# API Integration Layer

This directory contains the API integration layer using Dio for HTTP requests.

## Structure

- **api_client.dart** - Core Dio client with interceptors and error handling
- **api_service.dart** - Main service class that provides access to all API services (singleton)
- **storage_service.dart** - Secure storage service using FlutterSecureStorage and SharedPreferences
- **session_manager.dart** - Session management with authentication state (ChangeNotifier)
- **auth_service.dart** - Authentication endpoints (register, login, profile)
- **recipe_service.dart** - Recipe management endpoints (CRUD operations)
- **comment_service.dart** - Comment management endpoints
- **notification_service.dart** - Notification management endpoints

## Configuration

The API base URL is configured in `lib/config/api_config.dart`. Default is `http://localhost:8000`.

## Secure Token Storage

The app uses `flutter_secure_storage` for secure token storage:
- Tokens are stored in the device Keychain (iOS) or Keystore (Android)
- User credentials are encrypted
- Session state is managed through `SessionManager`

## Session Management

Use `SessionManager` for authentication and session handling:

```dart
import 'package:family_recipe_app/services/session_manager.dart';

// Get the singleton instance
final session = sessionManager;

// Listen to session changes
session.addListener(() {
  if (session.isLoggedIn) {
    // User is logged in
    print('User: ${session.currentUser?.name}');
  }
});

// Login
await session.login('user@example.com', 'password123');

// Register
await session.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  nickname: 'Johnny',
);

// Logout
await session.logout();

// Update profile
await session.updateProfile(nickname: 'New Nickname');

// Refresh user data
await session.refreshUser();

// Check if logged in
if (session.isLoggedIn) {
  // User is authenticated
}
```

## Usage

### Basic API Usage (Low-level)

```dart
import 'package:family_recipe_app/services/api_service.dart';

// Use the singleton instance
final api = apiService;

// Login
final loginResponse = await api.auth.login(
  LoginRequest(
    email: 'user@example.com',
    password: 'password123',
  ),
);

// The token is automatically set after login
// Now you can make authenticated requests

// Get all recipes
final recipes = await api.recipes.getRecipes();

// Create a recipe
final newRecipe = await api.recipes.createRecipe(
  CreateRecipeRequest(
    title: 'My Recipe',
    ingredients: ['ingredient1', 'ingredient2'],
    instructions: 'Cook it',
  ),
);
```

### Recommended: Using Session Manager (High-level)

For authentication and session management, use `SessionManager` instead:

```dart
import 'package:family_recipe_app/services/session_manager.dart';

final session = sessionManager;

// Register and auto-login
await session.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
);

// Login
await session.login('john@example.com', 'password123');

// Session is automatically initialized on app startup
// Token is automatically stored and retrieved

// Access current user
final user = session.currentUser;

// Check login state
if (session.isLoggedIn) {
  // User is authenticated
}

// Logout (clears token and session)
await session.logout();
```

### Authentication Flow

```dart
// Using SessionManager (recommended)
final session = sessionManager;

// Register
await session.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  nickname: 'Johnny',
);

// Login
await session.login('john@example.com', 'password123');

// Get current user (automatically available after login)
final user = session.currentUser;

// Update profile
await session.updateProfile(
  nickname: 'New Nickname',
  avatar: 'base64_encoded_image',
);

// Logout (clears all stored data)
await session.logout();
```

### Recipe Operations

```dart
final api = apiService;

// Get all recipes
final recipes = await api.recipes.getRecipes();

// Get recipes by category
final desserts = await api.recipes.getRecipes(category: 'Dessert');

// Get recipes by author
final myRecipes = await api.recipes.getRecipes(authorId: 'user_id');

// Get single recipe
final recipe = await api.recipes.getRecipeById('recipe_id');

// Create recipe
final newRecipe = await api.recipes.createRecipe(
  CreateRecipeRequest(
    title: 'Grandma\'s Chocolate Cake',
    ingredients: ['2 cups flour', '1 cup sugar'],
    instructions: 'Mix and bake',
    cookingTime: 30,
    servings: 8,
    category: 'Dessert',
    difficulty: 'easy',
  ),
);

// Update recipe
final updated = await api.recipes.updateRecipe(
  'recipe_id',
  UpdateRecipeRequest(
    title: 'Updated Title',
    cookingTime: 45,
  ),
);

// Delete recipe
await api.recipes.deleteRecipe('recipe_id');

// Get categories
final categories = await api.recipes.getCategories();
```

### Comment Operations

```dart
final api = apiService;

// Get comments for a recipe
final comments = await api.comments.getComments('recipe_id');

// Create comment
final comment = await api.comments.createComment(
  'recipe_id',
  CreateCommentRequest(
    text: 'This looks delicious!',
  ),
);

// Delete comment
await api.comments.deleteComment('comment_id');
```

### Notification Operations

```dart
final api = apiService;

// Get all notifications
final notifications = await api.notifications.getNotifications();

// Get unread count
final unreadCount = await api.notifications.getUnreadCount();

// Mark notification as read
await api.notifications.markAsRead('notification_id');

// Mark all as read
await api.notifications.markAllAsRead();
```

## Error Handling

All API calls throw exceptions that should be caught:

```dart
try {
  await session.login('email@example.com', 'password');
} catch (e) {
  print('Error: $e');
  // Handle error (show snackbar, etc.)
}
```

## Models

All models are in `lib/models/`:
- **user.dart** - User, LoginRequest, RegisterRequest, LoginResponse, UpdateProfileRequest
- **recipe.dart** - Recipe, CreateRecipeRequest, UpdateRecipeRequest, Category
- **comment.dart** - Comment, CreateCommentRequest
- **notification.dart** - NotificationModel, UnreadCountResponse

## Security Features

- **Secure Token Storage**: Uses FlutterSecureStorage (Keychain/Keystore)
- **Automatic Token Management**: Tokens are automatically stored and retrieved
- **Session Persistence**: User session persists across app restarts
- **Token Validation**: Automatic token validation on app startup
- **Secure Logout**: All stored data is cleared on logout
