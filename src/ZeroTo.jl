immutable ZeroTo{T<:Signed} <: AbstractUnitRange{T}
    stop::T
    ZeroTo(stop) = new(max(T(-1), stop))
end
ZeroTo{T<:Signed}(stop::T) = ZeroTo{T}(stop)

Base.length(r::ZeroTo) = r.stop+1

Base.length{T<:Union{Int,Int64}}(r::ZeroTo{T}) = T(r.stop+1)

let smallint = (Int === Int64 ?
                Union{Int8,UInt8,Int16,UInt16,Int32,UInt32} :
                Union{Int8,UInt8,Int16,UInt16})
    Base.length{T <: smallint}(r::ZeroTo{T}) = Int(r.stop)+1
    Base.start{T<:smallint}(r::ZeroTo{T}) = 0
end

Base.first{T}(r::ZeroTo{T}) = zero(T)

Base.start{T}(r::ZeroTo{T}) = zero(T)

@inline function Base.getindex{T}(v::ZeroTo{T}, i::Integer)
    @boundscheck ((i > 0) & (i <= length(v))) || Base.throw_boundserror(v, i)
    convert(T, i-1)
end

@inline function Base.getindex{T}(r::ZeroTo{T}, s::ZeroTo)
    @boundscheck checkbounds(r, s)
    ZeroTo(T(s.stop))
end

@inline function Base.getindex{T}(r::ZeroTo{T}, s::AbstractUnitRange)
    @boundscheck checkbounds(r, s)
    T(first(s)-1):T(last(s)-1)
end

Base.intersect(r::ZeroTo, s::ZeroTo) = ZeroTo(min(r.stop,s.stop))

Base.promote_rule{T1,T2}(::Type{ZeroTo{T1}},::Type{ZeroTo{T2}}) =
    ZeroTo{promote_type(T1,T2)}
Base.convert{T<:Real}(::Type{ZeroTo{T}}, r::ZeroTo{T}) = r
Base.convert{T<:Real}(::Type{ZeroTo{T}}, r::ZeroTo) = ZeroTo{T}(r.stop)

Base.show(io::IO, r::ZeroTo) = print(io, typeof(r).name, "(", r.stop, ")")
