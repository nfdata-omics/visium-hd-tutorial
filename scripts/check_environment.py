#!/usr/bin/env python3

modules = [
    "numpy",
    "pandas",
    "scipy",
    "anndata",
    "scanpy",
    "spatialdata",
    "zarr",
    "h5py",
    "tifffile",
]

for module in modules:
    __import__(module)

print("Environment OK")
