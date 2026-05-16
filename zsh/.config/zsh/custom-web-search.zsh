
function web_search() {
  emulate -L zsh

  # define search engine URLS
  typeset -A urls
  urls=(
    $ZSH_WEB_SEARCH_ENGINES
    google          "https://www.google.com/search?q="
    github          "https://github.com/search?q="
    stackoverflow   "https://stackoverflow.com/search?q="
    youtube         "https://www.youtube.com/results?search_query="
    dockerhub       "https://hub.docker.com/search?q="
    gems            "https://rubygems.org/search?query="
    npmpkg          "https://www.npmjs.com/search?q="
    chatgpt         "https://chatgpt.com/?q="
    claudeai        "https://claude.ai/new?q="
    reddit          "https://www.reddit.com/search/?q="
  )

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Dostępne wyszukiwarki:"
  for key in ${(k)urls}; do
    echo "  $key"
  done
  return 0
fi

  # search or go to main page depending on number of arguments passed
  if [[ $# -gt 1 ]]; then
    # if search goes in the query string ==> space as +, otherwise %20
    # see https://stackoverflow.com/questions/1634271/url-encoding-the-space-character-or-20
    local param="-P"
    [[ "$urls[$1]" == *\?*= ]] && param=""

    # build search url:
    # join arguments passed with '+', then append to search engine URL
    url="${urls[$1]}$(omz_urlencode $param ${(s: :)@[2,-1]})"
  else
    # build main page url:
    # split by '/', then rejoin protocol (1) and domain (2) parts with '//'
    url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
  fi

  open_command "$url"
}


alias google='web_search google'
alias github='web_search github'
alias stackoverflow='web_search stackoverflow'
alias youtube='web_search youtube'
alias dockerhub='web_search dockerhub'
alias gems='web_search gems'
alias npmpkg='web_search npmpkg'
alias chatgpt='web_search chatgpt'
alias claudeai='web_search claudeai'
alias reddit='web_search reddit'



