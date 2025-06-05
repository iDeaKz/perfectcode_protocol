#!/bin/bash
# PerfectCode Protocol v1.0 Installation Script
# Created by: iDeaKz

echo "🔥 Installing PerfectCode Protocol v1.0..."
echo "Created by: iDeaKz - The Master of Precision Engineering"
echo ""

# Check Node.js version
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required. Please install Node.js 18+ first."
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js 18+ required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js $(node -v) detected"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the project
echo "🔨 Building PerfectCode CLI..."
npm run build

# Make CLI executable
echo "⚡ Setting up CLI..."
chmod +x bin/cli.js

# Link globally (optional)
read -p "🌍 Install globally? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    npm link
    echo "✅ PerfectCode CLI installed globally!"
    echo "   Use: perfectcode --help"
else
    echo "✅ PerfectCode CLI ready!"
    echo "   Use: ./bin/cli.js --help"
fi

echo ""
echo "🎯 PerfectCode Protocol v1.0 Installation Complete!"
echo "Created by: iDeaKz"
echo ""
echo "📋 Quick Start:"
echo "  perfectcode init my-project"
echo "  cd my-project"
echo "  perfectcode generate --type microservice"
echo "  perfectcode deploy --target cloudflare"
echo ""
echo "🔥 Welcome to the future of precision engineering!"