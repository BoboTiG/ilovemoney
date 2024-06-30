# Tambouille

Le script [`tambouille.sh`](tambouille.sh) sert à renommer le projet en "I love money", et à supprimer quelques fichiers.

Dans l'idée, à chaque nouvelle version de `ihatemoney`, ce dépôt est mis à jour, puis modifié via le script nommé ci-avant.

Voici les étapes à suivre :

```shell
# Ménage
git reset HEAD^ && rm -rf ilovemoney && git reset --hard

# Mise à jour
# git remote add upstream https://github.com/spiral-project/ihatemoney.git
git fetch upstream master && git rebase upstream/master

# Modifications
bash tambouille.sh && git add .gitignore && git add -A && git commit -m 'feat: I Love Money!'
```
