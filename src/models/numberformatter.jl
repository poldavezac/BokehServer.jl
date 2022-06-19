#- file created by '/home/pdavezac/code/Bokeh/deps/src/CodeCreator.jl': edit at your own risk! -#

@model mutable struct NumberFormatter <: iNumberFormatter

    font_style :: Bokeh.Model.EnumType{(:bold, :normal, Symbol("bold italic"), :italic)} = :normal

    format :: String = "0,0"

    js_event_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    js_property_callbacks :: Dict{Symbol, Vector{iCustomJS}}

    language :: Bokeh.Model.EnumType{(Symbol("da-dk"), :de, :en, :th, :chs, Symbol("fr-ch"), :pl, :tr, Symbol("pt-pt"), Symbol("es-ES"), :fr, Symbol("pt-br"), :es, Symbol("en-gb"), :ja, :hu, Symbol("fr-CA"), Symbol("de-ch"), Symbol("nl-nl"), :it, :ru, Symbol("ru-UA"), :fi, Symbol("be-nl"), :cs, :et, :sk, Symbol("uk-UA"))} = :en

    name :: Bokeh.Model.Nullable{String} = nothing

    nan_format :: String = "-"

    rounding :: Bokeh.Model.EnumType{(:rounddown, :round, :nearest, :floor, :ceil, :roundup)} = :round

    subscribed_events :: Vector{Symbol}

    syncable :: Bool = true

    tags :: Vector{Any}

    text_align :: Bokeh.Model.EnumType{(:left, :right, :center)} = :left

    text_color :: Bokeh.Model.Nullable{Bokeh.Model.Color} = nothing
end
