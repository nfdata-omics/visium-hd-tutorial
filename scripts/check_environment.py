#!/usr/bin/env python3

import importlib
import importlib.metadata
import sys


MODULES = {
    "torch": "torch",
    "torchvision": "torchvision",
    "numpy": "numpy",
    "pandas": "pandas",
    "scipy": "scipy",
    "scanpy": "scanpy",
    "leidenalg": "leidenalg",
    "spatialdata": "spatialdata",
    "spatialdata-io": "spatialdata_io",
    "spatialdata-plot": "spatialdata_plot",
    "matplotlib": "matplotlib",
    "seaborn": "seaborn",
    "cell2location": "cell2location",
    "bin2cell": "bin2cell",
    "tifffile": "tifffile",
    "scikit-learn": "sklearn",
    "opencv-python": "cv2",
    "scikit-image": "skimage",
    "prek": "prek",
    "ipykernel": "ipykernel",
    "jupyterlab": "jupyterlab",
    "pip-tools": "piptools",
}


def get_package_version(package_name):
    try:
        return importlib.metadata.version(package_name)
    except importlib.metadata.PackageNotFoundError:
        return "-"


def print_header():
    print("Visium HD tutorial environment check")
    print("=" * 36)
    print(f"Python     : {sys.version.split()[0]}")
    print(f"Executable : {sys.executable}")
    print(f"Packages   : {len(MODULES)}")
    print()


def print_result(status, package_name, module_name, version, message=""):
    package_display = package_name[:25]
    module_display = module_name[:23]
    version_display = version[:14]
    print(
        f"{status:<8} {package_display:<25} "
        f"{module_display:<23} {version_display:<14} {message}"
    )


print_header()
print_result("Status", "Package", "Import name", "Version")
print("-" * 82)

failures = []
successes = 0

for package_name, module_name in MODULES.items():
    version = get_package_version(package_name)

    try:
        importlib.import_module(module_name)
    except Exception as exc:
        failures.append((package_name, module_name, version, exc))
        print_result("MISSING", package_name, module_name, version, exc.__class__.__name__)
    else:
        successes += 1
        print_result("OK", package_name, module_name, version)

print("-" * 82)
print(f"Summary    : {successes}/{len(MODULES)} imports available")

if failures:
    print()
    print("Missing or failing imports:")
    for package_name, module_name, version, exc in failures:
        print(f"- {package_name} ({module_name}, version {version}): {exc}")
    print()
    print("Install the tutorial environment, then rerun this check.")
    sys.exit(1)

print("Environment OK")
