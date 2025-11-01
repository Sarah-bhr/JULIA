#module pour gerer les personnes et leurs amitiés 
module Friendships

using Random

mutable struct Person
    id::Int 
    values::Vector{Float64}
    emotions::Vector{Float64}
    friends::Vector{Int}
end

const Population=Vector{Person}

export Population, relashionships!

function Population(n::Int)
    [Person(i, rand(5), rand(3), Int[]) for i in 1:n]
end

function relationships!(people::Population,prob::Float64=0.5)
    for i in 1:length(people)
        for j in i+1:length(people)

            if rand() < prob
                push!(people[i].friends,j)
                push!(people[j].friends,i)
            end
        end
    end
end

function Base.show(io::IO,people::Population)
    println(io,"Population :")
    for p in people
        Base.show(io,p) #appel le show déjà défini pour Person
        println(io) #saut de ligne
    end 
end 

end