struct Image end

bokehfieldtype(::Type{Image}) = String

const IMAGE_PATTERN = r"^data:image/(PNG|JPG);base64,[a-zA-Z0-9+_/=]*$"

bokehwrite(::Type{Image}, ν) = throw(ErrorException("Use base64 encoded string: \"data:image/PNG;base64,...\""))

const _FORMATS = (
    r"\.png"i                  => :png,
    r"\.(p*?jpe*?g|jfif|pjp)"i => :jpeg,
    r"\.svg"i                  => Symbol("svg+xml"),
)

function bokehwrite(::Type{Image}, ν::AbstractString)
    if isfile(ν)
        ind = findfirst(!isnothing∘Base.Fix2(match, splitext(ν)[end])∘first, _FORMATS)

        isnothing(ind) && throw(ErrorException("unknown image format in $ν"))

        return "data:image/$(_FORMATS[ind][end]);base64,$(base64encode(read(ν)))"
    end
    
    isnothing(match(IMAGE_PATTERN, ν)) || throw(ErrorException("unknown image format '$ν'"))
    return ν
end
