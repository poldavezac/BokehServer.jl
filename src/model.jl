module Model
using ..Bokeh
using ..AbstractTypes

"""
    macro wrap(args::Expr)

For advanced uses only. Allows creating Bokeh-aware model:

* the model can be transfered to the javascript client
* changes to the fields will trigger events which one can subscribe to
 
** Note ** Dicts and Vectors are wrapped in a `Container` class
which allows triggering an event when using `push!` methods and
others of the same type.

** Note ** The same behaviour as when using `Base.@kwdef` is provided. It's good
practice to always provide default values.

** Note ** Wrapping a type in `Internal` will remove the field 
from the Bokeh behavior: the client remains unaware of it and
changes trigger no event.

## Examples

```julia
@Bokeh.model mutable struct X <: Bokeh.iModel
    field1::Int     = 0
    field2::Float64 = 0.0
end
@assert propertynames(X) ≡ (:field1, :field2)
@assert propertynames(X; private = true) ≡ (:field1, :field2, :id, :callbacks)
@assert X().field1 ≡ 0
@assert X().field2 ≡ 0.0

"Z is a structure where fields `nojs1` and `nojs2` are *not* passed to bokehjs"
@Bokeh.model mutable struct Z <: Bokeh.iModel
    nojs1 ::Internal{Any} = []
    nojs2 ::Internal{Any} = Set([])
    field1::Int           = 0
    field2::Float64       = 0.0
end
@assert Z().nojs1 isa Vector{Any}
@assert Z().nojs2 isa Set{Any}
"""
:(@wrap)

"""
    macro model(args::Expr)

Allows creating Bokeh-aware model, just as `@wrap` does, but adding default
fields used by every `iModel` structure. This macro should be used rather than
`@wrap` which is called internally.
"""
:(@model)

"Stores every class created by the @wrap macro"
const MODEL_TYPES = Set{DataType}()

Base.show(io::IO, µ::iHasProps) = print(io, "$(nameof(typeof(µ)))(id = $(µ.id))")
include("model/properties.jl")
include("model/macrohelpers.jl")
include("model/wrapmacro.jl")
include("model/modelmacro.jl")
include("model/allmodels.jl")
end
using .Model
