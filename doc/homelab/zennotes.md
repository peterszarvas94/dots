# ZenNotes

ZenNotes is deployed as a containerized service with its vault and application
data stored outside this repository. Keep compose files, environment files,
storage paths, public hostname, and internal listener in private operations
notes.

Expose it only through a dedicated HTTPS hostname at the reverse proxy. Keep
authentication tokens in a protected environment file and never commit them.
Verify browser access, persistence, and backups after deployment changes.
