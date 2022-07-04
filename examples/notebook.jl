### A Pluto.jl notebook ###
# v0.19.5

using Markdown
using InteractiveUtils

# ╔═╡ d4981f9e-fab5-4f64-957c-fb8c67fa80b6
begin
	using Pkg
	Pkg.activate("/home/pdavezac/code/Bokeh/")
	using Bokeh.Plotting
end

# ╔═╡ cd3cc468-58c3-4315-8e0b-880734128707
fig = Plotting.line(; x = 1:10, y = 1:10)

# ╔═╡ b2ea7ada-53bb-44c9-9123-9d5ef1ab59b2
let data = fig.renderers[1].data_source.data
	push!(data, Dict("x" => [length(data["x"])], "y" => [rand(1:10)]))
end

# ╔═╡ Cell order:
# ╠═d4981f9e-fab5-4f64-957c-fb8c67fa80b6
# ╠═cd3cc468-58c3-4315-8e0b-880734128707
# ╠═b2ea7ada-53bb-44c9-9123-9d5ef1ab59b2
