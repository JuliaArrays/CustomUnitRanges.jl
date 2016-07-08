module ModU

include(Pkg.dir("CustomUnitRanges", "src", "URange.jl"))

end

using ModU: URange

r = URange(-3,-5)
@test isempty(r)
@test length(r) == 0
@test size(r) == (0,)
r = URange(-5,3)
rref = -5:3
@test !isempty(r)
@test length(r) == length(rref)
@test size(r) == size(rref)
@test step(r) == 1
@test first(r) == -5
@test last(r) == 3
@test minimum(r) == -5
@test maximum(r) == 3
@test r[1] == -5
@test r[2] == -4
@test r[8] == 2
@test r[9] == 3
@test_throws BoundsError r[10]
@test_throws BoundsError r[0]
@test r+1 === -4:4
@test 2*r === -10:2:6
k = -6
for i in r
    @test i == (k+=1)
end
@test intersect(r, URange(-5,2)) == URange(-5,2)
@test intersect(r, -1:5) === -1:3
@test intersect(r, 2:5) == 2:3
io = IOBuffer()
show(io, r)
str = takebuf_string(io)
@test str == "ModU.URange(-5,3)"
