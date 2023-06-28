#!/usr/bin/env bash

set -e

export AIRFLOW_VERSION=2.6.1

rm -rf docker-context-files/*
rm -f airflow_wheels.tar.gz
mkdir -p docker-context-files

cp constraints-3.9.txt docker-context-files/constraints-3.9.txt
cp check_dependencies.py docker-context-files/check_dependencies.py

export DOCKER_BUILDKIT=1

echo "Building Docker image..."
docker build . \
    --pull \
    --no-cache \
    --build-arg PYTHON_BASE_IMAGE="python:3.9" \
    --build-arg AIRFLOW_VERSION="${AIRFLOW_VERSION}" \
    --tag "tdp-airflow-1.0.0"

rm -rf airflow_wheels

container_name="airflow_venv_$(date +%s)"

echo "Running container..."
container_id=$(docker run --name "$container_name" -d tdp-airflow-1.0.0 sleep infinity)

docker exec "${container_name}" bash -c "/venv/bin/pip freeze > /app/requirements.txt"
docker exec "${container_name}" bash -c "/venv/bin/pip wheel --no-cache-dir --wheel-dir /app -r /app/requirements.txt"

echo "Copying files airflow_wheels"
docker cp $container_id:/app/ airflow_wheels

echo "Copying files requirements"
rm -rf requirements.txt
docker cp $container_id:/app/requirements.txt .

echo "Archive"
rm -rf airflow_wheels.tar.gz
tar -czvf airflow_wheels.tar.gz airflow_wheels/

echo "Creating a tarball of the virtual environment..."
docker cp $container_id:/venv/ venv/
tar -czvf venv.tar.gz venv/

echo "Running check_dependencies.py script..."
docker exec "${container_name}" touch /app/check_dependencies.txt
docker exec "${container_name}" python3.9 /app/check_dependencies.py

docker cp $container_id:/app/check_dependencies.txt .

echo "Cleaning up..."
docker stop "$container_name"
docker rm "$container_name"
