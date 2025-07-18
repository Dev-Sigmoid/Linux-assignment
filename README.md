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



# 4. Auto-Uncompress `research` File Script

This script automatically **searches**, **detects**, and **uncompresses** a file named `research` located anywhere in the Linux filesystem — based on its compression type.

---

## What It Does

- Searches the entire filesystem for a file named `research` with any of the following extensions:
  - `.gz`
  - `.zip`
  - `.xz`
  - `.bz2`
- Automatically detects the compression type
- Decompresses it using the appropriate tool

---

## Supported Compression Types

| Extension | Tool       |
|-----------|------------|
| `.gz`     | `gunzip`   |
| `.zip`    | `unzip`    |
| `.xz`     | `unxz`     |
| `.bz2`    | `bunzip2`  |

---

## Prerequisites

Make sure the required tools are installed:

```bash
sudo apt install gzip unzip xz-utils bzip2 -y
```

## How to Use
   ### 1. Save the script as find_and_uncompress.sh
   ### 2. Make it executable:
   ```bash
   chmod +x find_and_uncompress.sh
   ```
   ### 3. Run the script:
   ```bash
   ./find_and_uncompress.sh
   ```
   ## If a compressed research file is found, it will be automatically uncompressed in its current directory.

# 5. Restrict File Permissions on Creation (Without Using `chmod`)

## Objective

Configure the system so that **any file created by any user** has **no permissions** — meaning the owner (and everyone else) **cannot read, write, or execute** the file.

This is done **without using the `chmod` command**.

---

## How It Works

- This is achieved by setting a **restrictive `umask` value** system-wide.

The `umask` controls the default permissions for newly created files.  
Setting it to `0777` removes all permissions by default.

---

## Where to Configure `umask 0777`

To apply this setting **system-wide** for all users:

### 1. Edit the `/etc/profile` file:

```bash
sudo vim /etc/profile
```

- Scroll to the bottom of the file and add:
```bash
umask 0777
```
-This ensures that every user gets 0000 permissions when they create a new file.

### 2. Save and exit:
- If using Nano: Press `Ctrl + O`, `Enter`, then `Ctrl + X`

### 3. Apply the change immediately:
```bash
source /etc/profile
```

## Expected Behavior
```bash
touch testfile
ls -l testfile
```

```bash
---------- 1 user user 0 Jul 16 15:40 testfile
```

# 5. Showtime Service (Cron-Based)

This setup configures a background job that **logs the current system time every minute** to a file named `showtime.log` in the user's home directory. It is implemented using a simple shell script and scheduled via `cron`.

---

## Directory Structure

Assuming your working directory is:

```bash
~/assignment1/showtime-service
```

Inside this folder, you will have:

```bash
showtime.sh        # The script that logs time
```

---

## Script Content

Create the file `showtime.sh` with the following content:

```bash
#!/bin/bash
/usr/bin/date >> /home/$USER/showtime.log
```

> This appends the current date and time to `~/showtime.log`

---

## Make Script Executable

```bash
chmod +x ~/assignment1/showtime-service/showtime.sh
```

---

## Schedule with Cron

Edit your crontab:

```bash
crontab -e
```

Add the following line to run the script every minute:

```cron
* * * * * /home/lenovo/assignment1/showtime-service/showtime.sh
```

> Replace `lenovo` with your actual username if it's different.

---

## Verify It's Working

1. Wait a minute or two.
2. Check if the file was created and contains timestamps:

```bash
cat ~/showtime.log
```

---

## To Stop Logging

Remove or comment out the cron job:

```bash
crontab -e
```

Then delete or comment the line running the script.

---

## Notes

* This approach does **not** require `systemd` service creation.
* It uses `cron`, which is more portable and sufficient for user-level background tasks.
* Ensure `cron` service is running: `sudo service cron status`

---

**Done!** You now have a working, minute-based logger using cron.
