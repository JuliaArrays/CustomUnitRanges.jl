module ModZ

include(Pkg.dir("CustomUnitRanges", "src", "ZeroRange.jl"))

end

using ModZ: ZeroRange

r = ZeroRange(-5)
@test isempty(r)
@test length(r) == 0
@test size(r) == (0,)
r = ZeroRange(3)
@test !isempty(r)
@test length(r) == 3
@test size(r) == (3,)
@test step(r) == 1
@test first(r) == 0
@test last(r) == 2
@test minimum(r) == 0
@test maximum(r) == 2
@test r[1] == 0
@test r[2] == 1
@test r[3] == 2
@test_throws BoundsError r[4]
@test_throws BoundsError r[-1]
@test r+1 === 1:3
@test 2*r === 0:2:4
k = -1
for i in r
    @test i == (k+=1)
end
@test k == length(r)-1
@test intersect(r, ZeroRange(2)) == ZeroRange(2)
@test intersect(r, -1:5) == 0:2
@test intersect(r, 2:5) == 2:2
io = IOBuffer()
show(io, r)
str = takebuf_string(io)
@test str == "ModZ.ZeroRange(3)"

r = ZeroRange(5)
@test checkindex(Bool, r, 4)
@test !checkindex(Bool, r, 5)
@test checkindex(Bool, r, :)
@test checkindex(Bool, r, 1:4)
@test !checkindex(Bool, r, 1:5)
@test !checkindex(Bool, r, trues(4))
@test !checkindex(Bool, r, trues(5))
@test convert(UnitRange, r) == 0:4
@test convert(StepRange, r) == 0:1:4
@test !in(-1, r)
@test in(0, r)
@test in(4, r)
@test !in(5, r)
@test issorted(r)
@test maximum(r) == 4
@test minimum(r) == 0
@test sortperm(r) == 1:5
@test r == 0:4
@test r+r == 0:2:8
@test (5:2:13)-r == 5:9
@test -r == 0:-1:-4
@test reverse(r) == 4:-1:0
@test r./2 == 0:0.5:2
