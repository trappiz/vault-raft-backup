#!/bin/bash
echo "Starting raft backup..."
/go/bin/vault_raft_snapshot_agent
echo "Started raft backup"

while true; 
  do sleep 10;
  echo "Staying alive!"; 
done
