# 🤝 Agent Academy — AI Agent Training Knowledge Base

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-800+-green.svg)](skills/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> **Give your AI assistant a "lifetime learning card"**  
> 800+ curated skills · 4-layer memory system · Multi-agent collaboration · MCP toolkit · Ready to use

[中文](README.md) | English

---

## ✨ Why Agent Academy?

AI assistants are smart, but they need **professional training** to truly deliver value.

Think of a brilliant fresh graduate — high IQ, but without domain-specific training, they struggle to immediately contribute to professional work.

**Agent Academy solves exactly this** — providing systematic knowledge, skills, and standards so your AI assistant can actually get things done.

---

## 🚀 Quick Start

### Option 1: One-Click Install (Recommended)

```bash
# Linux / macOS
curl -fsSL https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.sh | bash

# Windows (PowerShell)
Invoke-WebRequest -Uri "https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

### Option 2: Manual Install

```bash
# Clone the repository
git clone https://github.com/hongmaple0820/agent-academy.git

# Copy skills to your AI agent directory
cp -r agent-academy/skills/* ~/.agents/skills/

# Copy workspace configuration template (optional but recommended)
cp agent-academy/templates/AGENTS.md ~/your-workspace/AGENTS.md
```

### Activate Your Agent

Tell your AI assistant:
```
I've installed Agent Academy at ~/.agents/
Please load the skill library and confirm available professional skills.
```

---

## 📦 What's Inside?

### 🎯 800+ Curated Skills

Covering 12 professional domains, each skill with full documentation and examples:

| Domain | Count | Example Skills |
|--------|-------|---------------|
| Development & Programming | 21+ | Git workflow, code review, CI/CD |
| AI / Machine Learning | 21+ | Model training, prompt engineering |
| Integrations | 28+ | GitHub, Slack, Notion, Figma |
| Design | 14+ | UI standards, API design, prototyping |
| Data Analysis | 8+ | Visualization, reports, data cleaning |
| Documentation | 4+ | PDF / Word / PPT / Excel |
| Product Management | 5+ | PRD writing, requirements analysis |
| Tool Development | 16+ | Skill creation, script automation |
| Web / API | 12+ | Interface design, frontend standards |
| Security Testing | 10+ | Vulnerability scanning, test strategy |
| Frameworks & Libraries | 15+ | React, Vue, Node.js best practices |
| Other Specialties | 20+ | More professional scenarios |

### 🧠 4-Layer Memory System

| Layer | Content | Effect |
|-------|---------|--------|
| Context Memory | Current conversation | Instant response |
| Session Memory | Single work session | Coherent conversation |
| Working Memory | Project specs / tech stack | Understands your project |
| Long-term Memory | Experience / preferences | Gets smarter over time |

**QMD Local Semantic Search**: 90% reduction in token usage, 93% search accuracy

### 👥 Multi-Agent Collaboration

5 collaboration modes, 3-8x efficiency boost:

| Mode | Best For | Speedup |
|------|----------|---------|
| Parallel | Batch processing | 5x |
| Serial | Dependent workflows | 3x |
| Master-Slave | Project management | 4x |
| Expert | Role-based tasks | 6x |
| Hybrid | Complex projects | 8x |

### 📡 Complete MCP Knowledge Base

| Document | Content |
|----------|---------|
| [Quick Start](knowledge/mcp/) | Get started with MCP in 5 minutes |
| [Tool Configuration](knowledge/mcp/) | Detailed config for 20+ tools |
| [Best Practices](knowledge/mcp/) | Lessons learned and architecture tips |
| [Real-World Cases](knowledge/mcp/) | 11 practical usage examples |

### 🌐 Browser Automation

- **Puppeteer** — Node.js browser control
- **Playwright** — Cross-browser support (Chrome / Firefox / Safari)
- Automated testing, web scraping, screenshots, form filling

---

## 📁 Repository Structure

```
agent-academy/
├── README.md                    # Project introduction (中文)
├── README_EN.md                 # This file (English)
├── LICENSE                      # MIT License
│
├── skills/                      # 🎯 800+ Skills
│   ├── README.md                # Skill index & navigation
│   ├── development/             # Development & programming
│   ├── ai-ml/                   # AI & machine learning
│   ├── integrations/            # Integration services
│   ├── design/                  # Design
│   ├── data-analysis/           # Data analysis
│   ├── documentation/           # Documentation
│   ├── pm-product/              # Product management
│   ├── tool-development/        # Tool development
│   ├── web-api/                 # Web / API
│   ├── security-testing/        # Security & testing
│   ├── frameworks/              # Frameworks & libraries
│   ├── others/                  # Other specialties
│   ├── daily-review/            # ⭐ Daily review (core skill)
│   ├── programming-workflow/    # ⭐ Programming workflow (core skill)
│   ├── project-standards/       # ⭐ Project standards guide (core skill)
│   └── pm-skills/               # ⭐ PM skill pack (65 skills, self-contained)
│
├── knowledge/                   # 📚 Knowledge Base
│   ├── INDEX.md                 # Knowledge base navigation
│   ├── mcp/                     # MCP knowledge (8 core docs)
│   ├── guides/                  # Usage guides
│   └── workflow/                # Workflow documentation
│
├── templates/                   # 📋 Templates
│   ├── AGENTS.md                # Workspace configuration template
│   ├── SOUL.md                  # AI identity definition template
│   └── MEMORY.md                # Long-term memory template
│
├── scripts/                     # 🔧 Automation Scripts
│   ├── install.sh               # One-click install (Linux/macOS)
│   ├── install.ps1              # One-click install (Windows)
│   └── skill-stats.py           # Skill statistics tool
│
└── docs/                        # 📖 Documentation
    └── articles/                # Blog posts & articles
```

---

## 📖 Essential Reading

| Document | Description | Priority |
|----------|-------------|----------|
| [Knowledge Base Index](knowledge/INDEX.md) | Core navigation for the knowledge base | ⭐⭐⭐⭐⭐ |
| [MCP Quick Start](knowledge/mcp/) | Get started with MCP protocol | ⭐⭐⭐⭐⭐ |
| [Contributing Guide](CONTRIBUTING.md) | How to contribute to the community | ⭐⭐⭐⭐ |
| [中文说明](README.md) | Chinese documentation | ⭐⭐⭐ |

---

## 🤝 Contributing

Agent Academy is a community-driven project — everyone is welcome!

### Ways to Contribute

| Method | Difficulty | Description |
|--------|------------|-------------|
| 📝 Submit a skill | ⭐⭐ | Fork → Create skill directory → Submit PR |
| 📚 Improve docs | ⭐ | Fix errors, add examples, translate |
| 🐛 Report issues | ⭐ | Describe problems in Issues |
| 💡 Suggest features | ⭐ | Share ideas and requirements |

### Skill Submission Format

```
skills/[category]/[skill-name]/
├── SKILL.md      # Skill description (required)
├── README.md     # Usage guide (recommended)
├── scripts/      # Script files (optional)
└── templates/    # Template files (optional)
```

See [Contributing Guide](CONTRIBUTING.md) for details.

---

## 📊 Current Status

| Metric | Value |
|--------|-------|
| Total Skills | **800+** |
| Domains Covered | **12** |
| Knowledge Documents | **70+** |
| Lines of Code | **430,000+** |

---

## 🌐 Repositories

| Platform | URL |
|----------|-----|
| **Gitee** (China) | https://gitee.com/hongmaple/agent-academy |
| **GitHub** | https://github.com/hongmaple0820/agent-academy |
| **GitCode** | https://gitcode.com/maple168/agent-academy |

---

## 🔗 Related Projects

**🍁 MapleClaw · Human-AI Collaboration Platform**  
A real-world multi-AI collaboration system. Agent Academy was born from lessons learned building this.  
URL: https://gitee.com/hongmaple/mapleclaw

---

## 📄 License

[MIT License](LICENSE) — Free to use, modify, and distribute.

---

<div align="center">

**If this project helps you, please give it a Star ⭐**

It's the best encouragement for open source.

Made with ❤️ by [MapleClaw Team](https://gitee.com/hongmaple)

</div>
