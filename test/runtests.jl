using Base.Test

include("zeroto.jl")
include("urange.jl")

@test intersect(ZeroTo(3), URange(-1,2)) === 0:2
@test ZeroTo(5)[URange(2,4)] === 1:3
