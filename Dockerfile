# get shiny serves plus tidyverse packages image
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
RUN R -e "install.packages('geomorph', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Morpho', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Rvcg', repos='http://cran.rstudio.com/')"

#build will fail with with small RAM allotments with uninformative error codes-- ask me how I know. Set aside at least 8GB
