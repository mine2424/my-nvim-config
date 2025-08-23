# /kiro Command Implementation Guide

## Core Implementation

When the user invokes `/kiro [feature]`, Claude should:

1. **Initialize Spec-Driven Development Mode**
   - Acknowledge the command with Kiro methodology
   - Parse the feature requirements (even if minimal)
   - Set up the 3-phase workflow

2. **Execute Phase 1: Requirements Discovery**
   ```
   - Expand minimal input into detailed user stories
   - Apply EARS notation for structured requirements
   - Auto-complete security requirements and edge cases
   - Engage in dialogue to refine requirements
   - Ask for approval: "Requirements Phase が完了しました。次に進んでよろしいですか？"
   - On "次に進んで" → Generate requirements.md
   ```

3. **Execute Phase 2: Design Exploration**
   ```
   - Analyze existing codebase patterns
   - Propose optimal architecture
   - Generate Mermaid diagrams
   - Create TypeScript interfaces
   - Discuss technical choices
   - Ask for approval: "Design Phase が完了しました。次に進んでよろしいですか？"
   - On "次に進んで" → Generate design.md
   ```

4. **Execute Phase 3: Implementation Planning**
   ```
   - Apply best practices automatically
   - Set quality checkpoints
   - Analyze dependencies and risks
   - Optimize implementation sequence
   - Discuss priorities and risks
   - Ask for approval: "Implementation Phase が完了しました。次に進んでよろしいですか？"
   - On "次に進んで" → Generate tasks.md
   ```

## Response Template

```markdown
# Spec-Driven Development: [Feature Name]

Kiro の spec-driven development を開始します。最小限の要件から詳細な仕様を段階的に構築していきます。

## Phase 1: Requirements Discovery

### 入力された要件
[User's minimal requirements]

### 自動拡張されたユーザーストーリー
[Expanded user stories]

### EARS 記法による要件定義
[EARS notation requirements]

### セキュリティ要件（自動補完）
[Security requirements]

### エッジケース（自動検出）
[Edge cases]

[Interactive discussion points]

Requirements Phase が完了しました。次に進んでよろしいですか？
```

## Key Behaviors

1. **Auto-Expansion**: Always expand minimal input into comprehensive requirements
2. **EARS Notation**: Use standardized requirement syntax
3. **Security-First**: Auto-include OWASP Top 10 and security best practices
4. **Interactive**: Engage in dialogue at each phase
5. **Quality Gates**: Require approval before generating files
6. **Best Practices**: Auto-apply industry standards

## File Generation

### requirements.md Structure
```markdown
# Requirements Specification: [Feature]

## User Stories
[Detailed user stories]

## EARS Requirements
[Structured requirements using EARS notation]

## Acceptance Criteria
[Clear, testable criteria]

## Security Requirements
[OWASP-compliant security specs]

## Edge Cases
[Comprehensive edge case handling]
```

### design.md Structure
```markdown
# Design Specification: [Feature]

## Architecture Overview
[System architecture description]

## Diagrams
```mermaid
[Architecture/flow diagrams]
```

## Interfaces
```typescript
[TypeScript interfaces]
```

## Technology Stack
[Selected technologies and rationale]

## Design Patterns
[Applied patterns and principles]
```

### tasks.md Structure
```markdown
# Implementation Plan: [Feature]

## Phase 1: Foundation
- [ ] Task 1
- [ ] Task 2

## Phase 2: Core Implementation
- [ ] Task 3
- [ ] Task 4

## Phase 3: Enhancement
- [ ] Task 5
- [ ] Task 6

## Quality Checkpoints
- [ ] Security scan
- [ ] Performance test
- [ ] Accessibility audit

## Risk Mitigation
[Identified risks and mitigation strategies]
```

## Error Handling

- If requirements are too vague: Ask clarifying questions
- If technical conflicts exist: Present options with trade-offs
- If security concerns arise: Highlight and propose solutions
- If scope is too large: Suggest breaking into smaller specs