library(Rvcg)
library(mesheR)
library(Morpho)
library(RvtkStatismo)
library(rgl)

template <- file2mesh('~/dense_5k_template.ply')
templatepoints <- as.matrix(read.mpp('~/dense_5k_template_picked_points.pp'))

m1 <- file2mesh('~/example_mesh.ply')
m1points <- as.matrix(read.mpp('~/example_mesh_picked_points.pp'))

m1rot <- rotmesh.onto(m1, m1points, templatepoints, scale = T)
m1Rlm <- m1rot$yrot
m1R <- m1rot$mesh

plot3d(m1R, aspect = "iso", col = 2, specular = 1)
points3d(m1points, col = 4)
rglwidget()

#initialize deformation
m1_icp <- icp(m1R, template, type = "rigid", iterations = 10, maxdist = 3)

# Sample random points on the mesh to guide the non-linear registration#### in reality, you should probably use a uniform sampling of points, although this should work ok as a demo
sample100 <- sample(1:nverts(template), 100)
sample500 <- sample(1:nverts(template), 500)
sample1000 <- sample(1:nverts(template), 1000)
sample2000 <- sample(1:nverts(template), 2000)


Kernels <- IsoKernel(0.1,template)

#create statismo model from the template mesh with isometric noise #### Takes a while to run!
mymod <- statismoModelFromRepresenter(template, kernel=Kernels, ncomp=100)

postDefFinalFull <- posteriorDeform(mymod, m1_icp, modlm = templatepoints, partsample = t(template$vb[-4, sample100]), deform = T, distance = 3, forceLM = F)
postDefFinalFull <- posteriorDeform(mymod, m1_icp, modlm = templatepoints, partsample = t(template$vb[-4, sample500]), deform = T, distance = 3, forceLM = F, reference = postDefFinalFull)
postDefFinalFull <- posteriorDeform(mymod, m1_icp, modlm = templatepoints, partsample = t(template$vb[-4, sample1000]), deform = T, distance = 3, forceLM = F, reference = postDefFinalFull)
postDefFinalFull <- posteriorDeform(mymod, m1_icp, modlm = templatepoints, partsample = t(template$vb[-4, sample2000]), deform = T, distance = 3, forceLM = F, reference = postDefFinalFull)

plot3d(postDefFinalFull, aspect = "iso", col = 2, specular = 1)
shade3d(m1R, col = 4)
rglwidget()



