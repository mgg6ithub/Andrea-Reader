#! /bin/zsh

mensaje_commit="${1:-script commit}"

git add .
echo "cambios agregados."

if git commit -m "$mensaje_commit" > /dev/null; then
	echo "cambios guardados.";
elif git commit -m "$mensaje_commit" | grep -q "nothing to commit, working tree clean"; then
	echo "cambios guardados.";
fi

git push origin main > /dev/null
echo "cambios subidos a remoto."
