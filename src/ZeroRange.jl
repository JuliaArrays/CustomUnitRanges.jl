"""
    ZeroRange(n)

Defines an `AbstractUnitRange` corresponding to the half-open interval
[0,n), equivalent to `0:n-1` but with the lower bound guaranteed to be
zero by Julia's type system.
"""
struct ZeroRange{T<:Integer} <: AbstractUnitRange{T}
    len::T
    ZeroRange{T}(len) where {T} = new{T}(max(zero(T), len))
end
ZeroRange(len::T) where {T<:Integer} = ZeroRange{T}(len)

Base.length(r::ZeroRange) = r.len

Base.length(r::ZeroRange{T}) where {T<:Union{Int,Int64}} = T(r.len)

let smallint = (Int === Int64 ?
                Union{Int8,UInt8,Int16,UInt16,Int32,UInt32} :
                Union{Int8,UInt8,Int16,UInt16})
    Base.length(r::ZeroRange{T}) where {T <: smallint} = Int(r.len)
    Base.start(r::ZeroRange{T}) where {T<:smallint} = 0
end

Base.first(r::ZeroRange{T}) where {T} = zero(T)
Base.last(r::ZeroRange{T}) where { T} = r.len-one(T)

Base.start(r::ZeroRange{T}) where {T} = oftype(one(T)+one(T), zero(T))
Base.done(r::ZeroRange{T}, i) where {T} = i == oftype(i, r.len)

@inline function Base.getindex(v::ZeroRange{T}, i::Integer) where T
    @boundscheck ((i > 0) & (i <= length(v))) || Base.throw_boundserror(v, i)
    convert(T, i-1)
end

@inline function Base.getindex(r::ZeroRange{R}, s::AbstractUnitRange{S}) where {R,S<:Integer}
    @boundscheck checkbounds(r, s)
    R(first(s)-1):R(last(s)-1)
end

Base.intersect(r::ZeroRange, s::ZeroRange) = ZeroRange(min(r.len,s.len))

Base.promote_rule(::Type{ZeroRange{T1}},::Type{ZeroRange{T2}}) where {T1,T2} =
    ZeroRange{promote_type(T1,T2)}
Base.convert(::Type{ZeroRange{T}}, r::ZeroRange{T}) where {T<:Real} = r
Base.convert(::Type{ZeroRange{T}}, r::ZeroRange) where {T<:Real} = ZeroRange{T}(r.len)

Base.show(io::IO, r::ZeroRange) = print(io, typeof(r).name, "(", r.len, ")")
