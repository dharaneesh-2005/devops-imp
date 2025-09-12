# GitHub Heatmap Generator

This script helps you maintain a green GitHub contribution heatmap by making frequent, meaningful commits to your repository.

## 🎯 Features

- **Automated Commits**: Makes commits with realistic messages
- **Scheduled Commits**: Runs commits at specific times throughout the day
- **Past Week Filler**: Creates commits for the past week
- **Statistics Tracking**: Keeps track of your commit activity
- **Cross-Platform**: Works on Windows, Mac, and Linux

## 🚀 Quick Start

### 1. Install Dependencies
```bash
cd scripts
npm install
```

### 2. Make Daily Commits
```bash
# Make 3 commits today
npm run daily

# Make 5 commits today
node github-heatmap.js daily 5
```

### 3. Schedule Commits
```bash
# Schedule commits throughout the day
npm run schedule
```

### 4. Fill Past Week
```bash
# Create commits for the past week
npm run past-week
```

## 📋 Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `daily [count]` | Make multiple commits today | `node github-heatmap.js daily 5` |
| `schedule` | Schedule commits throughout the day | `node github-heatmap.js schedule` |
| `past-week` | Make commits for the past week | `node github-heatmap.js past-week` |
| `single` | Make a single commit | `node github-heatmap.js single` |
| `stats` | Show current statistics | `node github-heatmap.js stats` |

## ⏰ Scheduling Options

### Option 1: Manual Daily Commits
```bash
# Run this every morning
npm run daily
```

### Option 2: Scheduled Commits
```bash
# This will make commits at 9am, 12pm, 3pm, 6pm, 9pm
npm run schedule
```

### Option 3: Continuous Scheduler
```bash
# Windows
heatmap-scheduler.bat

# Linux/Mac
chmod +x heatmap-scheduler.sh
./heatmap-scheduler.sh
```

## 📊 What It Does

1. **Creates Realistic Commits**: Uses meaningful commit messages
2. **Updates Files**: Modifies log files and statistics
3. **Tracks Activity**: Keeps statistics in `stats.json`
4. **Pushes to GitHub**: Automatically pushes commits to remote

## 📁 Generated Files

- `heatmap-log.txt` - Log of all commits made
- `stats.json` - Statistics and commit counts
- Git commits with realistic messages

## 🎨 Customization

### Custom Commit Messages
Edit the `commitMessages` array in `github-heatmap.js`:

```javascript
this.commitMessages = [
  'Update documentation',
  'Fix minor typos',
  'Improve code formatting',
  // Add your own messages here
];
```

### Custom Schedule Times
Edit the `hours` array in the `scheduleCommits()` method:

```javascript
const hours = [9, 12, 15, 18, 21]; // 9 AM, 12 PM, 3 PM, 6 PM, 9 PM
```

## 🔧 Setup for Automation

### Windows Task Scheduler
1. Open Task Scheduler
2. Create Basic Task
3. Set trigger to "Daily"
4. Set action to run: `node github-heatmap.js daily`

### Linux Cron Job
```bash
# Edit crontab
crontab -e

# Add this line to run daily at 9 AM
0 9 * * * cd /path/to/your/repo && node scripts/github-heatmap.js daily
```

### Mac Automator
1. Open Automator
2. Create new "Application"
3. Add "Run Shell Script" action
4. Add: `cd /path/to/your/repo && node scripts/github-heatmap.js daily`

## 📈 Tips for Best Results

1. **Run Daily**: Make it a habit to run the script daily
2. **Mix with Real Work**: Use alongside actual development
3. **Customize Messages**: Make commit messages relevant to your project
4. **Monitor Stats**: Check your progress with `npm run stats`
5. **Be Consistent**: Regular commits look more natural

## 🚨 Important Notes

- **Use Responsibly**: This is for learning and maintaining activity
- **Real Work First**: Always prioritize actual development work
- **GitHub Guidelines**: Follow GitHub's terms of service
- **Backup**: Keep backups of your repository

## 🎯 Example Workflow

```bash
# Morning routine
npm run daily 3

# Check stats
npm run stats

# Evening routine
npm run single
```

## 🔍 Troubleshooting

### Common Issues

**"Git not found"**
- Install Git and add it to your PATH

**"Node not found"**
- Install Node.js and add it to your PATH

**"Permission denied"**
- Check file permissions
- Ensure you have write access to the repository

**"Remote not found"**
- Set up your Git remote: `git remote add origin <your-repo-url>`

### Getting Help

1. Check the console output for error messages
2. Ensure Git is properly configured
3. Verify your repository is set up correctly
4. Check file permissions

## 🎉 Success!

Once you start using this script regularly, you'll see:
- ✅ Green squares on your GitHub heatmap
- 📊 Consistent contribution activity
- 🚀 Improved coding habits
- 📈 Better project visibility

Happy coding! 🎯
