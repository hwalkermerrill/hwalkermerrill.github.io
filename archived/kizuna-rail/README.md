# Kizuna Rail (絆鉄道)

A brownfield web development training project designed to build real-world software engineering expertise through reverse engineering, refactoring, and debugging existing codebases.

## What is this?

Kizuna Rail is a fictional scenic railway booking website for tourists in Japan. While the company isn't real, the development challenges are. This project simulates a real brownfield codebase—existing code written by someone else that needs improvement, bug fixes, and new features.

## Purpose

This repository exists to develop essential software engineering skills that separate competent developers from true experts:

- **Reverse engineering** unfamiliar codebases to understand architecture and data flow
- **Refactoring** poorly structured code while maintaining functionality
- **Debugging** complex issues across multiple layers of the application
- **Code archaeology** through reading, tracing, and comprehending someone else's implementation decisions
- **Technical decision-making** about when to refactor vs. rewrite vs. extend existing patterns
- **Self-directed problem solving** without step-by-step tutorials

These skills define professional software engineering. Most developers spend 80% of their time working with existing code, not building greenfield projects.

## Who is this for?

- **Students**: This project was created for university-level software development courses, but anyone learning web development is welcome to use it
- **Self-learners**: Found this repo on your own? Great! Work through the scenarios at your own pace
- **Educators**: Feel free to incorporate these scenarios into your curriculum

## Why Brownfield Development?

Real-world software development means inheriting legacy systems with technical debt, inconsistent patterns, undocumented decisions, and code written by developers with varying skill levels. Learning to effectively reverse engineer these systems, refactor problematic areas, and extend functionality without introducing regressions is what distinguishes senior developers from junior ones.

Greenfield tutorials teach you syntax. Brownfield projects teach you engineering.

## Important Notes

**This codebase contains intentional technical debt.** You'll find suboptimal architecture, missing error handling, inconsistent patterns, and code that needs refactoring—all by design. These are learning opportunities, not mistakes.

**Do not submit PRs to fix code issues.** The technical debt, bugs, and architectural issues are intentional teaching moments for developers working through the scenarios.

**However**, if you find:
- Actual errors that break the learning experience
- Typos in documentation or scenario descriptions
- Ideas for new scenarios or challenges

Please open an issue or submit a PR! Contributions to improve the educational value are welcome.

## Getting Started

### For Students and Self-Learners

This repository is set up as a **GitHub template**. Use the template feature to create your own independent copy where you can complete the challenges.

1. Click the **Use this template** button at the top of this repository
2. Select **Create a new repository**
3. Give your repository a name (`kizuna-rail`) and create it under your GitHub account
4. Clone your new repository to your local machine:
   ```bash
   git clone https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
   cd YOUR-REPO-NAME
   ```
5. Install dependencies: `pnpm install`
6. Start the development server: `pnpm run dev`
7. Visit `/scenarios` to see available development challenges

Each scenario simulates realistic work situations requiring reverse engineering, refactoring, debugging, or feature extension.

### For Contributors

If you want to contribute improvements to the challenge scenarios, documentation, or educational content itself:

1. **Fork** this repository (not "Use this template")
2. Create a feature branch for your changes
3. Submit a pull request with your improvements

Forking maintains the connection to the original repository and allows you to contribute back. Using the template creates an independent copy for your own work.

## Technology Stack

- **Backend**: Node.js with Express framework
- **Templating**: EJS
- **Styling**: Modern nested CSS with custom properties
- **Database**: JSON-based data store, pretending to be a relational database

## Skills You'll Develop

- Code comprehension and reverse engineering
- Refactoring techniques and code smell identification
- Debugging across the full stack
- Working with unfamiliar frameworks and patterns
- Making architectural decisions in existing systems
- Reading and understanding someone else's code
- Git workflow in team environments

## License

This is an educational project—feel free to use it for learning and teaching. The project is released under the MIT License; see `LICENSE.txt` for the full text.