# Supabase Setup Guide (100% Free)

## Step 1: Create Supabase Project (2 minutes)

1. **Go to Supabase**
   - Visit: https://supabase.com
   - Click "Start your project"
   - Sign in with GitHub (or create account)

2. **Create New Project**
   - Click "New Project"
   - Organization: Select or create one
   - Name: `task-manager-app`
   - Database Password: Create a strong password (save it!)
   - Region: Choose closest to you
   - Click "Create new project"
   - Wait 1-2 minutes for setup

## Step 2: Get API Credentials

1. **Find Your Credentials**
   - In your project dashboard, click "Settings" (gear icon)
   - Click "API" in the left menu
   - You'll see:
     - **Project URL** (looks like: `https://xxxxx.supabase.co`)
     - **anon public** key (long string starting with `eyJ...`)

2. **Copy These Values** - You'll need them!

## Step 3: Create Database Table

1. **Go to SQL Editor**
   - Click "SQL Editor" in the left menu
   - Click "New query"

2. **Run This SQL**
   ```sql
   -- Create tasks table
   CREATE TABLE tasks (
     id TEXT PRIMARY KEY,
     user_id TEXT NOT NULL,
     title TEXT NOT NULL,
     description TEXT,
     due_date TIMESTAMP NOT NULL,
     priority TEXT NOT NULL,
     is_completed BOOLEAN DEFAULT FALSE,
     created_at TIMESTAMP DEFAULT NOW()
   );

   -- Enable Row Level Security
   ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

   -- Create policy: Users can only see their own tasks
   CREATE POLICY "Users can view their own tasks"
     ON tasks FOR SELECT
     USING (auth.uid()::text = user_id);

   -- Create policy: Users can insert their own tasks
   CREATE POLICY "Users can insert their own tasks"
     ON tasks FOR INSERT
     WITH CHECK (auth.uid()::text = user_id);

   -- Create policy: Users can update their own tasks
   CREATE POLICY "Users can update their own tasks"
     ON tasks FOR UPDATE
     USING (auth.uid()::text = user_id);

   -- Create policy: Users can delete their own tasks
   CREATE POLICY "Users can delete their own tasks"
     ON tasks FOR DELETE
     USING (auth.uid()::text = user_id);
   ```

3. **Click "Run"** - You should see "Success"

## Step 4: Enable Email Authentication

1. **Go to Authentication**
   - Click "Authentication" in the left menu
   - Click "Providers"
   - Email is already enabled by default ✅

## Step 5: Configure Your App

Create a file `.env` in your project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

Replace with your actual values from Step 2!

## Step 6: Run the App

```bash
flutter run -d chrome --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Or for easier use, create a file `run.bat`:

```batch
@echo off
flutter run -d chrome --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## ✅ Verification

1. Run the app
2. Sign up with an email
3. Create a task
4. Go to Supabase Dashboard → Table Editor → tasks
5. You should see your task!

## 🎉 You're Done!

Your app is now using Supabase (completely free) instead of Firebase!

**Free Tier Limits:**
- 500MB database
- 50,000 monthly active users
- 2GB file storage
- Unlimited API requests

Perfect for development and demos! 🚀
