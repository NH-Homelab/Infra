# Infra
Basic infrastructure and setup scripts to support the homelab

## Persistent Volumes
Persistent volumes for the containers are configured to reside in `/home/<user>/.homelab-data/<service-name>`. Minio, postgres, and pg-admin persistent data is stored here.