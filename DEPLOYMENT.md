# Deployment Guide

## Deploy to Netlify (Recommended)

### Method 1: Drag and Drop (Easiest)

1. **Build your app**
   ```bash
   flutter build web --release --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

2. **Go to Netlify**
   - Visit https://app.netlify.com
   - Sign in with GitHub/Email

3. **Deploy**
   - Drag the `build/web` folder to Netlify
   - Your site will be live in seconds!
   - You'll get a URL like: `https://random-name.netlify.app`

4. **Add Environment Variables** (Important!)
   - Go to Site settings → Environment variables
   - Add:
     - `SUPABASE_URL` = your Supabase project URL
     - `SUPABASE_ANON_KEY` = your Supabase anon key

5. **Redeploy**
   - Go to Deploys → Trigger deploy

### Method 2: GitHub Integration (Auto-deploy)

1. **Push to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/yourusername/task-manager-app.git
   git push -u origin main
   ```

2. **Connect to Netlify**
   - In Netlify, click "Add new site" → "Import an existing project"
   - Choose GitHub
   - Select your repository
   - Build settings:
     - Build command: `flutter build web --release`
     - Publish directory: `build/web`
   - Add environment variables
   - Click "Deploy site"

---

## Deploy to Vercel

### Method 1: Vercel CLI

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Build and Deploy**
   ```bash
   flutter build web --release --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your-anon-key
   cd build/web
   vercel --prod
   ```

3. **Follow prompts**
   - Login to Vercel
   - Set up project
   - Your site will be live!

### Method 2: GitHub Integration

1. **Push to GitHub** (same as above)

2. **Import to Vercel**
   - Go to https://vercel.com
   - Click "Add New" → "Project"
   - Import your GitHub repository
   - Framework Preset: Other
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
   - Add environment variables
   - Click "Deploy"

---

## Custom Domain (Optional)

### On Netlify
1. Go to Domain settings
2. Add custom domain
3. Update DNS records as instructed

### On Vercel
1. Go to Settings → Domains
2. Add your domain
3. Update DNS records

---

## Environment Variables

Both platforms need these variables:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Get these from your Supabase project dashboard → Settings → API

---

## Troubleshooting

**Build fails:**
- Make sure Flutter is installed: `flutter doctor`
- Run `flutter clean` then `flutter pub get`

**App loads but can't connect to Supabase:**
- Check environment variables are set correctly
- Verify Supabase URL and key are correct
- Check browser console for errors

**404 errors on refresh:**
- Make sure `netlify.toml` or `vercel.json` is in your repository
- These files configure SPA routing

---

## 🎉 Success!

Your app should now be live and accessible to anyone with the URL!

Share the link with:
- Whatbytes team for assignment review
- Friends and colleagues
- Portfolio visitors

**Example URLs:**
- Netlify: `https://task-manager-app-whatbytes.netlify.app`
- Vercel: `https://task-manager-app.vercel.app`
