#!/bin/bash

# Quick Publishing Test Script
# This script tests that all publishing tasks are available

echo "🔍 Checking available publishing tasks..."
echo ""

./gradlew tasks --group=publishing

echo ""
echo "✅ If you see 'publish', 'publishToMavenLocal', and 'publishReleasePublicationToGitHubPackagesRepository' tasks,"
echo "   then your publishing configuration is correct!"
echo ""
echo "📦 To publish locally for testing:"
echo "   ./gradlew publishToMavenLocal"
echo ""
echo "📤 To publish to GitHub Packages:"
echo "   1. Set environment variables:"
echo "      export GITHUB_ACTOR=NicoMederoReLearn"
echo "      export GITHUB_TOKEN=your_token_here"
echo "   2. Run: ./gradlew publish"

