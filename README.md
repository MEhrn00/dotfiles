# Dots
Dotfiles and other scripts for Linux/Windows.

## local.yml
> [!WARNING]
> WIP

[Ansible Pull](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html) playbook.

### Usage
Uses tags for management. Playbook uses an opt-in approach. Nothing is added unless
explicitly stated. `install` tag is used for installing packages.

```bash
ansible-pull -U https://github.com/MEhrn00/dotfiles.git -t nvim
```

```bash
ansible-pull -U https://github.com/MEhrn00/dotfiles.git -t vim,tmux
```

```bash
ansible-pull -U https://github.com/MEhrn00/dotfiles.git -t install,clang-format -K
```
