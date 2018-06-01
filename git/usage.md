# install
```
sudo apt-get update 
sudo apt-get install git

git config --global user.name "your_ame"  
git config --global user.email "youremail@domain.com"

ssh-keygen -C 'youremail@domain.com' -t rsa
```

Continuous press enter and no password set
```
cd  ~/.ssh/
more id_rsa.pub
```

paste it on Settings-ssh and GPG keys-new SSH key-ok
```
vi ~/.gitconfig
```

after added the following contents , the next time you enter your username and password  ,

git can remember that and you won't have to enter later
```
[credential]
    helper = store
```

# change password
```
cd ~/.ssh/
ssh-keygen -f id_rsa -p
cd ~/Document/dockerfiles
```

# start a repository
```
git init
touch Readme
git add Readme
git commit -m 'add readme file'
connect local repository with github repository：
git remote add origin https://github.com/your_github_name/your_github_repository_name.git
git push origin master
```

# clone a repository
```
git clone https://github.com/your_github_name/your_github_repository_name.git
git add Readme_new
git commit -m 'add new readme file'
git commit -a
git push origin master
```

# while made change at github_web
```
git pull origin master
```

# after mkdir
remember that the new dir should'not be emply to add to git
```
mkdir linux
cd linux
touch readme
cd ..
git add linux
git commit -m 'add linux'
git push origin master
```
