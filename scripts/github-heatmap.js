#!/usr/bin/env node

/**
 * GitHub Heatmap Generator
 * Makes frequent commits to keep your GitHub contribution graph green
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

class GitHubHeatmapGenerator {
  constructor() {
    this.repoPath = process.cwd();
    this.logFile = path.join(this.repoPath, 'heatmap-log.txt');
    this.commitMessages = [
      'Update documentation',
      'Fix minor typos',
      'Improve code formatting',
      'Add new features',
      'Refactor code structure',
      'Update dependencies',
      'Enhance error handling',
      'Optimize performance',
      'Add unit tests',
      'Update README',
      'Fix linting issues',
      'Improve comments',
      'Update configuration',
      'Add new examples',
      'Enhance security',
      'Update build scripts',
      'Improve logging',
      'Add validation',
      'Update API documentation',
      'Fix edge cases'
    ];
  }

  /**
   * Get a random commit message
   */
  getRandomCommitMessage() {
    return this.commitMessages[Math.floor(Math.random() * this.commitMessages.length)];
  }

  /**
   * Get current timestamp
   */
  getTimestamp() {
    return new Date().toISOString();
  }

  /**
   * Make a small change to a file
   */
  makeSmallChange() {
    const timestamp = this.getTimestamp();
    const logEntry = `[${timestamp}] ${this.getRandomCommitMessage()}\n`;
    
    // Append to log file
    fs.appendFileSync(this.logFile, logEntry);
    
    // Also update a stats file
    const statsFile = path.join(this.repoPath, 'stats.json');
    let stats = {};
    
    if (fs.existsSync(statsFile)) {
      stats = JSON.parse(fs.readFileSync(statsFile, 'utf8'));
    }
    
    const today = new Date().toISODateString();
    stats[today] = (stats[today] || 0) + 1;
    stats.lastCommit = timestamp;
    
    fs.writeFileSync(statsFile, JSON.stringify(stats, null, 2));
  }

  /**
   * Make a commit
   */
  makeCommit() {
    try {
      this.makeSmallChange();
      
      const message = this.getRandomCommitMessage();
      const timestamp = this.getTimestamp();
      
      // Add all changes
      execSync('git add .', { cwd: this.repoPath, stdio: 'pipe' });
      
      // Make commit
      execSync(`git commit -m "${message} - ${timestamp}"`, { 
        cwd: this.repoPath, 
        stdio: 'pipe' 
      });
      
      console.log(`✅ Commit made: ${message} - ${timestamp}`);
      return true;
    } catch (error) {
      console.log(`❌ Commit failed: ${error.message}`);
      return false;
    }
  }

  /**
   * Push to remote
   */
  pushToRemote() {
    try {
      execSync('git push origin main', { 
        cwd: this.repoPath, 
        stdio: 'pipe' 
      });
      console.log('🚀 Pushed to remote repository');
      return true;
    } catch (error) {
      console.log(`❌ Push failed: ${error.message}`);
      return false;
    }
  }

  /**
   * Make multiple commits throughout the day
   */
  async makeDailyCommits(commitsPerDay = 3) {
    console.log(`🎯 Making ${commitsPerDay} commits today...`);
    
    for (let i = 0; i < commitsPerDay; i++) {
      const success = this.makeCommit();
      if (success) {
        // Wait a bit between commits
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    }
    
    // Push all commits at once
    this.pushToRemote();
  }

  /**
   * Schedule commits throughout the day
   */
  scheduleCommits() {
    const now = new Date();
    const hours = [9, 12, 15, 18, 21]; // 9 AM, 12 PM, 3 PM, 6 PM, 9 PM
    
    console.log('⏰ Scheduling commits for today...');
    
    hours.forEach(hour => {
      const commitTime = new Date(now);
      commitTime.setHours(hour, Math.floor(Math.random() * 60), 0, 0);
      
      if (commitTime > now) {
        const delay = commitTime.getTime() - now.getTime();
        
        setTimeout(() => {
          console.log(`🕐 Time for commit at ${hour}:00`);
          this.makeCommit();
          this.pushToRemote();
        }, delay);
      }
    });
  }

  /**
   * Make commits for the past week (for testing)
   */
  makePastWeekCommits() {
    console.log('📅 Making commits for the past week...');
    
    for (let i = 6; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      
      // Set the date for git
      const dateStr = date.toISOString().split('T')[0];
      
      for (let j = 0; j < Math.floor(Math.random() * 5) + 1; j++) {
        this.makeSmallChange();
        
        try {
          execSync('git add .', { cwd: this.repoPath, stdio: 'pipe' });
          execSync(`git commit -m "Daily commit - ${dateStr}" --date="${dateStr}"`, { 
            cwd: this.repoPath, 
            stdio: 'pipe' 
          });
        } catch (error) {
          // Ignore errors for past dates
        }
      }
    }
    
    console.log('✅ Past week commits created');
  }

  /**
   * Show current stats
   */
  showStats() {
    const statsFile = path.join(this.repoPath, 'stats.json');
    
    if (fs.existsSync(statsFile)) {
      const stats = JSON.parse(fs.readFileSync(statsFile, 'utf8'));
      console.log('📊 Current Stats:');
      console.log(JSON.stringify(stats, null, 2));
    } else {
      console.log('📊 No stats available yet');
    }
  }
}

// CLI Interface
if (require.main === module) {
  const generator = new GitHubHeatmapGenerator();
  const command = process.argv[2];
  
  switch (command) {
    case 'daily':
      const commits = parseInt(process.argv[3]) || 3;
      generator.makeDailyCommits(commits);
      break;
      
    case 'schedule':
      generator.scheduleCommits();
      break;
      
    case 'past-week':
      generator.makePastWeekCommits();
      break;
      
    case 'stats':
      generator.showStats();
      break;
      
    case 'single':
      generator.makeCommit();
      generator.pushToRemote();
      break;
      
    default:
      console.log(`
🎯 GitHub Heatmap Generator

Usage:
  node github-heatmap.js daily [commits]  - Make multiple commits today
  node github-heatmap.js schedule         - Schedule commits throughout the day
  node github-heatmap.js past-week        - Make commits for the past week
  node github-heatmap.js single           - Make a single commit
  node github-heatmap.js stats            - Show current stats

Examples:
  node github-heatmap.js daily 5          - Make 5 commits today
  node github-heatmap.js schedule         - Schedule commits at 9am, 12pm, 3pm, 6pm, 9pm
  node github-heatmap.js past-week        - Fill in the past week with commits
      `);
  }
}

module.exports = GitHubHeatmapGenerator;
