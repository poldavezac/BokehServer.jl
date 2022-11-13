const DataDictArg = Union{
    Pair{<:AbstractString, <:AbstractVector},
    AbstractDict{<:AbstractString, <:AbstractVector},
    AbstractVector{<:Pair{<:AbstractString, <:AbstractVector}},
    DataDictContainer
}

"""
    stream!(
            γ         :: Union{ColumnDataSource, DataDictContainer},
            𝑑s        :: Vararg{DataDictArg};
            rollover  :: Union{Int, Nothing} = nothing,
    )

Add rows to the `ColumnDataSource`.

* `𝑑s` can be of dictionnaries or pairs (column name, new data). 
* `rollover` indicates maximum number of rows after the rows are added. Oldest
rows are deleted as required.

```julia
DS = BokehServer.ColumnDataSource(; data = Dict("x" => [1, 2], "y" => [3, 4]))

BokehServer.stream!(DS, "x" => [3], "y" => [4])
@assert length(DS.data["x"]) == 3

BokehServer.stream!(DS, Dict("x" => [4], "y" => [5]))
@assert length(DS.data["x"]) == 4
```
"""
function stream!(
        γ         :: DataDictContainer,
        𝑑s        :: Vararg{DataDictArg};
        rollover  :: Union{Int, Nothing} = nothing,
        dotrigger :: Bool                = true
)
    @_𝑑𝑠_merge_args haskey(out, i) ? vcat(out[i], j) : copy(j)
    (!isnothing(rollover) && (rollover ≤ 0)) && (rollover = nothing)

    len  = size(γ, 1)
    data = DataDict(
        "$i" => let old = get(γ.values, i, missing)
            if ismissing(old) || (!isnothing(rollover) && rollover ≡ length(j))
                j
            elseif isnothing(rollover) || rollover > length(j) + length(old)
                vcat(old, j)
            elseif rollover < length(j)
                j[end-rollover+1:end]
            else
                vcat(@view(old[end-rollover+1+length(j):end]), j)
            end
        end
        for (i, j) ∈ 𝑑
    )
    keys(data) ⊇ keys(γ.values) || throw(BokehException("`stream!` requires new data for every column"))

    _𝑑𝑠_check(data)
    merge!(γ.values, data)
    @_𝑑𝑠_trigger ColumnsStreamedEvent 𝑑 rollover
    return γ
end

function Base.push!(
        γ         :: DataDictContainer,
        𝑑s        :: Vararg{DataDictArg};
        rollover  :: Union{Int, Nothing} = nothing,
        dotrigger :: Bool                = true
)
    stream!(γ, 𝑑s...; rollover, dotrigger)
end

export stream!
