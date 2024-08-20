#build will fail with with small RAM allotments with uninformative error codes-- Set aside at least 8GB
FROM rocker/rstudio:3.6.3-ubuntu18.04

#system libraries of general use
RUN apt-get update && apt-get install -y \
    software-properties-common \
    libssl-dev \
    build-essential \
    libharfbuzz-dev \
    libfribidi-dev

RUN apt-add-repository ppa:zarquon42/statismo-develop
RUN sudo apt update
RUN sudo apt install -y statismo-dev

# install R packages required
RUN R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_github('zarquon42b/RvtkStatismo',ref='develop')"
RUN R -e "devtools::install_github('zarquon42b/mesheR')"
RUN R -e "install.packages('Morpho', repos='http://cran.rstudio.com/')"

# copy example data and script
COPY example_mesh.ply /home/rstudio/
COPY example_mesh_picked_points.pp /home/rstudio/
COPY example_template.ply /home/rstudio/
COPY example_template_picked_points.pp /home/rstudio/
COPY register_mesh_statismo.R /home/rstudio/
