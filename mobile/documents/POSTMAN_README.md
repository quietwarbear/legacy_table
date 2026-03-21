# Postman Collection for Honor Touré Family Recipes API

This directory contains a complete Postman collection for testing all API endpoints of the Honor Touré Family Recipes application.

## Files

- `HTrecipes_API.postman_collection.json` - Complete API collection with all endpoints
- `HTrecipes_API.postman_environment.json` - Environment variables for easy configuration

## Setup Instructions

### 1. Import the Collection

1. Open Postman
2. Click **Import** button (top left)
3. Select `HTrecipes_API.postman_collection.json`
4. Click **Import**

### 2. Import the Environment

1. Click **Import** button again
2. Select `HTrecipes_API.postman_environment.json`
3. Click **Import**
4. Select the environment from the dropdown (top right) - choose "Honor Touré Family Recipes - Local"

### 3. Configure Environment Variables

The environment comes pre-configured with:
- `base_url`: `http://localhost:8000` (default)
- `token`: Will be auto-populated after login
- `user_id`: Will be auto-populated after login

**To change the base URL:**
1. Click the environment dropdown (top right)
2. Click the eye icon to view variables
3. Edit `base_url` if your backend is running on a different port/host

## Using the Collection

### Quick Start Workflow

1. **Health Check** - Verify the API is running
   - Use `Health Check > Health Check` endpoint

2. **Register a New User**
   - Use `Authentication > Register`
   - Fill in name, email, password (nickname is optional)
   - Copy the `token` from the response

3. **Login** (Alternative to Register)
   - Use `Authentication > Login`
   - The token will be automatically saved to the environment variable
   - The user_id will also be saved automatically

4. **Get Your Profile**
   - Use `Authentication > Get Current User`
   - This uses the saved token automatically

5. **Create a Recipe**
   - Use `Recipes > Create Recipe`
   - Fill in all required fields
   - The token is automatically included in the request

6. **Get All Recipes**
   - Use `Recipes > Get All Recipes`
   - Optionally add query parameters for filtering

### Collection Structure

The collection is organized into folders:

#### 1. Authentication
- **Register** - Create a new user account
- **Login** - Login and get JWT token (auto-saves token)
- **Get Current User** - Get authenticated user info
- **Update Profile** - Update nickname and/or avatar

#### 2. Recipes
- **Create Recipe** - Create a new recipe (requires auth)
- **Get All Recipes** - List all recipes (supports category/author filters)
- **Get Recipe by ID** - Get a specific recipe
- **Update Recipe** - Update a recipe (author only)
- **Delete Recipe** - Delete a recipe (author only)
- **Get Categories** - Get all available categories

#### 3. Comments
- **Create Comment** - Add a comment to a recipe (requires auth)
- **Get Comments** - Get all comments for a recipe
- **Delete Comment** - Delete a comment (author only)

#### 4. Notifications
- **Get Notifications** - Get all user notifications (requires auth)
- **Get Unread Count** - Get count of unread notifications
- **Mark Notification as Read** - Mark a specific notification as read
- **Mark All Notifications as Read** - Mark all notifications as read

#### 5. Health Check
- **API Root** - Get API welcome message
- **Health Check** - Check API health status

## Authentication

Most endpoints require authentication using a JWT token. The token is automatically included in requests when you:
1. Use the Login endpoint (it auto-saves the token)
2. Manually set the `token` environment variable

**To manually set a token:**
1. Click the environment dropdown
2. Click the eye icon
3. Edit the `token` variable with your JWT token

## Example Request Bodies

### Register
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "nickname": "Johnny"
}
```

### Login
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

### Create Recipe
```json
{
  "title": "Grandma's Chocolate Cake",
  "ingredients": [
    "2 cups flour",
    "1 cup sugar",
    "3 eggs",
    "1/2 cup butter"
  ],
  "instructions": "Mix all ingredients together. Bake at 350°F for 30 minutes.",
  "story": "This recipe has been passed down through generations.",
  "photos": [],
  "cooking_time": 30,
  "servings": 8,
  "category": "Dessert",
  "difficulty": "easy"
}
```

### Create Comment
```json
{
  "text": "This recipe looks amazing! Can't wait to try it."
}
```

### Update Profile
```json
{
  "nickname": "Johnny",
  "avatar": "data:image/png;base64,..."
}
```

## Notes

- **Base URL**: Default is `http://localhost:8000`. Change in environment variables if needed.
- **Token Auto-Save**: The Login endpoint automatically saves the token to the environment.
- **User ID Auto-Save**: The Login endpoint also saves the user_id for convenience.
- **Path Variables**: Some endpoints use path variables (like `:recipe_id`). Replace these in the URL or set them in the environment.
- **Query Parameters**: Some endpoints support optional query parameters. Enable/disable them in the request.

## Troubleshooting

### "Invalid token" errors
- Make sure you've logged in and the token is saved
- Check that the token hasn't expired (tokens last 7 days)
- Verify the token is correctly set in the environment variable

### "Connection refused" errors
- Ensure the backend server is running on `http://localhost:8000`
- Check the `base_url` environment variable
- Verify the backend is accessible

### CORS errors
- The backend should be configured to allow requests from your origin
- Check the CORS_ORIGINS environment variable in the backend

## API Base URL

Default: `http://localhost:8000`

The API base path is `/api`, so full endpoints are:
- `http://localhost:8000/api/auth/login`
- `http://localhost:8000/api/recipes`
- etc.
