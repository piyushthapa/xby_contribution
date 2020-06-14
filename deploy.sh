mix deps.get --only prod
MIX_ENV=prod mix compile
npm run deploy --prefix ./assets
mix phx.digest
MIX_ENV=prod mix release
rm xby_status.zip
zip -r xby_status.zip  _build/prod/rel/xby_status

sshpass -p $password scp xby_status.zip $user@$host:$host_path 