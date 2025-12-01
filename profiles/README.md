# Dotfiles Profiles

Profiles allow you to separate work-specific and personal configurations without cluttering your base dotfiles.

## Available Profiles

### work-sram
SRAM work environment with:
- Project-specific aliases (WannaGo, RockShox, Centauri, etc.)
- Work git identity (tarcuri@sram.com)
- SRAM-specific workflow helpers

### personal
Personal machine setup with:
- Personal git identity
- Add personal-specific aliases here

## Using Profiles

### During Setup
When running `./setup.sh`, you'll be prompted to select a profile:
1. none (default - for personal machines without work configs)
2. work-sram (SRAM work environment)
3. personal (explicit personal profile)

### Switching Profiles Manually
```bash
# Switch to work-sram profile
echo "work-sram" > ~/.dotfiles/.dotfiles-profile
ln -sf ~/.dotfiles/profiles/work-sram/.gitconfig.work-sram ~/.dotfiles/.gitconfig.active-profile
source ~/.zshrc  # or source ~/.bashrc

# Switch to no profile
echo "none" > ~/.dotfiles/.dotfiles-profile
source ~/.zshrc

# Switch to personal profile
echo "personal" > ~/.dotfiles/.dotfiles-profile
ln -sf ~/.dotfiles/profiles/personal/.gitconfig.personal ~/.dotfiles/.gitconfig.active-profile
source ~/.zshrc
```

### Creating a New Profile
1. Create a new directory: `mkdir ~/.dotfiles/profiles/my-profile`
2. Add shell configs:
   - `.zshrc.my-profile` - zsh-specific aliases/configs
   - `.bashrc.my-profile` - bash-specific aliases/configs
   - `.gitconfig.my-profile` - git user identity
3. Update `setup.sh` to include your new profile in the selection menu

## How Profiles Work
Profiles use a layered loading approach:
1. **Shared** configs load first (common aliases, environment variables)
2. **Platform** configs load second (macOS/Linux specific)
3. **Profile** configs load last (work/personal specific - overrides everything)

Git identity is managed through Git's conditional includes, so switching profiles automatically updates your git user.name and user.email.
