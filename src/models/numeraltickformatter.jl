#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct NumeralTickFormatter <: iNumeralTickFormatter

    syncable :: Bool = true

    language :: Bokeh.Model.EnumType{(Symbol("da-dk"), :de, :en, :th, :chs, Symbol("fr-ch"), :pl, :tr, Symbol("pt-pt"), Symbol("es-ES"), :fr, Symbol("pt-br"), :es, Symbol("en-gb"), :ja, :hu, Symbol("fr-CA"), Symbol("de-ch"), Symbol("nl-nl"), :it, :ru, Symbol("ru-UA"), :fi, Symbol("be-nl"), :cs, :et, :sk, Symbol("uk-UA"))} = :en

    name :: Bokeh.Model.Nullable{String} = nothing

    subscribed_events :: Vector{Symbol}

    format :: String = "0,0"

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    rounding :: Bokeh.Model.EnumType{(:rounddown, :round, :nearest, :floor, :ceil, :roundup)} = :round

    tags :: Vector{Any}

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
