import json
import subprocess
from typing import List

def find_google_or_azure_dependency(
    package: str, parent: str, dependency_tree: List[dict], visited_packages: dict
) -> None:
    key = f"{package}_{parent}"
    if key in visited_packages:
        return

    visited_packages[key] = True

    if "google" in package or "azure" in package or "gcsfs" in package or "grpcio-status" in package:
        dependencies_list.add(parent)

    for pkg in dependency_tree:
        if pkg["package"]["key"] == package:
            for dep in pkg["dependencies"]:
                find_google_or_azure_dependency(dep["key"], package, dependency_tree, visited_packages)

def main():
    global dependencies_list
    dependencies_list = set()

    with open("requirements.txt", "r") as f:
        requirements = f.readlines()

    cmd_output = subprocess.check_output(["/venv/bin/pipdeptree", "--json"]).decode()
    dependency_tree = json.loads(cmd_output)

    for requirement in requirements:
        package = requirement.strip().split("==")[0]
        find_google_or_azure_dependency(package, package, dependency_tree, {})

    with open("check_dependencies.txt", "w") as f:
        f.write("Packages with Google, Azure, gcsfs, and grpcio-status dependencies:\n")
        for dep in sorted(dependencies_list):
            f.write(f"- {dep}\n")

if __name__ == "__main__":
    main()
