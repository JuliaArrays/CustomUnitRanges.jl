module CustomUnitRanges

function __init__()
    error("""
Usage error:
    include(Pkg.dir(\"CustomUnitRanges\", \"src\", filename))
where `filename` corresponds to the type you want to use
""")
end

end # module
