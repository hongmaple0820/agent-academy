# Contributing Guide

Thank you for considering contributing to Agent Academy! This is a **community-driven** knowledge base where everyone can participate.

## 🤝 Contribution Philosophy

> **One person contributes, thousands benefit**

Agent Academy aims to build an open AI Agent training knowledge base. Whether you are:
- 🧑‍💻 **Developer** - Share your development skills and best practices
- 📝 **Writer** - Improve documentation, translate content
- 🤖 **AI User** - Contribute your experience in training Agents
- 🏢 **Enterprise Team** - Share enterprise-level solutions

Your every contribution helps more people.

## 🎯 Ways to Contribute

| Method | Description | Difficulty | Time |
|--------|-------------|------------|------|
| 📝 **Submit New Skills** | Share your professional skills | ⭐⭐ | 30 min |
| 📚 **Improve Documentation** | Enhance existing docs or translate | ⭐ | 10 min |
| 🐛 **Report Bugs** | Help us find and fix issues | ⭐ | 5 min |
| 💡 **Propose Ideas** | Share your thoughts and needs | ⭐ | 5 min |
| 🔧 **Improve Code** | Optimize existing skills and scripts | ⭐⭐⭐ | 1 hour |
| 🌍 **Translate Content** | Help with internationalization | ⭐⭐ | 30 min |

## 📤 Submit PR Process

### Method 1: Standard Process

#### Step 1: Fork Repository

1. Visit [Agent Academy](https://gitee.com/hongmaple/agent-academy)
2. Click the **Fork** button in the top right
3. Select your account as the target space

#### Step 2: Clone and Create Branch

```bash
# Clone your forked repository
git clone https://gitee.com/[your-username]/agent-academy.git
cd agent-academy

# Create feature branch
git checkout -b feature/your-skill-name
```

#### Step 3: Add or Modify Content

```bash
# Create skill directory
mkdir -p skills/[category]/[skill-name]

# Create skill file
touch skills/[category]/[skill-name]/SKILL.md
```

#### Step 4: Commit and Push

```bash
# Add files
git add .

# Commit (use standard format)
git commit -m "feat(skill): add [skill-name] skill"

# Push to your repository
git push origin feature/your-skill-name
```

#### Step 5: Create Pull Request

1. Visit your forked repository page
2. Click **+ Pull Request** button
3. Select:
   - Source branch: `[your-username]/agent-academy:feature/your-skill-name`
   - Target branch: `hongmaple/agent-academy:master`
4. Fill in PR title and description
5. Submit PR and wait for review

### Method 2: Let Agent Help You Submit PR

Tell your AI Agent (Claude, ChatGPT, Cursor, etc.):

```
Please help me submit a new skill to Agent Academy:

1. Skill name: [skill-name]
2. Skill category: [choose from 12 categories]
3. Skill functionality: [function description]
4. Usage method: [usage instructions]
5. My Gitee username: [your-username]

Follow these steps to help me create a PR:
1. Fork repository https://gitee.com/hongmaple/agent-academy
2. Create skill file skills/[category]/[skill-name]/SKILL.md
3. Commit and create Pull Request
```

The Agent will automatically complete the entire process for you!

## 📋 Skill Categories

| Category | Directory | Description | Examples |
|----------|-----------|-------------|----------|
| Product & Project Management | `pm-product/` | Product requirements, project management | Requirements analysis, Scrum |
| Development & Programming | `development/` | Software development, code review | Git workflow, Code review |
| Design & UI | `design/` | UI design, API design | Component design, Prototyping |
| Documentation & Writing | `documentation/` | Documentation, knowledge management | Markdown, Technical writing |
| Data Analysis | `data-analysis/` | Data analysis, visualization | Data reports, Statistical analysis |
| Tool Development | `tool-development/` | Skill creation, tool development | Skill templates, Debugging tools |
| Web/API | `web-api/` | Web development, API design | REST API, GraphQL |
| Security & Testing | `security-testing/` | Testing strategies, security validation | Unit testing, Penetration testing |
| AI/Machine Learning | `ai-ml/` | ML training, AI tools | Model training, Prompt engineering |
| Frameworks & Libraries | `frameworks/` | React, Vue and other frameworks | React Hooks, Vue components |
| Integrations | `integrations/` | Third-party service integrations | GitHub, Slack, Notion |
| Others | `others/` | Other skills | Workflow optimization, Team collaboration |

## 📝 Skill Template

When creating a new skill, please use the following template:

```markdown
# [Skill Name]

> Version: 1.0.0
> Updated: YYYY-MM-DD
> Category: [Category Name]
> Author: [Your Name] (Optional)

## 📋 Overview

[One-sentence description of this skill's purpose]

## 🎯 Core Features

- Feature 1: [Description]
- Feature 2: [Description]
- Feature 3: [Description]

## 🚀 Usage

### Installation

\`\`\`bash
# Installation commands (if any)
\`\`\`

### Basic Usage

\`\`\`bash
# Usage example
\`\`\`

### Advanced Usage

\`\`\`bash
# Advanced example
\`\`\`

## 📁 File Structure

\`\`\`
[skill-name]/
├── SKILL.md          # Skill documentation (required)
├── README.md         # Usage guide
├── scripts/          # Script files
│   └── example.sh
└── templates/        # Template files
    └── example.md
\`\`\`

## 💡 Best Practices

1. Best practice 1
2. Best practice 2

## ⚠️ Notes

- Note 1
- Note 2

## 🔗 Related Resources

- [Related link 1](URL)
- [Related link 2](URL)

## 🔄 Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | YYYY-MM-DD | Initial version |
```

## 📝 Code Standards

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | feat(skill): add git-workflow skill |
| `fix` | Bug fix | fix(script): resolve skill-stats bug |
| `docs` | Documentation update | docs(mcp): update quick-start guide |
| `style` | Code formatting | style(skill): format code |
| `refactor` | Refactoring | refactor(skill): improve structure |
| `test` | Testing | test(skill): add unit tests |
| `chore` | Build/tools | chore(ci): update workflow |

**Example**:
```
feat(skill): add git-workflow-management skill

- Add commit check script
- Add review checklist
- Add CI workflow configuration

Closes #123
```

### Code Style

- ✅ Add necessary comments
- ✅ Follow language conventions
- ✅ Keep code concise
- ✅ Use UTF-8 encoding
- ❌ No sensitive information

## 🔍 Review Process

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Submit PR  │ -> │ Auto Check  │ -> │ Code Review │
└─────────────┘    └─────────────┘    └─────────────┘
                         │                   │
                         v                   v
                   ┌─────────────┐    ┌─────────────┐
                   │Check Results│    │Review Comments│
                   └─────────────┘    └─────────────┘
                         │                   │
                         v                   v
                   ┌─────────────┐    ┌─────────────┐
                   │ Pass/Fail   │    │ Pass/Modify │
                   └─────────────┘    └─────────────┘
                                            │
                                            v
                                      ┌─────────────┐
                                      │ Merge Code  │
                                      └─────────────┘
```

### Automated Checks (CI/CD)

| Check Item | Requirement |
|------------|-------------|
| Commit Message | Follows Conventional Commits format |
| File Structure | Follows skill directory conventions |
| Documentation Complete | Contains SKILL.md with clear descriptions |
| No Sensitive Info | No keys, passwords, or private data |

### Code Review

- Code quality
- Documentation completeness
- Functionality correctness
- Best practices

## 🔄 Keep Synced

If you've already forked the repository and need to sync with the latest code:

```bash
# Add upstream repository (only once)
git remote add upstream https://gitee.com/hongmaple/agent-academy.git

# Sync latest code
git fetch upstream
git checkout master
git merge upstream/master

# Push to your repository
git push origin master
```

## 🐛 Report Bugs

Submit bug reports in [Issues](https://gitee.com/hongmaple/agent-academy/issues):

**Template**:
```markdown
## Bug Description
[Clear and concise description of the bug]

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
[Describe what you expected to happen]

## Actual Behavior
[Describe what actually happened]

## Environment
- OS: [e.g., Windows 11]
- Agent Type: [e.g., Claude / ChatGPT / Cursor]
- Version: [e.g., v1.0.0]

## Screenshots
[If applicable, add screenshots]
```

## 💡 Feature Requests

Submit feature requests in [Issues](https://gitee.com/hongmaple/agent-academy/issues):

**Template**:
```markdown
## Feature Description
[Clear and concise description of the feature]

## Use Case
[Describe what problem this feature solves]

## Proposed Solution
[Describe your suggested implementation]

## Alternatives
[Describe other solutions you've considered]

## Additional Info
[Other relevant information]
```

## 🏢 Related Projects

### 🍁 MapleClaw - Human-AI Collaboration Platform

> Seamless collaboration between AI and humans for intelligent workflows

**Project URL**: [https://gitee.com/hongmaple/mapleclaw](https://gitee.com/hongmaple/mapleclaw)

MapleClaw is an innovative human-AI collaboration solution that applies Agent Academy's skill system to real-world business scenarios.

## 📧 Contact

- **Issues**: https://gitee.com/hongmaple/agent-academy/issues
- **Pull Requests**: https://gitee.com/hongmaple/agent-academy/pulls
- **Homepage**: https://gitee.com/hongmaple/agent-academy

## 🙏 Acknowledgments

Thanks to all contributors!

---

<div align="center">

**Contribute to grow, share to gain**

Made with ❤️ by [MapleClaw Team](https://gitee.com/hongmaple)

</div>
