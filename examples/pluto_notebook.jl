### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ d4981f9e-fab5-4f64-957c-fb8c67fa80b6
begin
	using Pkg
	Pkg.activate(joinpath(@__DIR__, ".."))
	using BokehServer
	# set the server port, if needed
	BokehServer.Embeddings.notebook(; port = 3333)
end

# ╔═╡ cd3cc468-58c3-4315-8e0b-880734128707
begin
    "A simple plot"
    FIG = BokehServer.line(; x = 1:10, y = 1:10)

    "The data source used by the plot"
    DATA = FIG.renderers[1].data_source

    "A button which adds a datapoint when clicked"
    BTN = let btn = BokehServer.Button(; label = "add a data point")

        # Note that the `onchange` call only reacts to `ButtonClick` events
        BokehServer.onchange(btn) do evt::BokehServer.ButtonClick
            BokehServer.stream!(
                DATA,
                Dict("x" => [length(DATA.data["x"])+1], "y" => [rand(1:10)])
            )
        end
        btn
    end

    "A display with both the plot and the button"
    BokehServer.layout([FIG, BTN])
end

# ╔═╡ b2ea7ada-53bb-44c9-9123-9d5ef1ab59b2
# add a data point
BokehServer.stream!(DATA, Dict("x" => [length(DATA.data["x"])+1], "y" => [rand(1:10)]));

# ╔═╡ Cell order:
# ╠═d4981f9e-fab5-4f64-957c-fb8c67fa80b6
# ╠═cd3cc468-58c3-4315-8e0b-880734128707
# ╠═b2ea7ada-53bb-44c9-9123-9d5ef1ab59b2
