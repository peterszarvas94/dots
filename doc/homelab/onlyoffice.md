# ONLYOFFICE

ONLYOFFICE Document Server is deployed as a containerized service for document
editing integrations. Keep its compose file, environment file, public
hostname, internal listener, and integration values in private operations
notes.

The browser-facing Document Server URL should use HTTPS through the reverse
proxy. Server-to-server integration should use a private internal address when
the deployment supports one. Keep JWT enabled and never commit its value.

Use the upstream documentation for installation and upgrades. Verify editing,
save callbacks, and authentication after changes.
