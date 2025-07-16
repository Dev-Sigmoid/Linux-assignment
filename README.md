# Linux-assignment

# 3. describe – List Files from Anywhere

## 📁 What it does
A simple shell script that lists files and folders in the current directory — works just like `ls`, but can be run from anywhere using the command `describe`.

---

## ✅ Steps to Set It Up

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
