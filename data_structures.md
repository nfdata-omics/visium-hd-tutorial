# From Arrays to SpatialData: Building Data Structures for Spatial Transcriptomics

Understanding **SpatialData** becomes much easier when viewed as the latest step in the evolution of Python data structures. Each structure builds upon the capabilities of the previous one, adding new features required to represent increasingly complex biological datasets.

## 1. NumPy Array: Numerical Data

A **NumPy array** is the fundamental data structure for numerical computing in Python.

* Stores homogeneous numerical values in one or more dimensions.
* Provides fast mathematical operations and efficient memory usage.
* Represents data without labels or metadata.

**Example**

* A vector of gene expression values.
* A 2D microscopy image (pixels).
* A 3D image stack.

**Key idea:** *Only numerical values.*

---

## 2. Pandas DataFrame: Tabular Data

A **Pandas DataFrame** extends numerical arrays by introducing rows, columns, labels, and heterogeneous data types.

* Organizes data as a table.
* Each column has a name and may contain a different data type.
* Supports indexing, filtering, grouping, and statistical operations.

**Example**

| Cell ID | Cell Type | Area | Sample |
| ------- | --------- | ---- | ------ |
| Cell_1  | T cell    | 112  | S1     |
| Cell_2  | B cell    | 98   | S1     |

**Key idea:** *Structured data with annotations.*

---

## 3. AnnData: Omics Data

![anndata representation](https://raw.githubusercontent.com/scverse/anndata/main/docs/_static/img/anndata_schema.svg)

**AnnData** was specifically designed for single-cell genomics.

It combines multiple data structures into a single coherent object.

Main components:

* **X**: expression matrix (cells × genes)
* **obs**: cell metadata (Pandas DataFrame)
* **var**: gene metadata (Pandas DataFrame)
* **obsm**: multidimensional representations (PCA, UMAP, spatial coordinates)
* **layers**: alternative expression matrices
* **uns**: unstructured metadata

AnnData therefore integrates quantitative measurements with biological annotations while maintaining consistency between observations and variables.

**Key idea:** *A complete container for omics datasets.*

---

## 4. GeoPandas: Spatial Vector Data

![alt text](https://geopandas.org/en/stable/_images/dataframe.svg)

While AnnData manages biological measurements, **GeoPandas** manages spatial geometries.

A GeoDataFrame extends a Pandas DataFrame by adding a dedicated **geometry** column.

Geometries may include:

* Points
* Lines
* Polygons
* Multipolygons

Each geometry exists within a defined coordinate reference system (CRS), enabling spatial operations such as intersections, buffering, nearest-neighbor searches, and overlays.

**Example**

* Cell boundaries
* Tissue annotations
* Segmentation masks converted to polygons

**Key idea:** *Tabular data with spatial geometry.*

---

## 5. SpatialData: Integrated Spatial Omics

![alt text](https://spatialdata.scverse.org/en/stable/_images/elements.png)

**SpatialData** combines all of the previous concepts into a unified framework for spatial biology.

A SpatialData object can simultaneously contain:

* Images (NumPy / xarray)
* Labels (segmentation masks)
* Points (transcripts, molecules)
* Shapes (GeoPandas geometries)
* Tables (AnnData with molecular measurements)

The crucial innovation is that every element is connected through a common spatial coordinate system using explicit coordinate transformations.

This allows images, segmentations, molecular measurements, and cell annotations to remain synchronized, even across multiple resolutions or imaging modalities.

Typical workflow:

```
NumPy
   ↓
Pandas
   ↓
AnnData          GeoPandas
      ↘          ↙
       SpatialData
```

SpatialData is therefore not simply another data structure—it is an integrated data model that brings together numerical data, biological annotations, geometries, images, and spatial relationships into a single interoperable ecosystem.

**Key idea:** *A unified representation of spatial biological experiments.*
