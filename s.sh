#! /bin/zsh

git add .
if git commit -m "script commit" > /dev/null; then
	echo "cambios guardados";
elif git commit -m "script commit" | grep -q "nothing to commit, working tree clean"; then
	echo "cambios guardados";
fi

if git branch | grep -q "sec_copy"; then
	if git branch -d sec_copy > /dev/null; then
		echo "rama seguridad borrada"
	fi
fi

if git branch sec_copy > /dev/null; then
	echo "Rama 'sec_copy' creada";
else
	echo "No se ha podido crear una rama de seguridad";
	exit 0
fi

if git fetch origin > /dev/null; then
	if git reset --hard origin/main > /dev/null; then
		echo "remote -> local";

		if git reset --hard sec_copy > /dev/null; then
			echo "local -> remote";
			git push origin main --force > /dev/null 2>&1
		fi
	fi
fi
