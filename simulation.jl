#Ce module gère la dynamique des relations :
#comment les amitiés évoluent avec le temps, en fonction de la compatibilité entre individus.
module Simulation

using Random
using LinearAlgebra
include("Friendships.jl")   
using .Friendships      

mutable struct FriendshipScore
    i::Int
    j::Int
    score::Float64
end


function init_friendships(people::Population)
    relations = FriendshipScore[]
    for i in 1:(length(people)-1)
        for j in (i+1):length(people)
            push!(relations, FriendshipScore(i, j, rand()))
        end
    end
    return relations
end

function update_friendship!(rel::FriendshipScore, ind1::Person, ind2::Person;
                            α=0.8, β=0.15, γ=0.05)
    compat = dot(ind1.values, ind2.values) / (norm(ind1.values) * norm(ind2.values))
    delta = α * rel.score + β * compat + γ * randn() * 0.1
    rel.score = clamp(delta, 0, 1)
end
#L’amitié augmente si les valeurs sont compatibles, mais peut varier aléatoirement selon les émotions et le hasard.
function simulate!(people::Population, relations::Vector{FriendshipScore}, steps::Int=100)
    for _ in 1:steps
        for rel in relations
            update_friendship!(rel, people[rel.i], people[rel.j])
        end
    end
end

export FriendshipScore, init_friendships, update_friendship!, simulate!

end
