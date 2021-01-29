# vault-raft-backup

This is a project to build a docker image to more easily take backups of Vault database running with Raft backend in k8s and store backups on s3 storage.
There is an image on dockerhub, trappis/vault-raft-backup:v0.1 that can be used right away.
However the deployment.yaml needs modification on the configmap part.

## Authentication

You must do some quick initial setup prior to being able to use the Snapshot Agent. This involves the following:

`vault login` with an admin user.
Create the following policy `vault policy write snapshot snapshot_policy.hcl`
 where `snapshot_policy.hcl` is:

```hcl
path "/sys/storage/raft/snapshot"
{
  capabilities = ["read"]
}
```

Then run:
```
vault write auth/approle/role/snapshot token_policies="snapshot"
vault read auth/approle/role/snapshot/role-id
vault write -f auth/approle/role/snapshot/secret-id
```

and copy your secret and role ids, and place them into the deployment.yaml file.

## TL;DR
```
kubectl apply -n <namespace> -f deployment.yaml
```

If you want to build the image yourself, run the following.
## Build image using docker.
```
docker build -t <repo>/vault-raft-backup:v0.1 .
```
```
docker push <repo>/vault-raft-backup:v0.1
```

Now edit the deployment.yaml to point to your internal repo and update the configmap from above.


Creds to https://github.com/Lucretius for making this binary :)

