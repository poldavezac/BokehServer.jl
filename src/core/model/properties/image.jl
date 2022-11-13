struct Image <: iProperty end

bokehstoragetype(::Type{Image}) = String

const IMAGE_PATTERN = r"^data:image/(PNG|JPG);base64,[a-zA-Z0-9+_/=]*$"

const _FORMATS = (
    r"\.png"i                  => :png,
    r"\.(p*?jpe*?g|jfif|pjp)"i => :jpeg,
    r"\.svg"i                  => Symbol("svg+xml"),
)

function bokehconvert(::Type{Image}, ν::AbstractString)
    if isfile(ν)
        ind = findfirst(!isnothing∘Base.Fix2(match, splitext(ν)[end])∘first, _FORMATS)

        isnothing(ind) && return Unknown("Unknown image file extension")

        return "data:image/$(_FORMATS[ind][end]);base64,$(base64encode(read(ν)))"
    end
    
    isnothing(match(IMAGE_PATTERN, ν)) && return Unknown("Unknown image string format")
    return ν
end


"""Special structure for dealing with Tool.icon property"""
struct ToolIconValue <: iProperty end

bokehstoragetype(::Type{ToolIconValue}) = Union{Symbol, String}
function bokehconvert(::Type{ToolIconValue}, ν)
    v1 = bokehconvert(ToolIcon, ν)
    v1 isa Unknown || return v1

    v2 = bokehconvert(Image, ν)
    v2 isa Unknown || return v2

    if ν isa AbstractString && length(ν) > 1 && ν[1] ≡ '.'
        return ν
    end
    return Unknown()
end
