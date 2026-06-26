#!/bin/bash

PROJECT_ROOT="/Users/bakkaiah/Developer/Co-Work/FSC-Knowedgebase"

cd "$PROJECT_ROOT" || {
  echo "❌ Project folder not found: $PROJECT_ROOT"
  exit 1
}

echo "🚀 Creating Salesforce Trainer Operating System markdown files..."

STANDARD_FILES=(
"00_README.md"
"01_Official_Resources.md"
"02_Learning_Path.md"
"03_Key_Concepts.md"
"04_Architecture_Patterns.md"
"05_Hands_On_Labs.md"
"06_Interview_Questions.md"
"07_Trainer_Notes.md"
"08_Common_Mistakes.md"
"09_Whats_New.md"
)

cat > "MASTER_INSTRUCTIONS.md" <<'MASTER'
# Salesforce Trainer Operating System - Master Instructions

## Mission

This knowledge base supports training for Salesforce Financial Services Cloud, Data Cloud, Agentforce, AI, and enterprise financial services use cases.

## Coaching Role

Act as:
- Salesforce CTA
- Financial Services Cloud Architect
- Data Cloud Consultant
- Agentforce Architect
- Enterprise Trainer
- Banking SME
- Wealth SME
- Insurance SME

## Standard Answer Format

Always answer with:

1. Business problem
2. Salesforce architecture
3. FSC objects
4. Data Cloud design
5. Agentforce design
6. Metadata configuration steps
7. Security and governance
8. Integration considerations
9. Hands-on lab
10. Beginner explanation
11. Intermediate explanation
12. Advanced explanation
13. Trainer tips
14. Interview questions
15. Daily challenge

## Rules

- Use official Salesforce sources first.
- Separate official Salesforce capability from suggested architecture.
- Do not invent Salesforce features.
- If information depends on latest release, verify against latest Salesforce Release Notes.
- Convert every topic into trainer-ready content.
- Prefer practical BFSI examples.
MASTER

for dir in */ ; do
  [ -d "$dir" ] || continue

  FOLDER_NAME="${dir%/}"

  for file in "${STANDARD_FILES[@]}"; do
    FILE_PATH="$dir$file"

    if [ ! -f "$FILE_PATH" ]; then
      cat > "$FILE_PATH" <<EOT
# ${file%.md}

## Folder

${FOLDER_NAME}

## Purpose

This file supports the Salesforce Trainer Operating System for ${FOLDER_NAME}.

## What to Capture

- Official Salesforce documentation
- Trailhead learning references
- Developer documentation
- Architecture patterns
- Real-world financial services examples
- Hands-on labs
- Trainer explanations
- Interview questions
- Common implementation mistakes

## Trainer Usage

Use this file to prepare training for 5+ years Salesforce professionals.

## Beginner Track

Explain the concept simply.

## Intermediate Track

Explain implementation and configuration.

## Advanced Track

Explain enterprise architecture, security, scale, and governance.

## Notes

Add curated content here.
EOT
      echo "✅ Created: $FILE_PATH"
    else
      echo "⏭️  Exists: $FILE_PATH"
    fi
  done
done

echo ""
echo "✅ Done. Markdown files created successfully."
echo ""
echo "Check output using:"
echo "find \"$PROJECT_ROOT\" -maxdepth 2 -name '*.md' | sort"
