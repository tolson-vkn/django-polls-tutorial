FROM postgres:11.12

# This is a feature of the postgres image
# https://hub.docker.com/_/postgres/ -> Initialization Scripts

# Many images often feature cool customizations with entrypoints, this is one of them.
# Note that because this is custom to this image, don't expect every project to use them,
# check the README files for images you consume to find these sorts of things.

# Note that the `make local-dump` if used here, will need the dumbo user removed, otherwise:
#     ERROR:  role "dumbo" already exists
# So not only is it a good idea to not store password hashes in the image, the POSTGRES_PASSWORD at
# runtime takes care of it.
# The same would also apply to
#     ERROR:  database "polls" already exists
# But not for an entire security reason, perhaps you should consider pg_dump instead of dumpall
ADD init-db.sql /docker-entrypoint-initdb.d/init-db.sql

