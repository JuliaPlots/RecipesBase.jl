@userplot CornerPlot

@userplot CorrPlot

@userplot GroupedBar

@userplot QQPlot

@userplot QQNorm

const StatPlotsRecipeType = Union{
    CornerPlot,
    CorrPlot,
    GroupedBar,
    QQPlot,
    QQNorm
}

@recipe function f(g::T) where {T<:StatPlotsRecipeType}
    error("Load StatPlots to use type recipe $T")
end
