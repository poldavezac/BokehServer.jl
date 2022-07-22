"""
    update!(
        γ::Union{ColumnDataSource, DataDictContainer},
        𝑑s::Vararg{Dict{String, Vector}}
    )

Adds or replaces columns.
"""
function update!(γ::DataDictContainer, 𝑑s::Vararg{DataDictArg}; dotrigger::Bool = true)
    @_𝑑𝑠_merge_args j
    filter!(𝑑) do (k, v)
        !compare(v, get(γ, k, nothing))
    end
    isempty(𝑑) && return γ   

    data = merge(γ.values, 𝑑)
    _𝑑𝑠_check(data)
    merge!(γ.values, data)
    @_𝑑𝑠_trigger ColumnDataChangedEvent 𝑑
    return γ
end

Base.merge!(γ::DataDictContainer, 𝑑s; dotrigger::Bool = true) = update!(γ, 𝑑s...; dotrigger)
export update!
