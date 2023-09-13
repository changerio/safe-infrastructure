#!/bin/bash

set -e

cd networks/wemix-testnet
source .env

echo "==> $(date +%H:%M:%S) ==> Starting up environment containers..."
docker compose up --build -d &&
  echo "==> $(date +%H:%M:%S) ==> Waiting for migrations... (may take a while)" &&
  sleep 60 &&
  echo "==> $(date +%H:%M:%S) ==> Creating super-user for Safe Config Service... (may take a while)" &&
  docker compose exec cfg-web python src/manage.py createsuperuser &&
  echo "==> $(date +%H:%M:%S) ==> Creating super-user for Safe Transaction Service... (may take a while)" &&
  docker compose exec txs-web python manage.py createsuperuser || exit

echo "==> $(date +%H:%M:%S) ==> All set! You may want to add a ChainInfo into the Config service. Please use the link below to fill its data: http://localhost:$REVERSE_PROXY_PORT/cfg/admin/chains/chain/add/"
