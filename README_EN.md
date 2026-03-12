# 🎓 Agent Academy - AI Agent Training Hub

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-800+-green.svg)](skills/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> **Train • Cultivate • Share** - A shared knowledge base for training and cultivating AI Agents

## 📖 Overview

**Agent Academy** is an open-source AI Agent training knowledge base dedicated to providing structured skill systems and knowledge resources for AI assistants (such as OpenClaw, Claude, ChatGPT, etc.).

Just as humans need to learn various skills in school, AI Agents also need an "academy" to acquire knowledge and improve their capabilities. Agent Academy is precisely such a treasure trove of knowledge, containing 800+ curated skills across 12 domains including software development, product design, data analysis, AI/ML, and a complete MCP (Model Context Protocol) knowledge system.

### 🎯 Core Values

| Value | Description |
|-------|-------------|
| **Train** | Provide structured skills and knowledge for Agents to quickly learn domain-specific capabilities |
| **Cultivate** | Continuous knowledge updates and best practices to help Agents grow and evolve |
| **Share** | Open-source community collaboration, knowledge sharing, everyone contributes and benefits |

### 💡 Use Cases

- **Individual Developers**: Configure professional skills for your AI assistant to improve productivity
- **Team Collaboration**: Build a shared team knowledge base to maintain consistent AI capabilities
- **Enterprise Users**: Private deployment with customized training for enterprise-specific AI assistants
- **Open Source Community**: Contribute skills, share knowledge, build the AI ecosystem together

## ✨ Features

- 📦 **800+ Curated Skills** - Covering 12 domains including development, design, data analysis
- 📚 **MCP Knowledge System** - Complete Model Context Protocol documentation and best practices
- 🔄 **CI/CD Integration** - Automated statistics, validation, and publishing workflows
- 🚀 **Quick Start** - One-click installation, ready to use
- 🤝 **Community Driven** - Open-source collaboration, continuous updates

## 📦 Installation

### Method 1: Agent Auto-Install (Recommended)

Tell your AI Agent to install the skill library:

```
Please install the Agent Academy skill library for me:
1. Clone the repository: git clone https://gitee.com/hongmaple/agent-academy.git
2. Copy skills: Copy the agent-academy/skills/ directory to my skill directory
3. Configure: Update AGENTS.md or related configuration files
```

**One-click Install Script** (Agent can execute directly):

```bash
# Linux/macOS
curl -fsSL https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.sh | bash

# Windows (PowerShell)
Invoke-WebRequest -Uri "https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.ps1" -OutFile "install.ps1"; ./install.ps1
```

### Method 2: Manual Installation

```bash
# 1. Clone repository
git clone https://gitee.com/hongmaple/agent-academy.git

# 2. Copy skills to your AI assistant
cp -r agent-academy/skills/* ~/.agents/skills/

# 3. Or selectively install specific categories
cp -r agent-academy/skills/development ~/.agents/skills/
cp -r agent-academy/skills/ai-ml ~/.agents/skills/
```

### Method 3: Fork and Customize

```bash
# 1. Fork this repository to your account

# 2. Clone your forked repository
git clone https://gitee.com/[your-username]/agent-academy.git

# 3. Add upstream repository (keep synced)
git remote add upstream https://gitee.com/hongmaple/agent-academy.git

# 4. Customize your skill library
# Add, modify, delete skills...

# 5. Sync with upstream updates
git fetch upstream
git merge upstream/master
```

## 🚀 Quick Start

1. **Browse Skills**: Check [Skills Index](skills/README.md) for available skills
2. **Learn MCP**: Read [MCP Knowledge Base](knowledge/mcp/README.md) to master tool integration
3. **Configure**: Refer to [Usage Guide](docs/usage.md) to configure your AI assistant
4. **Contribute**: Check [Contributing Guide](CONTRIBUTING.md) to participate in community building

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Skills Index](skills/README.md) | Complete list of 800+ skills and categories |
| [MCP Quick Start](knowledge/mcp/mcp-quick-start.md) | Get started with MCP tools in 5 minutes |
| [MCP Best Practices](knowledge/mcp/mcp-best-practices.md) | MCP development and usage guide |
| [MCP Tools Configuration](knowledge/mcp/mcp-tools-configuration.md) | 20+ tools configuration manual |
| [Contributing Guide](CONTRIBUTING.md) | How to contribute to the project |

## 📂 Directory Structure

```
agent-academy/
├── skills/              # Skill Library (800+ skills)
│   ├── pm-product/      # Product & Project Management (5)
│   ├── development/     # Development & Programming (21)
│   ├── design/          # Design & UI (14)
│   ├── documentation/   # Documentation & Writing (5)
│   ├── data-analysis/   # Data Analysis (8)
│   ├── tool-development/# Tool Development (16)
│   ├── web-api/         # Web/API Development
│   ├── security-testing/# Security & Testing (3)
│   ├── ai-ml/           # AI/Machine Learning (21)
│   ├── frameworks/      # Frameworks & Libraries (4)
│   ├── integrations/    # Integrations (28)
│   └── others/          # Other Skills (29)
├── knowledge/           # Knowledge Base
│   ├── mcp/            # MCP Knowledge System (8 documents)
│   └── guides/         # Usage Guides
├── templates/          # Template Files
├── scripts/            # Automation Scripts
├── .github/            # CI/CD Configuration
└── docs/               # Documentation Site
```

## 🤝 Contributing

We welcome all forms of contribution! This is a **community-driven** knowledge base where everyone can participate.

### Contribution Methods

| Method | Description | Difficulty |
|--------|-------------|------------|
| 📝 **Submit New Skills** | Share your professional skills | ⭐⭐ |
| 📚 **Improve Documentation** | Enhance existing docs or translate | ⭐ |
| 🐛 **Report Bugs** | Help us find and fix issues | ⭐ |
| 💡 **Propose Ideas** | Share your thoughts and needs | ⭐ |
| 🔧 **Improve Code** | Optimize existing skills and scripts | ⭐⭐⭐ |

### 📤 Submit PR Process

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

#### Step 3: Add or Modify Skills

```bash
# Create skill directory
mkdir -p skills/[category]/[skill-name]

# Create skill file
touch skills/[category]/[skill-name]/SKILL.md
```

**Skill Template**:

```markdown
# Skill Name

> Version: 1.0.0
> Updated: YYYY-MM-DD
> Category: [Category Name]

## 📋 Overview
[Brief description]

## 🎯 Core Features
- Feature 1
- Feature 2

## 🚀 Usage
[Usage instructions]
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
2. Click **Pull Request** button
3. Fill in PR title and description
4. Submit PR and wait for review

### 🤖 Let Agent Help You Submit PR

Tell your AI Agent:

```
Please help me submit a new skill to Agent Academy:
1. Skill name: xxx
2. Skill category: development/ai-ml/integrations etc.
3. Skill functionality: xxx
4. Usage method: xxx

Follow the CONTRIBUTING.md process to help me create a PR
```

The Agent will automatically complete the entire process for you!

See [Contributing Guide](CONTRIBUTING.md) for more details.

## 📊 Statistics

| Metric | Count |
|--------|-------|
| Total Skills | 800+ |
| Categories | 12 |
| MCP Documents | 8 |
| CI/CD Workflows | 4 |
| Lines of Code | 430,000+ |

## 🏆 Related Projects

### 🍁 MapleClaw - Human-AI Collaboration Platform

> Seamless collaboration between AI and humans for intelligent workflows

**Project URL**: [https://gitee.com/hongmaple/mapleclaw](https://gitee.com/hongmaple/mapleclaw)

MapleClaw is an innovative human-AI collaboration solution that applies Agent Academy's skill system to real-world business scenarios, enabling:
- 🤖 Intelligent task allocation and execution
- 📊 Automated workflows
- 🔄 Human-AI collaborative decision making
- 📈 Continuous learning and optimization

---

## 👥 Authors

| Role | Information |
|------|-------------|
| **Organization** | MapleClaw Team |
| **Maintainers** | 小琳, 小猪, 小熊 |
| **Contact** | [Gitee Issues](https://gitee.com/hongmaple/agent-academy/issues) |

## 📄 License

[MIT License](LICENSE) - Free to use, modify, and distribute

---

<div align="center">

**⭐ If this project helps you, please give it a Star ⭐**

Made with ❤️ by [MapleClaw Team](https://gitee.com/hongmaple)

[🏠 Home](https://gitee.com/hongmaple/agent-academy) · [📖 Docs](docs/) · [🐛 Issues](https://gitee.com/hongmaple/agent-academy/issues) · [🤝 Contribute](CONTRIBUTING.md)

</div>
