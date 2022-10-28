
# Lists the files in your .ssh directory, if they exist
  ls -al ~/.ssh
# Generating a new SSH key
 ssh-keygen -t ed25519 -C "your_email@example.com"
 
 #enter a file to save the key
 
 no passphrase
 
 #Testing your SSH connection
 Command: $ ssh -T git@github.com
# Attempts to ssh to GitHub

# with multiple account

https://www.jianshu.com/p/756dc956f693

cd ~/.ssh

edit config 

# Personal GitHub account
Host github.com
 Hostname ssh.github.com
 Port 443
 IdentityFile ~/.ssh/id_ed25519

# Work GitLab account
Host gitlab.com
 HostName git.tu-berlin.de
 PreferredAuthentications publickey
 IdentityFile ~/.ssh/tu-berlin_rsa

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh
https://docs.gitlab.com/ee/user/ssh.html

 
