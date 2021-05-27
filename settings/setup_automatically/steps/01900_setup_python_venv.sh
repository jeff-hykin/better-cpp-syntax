export VIRTUAL_ENV="$PROJECTR_FOLDER/.venv"
export PATH="$VIRTUAL_ENV/bin:$PATH"
if ! [[ -d "$VIRTUAL_ENV" ]]
then
    echo "creating virtual env for python"
    python -m venv "$VIRTUAL_ENV" && echo "virtual env created"
fi