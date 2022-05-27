struct EnumType{T}
end

bokehfieldtype(::Type{<:EnumType}) = Symbol

longform(𝑇::Type{<:EnumType}, ν::String)         = longform(𝑇, Symbol(ν))
longform(::Type{<:EnumType}, ν::Symbol)         = ν
Base.values(::Type{<:EnumType{𝑇}}) where {𝑇}    = 𝑇
Base.in(ν::Symbol, 𝑇::Type{<:EnumType})         = longform(𝑇, ν) ∈ values(𝑇)
Base.in(ν::AbstractString, 𝑇::Type{<:EnumType}) = Symbol(ν) ∈ 𝑇

function bokehwrite(𝑇::Type{<:EnumType}, ν::Union{AbstractString, Symbol})
    val = longform(𝑇, ν)
    @assert val ∈ 𝑇
    return val
end

const DashPattern = EnumType{(:solid, :dashed, :dotted, :dotdash, :dashdot)}
const MarkerType  = EnumType{(
    :asterisk, :circle, :circle_cross, :circle_dot, :circle_x,
    :circle_y, :cross, :dash, :diamond, :diamond_cross, :diamond_dot,
    :dot, :hex, :hex_dot, :inverted_triangle, :plus, :square,
    :square_cross, :square_dot, :square_pin, :square_x, :star, :star_dot,
    :triangle, :triangle_dot, :triangle_pin, :x, :y
)}

const HatchPatternType = EnumType{(
    :blank,
    :dot,
    :ring,
    :horizontal_line,
    :vertical_line,
    :cross,
    :horizontal_dash,
    :vertical_dash,
    :spiral,
    :right_diagonal_line,
    :left_diagonal_line,
    :diagonal_cross,
    :right_diagonal_dash,
    :left_diagonal_dash,
    :horizontal_wave,
    :vertical_wave,
    :criss_cross,
)}

function longform(::Type{HatchPatternType}, ν::Symbol)
    ν = (
        ν ≡ Symbol(" ") ? :blank :
        ν ≡ Symbol(".") ? :dot :
        ν ≡ Symbol("o") ? :ring :
        ν ≡ Symbol("-") ? :horizontal_line :
        ν ≡ Symbol("|") ? :vertical_line :
        ν ≡ Symbol("+") ? :cross :
        ν ≡ Symbol("\"") ? :horizontal_dash :
        ν ≡ Symbol(":") ? :vertical_dash :
        ν ≡ Symbol("@") ? :spiral :
        ν ≡ Symbol("/") ? :right_diagonal_line :
        ν ≡ Symbol("\\") ? :left_diagonal_line :
        ν ≡ Symbol("x") ? :diagonal_cross :
        ν ≡ Symbol(",") ? :right_diagonal_dash :
        ν ≡ Symbol("`") ? :left_diagonal_dash :
        ν ≡ Symbol("v") ? :horizontal_wave :
        ν ≡ Symbol(">") ? :vertical_wave :
        ν ≡ Symbol("*") ? :criss_cross :
        ν
    )
end
