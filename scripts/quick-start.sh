#!/bin/bash

echo "🎯 GitHub Heatmap Generator - Quick Start"
echo "========================================"

echo ""
echo "Setting up GitHub Heatmap Generator..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    echo "Download from: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js is installed"

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    echo "Download from: https://git-scm.com/"
    exit 1
fi

echo "✅ Git is installed"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

echo ""
echo "🚀 Ready to go! Here are your options:"
echo ""
echo "1. Make 3 commits today:     npm run daily"
echo "2. Make 5 commits today:     node github-heatmap.js daily 5"
echo "3. Schedule commits:         npm run schedule"
echo "4. Fill past week:          npm run past-week"
echo "5. Make single commit:      npm run single"
echo "6. Show stats:              npm run stats"
echo ""
echo "💡 Tip: Run 'npm run daily' every morning for best results!"
echo ""

read -p "Press Enter to continue..."
