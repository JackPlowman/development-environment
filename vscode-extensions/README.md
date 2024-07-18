# VSCode Extensions

## How to get installed extensions

`code --list-extensions >> vscode-extensions/extensions.txt`

## How to install extensions from list

`cat vscode-extensions/extensions.txt | xargs -L 1 echo code --install-extension`
