# Hotel Room Reservation System - Deployment Guide

## 🚀 **Quick Deployment Options**

### **Option 1: Heroku (Recommended)**

1. **Create Heroku Account:**
   - Go to [heroku.com](https://heroku.com)
   - Sign up for free account

2. **Install Heroku CLI:**
   ```bash
   # Ubuntu/Debian
   curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
   
   # Or download from: https://devcenter.heroku.com/articles/heroku-cli
   ```

3. **Deploy to Heroku:**
   ```bash
   # Login to Heroku
   heroku login
   
   # Create new app
   heroku create your-hotel-app-name
   
   # Add PostgreSQL addon
   heroku addons:create heroku-postgresql:mini
   
   # Deploy
   git push heroku main
   
   # Run migrations and seeds
   heroku run rails db:migrate
   heroku run rails db:seed
   
   # Open app
   heroku open
   ```

### **Option 2: Railway**

1. **Create Railway Account:**
   - Go to [railway.app](https://railway.app)
   - Sign up with GitHub

2. **Deploy:**
   - Connect your GitHub repository
   - Railway will auto-detect Rails app
   - Add PostgreSQL database
   - Deploy automatically

### **Option 3: Render**

1. **Create Render Account:**
   - Go to [render.com](https://render.com)
   - Sign up for free

2. **Deploy:**
   - Connect GitHub repository
   - Choose "Web Service"
   - Select Ruby environment
   - Add PostgreSQL database
   - Deploy

## 📋 **Pre-Deployment Checklist**

### **1. Update Database Configuration**
Create `config/database.yml` for production:
```yaml
production:
  adapter: postgresql
  url: <%= ENV['DATABASE_URL'] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
```

### **2. Add Production Gems**
Update `Gemfile`:
```ruby
group :production do
  gem 'pg', '~> 1.1'
end
```

### **3. Environment Variables**
Set these in your deployment platform:
- `RAILS_MASTER_KEY` (from `config/master.key`)
- `DATABASE_URL` (auto-set by platform)

### **4. Create Procfile**
Create `Procfile` in root directory:
```
web: bundle exec puma -C config/puma.rb
release: bundle exec rails db:migrate
```

## 🔧 **Local Testing Before Deployment**

1. **Test with PostgreSQL:**
   ```bash
   # Install PostgreSQL
   sudo apt-get install postgresql postgresql-contrib
   
   # Update Gemfile
   echo "gem 'pg', '~> 1.1'" >> Gemfile
   bundle install
   
   # Update database.yml for development
   # Test locally
   rails db:create db:migrate db:seed
   rails server
   ```

2. **Test Production Build:**
   ```bash
   # Precompile assets
   RAILS_ENV=production bundle exec rails assets:precompile
   
   # Test production locally
   RAILS_ENV=production rails server
   ```

## 📝 **Submission Checklist**

### **✅ Before Submitting:**
- [ ] Application deployed and accessible via URL
- [ ] All features working on live site
- [ ] Database properly seeded with 97 rooms
- [ ] Booking algorithm functioning correctly
- [ ] Random occupancy generation working
- [ ] Reset functionality operational

### **📋 Submission Requirements:**
1. **Working App Link:** `https://your-app-name.herokuapp.com`
2. **Code Repository:** `https://github.com/yourusername/hotel-room-reservation`
3. **Google Doc:** Copy content from `SOLUTION_DOCUMENT.md`

## 🐛 **Troubleshooting**

### **Common Issues:**

1. **Database Connection Error:**
   - Ensure PostgreSQL addon is added
   - Check DATABASE_URL environment variable

2. **Asset Compilation Error:**
   - Add `gem 'rails_12factor'` to Gemfile
   - Run `bundle exec rails assets:precompile`

3. **Migration Errors:**
   - Run `heroku run rails db:migrate`
   - Check database permissions

4. **Room Initialization:**
   - Run `heroku run rails db:seed`
   - Verify 97 rooms created

## 📞 **Support**

If you encounter issues:
1. Check deployment platform logs
2. Verify environment variables
3. Test locally with PostgreSQL
4. Check Rails logs: `heroku logs --tail`

---

**Note:** Choose the deployment option that works best for you. Heroku is recommended for beginners, while Railway and Render offer modern alternatives with automatic deployments.
