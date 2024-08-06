# 3D Geometry-Based Tissue Block Annotation: Collision Detection between Tissue Blocks and Anatomical Structures

**Version:** 2.0.0

**Release date:** 15 June 2024

## Overview:

3D geometry-based tissue block annotation project includes: 
1. a C++ library for http service for collision detection and intersection volume computation between tissue blocks and anatomical structures 
2. a C++ library for checking manifoldness and closedness of meshes as well as hole filling for the unclosed meshes.   
3. a Python library for converting glb files to off (Object File Format) files, which is the underlying 3D model format for collision detection.


## Dependencies
For C++ libraries [1] [2]:
1. CMake
    ```bash
    sudo apt-get install build-essential libssl-dev
    cd /tmp
    wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz
    tar -zxvf cmake-3.20.0.tar.gz
    cd cmake-3.20.0
    ./bootstrap
    make
    sudo make install
    ```
2. Boost
    ```bash
    sudo apt-get update
    sudo apt-get install libboost-all-dev
    ```
3. GMP
    ```bash
    sudo apt-get install libgmp-dev
    ```
4. MPFR
    ```bash
    sudo apt-get install libmpfr-dev
    ```
3. CGAL
    ```bash
    sudo apt-get install libcgal-dev
    ```
4. Eigen3
    ```bash
    sudo apt install libeigen3-dev
    ```
5. cpprestsdk
    ```bash
    sudo apt-get install libcpprest-dev
    ```

For Python library [3]:
1. pygltflib
    ```bash
    pip install pygltflib
    ```
## Compilation

We use CMake to configure the program with third-party dependencies and generate the native build system by creating a CMakeLists.txt file. 

1. for collision detection and volume computation:
    ```bash
    cd $collision_detection_http_service
    mkdir build
    cd build
    cmake ..
    make
    ```

## Model

**New updates on July 2024:**

1. **all_preprocessed_off_models_v2.0: OFF models generated by [hra-glb-preprocessor](https://github.com/cns-iu/hra-glb-preprocessor).**
2. **asct-b-grlc.csv: downloaded from "https://grlc.io/api-git/hubmapconsortium/ccf-grlc/subdir/mesh-collision/anatomical-structures.csv" by script [downloaded_data.py](https://github.com/hubmapconsortium/hra-tissue-block-annotation/blob/asct-b/scripts/download_data.py).**
3. **reference-organ-grlc.csv: downloaded from "https://grlc.io/api-git/hubmapconsortium/ccf-grlc/subdir/mesh-collision/placement-patches.csv" by script [downloaded_data.py](https://github.com/hubmapconsortium/hra-tissue-block-annotation/blob/asct-b/scripts/download_data.py).**


## Usage
### Server side: 
Option 1: on local host
1. download the required data
    ```bash
    python3 scripts/download_data.py
    ```
1. start http service and receive json request:
    ```bash
    ./server.sh
    ```

Option 2: Using Docker 
1. build the docker image
    ```bash
    docker build -t hra-tissue-block-annotation:v2 .
    ```
2. Start the docker container
    ```bash
    docker run -it -p 8080:8080 hra-tissue-block-annotation:v2
    ```
  
### Client side:

POST http://server_ip:port/get-collisions

- JSON request example
```json
{
  "@context": "https://hubmapconsortium.github.io/hubmap-ontology/ccf-context.jsonld",
  "@id": "http://purl.org/ccf/1.5/6d000077-6866-42e5-8af8-eb068239747a",
  "@type": "SpatialEntity",
  "creator": "a b",
  "creator_first_name": "a",
  "creator_last_name": "b",
  "creation_date": "2022-10-19",
  "ccf_annotations": [
    "http://purl.obolibrary.org/obo/UBERON_0002015",
    "http://purl.obolibrary.org/obo/UBERON_0008716",
    "http://purl.obolibrary.org/obo/UBERON_0000362",
    "http://purl.obolibrary.org/obo/UBERON_0001228",
    "http://purl.obolibrary.org/obo/UBERON_0004200",
    "http://purl.obolibrary.org/obo/UBERON_0001225",
    "http://purl.obolibrary.org/obo/UBERON_0001284",
    "http://purl.obolibrary.org/obo/UBERON_0002189"
  ],
  "x_dimension": 10,
  "y_dimension": 10,
  "z_dimension": 10,
  "dimension_units": "millimeter",
  "placement": {
    "@context": "https://hubmapconsortium.github.io/hubmap-ontology/ccf-context.jsonld",
    "@id": "http://purl.org/ccf/1.5/6d000077-6866-42e5-8af8-eb068239747a_placement",
    "@type": "SpatialPlacement",
    "target": "http://purl.org/ccf/latest/ccf.owl#VHFLeftKidneyV1.1",
    "placement_date": "2022-10-19",
    "x_scaling": 1,
    "y_scaling": 1,
    "z_scaling": 1,
    "scaling_units": "ratio",
    "x_rotation": 0,
    "y_rotation": 0,
    "z_rotation": 0,
    "rotation_order": "XYZ",
    "rotation_units": "degree",
    "x_translation": 25.536,
    "y_translation": 94.007,
    "z_translation": 38.79,
    "translation_units": "millimeter"
  }
}
  ```
  - Request as a CURL command:
  ```bash
  curl -d '@examples/test-registration.json' -H "Content-Type: application/json" -X POST http://localhost:8080/get-collisions
  ```
  - JSON response example
  ```json
[
  {
    "AS_volume": 8361.985667661724,
    "id": "http://purl.org/ccf/latest/ccf.owl#VHFemaleOrgans_VH_F_hilum_of_kidney_L",
    "intersection_volume": 33,
    "is_closed": true,
    "label": "hilum of kidney",
    "node_name": "VH_F_hilum_of_kidney_L",
    "percentage_of_AS": 0.003946431064528223,
    "percentage_of_tissue_block": 0.033,
    "representation_of": "http://purl.obolibrary.org/obo/UBERON_0008716",
    "tissue_volume": 1000
  },
  {
    "AS_volume": 8149.50311414705,
    "id": "http://purl.org/ccf/latest/ccf.owl#VHFemaleOrgans_VH_F_renal_pyramid_L_a",
    "intersection_volume": 30,
    "is_closed": true,
    "label": "renal pyramid",
    "node_name": "VH_F_renal_pyramid_L_a",
    "percentage_of_AS": 0.0036812060293494207,
    "percentage_of_tissue_block": 0.03,
    "representation_of": "http://purl.obolibrary.org/obo/UBERON_0004200",
    "tissue_volume": 1000
  },
  {
    "AS_volume": 2480.1476405575104,
    "id": "http://purl.org/ccf/latest/ccf.owl#VHFemaleOrgans_VH_F_renal_pyramid_L_b",
    "intersection_volume": 59,
    "is_closed": true,
    "label": "renal pyramid",
    "node_name": "VH_F_renal_pyramid_L_b",
    "percentage_of_AS": 0.02378890636798438,
    "percentage_of_tissue_block": 0.059,
    "representation_of": "http://purl.obolibrary.org/obo/UBERON_0004200",
    "tissue_volume": 1000
  },
  {
    "AS_volume": 72301.89436880287,
    "id": "http://purl.org/ccf/latest/ccf.owl#VHFemaleOrgans_VH_F_renal_column_L",
    "intersection_volume": 825,
    "is_closed": true,
    "label": "renal column",
    "node_name": "VH_F_renal_column_L",
    "percentage_of_AS": 0.01141048940974878,
    "percentage_of_tissue_block": 0.825,
    "representation_of": "http://purl.obolibrary.org/obo/UBERON_0001284",
    "tissue_volume": 1000
  }
]
  ```
  - Request as a CURL command on staging server:
  ```bash
  curl -d '@examples/test-registration.json' -H "Content-Type: application/json" -X POST https://pfn8zf2gtu.us-east-2.awsapprunner.com/get-collisions
  ```
  Input: [RUI Registration](examples/test-registration.json)
  Produces: [result](examples/test-registration-collisions.json)
