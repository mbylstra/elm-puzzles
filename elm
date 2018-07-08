docker run -it --rm -v "$(pwd):/code" -w "/code" -e "HOME=/tmp" mbylstra/elm "$@"
