"""
    ZeroRange(n)

Defines an `AbstractUnitRange` corresponding to the half-open interval
[0,n), equivalent to `0:n-1` but with the lower bound guaranteed to be
zero by Julia's type system.
"""
immutable ZeroRange{T<:Integer} <: AbstractUnitRange{T}
    len::T
    (::Type{ZeroRange{T}}){T}(len) = new{T}(max(zero(T), len))
end
ZeroRange{T<:Integer}(len::T) = ZeroRange{T}(len)

Base.length(r::ZeroRange) = r.len

Base.length{T<:Union{Int,Int64}}(r::ZeroRange{T}) = T(r.len)

let smallint = (Int === Int64 ?
                Union{Int8,UInt8,Int16,UInt16,Int32,UInt32} :
                Union{Int8,UInt8,Int16,UInt16})
    Base.length{T <: smallint}(r::ZeroRange{T}) = Int(r.len)
    Base.start{T<:smallint}(r::ZeroRange{T}) = 0
end

Base.first{T}(r::ZeroRange{T}) = zero(T)
Base.last{ T}(r::ZeroRange{T}) = r.len-one(T)

Base.start{T}(r::ZeroRange{T}) = oftype(one(T)+one(T), zero(T))
Base.done{T}(r::ZeroRange{T}, i) = i == oftype(i, r.len)

@inline function Base.getindex{T}(v::ZeroRange{T}, i::Integer)
    @boundscheck ((i > 0) & (i <= length(v))) || Base.throw_boundserror(v, i)
    convert(T, i-1)
end

@inline function Base.getindex{R,S<:Integer}(r::ZeroRange{R}, s::AbstractUnitRange{S})
    @boundscheck checkbounds(r, s)
    R(first(s)-1):R(last(s)-1)
end

Base.intersect(r::ZeroRange, s::ZeroRange) = ZeroRange(min(r.len,s.len))

Base.promote_rule{T1,T2}(::Type{ZeroRange{T1}},::Type{ZeroRange{T2}}) =
    ZeroRange{promote_type(T1,T2)}
Base.convert{T<:Real}(::Type{ZeroRange{T}}, r::ZeroRange{T}) = r
Base.convert{T<:Real}(::Type{ZeroRange{T}}, r::ZeroRange) = ZeroRange{T}(r.len)

Base.show(io::IO, r::ZeroRange) = print(io, typeof(r).name, "(", r.len, ")")
