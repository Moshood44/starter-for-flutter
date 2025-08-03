# 🚀 TaskPay Appwrite Setup Guide

This guide will help you set up Appwrite backend for your TaskPay app in **5 simple steps**.

## Step 1: Create Your Appwrite Project

### 1.1 Sign up for Appwrite Cloud
- Go to [cloud.appwrite.io](https://cloud.appwrite.io)
- Sign up with your email or GitHub account
- It's **completely free** for development!

### 1.2 Create New Project
- Click **"Create Project"**
- Project Name: `TaskPay`
- Click **"Create"**

### 1.3 Get Your Project ID
- After creating the project, you'll see your **Project ID** on the dashboard
- Copy this ID (it looks like: `507f1f77bcf86cd799439011`)

### 1.4 Update Your Environment File
Open your `.env` file and replace `your_project_id_here` with your actual Project ID:
```env
APPWRITE_PROJECT_ID=507f1f77bcf86cd799439011
```

**Important:** You'll also need to add your database ID later in Step 3.

---

## Step 2: Enable Authentication

### 2.1 Go to Auth Settings
- In your Appwrite dashboard, click **"Auth"** in the left sidebar
- Click **"Settings"** tab

### 2.2 Enable Email/Password
- Find **"Email/Password"** in the list
- Toggle it **ON** (should turn blue/green)
- Set minimum password length to **6 characters**
- Click **"Update"**

---

## Step 3: Create Database

### 3.1 Create Database
- Click **"Databases"** in the left sidebar
- Click **"Create Database"**
- Database ID: `taskpay_db` (you can use any ID you want)
- Name: `TaskPay Database`
- Click **"Create"**

**📝 Important:** After creating the database, copy the **Database ID** (it will look like `688f8c2a000e8d008100`) and add it to your `.env` file:
```env
APPWRITE_DATABASE_ID=your_actual_database_id_here
```

### 3.2 Create Collections
Now we'll create 3 collections (think of them as tables):

#### Collection 1: Users
- Click **"Create Collection"**
- Collection ID: `users`
- Name: `Users`
- Click **"Create"**

**Add these attributes (fields):**
1. Click **"Create Attribute"** → **"String"**
   - Key: `email`
   - Size: `255`
   - Required: ✅
   - Click **"Create"**

2. Click **"Create Attribute"** → **"String"**
   - Key: `primaryRole`
   - Size: `50`
   - Required: ✅
   - Click **"Create"**

3. Click **"Create Attribute"** → **"String"** → **"Array"**
   - Key: `availableRoles`
   - Size: `50`
   - Required: ✅
   - Click **"Create"**

4. Click **"Create Attribute"** → **"DateTime"**
   - Key: `createdAt`
   - Required: ✅
   - Click **"Create"**

5. Click **"Create Attribute"** → **"Boolean"**
   - Key: `isVerified`
   - Required: ✅
   - Default: `false`
   - Click **"Create"**

#### Collection 2: User Profiles
- Click **"Create Collection"**
- Collection ID: `user_profiles`
- Name: `User Profiles`
- Click **"Create"**

**Add these attributes:**
1. `userId` (String, size: 255, required)
2. `displayName` (String, size: 255, required)
3. `bio` (String, size: 1000, optional)
4. `skills` (String Array, size: 100, optional)
5. `profileImageUrl` (String, size: 500, optional)
6. `rating` (Double, required, default: 0.0)
7. `completedTasks` (Integer, required, default: 0)
8. `isStudentVerified` (Boolean, required, default: false)
9. `contactInfo` (String, size: 1000, optional)
10. `lastUpdated` (DateTime, required)

#### Collection 3: Ratings
- Click **"Create Collection"**
- Collection ID: `ratings`
- Name: `Ratings`
- Click **"Create"**

**Add these attributes:**
1. `fromUserId` (String, size: 255, required)
2. `toUserId` (String, size: 255, required)
3. `taskId` (String, size: 255, required)
4. `rating` (Double, required)
5. `comment` (String, size: 1000, optional)
6. `createdAt` (DateTime, required)

---

## Step 4: Create Storage Bucket

### 4.1 Create Bucket for Images
- Click **"Storage"** in the left sidebar
- Click **"Create Bucket"**
- Bucket ID: `profile_images`
- Name: `Profile Images`
- Click **"Create"**

### 4.2 Set Permissions
- Click on your new bucket
- Go to **"Settings"** tab
- Under **"Permissions"**, add:
  - **Create**: `users`
  - **Read**: `any`
  - **Update**: `users`
  - **Delete**: `users`

---

## Step 5: Test Your Setup

### 5.1 Run Your App
```bash
flutter run
```

### 5.2 Check Connection
- Look at your debug console/terminal
- You should see: **"Appwrite connection initialized: Success"**
- If you see this, congratulations! 🎉 Your backend is ready!

### 5.3 If Connection Fails
- Double-check your Project ID in `.env` file
- Make sure you're using the correct endpoint: `https://cloud.appwrite.io/v1`
- Restart your app after changing `.env` file

---

## 🎯 Quick Checklist

- [ ] Created Appwrite project
- [ ] Copied Project ID to `.env` file
- [ ] Enabled Email/Password authentication
- [ ] Created `taskpay_db` database
- [ ] Created `users` collection with 5 attributes
- [ ] Created `user_profiles` collection with 10 attributes
- [ ] Created `ratings` collection with 6 attributes
- [ ] Created `profile_images` storage bucket
- [ ] App shows "Appwrite connection initialized: Success"

---

## 🆘 Need Help?

If you get stuck:
1. Check the [Appwrite Documentation](https://appwrite.io/docs)
2. Make sure all collection IDs match exactly (case-sensitive)
3. Verify your Project ID is correct
4. Try refreshing your Appwrite dashboard

**Your TaskPay app is now ready to handle user authentication and data storage!** 🚀