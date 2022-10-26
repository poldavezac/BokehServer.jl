using Printf
using Colors

struct Color <: iProperty
    r::UInt8
    g::UInt8
    b::UInt8
    a::UInt8
end

const COLOR_PATTERNS = (
    r"^#[0-9a-fA-F]{3}$",
    r"^#[0-9a-fA-F]{4}$",
    r"^#[0-9a-fA-F]{6}$",
    r"^#[0-9a-fA-F]{8}$",
    r"^rgba\(((25[0-5]|2[0-4]\d|1\d{1,2}|\d\d?)\s*,\s*?){2}(25[0-5]|2[0-4]\d|1\d{1,2}|\d\d?)\s*,\s*([01]\.?\d*?)\)",
    r"^rgb\(((25[0-5]|2[0-4]\d|1\d{1,2}|\d\d?)\s*,\s*?){2}(25[0-5]|2[0-4]\d|1\d{1,2}|\d\d?)\s*?\)",
)
const CSS_PATT = r"\s*[(,)]\s*"

function color(ν::AbstractString)
    haskey(Colors.color_names, ν) && return Color(Colors.color_names[ν]...)

    let m = match(COLOR_PATTERNS[1], ν)
        isnothing(m) && (m = match(COLOR_PATTERNS[2], ν))
        isnothing(m) || return Color((parse(UInt8, "0x$(ν[i])") for i ∈ 2:length(ν))...)
    end

    let m = match(COLOR_PATTERNS[3], ν)
        isnothing(m) && (m = match(COLOR_PATTERNS[4], ν))
        isnothing(m) || return Color((parse(UInt8, "0x$(ν[i:i+1])") for i ∈ 2:2:length(ν))...)
    end

    let m = match(COLOR_PATTERNS[5], ν)
        isnothing(m) && (m = match(COLOR_PATTERNS[6], ν))
        isnothing(m) || return Color((parse(Int, i) for i ∈ split(ν, CSS_PATT)[2:end-1])...)
    end
    return missing
end
function color(ν::Symbol)
    clr = get(Colors.color_names, "$ν", missing)
    ismissing(clr) ? missing : Color(clr)
end
color(r, g, b, a)                                         = Color(r, g, b, a)
color(r, g, b)                                            = Color(r, g, b, 0xff)
color(ν::Union{NTuple{4,<:Integer}, NTuple{3,<:Integer}}) = Color(ν...)
color(ν::Int32)                                           = Color(reinterpret(UIn8, Int32[ν])...)
color(ν::Colors.ColorTypes.RGB) = color((convert(UInt8, typemax(UInt8)*i) for i ∈ (ν.r, ν.g, ν.b))...)
color(ν::Colors.ColorTypes.RGBA) = color((convert(UInt8, typemax(UInt8)*i) for i ∈ (ν.r, ν.g, ν.b, ν.a))...)
color(ν::Color) = ν

Color(r, g, b)                                            = Color(r, g, b, 0xff)
Color(ν::Union{NTuple{4,<:Integer}, NTuple{3,<:Integer}}) = Color(ν...)
Color(ν::Int32)                                           = Color(reinterpret(UIn8, Int32[ν])...)
function Color(ν::AbstractString)
    c = color(ν)
    ismissing(ν) && throw(BokehException("unknown color $ν"))
    return c
end

macro color_str(val)
    c = color(String(val))
    @assert !ismissing(c)
    :($c)
end

struct ColorHex <: iProperty end

colorhex(ν) = colorhex(color(ν))
colorhex(::Missing) = missing
function colorhex(ν::Color)
    if ν.a ≡ 0xff
        @sprintf("#%02X%02X%02X", ν.r, ν.g, ν.b)
    else
        @sprintf("#%02X%02X%02X%02X", ν.r, ν.g, ν.b, ν.a)
    end
end

Base.show(io::IO, c::Color) = print(io, '"', colorhex(c), '"')

const COLOR_ARGS = Union{NTuple{4, <:Integer}, NTuple{3, <:Integer}, Symbol, Int32, AbstractString, Color}

bokehconvert(::Type{Color}, ::Nothing) = Color(0x0, 0x0, 0x0, 0x0)
bokehconvert(::Type{ColorHex}, ::Nothing) = "#00000000"

function bokehconvert(::Type{Color}, ν::COLOR_ARGS)
    clr = color(ν)
    ismissing(clr) ? Unknown() : clr
end

function bokehconvert(::Type{ColorHex}, ν::COLOR_ARGS)
    clr = colorhex(ν)
    ismissing(clr) ? Unknown() : clr
end

bokehstoragetype(::ColorHex) = String
