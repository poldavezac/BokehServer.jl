struct Image end

bokehfieldtype(::Type{Image}) = String

const IMAGE_PATTERN = r"^data:image/(PNG|JPG);base64,[a-zA-Z0-9+_/=]*$"

bokehwrite(::Type{FontStyle}, ν) = throw(ErrorException("Use base64 encoded string: \"data:image/PNG;base64,...\""))

function bokehwrite(::Type{FontStyle}, ν::AbstractString)
    if isfile(ν)
        if any(endswith(ν,i) for i ∈ (".png", ".PNG"))
            return "data:image/PNG;base64:$(base64encode(read(ν)))"
        elseif any(endswith(ν,i) for i ∈ (".jpeg", ".jpg", ".JPEG", ".JPG"))
            return "data:image/JPG;base64:$(base64encode(read(ν)))"
        end
        @assert false "unknown image format in $ν"
    end
    
    @assert !isnothing(match(IMAGE_PATTERN, ν))
    return ν
end
