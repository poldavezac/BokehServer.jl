#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct NumberFormatter <: iNumberFormatter

    syncable :: Bool = true

    nan_format :: String = "-"

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    tags :: Vector{Any}

    subscribed_events :: Vector{Symbol}

    name :: Bokeh.Model.Nullable{String} = nothing

    format :: String = "0,0"

    language :: Bokeh.Model.EnumType{(Symbol("da-dk"), :de, :en, :th, :chs, Symbol("fr-ch"), :pl, :tr, Symbol("pt-pt"), Symbol("es-ES"), :fr, Symbol("pt-br"), :es, Symbol("en-gb"), :ja, :hu, Symbol("fr-CA"), Symbol("de-ch"), Symbol("nl-nl"), :it, :ru, Symbol("ru-UA"), :fi, Symbol("be-nl"), :cs, :et, :sk, Symbol("uk-UA"))} = :en

    rounding :: Bokeh.Model.EnumType{(:rounddown, :round, :nearest, :floor, :ceil, :roundup)} = :round

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}
end
