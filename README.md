# Project: TDP Airflow Package Builder

## Overview

This repository contains tools for creating a custom build of the Apache Airflow package, version 2.6.1, with additional dependencies. The build is wrapped in a Docker image, ready for deployment in a Docker-compatible environment.

The process uses four main components:

1. `devenv` Environment: A declarative Nix environment setup that outlines required system packages and configurations.

2. Build Script (`build_airflow`): A bash script that manages the Docker-based build process.

3. Dockerfile: A Dockerfile defining the build steps for the Docker image. This Dockerfile creates a Python 3.9 environment and installs Airflow along with its dependencies.

4. A constraints file that will dictate versioning of the dependencies.

## How to Use

### 1. Set Up `devenv` Environment

This project uses `devenv` to create a controlled environment with the necessary tools and dependencies. This includes packages like git, jq, ansible, zip, unzip, libkrb5, python39, pip, virtualenv, venvShellHook. To activate and use it follow the instructions here: https://devenv.sh/

Otherwise you can use the rest of the files in the repository while installing your own dependencies.

### 2. Build the Docker Image

Use the `build_airflow` bash script to build the Docker image.

To do this, run the `build_airflow` script in your terminal. This script does the following:

- Prepares the build context, cleaning up old files and copying the necessary ones.
- Builds a Docker image according to the Dockerfile.
- Runs a container from this image.
- Installs all necessary Python dependencies within the container.
- Saves the Python packages installed in the container to a tarball file (`airflow_wheels.tar.gz`) and a `requirements.txt` file.
- Checks all the dependencies installed with the `check_dependencies.py` script.
- Cleans up the Docker container used in the process.

### 3. Dockerfile

The Dockerfile specifies how to build the Docker image. It starts with a Python 3.9 base image and installs necessary packages for building Apache Airflow and its dependencies. The Dockerfile then creates a virtual environment and installs the Apache Airflow package with additional dependencies as outlined in the `constraints-3.9.txt` file.

## Result

After running the `build_airflow` script, you will have a Docker image tagged `tdp-airflow-1.0.0` with Apache Airflow and all the specified dependencies installed. The Python packages installed in the image are also saved in a tarball file (`airflow_wheels.tar.gz`) and a `requirements.txt` file.

The output from the `check_dependencies.py` script is saved in `check_dependencies.txt`, showing the status of all dependencies checked.

## Clean Up

After the build process, the script cleans up the Docker container used for building. The Docker image built remains and can be used or distributed as needed.
