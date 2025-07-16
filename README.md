# Linux-assignment

# 1. Send Local Email from Terminal (Interactive Script)

This script allows you to send a simple plain-text email to a **local Linux user** using the `mail` command.

---

##  Explanation of Script Components

#### `read -p "Enter subject: " subject`
- Prompts the user to enter the **email subject**.

#### `echo "Enter body (end with Ctrl+D):"`  
`body=$(</dev/stdin)`
- Asks the user to input the **email body**.
- Accepts multi-line input until you press `Ctrl + D` (end-of-file).
- Stores the entire input into the `body` variable.

#### `read -p "Enter local username to send mail to: " recipient`
- Prompts for the **recipient's username** (must be a local system user).

#### `if ! id "$recipient" &>/dev/null; then ...`
- Validates that the entered user exists on the system.
- If not, it shows an error and exits.

#### `echo "$body" | mail -s "$subject" "$recipient"`
- Sends the actual mail using `mailutils` and local SMTP (Postfix).
- Subject and body are passed to the `mail` command.

#### `echo "Mail sent to $recipient."`
- Confirms the mail was sent.

---

## Prerequisites

Before using the script, make sure:

1. **Postfix is installed and configured for** **Local delivery only**:
   ```bash
   sudo apt install postfix mailutils
   ```
   
2. **You have at least one local user to send mail to (e.g., testuser).**

## 🧪 How to Test
  ### 1. Run the script:
   ```bash
   ./send_local_mail.sh
   ```
  ### 2. Enter inputs when prompted:
  -  Subject
  -  Body (press Ctrl + D when done)
  -  Body (press Ctrl + D when done)

  ### 3. Switch to the recipient user and check their mail:
   ```bash
   sudo cat /var/mail/testuser
   ```


# 2. Create a User Without `sudo` Access

This script helps you create a Linux user who **cannot run `sudo` commands**.

---

### Explanation of Key Parts

#### `read -p "Enter the new username..." username`
- Prompts the user to enter a username.
- `-p` displays the prompt inline.

#### `--disabled-password`
- Prevents login via password initially.
- You set the password later with `passwd`.

#### `--gecos ""`
- Skips additional prompts (like full name, phone, etc.).
- GECOS is just user metadata, and we leave it empty for automation.

#### `sudo passwd "$username"`
- Sets a password for the new user so they can log in.

#### `sudo deluser "$username" sudo`
- Ensures the user **is not part of the `sudo` group**.
- Even if the user was added accidentally, this will remove them from it.
- The `2>/dev/null || ...` part just hides the error if the user wasn't in the group already.

#### `id "$username"`
- Displays user ID and group memberships.
- Useful for confirming that `sudo` is **not** in the list.

---

### 🧪 How to Test

1. **Run the script**:

   ```bash
   ./no_sudo_user.sh
   ```

2. **Enter a username when prompted (e.g., testuser).**

3. **Switch to the new user**
   ```bash
   su - testuser
   ```
4. **Try to use sudo**
   ```bash
   su ls
   ```
   #### After Entering Password You should see:
   ```bash
   testuser is not in the sudoers file. This incident will be reported.
   ```


# 3. describe – List Files from Anywhere

##  What it does
A simple shell script that lists files and folders in the current directory — works just like `ls`, but can be run from anywhere using the command `describe`.

---

##  Steps to Set It Up

### 1. Create the script

Create a file named `describe` with the following content:

```bash
#!/bin/bash
ls
```

### 2. Make it executable
```bash
chmod +x describe
```

### 3. Move it to a directory (e.g., ~/assignment1/bin)
```bash
mkdir -p ~/assignment1/bin
mv describe ~/assignment1/bin/
```

### 4. Add that directory to your PATH
#### Edit ~/.bashrc and add the of your bin path at the bottom:
```bash
export PATH="$HOME/assignment1/bin:$PATH"
```
#### Then reload your shell config:
```bash
source ~/.bashrc
```

### 5. Use it from anywhere
```bash
describe
```
#### DONE. It will list all files and folders in your current working directory.
