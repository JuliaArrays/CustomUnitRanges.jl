# CustomUnitRanges

[![Build Status](https://travis-ci.org/timholy/CustomUnitRanges.jl.svg?branch=master)](https://travis-ci.org/timholy/CustomUnitRanges.jl)

[![Coverage Status](https://coveralls.io/repos/timholy/CustomUnitRanges.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/timholy/CustomUnitRanges.jl?branch=master)

[![codecov.io](http://codecov.io/github/timholy/CustomUnitRanges.jl/coverage.svg?branch=master)](http://codecov.io/github/timholy/CustomUnitRanges.jl?branch=master)

This Julia package supports the creation of array types with
"unconventional" indices, i.e., when the indices may not start at 1.
With this package, each custom array type can have a corresponding
`indices` range type, consequently providing a means for consistency
in allocation by `similar`.

See http://docs.julialang.org/en/latest/devdocs/offset-arrays.html for
more information about defining and using array types with non-1
indices.

# What's in this package

Currently this package defines two `AbstractUnitRange` types:

- `ZeroTo`, where `ZeroTo(n)` is the equivalent of `0:n`, except that
  Julia's type system knows that the lower bound is 0. (This is
  analogous to `Base`'s `OneTo` type.) This is useful for defining
  arrays that are indexed starting with 0.

- `URange`, a parallel to `UnitRange`, for defining arbitrary range indices.

# Usage

Atypically, you should **not** exploit this with `using
CustomUnitRanges`, and indeed that will throw an error:

    julia> using CustomUnitRanges
    ERROR: LoadError: InitError: Usage error:
        include(Pkg.dir("CustomUnitRanges", "src", filename))
    where `filename` corresponds to the type you want to use

     in __init__() at /home/tim/.julia/v0.5/CustomUnitRanges/src/CustomUnitRanges.jl:4
     ...

The reason is that this package's range types should be *private* to
the module that needs them; consequently you don't want to define a
module in the global namespace.

Instead, suppose you're defining an array type that supports arbitrary
indices. In broad terms, your module might look like this:

    module MyArrayType

    include(Pkg.dir("CustomUnitRanges", "src", "URange.jl"))

    immutable MyArray{T,N} <: AbstractArray{T,N}
        ...
    end

    indices(A::MyArray) = map(URange, #=starting indices=#, #=ending indices=#)

    ...

    end

Here, the first line to note is the `include` statement, which will
load (at source-level) the code for the `URange` type into your
`MyArrayType` module.  We chose `"URange.jl"` because here we want
arbitrary indices; had we wanted zero-based indices, we would have
chosen `"ZeroTo.jl"` instead. Second, note that the output of
`indices` is a `URange` type. More specifically, it's creating a tuple
of `MyArrayType.URange`---there is no "global" `URange` type, so the
indices-tuple is therefore *specific to this package*.

The important result is that two packages, defining `MyArray` and
`OtherArray`, can independently exploit `URange`.  If `MyArrayType`
includes the specialization

    function Base.similar(f::Union{Type,Function}, shape::Tuple{URange,Vararg{URange}}
        MyArray(f(map(length, shape)), #=something for the offset=#)
    end

and similarly for `OtherArrayType`. Then, if `A` is a `MyArray` and
`B` is an `OtherArray`,

- `similar(Array{Int}, indices(A))` will create another `MyArray`
- `similar(Array{Int}, indices(B))` will create another `OtherArray`

despite the fact that they both use `URange`.
