# Spatial transcriptomics meets advanced image analysis: AI-driven integration of spatial omics data

This repository contains the hands-on material for a workshop on high-resolution spatial transcriptomics and image-based analysis using 10x Genomics Visium HD data. The practicals use GitHub Codespaces, `SpatialData`, and Bin2Cell to move from Visium HD bin-level data to a cell-level matrix supported by image-derived segmentation.

The dataset used in the workshop is a human colorectal cancer FFPE Visium HD sample from 10x Genomics, referred to in the notebooks as sample P5.

## Start Here

1. Open this repository in GitHub Codespaces.
2. Wait until the Codespace setup and data download have completed.
3. Open `notebooks/01_quality_control_and_data_exploration.ipynb`.
4. Run the notebooks in order.

The workshop is designed to run inside the provided Codespaces environment. The data are downloaded automatically during setup.

## Workshop Goals

By the end of the hands-on session, you will be able to:

- load and inspect Visium HD data with `SpatialData`
- understand bin-level expression matrices
- perform spatial quality control on Visium HD bins
- connect transcriptomics data with image-derived segmentation
- use Bin2Cell to aggregate 2 um bins into segmented cells
- build and inspect a cell-level expression matrix
- run downstream single-cell-like analysis on spatially resolved cells
- visualize QC metrics, marker genes, clusters, and annotations in tissue space

## Dataset and Biological Context

The workshop uses a human colorectal cancer FFPE Visium HD dataset from 10x Genomics. The notebooks focus on sample P5.

Colorectal cancer tissue contains a spatially organized mixture of tumour, stromal, epithelial, and immune populations. Visium HD provides high-resolution transcriptomic measurements across the tissue, while image-derived segmentation helps connect those transcriptomic bins to biologically interpretable cell-level regions.

This combination makes the dataset useful for learning how spatial transcriptomics and image analysis can be integrated in a practical analysis workflow.

## Workshop Roadmap

| Step | Notebook | Main focus | Output |
|---|---|---|---|
| 1 | `notebooks/01_quality_control_and_data_exploration.ipynb` | Load `SpatialData`, inspect Visium HD data, compute QC metrics, and filter spatial bins | filtered 16 um AnnData object |
| 2 | `notebooks/02_bin2cell_cell_level_matrix.ipynb` | Use a segmentation mask with Bin2Cell, aggregate 2 um bins into cells, and analyze the cell-level matrix | annotated cell-level `SpatialData` object |
| Reference | `notebooks/prepare_input_datasets.ipynb` | Show how the reduced tutorial datasets were prepared from the original inputs | workshop-ready Zarr files |

`prepare_input_datasets.ipynb` is included for transparency and reference. Participants do not need to run it during the workshop.

## How to Follow the Hands-On

### 1. Quality Control and Data Exploration

In the first notebook, you will:

- load the full-slide `SpatialData` object
- inspect images, shapes, and expression tables
- compute library size, detected genes, and mitochondrial fraction
- visualize QC metrics across the tissue
- identify low-quality spatial bins
- filter the bin-level matrix
- save and inspect the filtered object

### 2. From Spatial Bins to Cells with Bin2Cell

In the second notebook, you will:

- load the cropped Visium HD dataset
- load the segmentation mask
- convert segmentation labels into a Bin2Cell-compatible sparse format
- register the segmentation labels in the `SpatialData` object
- check alignment between the image, coordinates, and segmentation mask
- assign spatial bins to segmented cells
- expand labels where appropriate
- aggregate bin-level counts into a cell-level matrix
- perform cell-level quality control
- normalize, reduce dimensions, and cluster cells
- inspect marker genes and assign broad annotations
- visualize QC metrics, markers, clusters, and annotations back in tissue space

## Tips and Tricks for Jupyter

- Run notebook cells sequentially unless the instructor tells you to skip ahead.
- Use `Shift+Enter` to run the current cell and move to the next one.
- Use `Esc` to enter command mode, then `B` to add a cell below or `A` to add a cell above.
- In command mode, use `C`, `X`, and `V` to copy, cut, and paste cells.
- If a plot or computation takes time, wait for the cell to finish before running it again.
- Check that the selected kernel is the tutorial Python environment before starting.
- Avoid restarting the Codespace during long computations.
- Workshop outputs are written under `/workspaces/results/`.

## Repository Layout

```text
notebooks/
  01_quality_control_and_data_exploration.ipynb
  02_bin2cell_cell_level_matrix.ipynb
  prepare_input_datasets.ipynb

scripts/
  download_data.sh
  check_environment.py
  local_test.sh

.devcontainer/
  devcontainer.json
  Dockerfile
```

## Technical Reference for Maintainers

Codespaces is configured through `.devcontainer/devcontainer.json` and uses the prebuilt image `ghcr.io/nfdata-omics/visium-hd-tutorial`.

The data setup is handled by `scripts/download_data.sh`, which downloads the tutorial Zarr stores and segmentation mask from Zenodo into `/workspaces/data`. Checksums are stored in `checksums.md5`.

Environment validation is available through:

```bash
python scripts/check_environment.py
```

The GitHub Actions workflow in `.github/workflows/build-devcontainer-image.yml` builds and pushes the devcontainer image when the environment files change. Repository maintenance checks are configured in `.pre-commit-config.yaml`.
