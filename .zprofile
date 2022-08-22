CPU=$(uname -p)

echo 
if [[ -f ~/.zprofile ]]; then
  echo "ERROR: ~/.zprofile already exists. 
if [[ "$CPU" == "arm" ]]; then
  if [[ -f /opt/homebrew/bin/brew ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)" 
