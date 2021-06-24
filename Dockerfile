FROM python:3

# Add the requirements txt file.
# Docker pro tip: For things like python packages, load them AFTER source code where
# possible. This will then use a union filesystem cache for packages earlier than code.
# If code is before pip packages, you will often need to refresh packages as code changes
# invalidate the previous union file system cache layer.
ADD requirements.txt /
RUN pip install -r requirements.txt

# Add our source to a friendly directory.
ADD django /src

# Set up our container to start in /src, where the code is.
WORKDIR /src

# Normally I'd advise a entrypoint and command. Often this should reflect something like
# the default PID 1, but often in python projects, locally you use python, then in prod you
# override with gunicorn or something like that. For now just use python. Note that our
# docker-compose will override this behavior, so will the kube resources.
ENTRYPOINT ["python"]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
