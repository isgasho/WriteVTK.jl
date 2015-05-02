#!/usr/bin/env julia

# Create rectilinear grid VTK file.

using WriteVTK
typealias FloatType Float32
const vtk_filename_noext = "rectilinear"

function main()
    # Define grid.
    const Ni, Nj, Nk = 20, 30, 40

    x = zeros(FloatType, Ni)
    y = zeros(FloatType, Nj)
    z = zeros(FloatType, Nk)

    [x[i] = i*i/Ni/Ni for i = 1:Ni]
    [y[j] = sqrt(j/Nj) for j = 1:Nj]
    [z[k] = k/Nk for k = 1:Nk]

    # Create some scalar and vectorial data.
    p = zeros(FloatType, Ni, Nj, Nk)
    q = zeros(FloatType, Ni, Nj, Nk)
    vec = zeros(FloatType, 3, Ni, Nj, Nk)

    for k = 1:Nk, j = 1:Nj, i = 1:Ni
        p[i, j, k] = i*i + k
        q[i, j, k] = k*sqrt(j)
        vec[1, i, j, k] = i
        vec[2, i, j, k] = j
        vec[3, i, j, k] = k
    end

    # Initialise new vtr file (rectilinear grid).
    vtk = vtk_grid(vtk_filename_noext, x, y, z)

    # Add data.
    vtk_point_data(vtk, p, "p_values")
    vtk_point_data(vtk, q, "q_values")
    vtk_point_data(vtk, vec, "myVector")

    # Save and close vtk file.
    outfiles = vtk_save(vtk)
    println("Saved:   ", outfiles...)

    return outfiles::Vector{UTF8String}
end

main()