# Set-up git with SSH
## Check the existing ssh key
### Lists the files in your .ssh directory, if they exist
  `ls -al ~/.ssh`
  `cd ~/.ssh`
## Generating a new SSH key
 `ssh-keygen -t ed25519 -C "your_email@example.com"`
 
## enter a file to save the key as demand and no passphrase
## Testing your SSH connection
 `ssh -T git@github.com`
 
 or `ssh -T git@gitlab.com`

## with multiple account
`
edit config 
`

`
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
 `
# Useful link
1. 多个账户配置ssh [here][1]
2.  [GitHub][2]
3.  [GitLab][3]

[1]: https://www.jianshu.com/p/756dc956f693
[2]: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh
[3]: https://docs.gitlab.com/ee/user/ssh.html

 
