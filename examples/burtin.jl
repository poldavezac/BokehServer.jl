#!/usr/bin/env -S julia --startup-file=no --history-file=no --project
push!(LOAD_PATH, joinpath(@__DIR__, "environment"))
import BokehJL
using CSV
using DataFrames
const  txt = """
bacteria,                        penicillin, streptomycin, neomycin, gram
Mycobacterium tuberculosis,      800,        5,            2,        negative
Salmonella schottmuelleri,       10,         0.8,          0.09,     negative
Proteus vulgaris,                3,          0.1,          0.1,      negative
Klebsiella pneumoniae,           850,        1.2,          1,        negative
Brucella abortus,                1,          2,            0.02,     negative
Pseudomonas aeruginosa,          850,        2,            0.4,      negative
Escherichia coli,                100,        0.4,          0.1,      negative
Salmonella (Eberthella) typhosa, 1,          0.4,          0.008,    negative
Aerobacter aerogenes,            870,        1,            1.6,      negative
Brucella antracis,               0.001,      0.01,         0.007,    positive
Streptococcus fecalis,           1,          1,            0.1,      positive
Staphylococcus aureus,           0.03,       0.03,         0.001,    positive
Staphylococcus albus,            0.007,      0.1,          0.001,    positive
Streptococcus hemolyticus,       0.001,      14,           10,       positive
Streptococcus viridans,          0.005,      10,           40,       positive
Diplococcus pneumoniae,          0.005,      11,           10,       positive
"""
const df = CSV.read(IOBuffer(txt), DataFrame; stripwhitespace = true)

const drug_color = Dict(
    Pair("Penicillin",   "#0d3362"),
    Pair("Streptomycin", "#c64737"),
    Pair("Neomycin",     "black"  ),
)

const gram_color = Dict("negative" => "#e69584", "positive" => "#aeaeb8")
const width = 800
const height = 800
const inner_radius = 90
const outer_radius = 300 - 10

const minr = √(log(.001 * 1E4))
const maxr = √(log(1000 * 1E4))
const a = (outer_radius - inner_radius) / (minr - maxr)
const b = inner_radius - a * maxr

rad(mic) = a .* sqrt.(log.(mic .* 1E4)) .+ b

const big_angle = 2π / (size(df, 1) + 1)
const small_angle = big_angle / 7

BokehJL.Plotting.serve() do
    p = BokehJL.figure(width=width, height=height, title="",
        x_axis_type=nothing, y_axis_type=nothing,
        x_range=(-420, 420), y_range=(-420, 420),
        min_border=0, outline_line_color="black",
        background_fill_color="#f0e1d2")

    p.xgrid.grid_line_color = nothing
    p.ygrid.grid_line_color = nothing

    # annular wedges
    angles = (π/2 - big_angle/2) .- (0:size(df, 1)-1) .* big_angle
    colors = [gram_color[i] for i ∈ df.gram]
    BokehJL.annularwedge!(p; x = 0, y = 0, inner_radius, outer_radius,
                   start_angle = -big_angle .+ angles, finish_angle = angles,
                   color=colors)

    # small wedges
    BokehJL.annularwedge!(p; x = 0, y = 0, inner_radius, outer_radius = rad(df.penicillin),
                    start_angle  = -big_angle .+ angles .+ 5*small_angle,
                    finish_angle = -big_angle .+ angles .+ 6*small_angle,
                    color=drug_color["Penicillin"])
    BokehJL.annularwedge!(p; x = 0, y = 0, inner_radius, outer_radius = rad(df.streptomycin),
                    start_angle  = -big_angle .+ angles .+ 3*small_angle,
                    finish_angle = -big_angle .+ angles .+ 4*small_angle,
                    color=drug_color["Streptomycin"])
    BokehJL.annularwedge!(p; x = 0, y = 0, inner_radius, outer_radius = rad(df.neomycin),
                    start_angle  = -big_angle .+ angles .+ 1*small_angle,
                    finish_angle = -big_angle .+ angles .+ 2*small_angle,
                    color=drug_color["Neomycin"])

    # circular axes and lables
    labels = 10.0 .^ (-3:3)
    radii = rad(labels)
    r = BokehJL.circle!(p; x= 0, y = 0, radius=radii, fill_color=nothing, line_color="white")
    BokehJL.text!(p; x = 0, y = radii[1:end-1], text  = [string(r) for r in labels[1:end-1]],
           text_font_size="11px", text_align="center", text_baseline="middle")

    # radial axes
    BokehJL.annularwedge!(p; x=  0, y = 0, inner_radius = inner_radius-10,
        outer_radius =  outer_radius+10,
        start_angle  = -big_angle .+ angles,
        finish_angle = -big_angle .+ angles,
        color="black")

    # bacteria labels
    xr = radii[1] .* cos.(-big_angle/2 .+ angles)
    yr = radii[1] .* sin.(-big_angle/2 .+ angles)
    label_angle= collect(-big_angle/2 .+ angles)
    label_angle[label_angle .< -π/2] .+= π # easier to read labels on the left side
    BokehJL.text!(p; x = xr, y = yr, text = df.bacteria, angle=label_angle,
           text_font_size="12px", text_align="center", text_baseline="middle")

    # OK, these hand drawn legends are pretty clunky, will be improved in future release
    BokehJL.circle!(p; x = [-40, -40], y = [-370, -390], color=collect(values(gram_color)), radius=5)
    BokehJL.text!(p; x = [-30, -30], y = [-370, -390], text= "Gram-" .*  keys(gram_color),
           text_font_size="9px", text_align="left", text_baseline="middle")

    BokehJL.rect!(p; x = [-40, -40, -40], y = [18, 0, -18], width=30, height=13,
           color=collect(values(drug_color)))
    BokehJL.text!(p; x = [-15, -15, -15], y = [18, 0, -18], text=collect(keys(drug_color)),
           text_font_size="12px", text_align="left", text_baseline="middle")
    p
end
