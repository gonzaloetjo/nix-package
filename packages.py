import os

def parse_wheels_directory(directory):
    """Parses the given wheels directory and returns a dictionary
    mapping package names to versions."""
    packages = {}
    for filename in os.listdir(directory):
        if filename.endswith('.whl'):
            parts = filename.split('-')
            name = '-'.join(parts[:-2])
            version = parts[-2]
            packages.setdefault(name, []).append(version)
    return packages

def compare_packages(old_directory, new_directory, output_file):
    """Compares the package names and versions in the two given wheels directories."""
    old_packages = parse_wheels_directory(old_directory)
    new_packages = parse_wheels_directory(new_directory)

    old_only = sorted(set(old_packages.keys()) - set(new_packages.keys()))
    new_only = sorted(set(new_packages.keys()) - set(old_packages.keys()))

    with open(output_file, 'w') as f:
        f.write(f'Packages only in {old_directory}:\n')
        for package in old_only:
            f.write(f'- {package}\n')

        f.write(f'\nPackages only in {new_directory}:\n')
        for package in new_only:
            f.write(f'- {package}\n')

        f.write(f'\nRepeated packages in {old_directory}:\n')
        for package, versions in old_packages.items():
            if len(versions) > 1:
                f.write(f'- {package}: {", ".join(versions)}\n')

        f.write(f'\nRepeated packages in {new_directory}:\n')
        for package, versions in new_packages.items():
            if len(versions) > 1:
                f.write(f'- {package}: {", ".join(versions)}\n')

# Usage example
compare_packages('older/airflow_wheels', 'newer/airflow_wheels', 'comparison_output.txt')
