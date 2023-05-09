#!/bin/sh

# debug mode
set -x

echo 'install basic packaging and soime cleaning'

sudo apt update
sudo apt install terminator vim curl wget unzip bzip2 gzip p7zip-full p7zip-rar geany gthumb gimp git gitk make pdftk xournal ca-certificates gnupg
echo 'No mail in local...'
suo apt remove thunderbird
echo 'You should also install also `tlp` for laptop'

echo 'installing docker...'
# https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# update docker groups
sudo usermod -aG docker $USER
#make it available now
newgrp docker
sudo docker run hello-world
docker run hello-world

echo 'configure some bashrc stuff'

cp -v home/.* ~/

cat << EOF >> ~/.bashrc

# PATH=$PATH:$HOME/bin

alias npm='docker run -it --user $(id -u) --rm -v $(pwd):/toto -w /toto node:16 npm'
#alias npm='docker run -it --user $(id -u) --rm -v $(pwd):/toto -w /toto -p 9229:9229 node:16 npm'
alias npx='docker run -it --user $(id -u) --rm -v $(pwd):/toto -w /toto node:16 npx'
alias node='docker run -it --user $(id -u) --rm -v $(pwd):/toto -w /toto node:16 node'

EOF

sed -zi 's/# If this is an xterm set the title to user@host:dir/\n. ~\/.gitbashprompt\nunset color_prompt force_color_prompt\n# #If this is an xterm set the title to user@host:dir\n/' ~/.bashrc

echo 'generate some keys ...'
# ssh git and shell
ssh-keygen -t ed25519 -C "<pro email>" -f .ssh/pro_s-id_ed25519
ssh-keygen -t ed25519 -C "<pro email>" -f .ssh/pro_git-id_ed25519
ssh-keygen -t ed25519 -C "<perso email>" -f .ssh/perso_git-id_ed25519

# gpg one
# https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
# https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
# https://www.redhat.com/sysadmin/creating-gpg-keypairs
gpg --list-keys
gpg --full-generate-key
echo 'Export (public) your key with : `gpg --armor --export XXX`'
 
