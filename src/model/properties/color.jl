using Printf
using Colors

struct Color
    r::UInt8
    g::UInt8
    b::UInt8
    a::UInt8
end

Base.show(io::IO, c::Color) = show(io, c.a ≡ 0xff ? "rgb($(c.r),$(c.g),$(c.b))" : "rgba($(c.r),$(c.g),$(c.b),$(c.a))")

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

Color(r, g, b)                                            = Color(r, g, b, 0xff)
Color(ν::Union{NTuple{4,<:Integer}, NTuple{3,<:Integer}}) = Color(ν...)
Color(ν::Symbol)                                          = Color(Colors.color_names["$ν"]...)
Color(ν::Int32)                                           = Color(reinterpret(UIn8, Int32[ν])...)

function Color(ν::AbstractString)
    c = color(ν)
    ismissing(ν) && throw(ErrorException("unknown color $ν"))
    return c
end


macro color_str(val)
    c = color(String(val))
    @assert !ismissing(c)
    :($c)
end

struct ColorHex end

colorhex(ν) = colorhex(Color(ν))
function colorhex(ν::Color)
    if ν.a ≡ 0xff
        @sprintf("#%02X%02X%02X", ν.r, ν.g, ν.b)
    else
        @sprintf("#%02X%02X%02X%02X", ν.r, ν.g, ν.b, ν.a)
    end
end

bokehwrite(::Type{Color}, ν)    = Color(ν)
bokehwrite(::Type{ColorHex}, ν) = colorhex(ν)
bokehfieldtype(::ColorHex) = String
