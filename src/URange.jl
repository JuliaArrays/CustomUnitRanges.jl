immutable URange{T<:Real} <: AbstractUnitRange{T}
    start::T
    stop::T
    URange(start, stop) = new(start, urange_last(start,stop))
end
URange{T<:Real}(start::T, stop::T) = URange{T}(start, stop)

urange_last(::Bool, stop::Bool) = stop
urange_last{T<:Integer}(start::T, stop::T) =
    ifelse(stop >= start, stop, convert(T,start-one(stop-start)))
urange_last{T}(start::T, stop::T) =
    ifelse(stop >= start, convert(T,start+floor(stop-start)),
                          convert(T,start-one(stop-start)))

Base.start{T}(r::URange{T}) = oftype(r.start + one(T), r.start)

@inline function Base.getindex{T}(v::URange{T}, i::Integer)
    ret = convert(T, first(v) + i - 1)
    @boundscheck ((i > 0) & (ret <= v.stop) & (ret >= v.start)) || Base.throw_boundserror(v, i)
    ret
end

@inline function Base.getindex{T<:Integer}(r::URange, s::AbstractUnitRange{T})
    @boundscheck checkbounds(r, s)
    st = oftype(r.start, r.start + first(s)-1)
    range(st, length(s))
end

Base.intersect{T<:Integer}(r::URange{T}, i::Integer) = intersect(i, r)

function Base.findin{T1<:Integer, T2<:Integer}(r::URange{T1}, span::URange{T2})
    ifirst, ilast = Base._findin(r, span)
    URange(ifirst, ilast)
end

function Base.findin{T1<:Integer, T2<:Integer}(r::Range{T1}, span::URange{T2})
    ifirst, ilast = Base._findin(r, span)
    ifirst:1:ilast
end

Base.promote_rule{T1,T2}(::Type{URange{T1}},::Type{URange{T2}}) =
    URange{promote_type(T1,T2)}
Base.convert{T<:Real}(::Type{URange{T}}, r::URange{T}) = r
Base.convert{T<:Real}(::Type{URange{T}}, r::URange) = URange{T}(r.start, r.stop)

Base.promote_rule{T1,UR<:AbstractUnitRange}(::Type{URange{T1}}, ::Type{UR}) =
    URange{promote_type(T1,eltype(UR))}
Base.convert{T<:Real}(::Type{URange{T}}, r::AbstractUnitRange) = URange{T}(first(r), last(r))

let smallint = (Int === Int64 ?
                Union{Int8,UInt8,Int16,UInt16,Int32,UInt32} :
                Union{Int8,UInt8,Int16,UInt16})
    Base.start{T<:smallint}(r::URange{T}) = convert(Int, r.start)
end

Base.show(io::IO, r::URange) = print(io, typeof(r).name, '(', repr(first(r)), ',', repr(last(r)), ')')
