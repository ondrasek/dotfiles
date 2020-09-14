# from: https://www.mahmoudashraf.dev/blog/my-terminal-became-more-rusty/
if [ "$(command -v bat)" ]; then
  unalias -m 'cat'
  alias cat='bat -pp --theme="Nord"'
fi
