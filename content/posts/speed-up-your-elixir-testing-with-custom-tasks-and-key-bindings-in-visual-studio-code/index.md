---
title: Speed Up Your Elixir Testing with Custom Tasks and Key Bindings in Visual Studio
  Code
date: '2024-02-28'
tags:
- tdd
- elixir
- testing
- vscode
slug: speed-up-your-elixir-testing-with-custom-tasks-and-key-bindings-in-visual-studio-code
aliases:
- "/2024/02/28/speed-up-your-elixir-testing-with-custom-tasks-and-key-bindings-in-visual-studio-code"
- "/speed-up-your-elixir-testing-with-custom-tasks-and-key-bindings-in-visual-studio-code"
---

Testing is an integral part of software development that ensures your code works as expected. However, running tests can sometimes be a slow and cumbersome process, especially when you're looking to quickly iterate on your code. I use a "secret" method that allows me to quickly run tests using custom tasks and key bindings in Visual Studio Code (VS Code). This approach is much faster and lighter than other solutions I've tried.

# Custom Tasks in VS Code

The first step in speeding up your test runs is to set up custom tasks in VS Code. These tasks can be configured to run specific test commands, such as "test current line" or "debug current line.". All you need to do is to create `.vscode/tasks.json` file in your project's root directory and add custom tasks. Here's what I have:

```json
{
  "version": "2.0.0",
  "options": {
    "shell": {
      "executable": "/bin/bash",
      "args": [
        "-l",
        "-c"
      ]
    },
    "cwd": "${fileWorkspaceFolder}"
  },
  "tasks": [
    {
      "label": "test all",
      "type": "shell",
      "command": "mix test",
      "problemMatcher": [],
      "group": "test",
      "presentation": {
        "focus": true
      }
    },
    {
      "label": "test current file",
      "type": "shell",
      "command": "mix test ${relativeFile}",
      "problemMatcher": [],
      "group": "test",
      "presentation": {
        "focus": true
      }
    },
    {
      "label": "test current line",
      "type": "shell",
      "command": "mix test ${relativeFile}:${lineNumber}",
      "presentation": {
        "focus": true
      }
    },
    {
      "label": "debug current line",
      "type": "shell",
      "command": "iex --dbg pry -S mix test --timeout 999999999 ${relativeFile}:${lineNumber}",
      "presentation": {
        "focus": true
      }
    }
  ]
}
```

# Key Bindings for Efficiency

Once you have your custom tasks set up, the next step is to bind them to specific keys for quick access. This can be done by editing the `keybindings.json` file in VS Code. To do this, open command palette and type "keyboard shortcuts" and select "Open Keyboard Shortcuts (JSON)" option. This will open up `keybindings.json` file. Then, you can add shortcuts to quickly run your custom tasks. Here's how I did that:

```json
{
    "key": "ctrl+t a",
    "command": "workbench.action.tasks.runTask",
    "args": "test all"
  },
  {
    "key": "ctrl+t f",
    "command": "workbench.action.tasks.runTask",
    "args": "test current file"
  },
  {
    "key": "ctrl+t l",
    "command": "workbench.action.tasks.runTask",
    "args": "test current line"
  },
  {
    "key": "ctrl+t d",
    "command": "workbench.action.tasks.runTask",
    "args": "debug current line"
  }
```

Now, with a simple keystroke, you can run all tests or tests in the current file or specific tests that can be found under the current line.

# Debugging with `dbg`

If you need to debug a specific line, simply insert a `dbg` breakpoint in your code. Then, use the `ctrl+t d` key binding to start an Elixir debug session for that line. I often use `debug current line` because it makes experimenting easy, allowing me to see what works and what doesn't. *It's more than just a debugging tool for me.*

This is how a debugging session may look like:

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1709108577181/1e82db91-8a60-4e9f-900e-52726149ea20.png align="center")

# Happy testing!

By creating custom tasks and key bindings in VS Code for your Elixir tests, you can greatly speed up your development process. This approach is quick, straightforward, and helps you stay focused on coding and improving your work. While there are many extensions offering similar features, I appreciate the simplicity and complete control that custom tasks provide. I also find it helpful to always have the test output visible in the terminal pane.

I recommend trying out this method! 🤓
