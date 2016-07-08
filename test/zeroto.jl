module ModZ

include(Pkg.dir("CustomUnitRanges", "src", "ZeroTo.jl"))

end

using ModZ: ZeroTo

r = ZeroTo(-5)
@test isempty(r)
@test length(r) == 0
@test size(r) == (0,)
r = ZeroTo(3)
@test !isempty(r)
@test length(r) == 4
@test size(r) == (4,)
@test step(r) == 1
@test first(r) == 0
@test last(r) == 3
@test minimum(r) == 0
@test maximum(r) == 3
@test r[1] == 0
@test r[2] == 1
@test r[3] == 2
@test r[4] == 3
@test_throws BoundsError r[5]
@test_throws BoundsError r[-1]
@test r+1 === 1:4
@test 2*r === 0:2:6
k = -1
for i in r
    @test i == (k+=1)
end
@test intersect(r, ZeroTo(2)) == ZeroTo(2)
@test intersect(r, -1:5) == 0:3
@test intersect(r, 2:5) == 2:3
io = IOBuffer()
show(io, r)
str = takebuf_string(io)
@test str == "ModZ.ZeroTo(3)"
